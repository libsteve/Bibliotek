//
//  BibMarcRecord+Decodable.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/13/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BibCoding/BibCoding.h>
#import "BibMarcRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface BibMarcRecord (Decodable) <BibDecodable>

@end

NS_ASSUME_NONNULL_END
