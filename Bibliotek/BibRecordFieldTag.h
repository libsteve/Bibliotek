//
//  BibRecordFieldTag.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/25/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *BibRecordFieldTag NS_TYPED_EXTENSIBLE_ENUM NS_SWIFT_NAME(Record.Field.Tag);

extern BibRecordFieldTag const BibRecordFieldTagIsbn;
extern BibRecordFieldTag const BibRecordFieldTagLCC NS_SWIFT_NAME(lcc);
extern BibRecordFieldTag const BibRecordFieldTagDDC NS_SWIFT_NAME(ddc);
extern BibRecordFieldTag const BibRecordFieldTagAuthor;
extern BibRecordFieldTag const BibRecordFieldTagTitle;
extern BibRecordFieldTag const BibRecordFieldTagEdition;
extern BibRecordFieldTag const BibRecordFieldTagPublication;
extern BibRecordFieldTag const BibRecordFieldTagPhysicslDescription;
extern BibRecordFieldTag const BibRecordFieldTagNote;
extern BibRecordFieldTag const BibRecordFieldTagBibliography;
extern BibRecordFieldTag const BibRecordFieldTagSummary;
extern BibRecordFieldTag const BibRecordFieldTagSubject;
extern BibRecordFieldTag const BibRecordFieldTagGenre;
extern BibRecordFieldTag const BibRecordFieldTagSeries;



