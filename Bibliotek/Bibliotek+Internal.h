//
//  Bibliotek+Internal.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Bibliotek/Bibliotek.h>

#import <Bibliotek/BibMetadata+Internal.h>
#import <Bibliotek/BibSerializationError+Internal.h>

#import <Bibliotek/BibHasher.h>

#define BibMApply(M, ...) M(__VA_ARGS__)
#define BibMConcat(M, ...) M ## __VA_ARGS__
#define BibMCount(...) _BibMCount_Sequence(__VA_ARGS__, 8, 7, 6, 5, 4, 3, 2, 1)
#define _BibMCount_Sequence(_8, _7, _6, _5, _4, _3, _2, _1, N, ...) N

#define __BibKeyPath_N(N) BibMConcat(__BibKeyPath_, N)
#define __BibKeyPath_1 _BibKeyPath_1
#define __BibKeyPath_2 _BibKeyPath_2
#define __BibKeyPath_3 _BibKeyPath_3
#define __BibKeyPath_4 _BibKeyPath_4
#define __BibKeyPath_5 _BibKeyPath_5

#ifdef DEBUG

#define BibKey(KEY) NSStringFromSelector(@selector(KEY))
#define BibKeyPath(...)  [@[ _BibKeyPath_N(__VA_ARGS__) ] componentsJoinedByString:@"."]
#define _BibKeyPath_1(KEY, ...) NSStringFromSelector(@selector(KEY))
#define _BibKeyPath_2(KEY, ...) _BibKeyPath_1(KEY), _BibKeyPath_1(__VA_ARGS__)
#define _BibKeyPath_3(KEY, ...) _BibKeyPath_1(KEY), _BibKeyPath_2(__VA_ARGS__)
#define _BibKeyPath_4(KEY, ...) _BibKeyPath_1(KEY), _BibKeyPath_3(__VA_ARGS__)
#define _BibKeyPath_5(KEY, ...) _BibKeyPath_1(KEY), _BibKeyPath_4(__VA_ARGS__)
#define _BibKeyPath_6(KEY, ...) _BibKeyPath_1(KEY), _BibKeyPath_5(__VA_ARGS__)
#define _BibKeyPath_7(KEY, ...) _BibKeyPath_1(KEY), _BibKeyPath_6(__VA_ARGS__)
#define _BibKeyPath_8(KEY, ...) _BibKeyPath_1(KEY), _BibKeyPath_7(__VA_ARGS__)
#define _BibKeyPath_N(...) BibMApply(__BibKeyPath_N(BibMCount(__VA_ARGS__)), __VA_ARGS__)

#else

#define BibKey(KEY) @#KEY
#define BibKeyPath(...) @ _BibKeyPath_N(__VA_ARGS__)
#define _BibKeyPath_1(KEY, ...) #KEY
#define _BibKeyPath_2(KEY, ...) _BibKeyPath_1(KEY) "." _BibKeyPath_1(__VA_ARGS__)
#define _BibKeyPath_3(KEY, ...) _BibKeyPath_1(KEY) "." _BibKeyPath_2(__VA_ARGS__)
#define _BibKeyPath_4(KEY, ...) _BibKeyPath_1(KEY) "." _BibKeyPath_3(__VA_ARGS__)
#define _BibKeyPath_5(KEY, ...) _BibKeyPath_1(KEY) "." _BibKeyPath_4(__VA_ARGS__)
#define _BibKeyPath_6(KEY, ...) _BibKeyPath_1(KEY) "." _BibKeyPath_5(__VA_ARGS__)
#define _BibKeyPath_7(KEY, ...) _BibKeyPath_1(KEY) "." _BibKeyPath_6(__VA_ARGS__)
#define _BibKeyPath_8(KEY, ...) _BibKeyPath_1(KEY) "." _BibKeyPath_7(__VA_ARGS__)
#define _BibKeyPath_N(...) BibMApply(__BibKeyPath_N(BibMCount(__VA_ARGS__)), __VA_ARGS__)

#endif
