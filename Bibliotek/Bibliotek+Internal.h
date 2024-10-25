//
//  Bibliotek+Internal.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import <Bibliotek/Bibliotek.h>

#import <Bibliotek/BibSerializationError+Internal.h>

#import <Bibliotek/BibHasher.h>

#if __has_attribute(objc_direct)
#define BIB_DIRECT __attribute__((objc_direct))
#else
#define BIB_DIRECT
#endif

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

#pragma mark -

/// Describe a class or instance method, i.e. `-addObject:`
///
/// - parameter self: The receiver of the method call. This can be either an object or a class.
/// - parameter _cmd: The method's selector, given to each method with its `_cmd` argument.
extern NSString *BibMethodName(id self, SEL _cmd);

/// Describe a method with the class of its receivers, i.e. `-[NSArray addObject:]`
///
/// - parameter self: The receiver of the method call. This can be either an object or a class.
/// - parameter clss: The `Class` where the method was originally defined.
///                   The class of `self` is used when `clss` is `nil`
/// - parameter _cmd: The method's selector, given to each method with its `_cmd` argument.
extern NSString *BibFullMethodName(id self, Class clss, SEL _cmd);

#pragma mark - Unimplemented Method Exceptions

/// Throw an exception when an abstract method isn't overridden by its subclass.
///
/// - parameter self: The object or class that received a call to the unimplemented initializer.
/// - parameter clss: The class that declared the unimplemented abstract initializer.
/// - parameter _cmd: The selector of the unimplemented initializer, provided by its `_cmd` argument.
/// - throws: An `NSInvalidArgumentException` on every call.
extern void BibUnimplementedInitializer(id self, Class clss, SEL _cmd) BIB_COLD BIB_NORETURN;

/// Throw an exception when an abstract method isn't overridden by its subclass.
///
/// - parameter self: The object or class that received a call to the unimplemented property.
/// - parameter clss: The class that declared the unimplemented abstract property.
/// - parameter _cmd: The selector of the unimplemented property, provided by its `_cmd` argument.
/// - throws: An `NSInvalidArgumentException` on every call.
extern void BibUnimplementedProperty(id self, Class clss, SEL _cmd) BIB_COLD BIB_NORETURN;

/// Throw an exception when an abstract method isn't overridden by its subclass.
///
/// - parameter self: The object or class that received a call to the unimplemented method.
/// - parameter clss: cThe lass that declared the unimplemented abstract method.
/// - parameter _cmd: The selector of the unimplemented method, provided by its `_cmd` argument.
/// - throws: An `NSInvalidArgumentException` on every call.
extern void BibUnimplementedMethod(id self, Class clss, SEL _cmd) BIB_COLD BIB_NORETURN;

/// Throw an exception when an abstract method isn't overridden by its subclass.
///
/// - parameter self: The object or class that received a call to the unimplemented selector.
/// - parameter _cmd: The selector of the unimplemented method, provided by its `_cmd` argument.
/// - throws: An `NSInvalidArgumentException` on every call.
extern void BibUnimplementedSelector(id self, SEL _cmd) BIB_COLD BIB_NORETURN;

#define BibUnimplementedInitializerFrom(KLASS) BibUnimplementedInitializer(self, [KLASS self], _cmd)
#define BibUnimplementedPropertyFrom(KLASS) BibUnimplementedProperty(self, [KLASS self], _cmd)
#define BibUnimplementedMethodFrom(KLASS) BibUnimplementedMethod(self, [KLASS self], _cmd)
#define BibUnimplemented() BibUnimplementedSelector(self, _cmd)
