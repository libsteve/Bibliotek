//
//  BibMARCXMLInputStream.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/6/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#import "BibMARCXMLInputStream.h"
#import "BibMARCXMLConstants.h"
#import <Bibliotek/Bibliotek.h>
#import <Bibliotek/Bibliotek+Internal.h>
#import <libxml/xmlreader.h>

static int bib_marcxml_read(void *context, char *buffer, int length);
static int bib_marcxml_close(void *context);

static NSError *BibMARCXMLInputStreamMakeMissingDataError(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);
static NSError *BibMARCXMLInputStreamMakeMalformedDataError(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);
static NSError *BibMARCXMLInputStreamMakeStreamAtEndError(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);

static NSString *BibXMLReaderTypeDescription(xmlReaderTypes type);

#pragma mark -

@implementation BibMARCXMLInputStream {
    xmlParserInputBufferPtr _input;
    xmlTextReaderPtr _reader;
    NSStreamStatus _streamStatus;
    NSError *_streamError;
    BOOL _didReadCollectionElement;
    BOOL _didReadRootRecordElement;
    NSInputStream *_inputStream;
    BOOL _warningsAsErrors;
}

- (instancetype)initWithInputStream:(NSInputStream *)inputStream
{
    if (self = [super initWithInputStream:inputStream]) {
        _inputStream = inputStream;
        void *context = (__bridge void *)inputStream;
        _input = xmlParserInputBufferCreateIO(bib_marcxml_read, bib_marcxml_close, context, XML_CHAR_ENCODING_UTF8);
        NSParameterAssert(_input != NULL);
    }
    return self;
}

- (void)dealloc
{
    [self close];
    xmlFreeParserInputBuffer(_input);
}

- (NSStreamStatus)streamStatus {
    return _streamStatus;
}

- (NSError *)streamError {
    return _streamError;
}

static char const *_parserErrorLevel(xmlParserSeverities severity) {
    switch (severity) {
        case XML_PARSER_SEVERITY_WARNING: return "WARNING";
        case XML_PARSER_SEVERITY_ERROR: return "ERROR";
        case XML_PARSER_SEVERITY_VALIDITY_WARNING: return "VALIDATION WARNING";
        case XML_PARSER_SEVERITY_VALIDITY_ERROR: return "VALIDATION ERROR";
    }
}

static void bib_marcxml_handleTextReaderError(void *context, char const *message,
                                              xmlParserSeverities severity,
                                              xmlTextReaderLocatorPtr locator) {
    BibMARCXMLInputStream *self = (__bridge id)context;
    switch (severity) {
        case XML_PARSER_SEVERITY_ERROR:
        case XML_PARSER_SEVERITY_VALIDITY_ERROR:
            break;
        case XML_PARSER_SEVERITY_WARNING:
        case XML_PARSER_SEVERITY_VALIDITY_WARNING:
            if (!self->_warningsAsErrors) {
                return;
            }
    }
    NSString *debug = [NSString stringWithFormat:@"xmlTextReader %s: %s", _parserErrorLevel(severity), message];
    self->_streamStatus = NSStreamStatusError;
    self->_streamError = [[NSError alloc] initWithDomain:BibSerializationErrorDomain
                                                    code:BibSerializationMalformedDataError
                                                userInfo:@{ NSDebugDescriptionErrorKey : debug }];
}

- (instancetype)open {
    if ([self streamStatus] == NSStreamStatusNotOpen) {
        [_inputStream open];
        _streamStatus = _inputStream.streamStatus;
        _streamError = _inputStream.streamError;
        if (_streamStatus == NSStreamStatusError) {
            return self;
        }
        _reader = xmlNewTextReader(_input, NULL);
        NSParameterAssert(_reader != NULL);
        xmlTextReaderSetErrorHandler(_reader, &bib_marcxml_handleTextReaderError, (__bridge void *)self);
    }
    return self;
}

- (instancetype)close
{
    if ([self streamStatus] != NSStreamStatusClosed) {
        if (_reader != NULL) {
            xmlTextReaderClose(_reader);
            xmlFreeTextReader(_reader);
            _reader = NULL;
            _streamStatus = [_inputStream streamStatus];
            _streamError = [_inputStream streamError];
        }
    }
    return self;
}

#pragma mark -

- (BOOL)_throwError:(NSError *)error toReceiver:(NSError *__autoreleasing *)receiver {
    if (error == nil) {
        return YES;
    }
    _streamStatus = NSStreamStatusError;
    _streamError = error;
    if (receiver != NULL) {
        *receiver = _streamError;
    }
    return NO;
}

- (BOOL)_advanceReader:(NSError *__autoreleasing *)error {
    switch (xmlTextReaderRead(_reader)) {
        case -1:
            if ([_inputStream streamStatus] == NSStreamStatusError) {
                return [self _throwError:[_inputStream streamError] toReceiver:error];
            }
            if (_streamStatus == NSStreamStatusError) {
                return [self _throwError:_streamError toReceiver:error];
            }
        case 0:
            _streamStatus = NSStreamStatusError;
            _streamError = BibMARCXMLInputStreamMakeStreamAtEndError(nil); // end of data
            return [self _throwError:_streamError toReceiver:error];
        case 1:
            break;
    }
    if (xmlTextReaderNodeType(_reader) == XML_READER_TYPE_SIGNIFICANT_WHITESPACE) {
        return [self _advanceReader:error];
    }
    return YES;
}

- (BOOL)_stringValue:(NSString *__autoreleasing *)stringValue error:(NSError *__autoreleasing *)error {
    if (![self _assertExpectedNodeType:XML_READER_TYPE_TEXT name:nil error:error]) {
        return NO;
    }
    NSParameterAssert(xmlTextReaderNodeType(_reader) == XML_READER_TYPE_TEXT);
    xmlChar const *content = xmlTextReaderConstValue(_reader);
    if (content == NULL) {
        if (error != NULL) {
            *error = BibMARCXMLInputStreamMakeMissingDataError
            (@"Did not find content in the current node: { type: %@, name: %s }",
             BibXMLReaderTypeDescription(xmlTextReaderNodeType(_reader)),
             (char *)xmlTextReaderConstName(_reader)); // did not find content in the current node
        }
        return NO;
    }
    if (stringValue != NULL) {
        *stringValue = [[NSString alloc] initWithCString:(char *)content encoding:NSUTF8StringEncoding];
    }
    return YES;
}

- (BOOL)_readValue:(NSString *__autoreleasing *)stringValue error:(NSError *__autoreleasing  *)error {
    if (![self _advanceReader:error]) {
        return NO;
    }
    if (![self _assertExpectedNodeType:XML_READER_TYPE_TEXT name:nil error:error]) {
        return NO;
    }
    return [self _stringValue:stringValue error:error];
}

- (BOOL)_assertElementHasAttributes:(NSError *__autoreleasing *)error {
    if (![self _assertExpectedNodeType:XML_READER_TYPE_ELEMENT name:nil error:error]) {
        return NO;
    }
    NSParameterAssert(xmlTextReaderNodeType(_reader) == XML_READER_TYPE_ELEMENT);
    if (xmlTextReaderHasAttributes(_reader)) {
        return YES;
    }
    if (error != NULL) {
        *error = BibMARCXMLInputStreamMakeMissingDataError
        (@"Current node does not contain attributes: { type: %@, name: %s }",
         BibXMLReaderTypeDescription(xmlTextReaderNodeType(_reader)),
         (char *)xmlTextReaderConstName(_reader));
    }
    return NO;
}

/// - note: You must call `xmlFree()` on the provided `attribute` when this method succeeds.
- (BOOL)_xmlAttribute:(xmlChar **)attribute name:(xmlChar const *)name error:(NSError *__autoreleasing *)error {
    NSParameterAssert(name != NULL);
    if (![self _assertExpectedNodeType:XML_READER_TYPE_ELEMENT name:nil error:error]) {
        return NO;
    }
    NSParameterAssert([self _assertElementHasAttributes:NULL]);
    xmlChar *value = xmlTextReaderGetAttribute(_reader, name);
    if (value == NULL) {
        if (error != NULL) {
            *error = BibMARCXMLInputStreamMakeMissingDataError
            (@"Current node does not contain expected attribute '%s': { type: %@, name: %s }",
             (char *)name,
             BibXMLReaderTypeDescription(xmlTextReaderNodeType(_reader)),
             (char *)xmlTextReaderConstName(_reader));
        }
        return NO;
    }
    if (attribute != NULL) {
        *attribute = value;
    }
    return YES;
}

- (BOOL)_attribute:(NSString *__autoreleasing *)attribute name:(xmlChar const *)name error:(NSError *__autoreleasing *)error {
    if (![self _assertExpectedNodeType:XML_READER_TYPE_ELEMENT name:nil error:error]) {
        return NO;
    }
    NSParameterAssert(xmlTextReaderNodeType(_reader) == XML_READER_TYPE_ELEMENT);
    NSParameterAssert(name != NULL);
    xmlChar *xmlValue = NULL;
    if (![self _xmlAttribute:&xmlValue name:name error:error]) {
        return NO;
    }
    if (attribute != NULL) {
        *attribute = [[NSString alloc] initWithCString:(char *)xmlValue encoding:NSUTF8StringEncoding];
    }
    xmlFree(xmlValue);
    return YES;
}

- (BOOL)_assertEndElementNamed:(xmlChar const *)name error:(NSError *__autoreleasing *)error {
    return [self _assertExpectedNodeType:XML_READER_TYPE_END_ELEMENT name:name error:error];
}

- (BOOL)_assertExpectedNodeType:(xmlReaderTypes)type name:(xmlChar const *)name error:(NSError *__autoreleasing *)error {
    if (xmlTextReaderNodeType(_reader) != type) {
        if (error != NULL) {
            if (name != NULL) {
                *error = BibMARCXMLInputStreamMakeMalformedDataError
                (@"Expected node { type: %@, %s } but found { type: %@, name: %s }",
                 BibXMLReaderTypeDescription(type), (char *)name,
                 BibXMLReaderTypeDescription(xmlTextReaderNodeType(_reader)),
                 xmlTextReaderConstName(_reader));
            } else {
                *error = BibMARCXMLInputStreamMakeMalformedDataError
                (@"Expected node type %@ but found { type: %@, name: %s }",
                 BibXMLReaderTypeDescription(type),
                 BibXMLReaderTypeDescription(xmlTextReaderNodeType(_reader)),
                 xmlTextReaderConstName(_reader));
            }
        }
        return NO;
    }
    if (name != NULL && !xmlStrEqual(xmlTextReaderConstName(_reader), name)) {
        if (error != NULL) {
            *error = BibMARCXMLInputStreamMakeMalformedDataError
            (@"Expected node { type: %@, name: %s } but found { type: %@, name: %s }",
             BibXMLReaderTypeDescription(type), (char *)name,
             BibXMLReaderTypeDescription(xmlTextReaderNodeType(_reader)),
             xmlTextReaderConstName(_reader));
        }
        return NO;
    }
    return YES;
}

- (BOOL)_subfield:(BibSubfield *__autoreleasing *)subfield error:(NSError *__autoreleasing *)error {
    if (![self _assertExpectedNodeType:XML_READER_TYPE_ELEMENT name:MARCXMLSubfield error:error]) {
        return NO;
    }
    NSParameterAssert(xmlTextReaderNodeType(_reader) == XML_READER_TYPE_ELEMENT);
    NSParameterAssert(xmlStrEqual(xmlTextReaderConstName(_reader), MARCXMLSubfield));
    if (!xmlStrEqual(MARCXMLSubfield, xmlTextReaderConstName(_reader))) {
        if (error != NULL) {
            *error = BibMARCXMLInputStreamMakeMalformedDataError
            (@"Expected element '%s': { type: %@, name: %s }",
             (char *)MARCXMLSubfield,
             BibXMLReaderTypeDescription(xmlTextReaderNodeType(_reader)),
             (char *)xmlTextReaderConstName(_reader));
        }
        return NO;
    }
    NSString *content = nil;
    BibSubfieldCode code = nil;
    if (![self _attribute:&code name:MARCXMLCode error:error] || ![self _readValue:&content error:error]) {
        return NO;
    }
    if (![self _advanceReader:error]) {
        return NO;
    }
    if (![self _assertExpectedNodeType:XML_READER_TYPE_END_ELEMENT name:MARCXMLSubfield error:error]) {
        return NO;
    }
    if (subfield != NULL) {
        *subfield = [[BibSubfield alloc] initWithCode:code content:content];
    }
    return YES;
}

- (BOOL)_readSubfiledOrDatafieldEnd:(BibSubfield *__autoreleasing *)subfield error:(NSError *__autoreleasing *)error {
    if (![self _advanceReader:error]) {
        return NO;
    }
    xmlReaderTypes type = xmlTextReaderNodeType(_reader);
    switch (type) {
        case XML_READER_TYPE_ELEMENT: {
            if ([self _assertExpectedNodeType:XML_READER_TYPE_ELEMENT name:MARCXMLSubfield error:error]) {
                return [self _subfield:subfield error:error];
            }
            return NO;
        }
        case XML_READER_TYPE_END_ELEMENT:
            if ([self _assertExpectedNodeType:XML_READER_TYPE_END_ELEMENT name:MARCXMLDatafield error:error]) {
                if (subfield != NULL) {
                    *subfield = nil;
                }
                return YES;
            }
            return NO;
        default:
            NSLog(@"type: %d; name: %s", type, (char *)xmlTextReaderConstLocalName(_reader));
            if (error != NULL) {
                *error = BibMARCXMLInputStreamMakeMalformedDataError
                (@"Expected { type: %@, name: %s } or { type: %@, name: %s } but found { type: %@, name: %s }",
                 BibXMLReaderTypeDescription(XML_READER_TYPE_ELEMENT), MARCXMLSubfield,
                 BibXMLReaderTypeDescription(XML_READER_TYPE_END_ELEMENT), MARCXMLDatafield,
                 BibXMLReaderTypeDescription(xmlTextReaderNodeType(_reader)),
                 (char *)xmlTextReaderConstName(_reader));
            }
            return NO;
    }
}

- (BOOL)_fieldTag:(BibFieldTag *__autoreleasing *)fieldTag error:(NSError *__autoreleasing *)error {
    if (![self _assertExpectedNodeType:XML_READER_TYPE_ELEMENT name:NULL error:error]) {
        return NO;
    }
    NSParameterAssert(xmlTextReaderNodeType(_reader) == XML_READER_TYPE_ELEMENT);
    NSString *tagString = nil;
    if (![self _attribute:&tagString name:MARCXMLTag error:error]) {
        return NO;
    }
    BibFieldTag *_fieldTag = [[BibFieldTag alloc] initWithString:tagString];
    if (_fieldTag == NULL) {
        if (error != NULL) {
            *error = BibMARCXMLInputStreamMakeMalformedDataError(@"Invalid MARC tag '%@'", tagString);
        }
        return NO;
    }
    if (fieldTag != NULL) {
        *fieldTag = _fieldTag;
    }
    return YES;
}

- (BOOL)_controlfiled:(BibRecordField *__autoreleasing *)controlfield error:(NSError *__autoreleasing *)error {
    if (![self _assertExpectedNodeType:XML_READER_TYPE_ELEMENT name:MARCXMLControlfield error:error]) {
        return NO;
    }
    NSParameterAssert(xmlTextReaderNodeType(_reader) == XML_READER_TYPE_ELEMENT);
    NSParameterAssert(xmlStrEqual(xmlTextReaderConstName(_reader), MARCXMLControlfield));
    BibFieldTag *tag = nil;
    NSString *content = nil;
    if ([self _fieldTag:&tag error:error] && [self _readValue:&content error:error]) {
        if (![self _advanceReader:error]) {
            return NO;
        }
        if (![self _assertExpectedNodeType:XML_READER_TYPE_END_ELEMENT name:MARCXMLControlfield error:error]) {
            return NO;
        }
        if (controlfield != NULL) {
            *controlfield = [[BibRecordField alloc] initWithFieldTag:tag controlValue:content];
        }
        return YES;
    }
    return NO;
}

- (BOOL)_fieldIndicator:(BibFieldIndicator *__autoreleasing *)indicator name:(xmlChar const *)name error:(NSError *__autoreleasing *)error {
    if (![self _assertExpectedNodeType:XML_READER_TYPE_ELEMENT name:MARCXMLDatafield error:error]) {
        return NO;
    }
    NSParameterAssert(xmlTextReaderNodeType(_reader) == XML_READER_TYPE_ELEMENT);
    NSParameterAssert(xmlStrEqual(xmlTextReaderConstName(_reader), MARCXMLDatafield));
    xmlChar *xmlValue = NULL;
    if (![self _xmlAttribute:&xmlValue name:name error:error]) {
        return NO;
    }
    if (indicator != NULL) {
        *indicator = [[BibFieldIndicator alloc] initWithRawValue:xmlValue[0]];
    }
    xmlFree(xmlValue);
    return YES;
}

- (BOOL)_datafield:(BibRecordField *__autoreleasing *)datafield error:(NSError *__autoreleasing *)error {
    if (![self _assertExpectedNodeType:XML_READER_TYPE_ELEMENT name:MARCXMLDatafield error:error]) {
        return NO;
    }
    NSParameterAssert(xmlTextReaderNodeType(_reader) == XML_READER_TYPE_ELEMENT);
    NSParameterAssert(xmlStrEqual(xmlTextReaderConstName(_reader), MARCXMLDatafield));
    BibFieldTag *tag = nil;
    BibFieldIndicator *ind1 = nil;
    BibFieldIndicator *ind2 = nil;
    if ([self _fieldTag:&tag error:error]
        && [self _fieldIndicator:&ind1 name:MARCXMLInd1 error:error]
        && [self _fieldIndicator:&ind2 name:MARCXMLInd2 error:error]) {
        BibSubfield *subfield = nil;
        NSMutableArray *subfields = (datafield != NULL) ? [NSMutableArray new] : nil;
        for (BOOL keepReading = YES; keepReading; keepReading = (subfield != nil)) {
            if (![self _readSubfiledOrDatafieldEnd:&subfield error:error]) {
                return NO;
            }
            if (subfield != nil) {
                [subfields addObject:subfield];
            }
        }
        if (datafield != NULL) {
            *datafield = [[BibRecordField alloc] initWithFieldTag:tag firstIndicator:ind1 secondIndicator:ind2
                                                        subfields:subfields];
        }
        return YES;
    }
    return NO;
}

- (BOOL)_readRecordFieldOrRecordEnd:(BibRecordField *__autoreleasing *)recordField error:(NSError *__autoreleasing *)error {
    if (![self _advanceReader:error]) {
        return NO;
    }
    xmlReaderTypes type = xmlTextReaderNodeType(_reader);
    switch (type) {
        case XML_READER_TYPE_ELEMENT: {
            xmlChar const *name = xmlTextReaderConstName(_reader);
            if (xmlStrEqual(name, MARCXMLControlfield)) {
                return [self _controlfiled:recordField error:error];
            }
            if (xmlStrEqual(name, MARCXMLDatafield)) {
                return [self _datafield:recordField error:error];
            }
            if (error != NULL) {
                *error = BibMARCXMLInputStreamMakeMalformedDataError
                (@"Expected '%s' or '%s' element found '%s'",
                 MARCXMLControlfield, MARCXMLDatafield, xmlTextReaderConstName(_reader));
            }
            return YES;
        }
        case XML_READER_TYPE_END_ELEMENT:
            if (![self _assertEndElementNamed:MARCXMLRecord error:error]) {
                return NO;
            }
            if (recordField != NULL) {
                *recordField = nil;
            }
            return YES;
        default:
            NSLog(@"type: %d; name: %s", type, (char *)xmlTextReaderConstLocalName(_reader));
            if (error != NULL) {
                *error = BibMARCXMLInputStreamMakeMalformedDataError
                (@"Expected { type: %@, name: %s }, { type: %@, name: %s }, or { type: %@, name: %s }"
                 @" but found { type: %@, name: %s }",
                 BibXMLReaderTypeDescription(XML_READER_TYPE_ELEMENT), MARCXMLControlfield,
                 BibXMLReaderTypeDescription(XML_READER_TYPE_ELEMENT), MARCXMLDatafield,
                 BibXMLReaderTypeDescription(XML_READER_TYPE_END_ELEMENT), MARCXMLRecord,
                 BibXMLReaderTypeDescription(xmlTextReaderNodeType(_reader)),
                 (char *)xmlTextReaderConstName(_reader));
            }
            return NO;
    }
}

- (BOOL)_readLeader:(BibLeader *__autoreleasing *)leader error:(NSError *__autoreleasing *)error {
    if (![self _advanceReader:error]) {
        return NO;
    }
    if (![self _assertExpectedNodeType:XML_READER_TYPE_ELEMENT name:nil error:error]) {
        return NO;
    }
    xmlChar const *name = xmlTextReaderConstName(_reader);
    if (!xmlStrEqual(name, MARCXMLLeader)) {
        if (error != NULL) {
            if (xmlStrEqual(name, MARCXMLControlfield) || xmlStrEqual(name, MARCXMLDatafield)) {
                *error = BibMARCXMLInputStreamMakeMissingDataError(@"Missing MARC leader");
            } else {
                [self _assertExpectedNodeType:XML_READER_TYPE_ELEMENT name:MARCXMLLeader error:error];
            }
        }
        return NO;
    }
    NSString *stringValue = nil;
    if (![self _readValue:&stringValue error:error]) {
        return NO;
    }
    if (![self _advanceReader:error]) {
        return NO;
    }
    if (![self _assertExpectedNodeType:XML_READER_TYPE_END_ELEMENT name:MARCXMLLeader error:error]) {
        return NO;
    }
    BibLeader *_leader = [[BibLeader alloc] initWithString:stringValue];
    if (_leader == nil) {
        if (error != NULL) {
            *error = BibMARCXMLInputStreamMakeMalformedDataError(@"Invalid MARC leader '%@'", stringValue);
        }
        return NO;
    }
    if (leader != NULL) {
        *leader = _leader;
    }
    return YES;
}

- (BOOL)_readRecordOrCollectionEnd:(BibRecord *__autoreleasing *)record error:(NSError *__autoreleasing *)error {
    if (_didReadCollectionElement && ![self _advanceReader:error]) {
        return NO;
    }
    xmlReaderTypes type = xmlTextReaderNodeType(_reader);
    switch (type) {
        case XML_READER_TYPE_ELEMENT: {
            if (![self _assertExpectedNodeType:XML_READER_TYPE_ELEMENT name:MARCXMLRecord error:error]) {
                return NO;
            }
            BibLeader *leader = nil;
            if (![self _readLeader:&leader error:error]) {
                return NO;
            }
            BibRecordField *field = nil;
            NSMutableArray *fields = (record != NULL) ? [NSMutableArray new] : nil;
            for (BOOL keepReading = YES; keepReading; keepReading = (field != nil)) {
                if (![self _readRecordFieldOrRecordEnd:&field error:error]) {
                    return NO;
                }
                if (field != nil) {
                    [fields addObject:field];
                }
            }
            if (record != NULL) {
                *record = [[BibRecord alloc] initWithLeader:leader fields:fields];
            }
            return YES;
        }
        case XML_READER_TYPE_END_ELEMENT:
            if (![self _assertEndElementNamed:MARCXMLCollection error:error]) {
                return NO;
            }
            if (record != NULL) {
                *record = nil;
            }
            return YES;
        default:
            NSLog(@"type: %d; name: %s", type, (char *)xmlTextReaderConstLocalName(_reader));
            if (error != NULL) {
                *error = BibMARCXMLInputStreamMakeMalformedDataError
                (@"Expected { type: %@, name: %s } or { type: %@, name: %s }"
                 @" but found { type: %@, name: %s }",
                 BibXMLReaderTypeDescription(XML_READER_TYPE_ELEMENT), MARCXMLRecord,
                 BibXMLReaderTypeDescription(XML_READER_TYPE_END_ELEMENT), MARCXMLCollection,
                 BibXMLReaderTypeDescription(xmlTextReaderNodeType(_reader)),
                 (char *)xmlTextReaderConstName(_reader));
            }
            return NO;
    }
}

#pragma mark -

- (BOOL)readRecord:(out BibRecord *__autoreleasing *)record error:(out NSError *__autoreleasing *)error {
    if ([self streamStatus] != NSStreamStatusOpen) {
        if ([self streamStatus] == NSStreamStatusAtEnd) {
            return NO;
        }
        if (error != NULL) {
            *error = BibSerializationMakeInputStreamNotOpenedError(_inputStream);
        }
        return NO;
    }
    NSError *_error = BibSerializationMakeInputStreamNotOpenedError(_inputStream);
    if (_error != nil) {
        if (error != NULL) {
            *error = _error;
        }
        return NO;
    }
    if (!_didReadCollectionElement && !_didReadRootRecordElement) {
        NSError *_error = nil;
        if (![self _advanceReader:&_error]) {
            if (error != NULL) {
                *error = _error;
            }
            _streamStatus = NSStreamStatusError;
            _streamError = _error;
            return NO;
        }
        if (xmlTextReaderNodeType(_reader) == XML_READER_TYPE_ELEMENT
            && xmlStrEqual(xmlTextReaderConstName(_reader), MARCXMLCollection)) {
            _didReadCollectionElement = YES;
        } else if (xmlTextReaderNodeType(_reader) == XML_READER_TYPE_ELEMENT
                   && xmlStrEqual(xmlTextReaderConstName(_reader), MARCXMLRecord)) {
            _didReadRootRecordElement = YES;
        } else {
            if (error != NULL) {
                *error = _error;
            }
            _streamStatus = NSStreamStatusError;
            _streamError = _error;
            return NO;
        }
    }
    if (![self _readRecordOrCollectionEnd:record error:&_error]) {
        if (error != NULL) {
            *error = _error;
        }
        _streamStatus = NSStreamStatusError;
        _streamError = _error;
        return NO;
    }
    if (record == nil) {
        _streamStatus = NSStreamStatusAtEnd;
    }
    return YES;
}

- (BibRecord *)readRecord:(out NSError *__autoreleasing *)error {
    BibRecord *record = nil;
    [self readRecord:&record error:error];
    return record;
}

@end

#pragma mark -

static int bib_marcxml_read(void *context, char *buffer, int length) {
    return (int)[(__bridge NSInputStream *)context read:(uint8_t *)buffer maxLength:length];
}

static int bib_marcxml_close(void *context) {
    [(__bridge NSInputStream *)context close];
    return ([(__bridge NSInputStream *)context streamStatus] == NSStreamStatusClosed) ? 0 : -1;
}

#pragma mark -

static NSString *debugDescriptionWithReason(NSString *message, NSString *format, va_list args) {
    if (format != nil) {
        NSString *reason = [[NSString alloc] initWithFormat:format arguments:args];
        message = [NSString stringWithFormat:@"%@: %@", message, reason];
    }
    return message;
}

static NSError *BibMARCXMLInputStreamMakeMissingDataError(NSString *format, ...) {
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    userInfo[NSDebugDescriptionErrorKey] = @"Expected to read more MARCXML data.";
//    NSLocalizedStringWithDefaultValue(@"serialization-error.marc-xml.missing-data",
//                                      @"Localized", [NSBundle bundleForClass:[BibMARCXMLInputStream self]],
//                                      @"Expected to read more MARCXML data.",
//                                      @"Error");
    if (format != nil) {
        va_list args;
        va_start(args, format);
        userInfo[NSDebugDescriptionErrorKey] = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
    }
    return  [NSError errorWithDomain:BibMARCSerializationErrorDomain
                                code:BibMARCSerializationMissingDataError
                            userInfo:userInfo];
}

static NSError *BibMARCXMLInputStreamMakeMalformedDataError(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *message = debugDescriptionWithReason(@"Malformed MARC XML data", format, args);
    va_end(args);
    return [NSError errorWithDomain:BibMARCSerializationErrorDomain
                               code:BibMARCSerializationMalformedDataError
                           userInfo:@{ NSDebugDescriptionErrorKey : message }];
}

static NSError *BibMARCXMLInputStreamMakeStreamAtEndError(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    static NSString *const message = @"Cannot read/write data from a the end of a stream";
    NSString *debug = debugDescriptionWithReason(message, format, args);
    va_end(args);
    return [NSError errorWithDomain:BibMARCSerializationErrorDomain
                               code:BibMARCSerializationStreamAtEndError
                           userInfo:@{ NSDebugDescriptionErrorKey : debug }];
}

#pragma mark -

static NSString *BibXMLReaderTypeDescription(xmlReaderTypes type) {
    switch (type) {
        case XML_READER_TYPE_NONE: return @"XML_READER_TYPE_NONE";
        case XML_READER_TYPE_ELEMENT: return @"XML_READER_TYPE_ELEMENT";
        case XML_READER_TYPE_ATTRIBUTE: return @"XML_READER_TYPE_ATTRIBUTE";
        case XML_READER_TYPE_TEXT: return @"XML_READER_TYPE_TEXT";
        case XML_READER_TYPE_CDATA: return @"XML_READER_TYPE_CDATA";
        case XML_READER_TYPE_ENTITY_REFERENCE: return @"XML_READER_TYPE_ENTITY_REFERENCE";
        case XML_READER_TYPE_ENTITY: return @"XML_READER_TYPE_ENTITY";
        case XML_READER_TYPE_PROCESSING_INSTRUCTION: return @"XML_READER_TYPE_PROCESSING_INSTRUCTION";
        case XML_READER_TYPE_COMMENT: return @"XML_READER_TYPE_COMMENT";
        case XML_READER_TYPE_DOCUMENT: return @"XML_READER_TYPE_DOCUMENT";
        case XML_READER_TYPE_DOCUMENT_TYPE: return @"XML_READER_TYPE_DOCUMENT_TYPE";
        case XML_READER_TYPE_DOCUMENT_FRAGMENT: return @"XML_READER_TYPE_DOCUMENT_FRAGMENT";
        case XML_READER_TYPE_NOTATION: return @"XML_READER_TYPE_NOTATION";
        case XML_READER_TYPE_WHITESPACE: return @"XML_READER_TYPE_WHITESPACE";
        case XML_READER_TYPE_SIGNIFICANT_WHITESPACE: return @"XML_READER_TYPE_SIGNIFICANT_WHITESPACE";
        case XML_READER_TYPE_END_ELEMENT: return @"XML_READER_TYPE_END_ELEMENT";
        case XML_READER_TYPE_END_ENTITY: return @"XML_READER_TYPE_END_ENTITY";
        case XML_READER_TYPE_XML_DECLARATION: return @"XML_READER_TYPE_XML_DECLARATION";
        default: return [NSString stringWithFormat:@"Unknown xmlReaderType %d", type];
    }
}
