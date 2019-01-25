//
//  BibMarcRecordFieldTag.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/23/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MarcRecord.FieldTag)
@interface BibMarcRecordFieldTag : NSObject <NSSecureCoding>

@property (nonatomic, strong, readonly) NSString *stringValue;

- (nullable instancetype)initWithString:(NSString *)stringValue NS_DESIGNATED_INITIALIZER;

+ (nullable instancetype)fieldTagWithString:(NSString *)stringValue;

- (BOOL)isEqualToFieldTag:(BibMarcRecordFieldTag *)fieldTag;

@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *isbnFieldTag NS_SWIFT_NAME(isbn);
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *lccFieldTag NS_SWIFT_NAME(lcc);
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *ddcFieldTag NS_SWIFT_NAME(ddc);
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *authorFieldTag NS_SWIFT_NAME(author);
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *titleFieldTag NS_SWIFT_NAME(title);
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *editionFieldTag NS_SWIFT_NAME(edition);
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *publicationFieldTag NS_SWIFT_NAME(publication);
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *physicalDescriptionFieldTag NS_SWIFT_NAME(physicalDescription);
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *noteFieldTag NS_SWIFT_NAME(note);
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *bibliographyFieldTag NS_SWIFT_NAME(bibliography);
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *summaryFieldTag NS_SWIFT_NAME(summary);
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *subjectFieldTag NS_SWIFT_NAME(subject);
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *genreFieldTag NS_SWIFT_NAME(genre);
@property (class, nonatomic, strong, readonly) BibMarcRecordFieldTag *seriesFieldTag NS_SWIFT_NAME(series);

@end

NS_ASSUME_NONNULL_END
