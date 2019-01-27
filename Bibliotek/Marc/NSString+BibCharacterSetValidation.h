//
//  NSString+BibCharacterSetValidation.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/27/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (BibCharacterSetValidation)

- (BOOL)bib_isRestrictedToCharacterSet:(NSCharacterSet *)characterSet inRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
