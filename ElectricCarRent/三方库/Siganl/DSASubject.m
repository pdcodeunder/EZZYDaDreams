//
//  DSASubject.m
//  MVVMDemo
//
//  Created by 汪亚强 on 15-1-27.
//  Copyright (c) 2015年 bitcar. All rights reserved.
//

#import "DSASubject.h"
#import "DSASubscriber.h"
#import "DSADisposable.h"
@interface DSASubject ()
@property (nonatomic, strong, readonly) NSMutableArray *subscribers;
@property (nonatomic,strong) void (^disposeBlock)();
- (void)enumerateSubscribersUsingBlock:(void (^)(id<DSASubscriber> subscriber))block;
@end
@implementation DSASubject

+ (instancetype)subject {
    return [[self alloc] init];
}
- (id)init {
    self = [super init];
    if (self == nil) return nil;
    
    _subscribers = [[NSMutableArray alloc] initWithCapacity:1];
    
    return self;
}
#pragma mark RACSubscriber
- (DSADisposable *)subscribe:(id<DSASubscriber>)subscriber {
    NSCParameterAssert(subscriber != nil);
    
    
    NSMutableArray *subscribers = self.subscribers;
    @synchronized (subscribers) {
        [subscribers addObject:subscriber];
    }
    return [DSADisposable disposableWithBlock:^{
        @synchronized (subscribers) {
            // Since newer subscribers are generally shorter-lived, search
            // starting from the end of the list.
            NSUInteger index = [subscribers indexOfObjectWithOptions:NSEnumerationReverse passingTest:^ BOOL (id<DSASubscriber> obj, NSUInteger index, BOOL *stop) {
                return obj == subscriber;
            }];
            //TODO
            if (index != NSNotFound)
            {
                if (_disposeBlock)
                {
                     _disposeBlock();
                }
                else
                {
                    NSLog(@"信号量disposeBlock未实现");
                }
               
                [subscribers removeObjectAtIndex:index];
            }
        }
    }];
    
}
- (void)enumerateSubscribersUsingBlock:(void (^)(id<DSASubscriber> subscriber))block {
    NSArray *subscribers;
    @synchronized (self.subscribers) {
        subscribers = [self.subscribers copy];
    }
    
    for (id<DSASubscriber> subscriber in subscribers) {
        block(subscriber);
    }
}
- (void)sendNext:(id)value {
    [self enumerateSubscribersUsingBlock:^(id<DSASubscriber> subscriber) {
        [subscriber sendNext:value];
    }];
}

- (void)sendError:(NSError *)error {
    
    
    [self enumerateSubscribersUsingBlock:^(id<DSASubscriber> subscriber) {
        [subscriber sendError:error];
    }];
}

- (void)sendCompleted {
   
    
    [self enumerateSubscribersUsingBlock:^(id<DSASubscriber> subscriber) {
        [subscriber sendCompleted];
    }];
}

- (void)setDispose:(void (^)(void))dispose
{
    _disposeBlock = [dispose copy];
}

@end
