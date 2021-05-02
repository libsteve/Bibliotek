//
//  BibAttributes.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/31/21.
//  Copyright © 2021 Steve Brunwasser. All rights reserved.
//

#ifndef BibAttributes_h
#define BibAttributes_h

#ifndef BIB_SWIFT_BRIDGE
#if __has_attribute(swift_bridge)
#define BIB_SWIFT_BRIDGE(_swift_type) __attribute__((swift_bridge(#_swift_type)))
#else
#define BIB_SWIFT_BRIDGE(_swift_type)
#endif
#endif

#ifndef BIB_SWIFT_NONNULL_ERROR
#if __has_attribute(swift_error)
#define BIB_SWIFT_NONNULL_ERROR __attribute__((swift_error(nonnull_error)))
#else
#define BIB_SWIFT_NONNULL_ERROR
#endif
#endif

#endif /* BibAttributes_h */
