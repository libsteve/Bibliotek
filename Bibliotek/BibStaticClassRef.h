//
//  BibStaticClassRef.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 9/19/24.
//  Copyright © 2024 Steve Brunwasser. All rights reserved.
//

#ifndef BibStaticClassRef_h
#define BibStaticClassRef_h

#import <objc/runtime.h>

// Use pointer authentication if available.
#if defined(__has_include) && __has_include(<ptrauth.h>)
#import <ptrauth.h>
#endif

// Define the pointer authentication attribute as nothing if it doesn't exist.
#ifndef __ptrauth_objc_isa_pointer
#define __ptrauth_objc_isa_pointer
#endif

#define STATIC_CLASS_NAME(CLASS) __StaticClass_##CLASS
#define STATIC_CLASS_REF(CLASS) ((__bridge Class)&STATIC_CLASS_NAME(CLASS))

#define DECLARE_STATIC_CLASS_STRUCT(CLASS, ...) \
    struct CLASS {                              \
        Class __ptrauth_objc_isa_pointer isa;   \
        __VA_ARGS__                             \
    }

#define STATIC_CLASS_STRUCT(CLASS, ...)         \
    (struct CLASS){                             \
        STATIC_CLASS_REF(CLASS)                 \
        __VA_OPT__(,) __VA_ARGS__               \
    }

#define STATIC_CLASS_INSTANCE(CLASS, ...)       \
    (__bridge CLASS *)&STATIC_CLASS_STRUCT(CLASS __VA_OPT__(,) __VA_ARGS__)

#if __OBJC2__
/// The class object, stored as a text section symbol.
/// https://stackoverflow.com/questions/24968690/objective-c-mangled-names-objc-class-vs-objc-class-name
#define DECLARE_STATIC_CLASS_REF(CLASS)                                     \
    extern void const STATIC_CLASS_NAME(CLASS) __asm__("_OBJC_CLASS_$_"#CLASS)
#elif __OBJC__
/// The _ConstantRectangle class object, stored as an absolute global symbol.
/// https://stackoverflow.com/questions/24968690/objective-c-mangled-names-objc-class-vs-objc-class-name
#define DECLARE_STATIC_CLASS_REF(CLASS)                                     \
    extern void const STATIC_CLASS_NAME(CLASS) __asm(".objc_class_name_"#CLASS)
#endif

#pragma mark - ARC Methods Overrides

#if defined(__has_feature) && __has_feature(objc_arc)

/// We can't deallocate constant objects.
static void static_class_dealloc(void *self, SEL _cmd) {}

/// No use retaining constant objects.
static void *static_class_retain(void *self, SEL _cmd) { return self; }

/// No use releasing constant objects.
static void static_class_release(void *self, SEL _cmd) {}

/// No use autoreleasing constant objects.
static void *static_class_autorelease(void *self, SEL _cmd) { return self; }

/// No use keeping track of a constant object's retain count.
static NSUInteger static_class_retainCount(void *self, SEL _cmd) { return 1; }

/// Override an existing method on the given class.
static BOOL static_class_override_method(Class self, SEL selector, IMP function) {
    Method method = class_getInstanceMethod(self, selector);
    char const *types = method_getTypeEncoding(method);
    return class_addMethod(self, selector, function, types);
}

/// If ARC is enabled, we can't simply override the existing retain/release
/// methods, so instead we manually swizzle in our overrides when the class
/// is loaded into the runtime.
///
/// Call this function in the class's `load` method.
static void static_class_apply_overrides(Class self) {
    static_class_override_method(self, sel_getUid("dealloc"), (IMP)static_class_dealloc);
    static_class_override_method(self, sel_getUid("retain"), (IMP)static_class_retain);
    static_class_override_method(self, sel_getUid("release"), (IMP)static_class_release);
    static_class_override_method(self, sel_getUid("autorelease"), (IMP)static_class_autorelease);
    static_class_override_method(self, sel_getUid("retainCount"), (IMP)static_class_retainCount);
}

#endif

#endif /* BibStaticClassRef_h */
