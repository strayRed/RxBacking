//
//  _Backing.m
//  RxBacking
//
//  Created by strayRed on 2021/10/12.
//

#import "_Backing.h"
@import ObjectiveC.runtime;

static NSMutableDictionary<NSString *, NSMutableSet<NSString *>*> *cachedResponsiveSELPerClass;

static NSMutableDictionary<NSString *, NSValue *> *swizzleFlags;

@implementation _Backing

+(NSSet*)fliterResponsiveSelectorsForProtocol:(Protocol *)protocol {
    NSMutableSet *selectors = [NSMutableSet set];
    /// discard the `NSObjectProtocol` methods.
    if (protocol_isEqual(protocol, NSProtocolFromString(@"NSObject"))) {
        return selectors;
    }
    unsigned int protocolMethodCount = 0;
    struct objc_method_description *pMethods = protocol_copyMethodDescriptionList(protocol, NO, YES, &protocolMethodCount);
    
    for (unsigned int i = 0; i < protocolMethodCount; ++i) {
        struct objc_method_description pMethod = pMethods[i];
        Method method = class_getInstanceMethod(self, pMethod.name);
        if (method) {
            NSString *sel = NSStringFromSelector(pMethod.name);
            /// discard the `CA_` methods.
            if (![sel hasPrefix:@"CA_"]) {
                [selectors addObject:sel];
            }
        }
    }
            
    free(pMethods);

    unsigned int numberOfBaseProtocols = 0;
    Protocol * __unsafe_unretained * pSubprotocols = protocol_copyProtocolList(protocol, &numberOfBaseProtocols);

    for (unsigned int i = 0; i < numberOfBaseProtocols; ++i) {
        [selectors unionSet:[self fliterResponsiveSelectorsForProtocol:pSubprotocols[i]]];
    }
    
    free(pSubprotocols);

    return selectors;
}

+ (void)initialize {
    if (cachedResponsiveSELPerClass == nil) {
        cachedResponsiveSELPerClass = [NSMutableDictionary<NSString *, NSMutableSet <NSString *>*> new];
    }
    NSString *classString = NSStringFromClass(self);
    NSMutableSet *selectors;
    if (cachedResponsiveSELPerClass[classString]) {
        selectors = cachedResponsiveSELPerClass[classString];
    }
    else {
        selectors = [NSMutableSet new];
#define CLASS_HIERARCHY_MAX_DEPTH 100
        NSInteger  classHierarchyDepth = 0;
        Class      targetClass         = NULL;

        for (classHierarchyDepth = 0, targetClass = self;
             classHierarchyDepth < CLASS_HIERARCHY_MAX_DEPTH && targetClass != nil;
             ++classHierarchyDepth, targetClass = class_getSuperclass(targetClass)
             ) {
            
            NSSet *cachedSelectorsForProtocol = cachedResponsiveSELPerClass[NSStringFromClass(targetClass)];
            if (cachedSelectorsForProtocol) {
                [selectors unionSet:cachedSelectorsForProtocol];
            }
            else {
                unsigned int count;
                Protocol *__unsafe_unretained *pProtocols = class_copyProtocolList(targetClass, &count);
                for (unsigned int i = 0; i < count; i++) {
                    NSSet *selectorsForProtocol = [self fliterResponsiveSelectorsForProtocol:pProtocols[i]];
                    [selectors unionSet:selectorsForProtocol];
                }
                free(pProtocols);
            }
        }
        if (classHierarchyDepth == CLASS_HIERARCHY_MAX_DEPTH) {
            NSLog(@"Detected weird class hierarchy with depth over %d. Starting with this class -> %@", CLASS_HIERARCHY_MAX_DEPTH, self);
#if DEBUG
            abort();
#endif
        }
        cachedResponsiveSELPerClass[classString] = selectors;
    }
    [self swizzleResponsiveMethods];
}

typedef struct IMPWrapper {
    IMP  value;
    bool isEmpty;
} *P_IMPWrapper;

+(void)swizzleResponsiveMethods {
    if(!swizzleFlags) { swizzleFlags = [NSMutableDictionary new]; }
    NSSet *selectors = cachedResponsiveSELPerClass[NSStringFromClass(self)];
    for (NSString *selString in selectors) {
        // Only swizzle once for each method.
        if(swizzleFlags[selString]) { return; }
        SEL sel = NSSelectorFromString(selString);
        Method method = class_getInstanceMethod(self, sel);
        unsigned int argCount = method_getNumberOfArguments(method);
        IMP oldIMP = method_getImplementation(method);
        IMP newIMP;
        P_IMPWrapper (^ forwardIMPWrapperGenerator)(id);
        forwardIMPWrapperGenerator = ^(id obj) {
            NSObject *forwardObject = [obj valueForKey:@"forwardObject"];
            struct IMPWrapper impWrapper; P_IMPWrapper pImpWrapper = &impWrapper;
            if (![forwardObject respondsToSelector:sel]) {
                // True means nil.
                pImpWrapper->isEmpty = true;
            }
            else {
                Method method = class_getInstanceMethod([forwardObject class], sel);
                pImpWrapper->value = method_getImplementation(method);
                pImpWrapper->isEmpty = false;
            }
            return pImpWrapper;
        };
        if(argCount == 2) {
            /// The SEL argument should not be declared in the block IMP.
            /// Using `void*` to represent any pointer.
            void*(^ newImpBlock)(id);
            newImpBlock = ^(id obj) {
                P_IMPWrapper forwardIMPWrapper = forwardIMPWrapperGenerator(obj);
                if(forwardIMPWrapper->isEmpty) {
                    return ((void* (*)(id, SEL))oldIMP)(obj, sel);
                }
                else {
                    return ((void* (*)(id, SEL))forwardIMPWrapper->value)(obj, sel);
                }
            };
            newIMP = imp_implementationWithBlock(newImpBlock);
        }
        else if (argCount == 3) {
            void*(^ newImpBlock)(id, void*);
            newImpBlock = ^(id obj, void* a) {
                P_IMPWrapper forwardIMPWrapper = forwardIMPWrapperGenerator(obj);
                if(forwardIMPWrapper->isEmpty) {
                    return ((void* (*)(id, SEL, void*))oldIMP)(obj, sel, a);
                }
                else {
                    return ((void* (*)(id, SEL, void*))forwardIMPWrapper->value)(obj, sel, a);
                }
            };
            newIMP = imp_implementationWithBlock(newImpBlock);
        }
        else if (argCount == 4) {
            void*(^ newImpBlock)(id, void*, void*);
            newImpBlock = ^(id obj, void* a, void* b) {
                P_IMPWrapper forwardIMPWrapper = forwardIMPWrapperGenerator(obj);
                if(forwardIMPWrapper->isEmpty) {
                    return ((void* (*)(id, SEL, void*, void*))oldIMP)(obj, sel, a, b);
                }
                else {
                    return ((void* (*)(id, SEL, void*, void*))forwardIMPWrapper->value)(obj, sel, a, b);
                }
            };
            newIMP = imp_implementationWithBlock(newImpBlock);
        }
        
        else if (argCount == 5) {
            void*(^ newImpBlock)(id, void*, void*, void*);
            newImpBlock = ^(id obj, void* a, void* b, void* c) {
                P_IMPWrapper forwardIMPWrapper = forwardIMPWrapperGenerator(obj);
                if(forwardIMPWrapper->isEmpty) {
                    return ((void* (*)(id, SEL, void*, void*, void*))oldIMP)(obj, sel, a, b, c);
                }
                else {
                    return ((void* (*)(id, SEL, void*, void*, void*))forwardIMPWrapper->value)(obj, sel, a, b, c);
                }
            };
            newIMP = imp_implementationWithBlock(newImpBlock);
        }
        
        else if (argCount == 6) {
            void*(^ newImpBlock)(id, void*, void*, void*, void*);
            newImpBlock = ^(id obj, void* a, void* b, void* c, void* d) {
                P_IMPWrapper forwardIMPWrapper = forwardIMPWrapperGenerator(obj);
                if(forwardIMPWrapper->isEmpty) {
                    return ((void* (*)(id, SEL, void*, void*, void*, void*))oldIMP)(obj, sel, a, b, c, d);
                }
                else {
                    return ((void* (*)(id, SEL, void*, void*, void*, void*))forwardIMPWrapper->value)(obj, sel, a, b, c, d);
                }
            };
            newIMP = imp_implementationWithBlock(newImpBlock);
        }
        
        else if (argCount == 7) {
            void*(^ newImpBlock)(id, void*, void*, void*, void*, void*);
            newImpBlock = ^(id obj, void* a, void* b, void* c, void* d, void* e) {
                P_IMPWrapper forwardIMPWrapper = forwardIMPWrapperGenerator(obj);
                if(forwardIMPWrapper->isEmpty) {
                    return ((void* (*)(id, SEL, void*, void*, void*, void*, void*))oldIMP)(obj, sel, a, b, c, d, e);
                }
                else {
                    return ((void* (*)(id, SEL, void*, void*, void*, void*, void*))forwardIMPWrapper->value)(obj, sel, a, b, c, d, e);
                }
            };
            newIMP = imp_implementationWithBlock(newImpBlock);
        }
        else {
            // The max number of arugments is set as 7(5).
            // That should be enough :)
            return;
        }
        if(newIMP) {
            method_setImplementation(method, newIMP);
            swizzleFlags[selString] = @YES;
        }
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [[self forwardObject] respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return [self forwardObject];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}


-(NSObject *)forwardObject {
    /// Override in subclasses.
    return nil;
}

@end
