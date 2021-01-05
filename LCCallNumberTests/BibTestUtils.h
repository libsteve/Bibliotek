//
//  BibTestUtils.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 1/4/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#ifndef BibTestUtils_h
#define BibTestUtils_h

#define BibAssertEqualStrings(expression1, expression2, ...) \
    _XCTPrimitiveAssertEqualObjects(self, @(expression1), @#expression1, @(expression2), @#expression2, __VA_ARGS__)

#endif /* BibTestUtils_h */
