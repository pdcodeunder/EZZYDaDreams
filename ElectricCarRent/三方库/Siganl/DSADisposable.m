//
//  DSADisposable.m
//  MVVMDemo
//
//  Created by 汪亚强 on 15-1-27.
//  Copyright (c) 2015年 bitcar. All rights reserved.
//

#import "DSADisposable.h"
#import <libkern/OSAtomic.h>
@interface DSADisposable () {
   
    void * volatile _disposeBlock;
    OSSpinLock _spinLock;
}

@end
@implementation DSADisposable
+ (instancetype)disposableWithBlock:(void (^)(void))block {
    return [[self alloc] initWithBlock:block];
}
- (id)initWithBlock:(void (^)(void))block {
    NSCParameterAssert(block != nil);
    
    self = [super init];
    if (self == nil) return nil;
    _disposablesArray=[NSMutableArray arrayWithCapacity:0];
    _disposeBlock = (void *)CFBridgingRetain([block copy]);
    OSMemoryBarrier();
    
    return self;
}
- (void)dealloc {
    if (_disposeBlock == NULL || _disposeBlock == (__bridge void *)self) return;
    
    CFRelease(_disposeBlock);
    _disposeBlock = NULL;
}
- (void)dispose {
    void (^disposeBlock)(void) = NULL;
    
    while (YES) {
        void *blockPtr = _disposeBlock;
        if (OSAtomicCompareAndSwapPtrBarrier(blockPtr, NULL, &_disposeBlock)) {
            if (blockPtr != (__bridge void *)self) {
                disposeBlock = CFBridgingRelease(blockPtr);
            }
            
            break;
        }
    }
    
    if (disposeBlock != nil)
    {
        disposeBlock();
    }
    


    
}
-(void)addDisposable:(DSADisposable *)disposable
{
    OSSpinLockLock(&_spinLock);
    {
        [_disposablesArray addObject:disposable];
    }
    OSSpinLockUnlock(&_spinLock);
}

- (void)removeDisposable:(DSADisposable *)disposable {
    if (disposable == nil) return;
    
    OSSpinLockLock(&_spinLock);
    {
        //[disposable dispose];
        [self.disposablesArray removeObject:disposable];
        
    }
    OSSpinLockUnlock(&_spinLock);
}


@end
