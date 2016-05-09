//
//  DSASubscriber.m
//  MVVMDemo
//
//  Created by 汪亚强 on 15-1-27.
//  Copyright (c) 2015年 bitcar. All rights reserved.
//

#import "DSASubscriber.h"
#import "DSADisposable.h"
@interface DSASubscriber ()

// These callbacks should only be accessed while synchronized on self.
@property (nonatomic, copy) void (^next)(id value);
@property (nonatomic, copy) void (^error)(NSError *error);
@property (nonatomic, copy) void (^completed)(void);
@property (nonatomic, strong, readonly) DSADisposable *disposable;
@end

@implementation DSASubscriber
+ (instancetype)subscriberWithNext:(void (^)(id x))next error:(void (^)(NSError *error))error completed:(void (^)(void))completed {
    DSASubscriber *subscriber = [[self alloc] init];
    
    subscriber->_next = [next copy];
    subscriber->_error = [error copy];
    subscriber->_completed = [completed copy];
    
    return subscriber;
}
- (id)init {
    self = [super init];
    if (self == nil) return nil;
    __weak DSASubscriber *weakSelf=self;
    DSADisposable *selfDisposable = [DSADisposable disposableWithBlock:^{
        
        if (weakSelf == nil) return;
        
        @synchronized (weakSelf) {
            weakSelf.next = nil;
            weakSelf.error = nil;
            weakSelf.completed = nil;
        }
    }];
    _disposable=selfDisposable;
    return self;
}
- (void)sendNext:(id)value {
    @synchronized (self) {
        void (^nextBlock)(id) = [self.next copy];
        if (nextBlock == nil) return;
        
        nextBlock(value);
    }
}

- (void)sendError:(NSError *)e {
    @synchronized (self) {
        void (^errorBlock)(NSError *) = [self.error copy];
        
        if (errorBlock == nil) return;
        errorBlock(e);
    }
}

- (void)sendCompleted {
    @synchronized (self) {
        void (^completedBlock)(void) = [self.completed copy];
        if (completedBlock == nil) return;
        completedBlock();
    }
}
-(void)dealloc
{
}
@end
