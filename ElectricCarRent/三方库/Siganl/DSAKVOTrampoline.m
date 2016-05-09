//
//  DSAKVOTrampoline.m
//  MVVMDemo
//
//  Created by 汪亚强 on 15-1-28.
//  Copyright (c) 2015年 bitcar. All rights reserved.
//

#import "DSAKVOTrampoline.h"
#import "DSAPropertySubscribing.h"
static void *DSAKVOWrapperContext = &DSAKVOWrapperContext;

@interface DSAKVOTrampoline ()

// The keypath which the trampoline is observing.
@property (nonatomic, readonly, copy) NSString *keyPath;

// These properties should only be manipulated while synchronized on the
// receiver.
@property (nonatomic, readonly, copy) DSAKVOBlock block;
@property (nonatomic, readonly, unsafe_unretained) NSObject *target;
@property (nonatomic, readonly, unsafe_unretained) NSObject *observer;

@end

@implementation DSAKVOTrampoline
- (id)initWithTarget:(NSObject *)target observer:(NSObject *)observer keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(DSAKVOBlock)block
{
    NSCParameterAssert(target != nil);
    NSCParameterAssert(keyPath != nil);
    NSCParameterAssert(block != nil);
    
    self = [super init];
    if (self == nil) return nil;
    
    _keyPath = [keyPath copy];
    
    _block = [block copy];
    _target = target;
    _observer = observer;
    
    [self.target addObserver:self forKeyPath:self.keyPath options:options context:&DSAKVOWrapperContext];
    [self.target.rac_deallocDisposable addDisposable:self];
    [self.observer.rac_deallocDisposable addDisposable:self];
    
    return self;

}
- (void)dealloc {
    [self dispose];
}

#pragma mark Observation

- (void)dispose {
    NSObject *target;
    NSObject *observer;
    
    @synchronized (self) {
        _block = nil;
        
        target = self.target;
        observer = self.observer;
        
        _target = nil;
        _observer = nil;
    }
    [target.rac_deallocDisposable removeDisposable:self];
    [observer.rac_deallocDisposable removeDisposable:self];
    
    
    [target removeObserver:self forKeyPath:self.keyPath context:&DSAKVOWrapperContext];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != &DSAKVOWrapperContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    DSAKVOBlock block;
    id observer;
    id target;
    
    @synchronized (self) {
        block = self.block;
        observer = self.observer;
        target = self.target;
    }
    
    if (block == nil) return;
    
    block(target, observer, change);
}


@end
