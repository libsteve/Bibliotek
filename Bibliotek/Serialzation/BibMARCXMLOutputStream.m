//
//  BibMARCXMLOutputStream.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/8/22.
//  Copyright © 2022 Steve Brunwasser. All rights reserved.
//

#import "BibMARCXMLOutputStream.h"
#import "BibMARCXMLConstants.h"
#import <Bibliotek/Bibliotek.h>
#import <Bibliotek/Bibliotek+Internal.h>
#import <libxml/xmlwriter.h>

static int bib_marcxml_write(void *context, char const *buffer, int length);
static int bib_marcxml_close(void *context);

@interface _BibMARCXMLWriter : NSObject
@property (nonatomic, readonly, nullable) NSError *error;
@end

@implementation BibMARCXMLOutputStream {
    xmlOutputBufferPtr _output;
    xmlTextWriterPtr _writer;
    NSOutputStream *_outputStream;
    NSStreamStatus _streamStatus;
    NSError *_streamError;
    BOOL _didStartRecordCollection;
}

- (NSStreamStatus)streamStatus {
    return _streamStatus;
}

- (NSError *)streamError {
    return _streamError;
}

- (BOOL)hasSpaceAvailable {
    return (_streamStatus == NSStreamStatusAtEnd) ? NO : [_outputStream hasSpaceAvailable];
}

- (NSData *)data {
    return [_outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
}

#pragma mark -

- (instancetype)init {
    return [self initToMemory];
}

- (instancetype)initWithOutputStream:(NSOutputStream *)outputStream {
    if (self = [super init]) {
        _outputStream = outputStream;
        void *context = (__bridge void *)outputStream;
        xmlCharEncodingHandlerPtr encoder = xmlGetCharEncodingHandler(XML_CHAR_ENCODING_UTF8);
        _output = xmlOutputBufferCreateIO(bib_marcxml_write, bib_marcxml_close, context, encoder);
        NSParameterAssert(_output != NULL);
    }
    return self;
}

- (void)dealloc {
    [self close];
}

#pragma mark -

- (instancetype)open {
    if ([self streamStatus] == NSStreamStatusNotOpen) {
        [_outputStream open];
        _streamStatus = _outputStream.streamStatus;
        _streamError = _outputStream.streamError;
        if (_streamStatus == NSStreamStatusError) {
            return self;
        }
        _writer = xmlNewTextWriter(_output);
        NSParameterAssert(_writer != NULL);
    }
    return self;
}

- (instancetype)close {
    if ([self streamStatus] != NSStreamStatusClosed) {
        if (_writer != NULL) {
            if (_didStartRecordCollection) {
                xmlTextWriterEndDocument(_writer);
            }
            xmlFreeTextWriter(_writer);
            _writer = NULL;
            _streamStatus = [_outputStream streamStatus];
            _streamError = [_outputStream streamError];
        }
    }
    return self;
}

#pragma mark -

- (void)__updateStreamStatusAfterError {
    switch ([_outputStream streamStatus]) {
        case NSStreamStatusError:
            _streamStatus = NSStreamStatusError;
            _streamError = [_outputStream streamError];
            return;

        case NSStreamStatusOpen: {
            xmlErrorPtr err = xmlGetLastError();
            NSParameterAssert(err != NULL);
            _streamStatus = NSStreamStatusError;
            _streamError = [NSError errorWithDomain:@"libXml" code:err->code userInfo:@{
                NSLocalizedDescriptionKey :
                    [NSString stringWithCString:err->message encoding:NSUTF8StringEncoding]
            }];
            return;
        }
        default:
            _streamStatus = [_outputStream streamStatus];
            _streamError = [_outputStream streamError];
            return;
    }
}

#pragma mark -

- (BOOL)__startElement:(xmlChar const *)name BIB_DIRECT {
    int result = xmlTextWriterStartElement(_writer, name);
    if (result == -1) {
        xmlErrorPtr err = xmlGetLastError();
        _streamStatus = NSStreamStatusError;
        _streamError = [NSError errorWithDomain:BibSerializationErrorDomain code:err->code userInfo:@{
            NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Cannot start new element <%s>", name],
            NSLocalizedFailureReasonErrorKey : [NSString stringWithCString:err->message encoding:NSUTF8StringEncoding]
        }];
    }
    return result != -1;
}

- (BOOL)__endElement BIB_DIRECT {
    int result = xmlTextWriterEndElement(_writer);
    if (result == -1) {
        xmlErrorPtr err = xmlGetLastError();
        _streamStatus = NSStreamStatusError;
        _streamError = [NSError errorWithDomain:BibSerializationErrorDomain code:err->code userInfo:@{
            NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Cannot close current element"],
            NSLocalizedFailureReasonErrorKey : [NSString stringWithCString:err->message encoding:NSUTF8StringEncoding]
        }];
    }
    return result != -1;
}

- (BOOL)__writeAttribute:(xmlChar const *)name string:(NSString *)string BIB_DIRECT {
    return [self __writeAttribute:name value:(BAD_CAST [string UTF8String])];
}

- (BOOL)__writeAttribute:(xmlChar const *)name value:(xmlChar const *)value BIB_DIRECT {
    int result = xmlTextWriterWriteAttribute(_writer, name, value);
    if (result == -1) {
        xmlErrorPtr err = xmlGetLastError();
        _streamStatus = NSStreamStatusError;
        _streamError = [NSError errorWithDomain:BibSerializationErrorDomain code:err->code userInfo:@{
            NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Cannot write attribute `%s`", name],
            NSLocalizedFailureReasonErrorKey : [NSString stringWithCString:err->message encoding:NSUTF8StringEncoding]
        }];
    }
    return result != -1;
}

- (BOOL)__writeString:(NSString *)string BIB_DIRECT {
    int result = xmlTextWriterWriteString(_writer, BAD_CAST [(string ?: @"") UTF8String]);
    if (result == -1) {
        xmlErrorPtr err = xmlGetLastError();
        _streamStatus = NSStreamStatusError;
        _streamError = [NSError errorWithDomain:BibSerializationErrorDomain code:err->code userInfo:@{
            NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Cannot write string content: %@", string],
            NSLocalizedFailureReasonErrorKey : [NSString stringWithCString:err->message encoding:NSUTF8StringEncoding]
        }];
    }
    return result != -1;
}

#pragma mark -

- (BOOL)__writeSubfields:(NSArray<BibSubfield *> *)subfields BIB_DIRECT {
    for (BibSubfield *subfield in subfields) {
        BOOL success = [self __startElement:MARCXMLSubfield]
                    && [self __writeAttribute:MARCXMLCode string:[subfield subfieldCode]]
                    && [self __writeString:[subfield content]]
                    && [self __endElement];
        if (!success) {
            _streamError = [NSError errorWithDomain:BibSerializationErrorDomain code:[_streamError code] userInfo:@{
                NSUnderlyingErrorKey : _streamError,
                NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Cannot write subfield %@", subfield],
                NSLocalizedFailureReasonErrorKey : [_streamError localizedFailureReason],
            }];
            return NO;
        }
    }
    return YES;
}

- (BOOL)__writeRecordField:(BibRecordField *)field BIB_DIRECT {
    BOOL success = YES;
    if ([field isControlField]) {
        success = [self __startElement:MARCXMLControlfield]
            && [self __writeAttribute:MARCXMLTag string:[[field fieldTag] stringValue]]
            && [self __writeString:[field controlValue]]
            && [self __endElement];
    } else {
        char ind1[] = { [[field firstIndicator] rawValue], '\0' };
        char ind2[] = { [[field secondIndicator] rawValue], '\0' };
        success = [self __startElement:MARCXMLDatafield]
            && [self __writeAttribute:MARCXMLTag string:[[field fieldTag] stringValue]]
            && [self __writeAttribute:MARCXMLInd1 value:(BAD_CAST ind1)]
            && [self __writeAttribute:MARCXMLInd2 value:(BAD_CAST ind2)]
            && [self __writeSubfields:[field subfields]]
            && [self __endElement];
    }
    if (!success) {
        NSMutableDictionary *userInfo = [[_streamError userInfo] mutableCopy];
        NSString *description = userInfo[NSLocalizedDescriptionKey];
        description = [NSString stringWithFormat:@"Field %@: %@", [field fieldTag], description];
        userInfo[NSLocalizedDescriptionKey] = description;
        _streamError = [NSError errorWithDomain:[_streamError domain] code:[_streamError code] userInfo:userInfo];
    }
    return success;
}

- (BOOL)__writeFields:(NSArray<BibRecordField *> *)fields BIB_DIRECT {
    for (BibRecordField *field in fields) {
        if (![self __writeRecordField:field]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)__writeLeader:(BibLeader *)leader BIB_DIRECT {
    NSUInteger length = [[leader rawData] length];
    char bytes[length + 1];
    memset(bytes, 0, length + 1);
    [[leader rawData] getBytes:bytes length:length];
    int result = xmlTextWriterWriteElement(_writer, MARCXMLLeader, BAD_CAST bytes);
    if (result == -1) {
        xmlErrorPtr err = xmlGetLastError();
        _streamStatus = NSStreamStatusError;
        _streamError = [NSError errorWithDomain:BibSerializationErrorDomain code:err->code userInfo:@{
            NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Cannot write record leader %@", leader],
            NSLocalizedFailureReasonErrorKey : [NSString stringWithCString:err->message encoding:NSUTF8StringEncoding]
        }];
    }
    return result != -1;
}

- (BOOL)__writeRecord:(BibRecord *)record BIB_DIRECT {
    return [self __startElement:MARCXMLRecord]
        && [self __writeAttribute:MARCXMLNamespace value:MARCXMLNamespaceURI]
        && [self __writeLeader:[record leader]]
        && [self __writeFields:[record fields]]
        && [self __endElement];
}

- (BOOL)writeRecord:(BibRecord *)record error:(NSError *__autoreleasing *)error {
    if ([self streamStatus] != NSStreamStatusOpen) {
        if (error != NULL) {
            *error = BibSerializationMakeOutputStreamNotOpenedError(_outputStream);
        }
        return NO;
    }
    if (!_didStartRecordCollection) {
        BOOL success = (xmlTextWriterStartDocument(_writer, "1.0", "UTF-8", NULL) != -1)
                    && [self __startElement:MARCXMLCollection]
                    && [self __writeAttribute:MARCXMLNamespace value:MARCXMLNamespaceURI];
        if (!success) {
            [self __updateStreamStatusAfterError];
            if (error != NULL) {
                *error = [self streamError];
            }
            return NO;
        }
        _didStartRecordCollection = YES;
    }
    if (![self __writeRecord:record]) {
        [self __updateStreamStatusAfterError];
        if (error != NULL) {
            *error = [self streamError];
        }
        return NO;
    }
    return [self streamStatus] == NSStreamStatusOpen;
}

@end

#pragma mark -

static int bib_marcxml_write(void *context, char const *buffer, int length) {
    return (int)[(__bridge NSOutputStream *)context write:(uint8_t *)buffer maxLength:length];
}

static int bib_marcxml_close(void *context) {
    [(__bridge NSOutputStream *)context close];
    return ([(__bridge NSOutputStream *)context streamStatus] == NSStreamStatusClosed) ? 0 : -1;
}
