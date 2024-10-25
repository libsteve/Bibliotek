//
//  Bibliotek+Internal.m
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/8/22.
//  Copyright © 2022 Steve Brunwasser. All rights reserved.
//

#import "Bibliotek+Internal.h"
#import <os/log.h>
#import <objc/runtime.h>
#import <objc/message.h>

/// Get the `+` or `-` prefix for a class or instance method respectfully.
///
/// - parameter self: The receiver for a method: either an object or a class.
/// - returns: `'+'` for classes and `'-'` for objects.
///
/// Both `-class` and `+class` return the same value for an object and its class.
/// With this knowledge, we can determine whether `self` is an object or class by
/// comparing `self` to `[self class]` to see if they're equal. `-class` is
/// is never equal to its object receiver, but `+class` always equals its receiver.
static inline char BibSelectorPrefixForObject(id self) {
    return (self == [self class]) ? '+' : '-';
}

NSString *BibMethodName(id self, SEL _cmd) {
    return [NSString stringWithFormat:@"%c%@", BibSelectorPrefixForObject(self), NSStringFromSelector(_cmd)];
}

NSString *BibFullMethodName(id self, Class clss, SEL _cmd) {
    char const prefix = BibSelectorPrefixForObject(self);
    NSString *className = NSStringFromClass(clss ?: [self class]);
    return [NSString stringWithFormat:@"%c[%@ %@]", prefix, className, NSStringFromSelector(_cmd)];
}

#pragma mark - Unimplemented Method Exceptions

BIB_COLD static os_log_t BibUnimplementedMethodsLog(void) {
    static os_log_t log = nil;
    dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        log = os_log_create("Bibliotek", "UnimplementedMethods");
    });
    return log;
}

/// Throw an exception for unimplemented methods with the specified semantics.
///
/// - parameter self: The object or class that received a call to the unimplemented method.
/// - parameter clss: The class that declared the unimplemented abstract method.
/// - parameter _cmd: The selector of the unimplemented method, provided by its `_cmd` argument.
/// - parameter type: The special semantics for a method, describing it as either
///                   an `"initializer"` a `"property"` or a regular `"method"`
BIB_COLD BIB_NORETURN static inline void _BibUnimplementedSelector(id self, Class clss, SEL _cmd, char const *type) {
    os_log_t const log = BibUnimplementedMethodsLog();
    NSString *const method = BibFullMethodName(self, clss, _cmd);
    os_log_fault(log, "%{public}@ does not implement the required %{public}s %{public}@", [self className], type, method);
    [NSException raise:NSInvalidArgumentException
                format:@"%@ does not implement the required %s %@", [self className], type, method];
    __builtin_unreachable();
}

BIB_COLD BIB_NORETURN void BibUnimplementedInitializer(id self, Class clss, SEL _cmd) {
    _BibUnimplementedSelector(self, clss, _cmd, "initializer");
}

BIB_COLD BIB_NORETURN void BibUnimplementedProperty(id self, Class clss, SEL _cmd) {
    _BibUnimplementedSelector(self, clss, _cmd, "property");
}

BIB_COLD BIB_NORETURN void BibUnimplementedMethod(id self, Class clss, SEL _cmd) {
    _BibUnimplementedSelector(self, clss, _cmd, "method");
}

BIB_COLD BIB_NORETURN void BibUnimplementedSelector(id self, SEL _cmd) {
    os_log_t const log = BibUnimplementedMethodsLog();
    NSString *method = BibMethodName(self, _cmd);
    os_log_fault(log, "%{public}@ does not implement %{public}@", [self className], method);
    [NSException raise:NSInvalidArgumentException format:@"%@ does not implement %@", [self className], method];
    __builtin_unreachable();
}
