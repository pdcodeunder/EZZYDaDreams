//
//  DSAPropertySubscribing.m
//  MVVMDemo
//
//  Created by 汪亚强 on 15-1-28.
//  Copyright (c) 2015年 bitcar. All rights reserved.
//

#import "DSAPropertySubscribing.h"
#import "DSASubject.h"
#import "DSAKVOTrampoline.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "DSACompoundDisposable.h"
static void *DSAKVOWrapperContext = &DSAKVOWrapperContext;
static const void *DSAObjectCompoundDisposable = &DSAObjectCompoundDisposable;




static NSMutableSet *swizzledClasses() {
    static dispatch_once_t onceToken;
    static NSMutableSet *swizzledClasses = nil;
    dispatch_once(&onceToken, ^{
        swizzledClasses = [[NSMutableSet alloc] init];
    });
    
    return swizzledClasses;
}

static void swizzleDeallocIfNeeded(Class classToSwizzle) {
    @synchronized (swizzledClasses()) {
        NSString *className = NSStringFromClass(classToSwizzle);
        if ([swizzledClasses() containsObject:className]) return;
        
        SEL deallocSelector = sel_registerName("dealloc");
        
        __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
        
        id newDealloc = ^(__unsafe_unretained id self) {
            DSADisposable *compoundDisposable = objc_getAssociatedObject(self,DSAObjectCompoundDisposable);
            [compoundDisposable dispose];
            
            if (originalDealloc == NULL) {
                struct objc_super superInfo = {
                    .receiver = self,
                    .super_class = class_getSuperclass(classToSwizzle)
                };
                
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                msgSend(&superInfo, deallocSelector);
            } else {
                originalDealloc(self, deallocSelector);
            }
        };
        
        IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
        
        if (!class_addMethod(classToSwizzle, deallocSelector, newDeallocIMP, "v@:")) {
            // The class already contains a method implementation.
            Method deallocMethod = class_getInstanceMethod(classToSwizzle, deallocSelector);
            
            // We need to store original implementation before setting new implementation
            // in case method is called at the time of setting.
            originalDealloc = (__typeof__(originalDealloc))method_getImplementation(deallocMethod);
            
            // We need to store original implementation again, in case it just changed.
            originalDealloc = (__typeof__(originalDealloc))method_setImplementation(deallocMethod, newDeallocIMP);
        }
        [swizzledClasses() addObject:className];
    }
}


@implementation NSObject(DSAPropertySubscribing)
- (DSASignal *)rac_valuesForKeyPath:(NSString *)keyPath observer:(NSObject *)observer {
    
    return [self rac_valuesAndChangesForKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld observer:observer];
    
}

- (DSASignal *)rac_valuesAndChangesForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options observer:(NSObject *)observer
{
    
        DSASubject *subject=[DSASubject subject];
        [self addObserver:observer forKeyPath:keyPath options:options context:DSAKVOWrapperContext block:^(id target, id observer, NSDictionary *change) {
            [subject sendNext:change];
        }];
//        DSAKVOTrampoline *trampoline=[self addObserver:observer forKeyPath:keyPath options:options context:DSAKVOWrapperContext block:^(id target, id observer, NSDictionary *change) {
//            [subject sendNext:change];
//        }];
  
//        DSADisposable *dispose=[DSADisposable disposableWithBlock:^{
//            
//            [trampoline dispose];
//        }];
//        [dispose addDisposable:trampoline];

    
    return subject;
    
}
-(DSAKVOTrampoline *)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context block:(DSAKVOBlock)block
{
   
    DSAKVOTrampoline *trampoline=[[DSAKVOTrampoline alloc]initWithTarget:self observer:observer keyPath:keyPath options:options block:block];
    return trampoline;
}
- (DSADisposable *)rac_deallocDisposable {
    @synchronized (self) {
        DSADisposable *compoundDisposable = objc_getAssociatedObject(self, DSAObjectCompoundDisposable);
        if (compoundDisposable != nil) return compoundDisposable;
        
        swizzleDeallocIfNeeded(self.class);
        
        compoundDisposable =[DSACompoundDisposable compoundDisposable];
        objc_setAssociatedObject(self, DSAObjectCompoundDisposable, compoundDisposable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return compoundDisposable;
    }
}

@end
