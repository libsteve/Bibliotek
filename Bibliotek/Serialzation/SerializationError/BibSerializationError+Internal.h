//
//  BibSerializationError+Internal.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/12/22.
//  Copyright © 2022 Steve Brunwasser. All rights reserved.
//

#import "BibSerializationError.h"

NS_ASSUME_NONNULL_BEGIN

extern NSError *BibSerializationMakeMissingDataError(NSDictionary *userInfo);
extern NSError *BibSerializationMakePrematureEndOfData(NSDictionary *userInfo);
extern NSError *_Nullable BibSerializationMakeInputStreamNotOpenedError(NSStream *stream);
extern NSError *_Nullable BibSerializationMakeOutputStreamNotOpenedError(NSStream *stream);

NS_ASSUME_NONNULL_END
