//
//  DSASignal.m
//  MVVMDemo
//
//  Created by 汪亚强 on 15-1-27.
//  Copyright (c) 2015年 bitcar. All rights reserved.
//

#import "DSASignal.h"
#import "DSASubscriber.h"
#import "DSADisposable.h"
#import "DSASubject.h"
@implementation DSASignal
+ (DSASignal *)createSignal:(DSADisposable * (^)(id<DSASubscriber> subscriber))didSubscribe
{
    DSASubject *subject=[DSASubject subject];
    
    return subject;
}
- (DSADisposable *)subscribeNext:(void (^)(id x))nextBlock
{
    NSCParameterAssert(nextBlock != NULL);
    
    DSASubscriber *o = [DSASubscriber subscriberWithNext:nextBlock error:NULL completed:NULL];
    return  [self subscribe:o];
}
- (DSADisposable *)subscribe:(id<DSASubscriber>)subscriber {
    NSCAssert(NO, @"This method must be overridden by subclasses");
    return nil;
}
/// Convenience method to subscribe to the `next` and `completed` events.
- (DSADisposable *)subscribeNext:(void (^)(id x))nextBlock completed:(void (^)(void))completedBlock
{
    NSCParameterAssert(nextBlock != NULL);
    NSCParameterAssert(completedBlock != NULL);
    
    DSASubscriber *o = [DSASubscriber subscriberWithNext:nextBlock error:NULL completed:completedBlock];
    return  [self subscribe:o];
}

/// Convenience method to subscribe to the `next`, `completed`, and `error` events.
- (DSADisposable *)subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock
{
    NSCParameterAssert(nextBlock != NULL);
    NSCParameterAssert(errorBlock != NULL);
    NSCParameterAssert(completedBlock != NULL);
    
    DSASubscriber *o = [DSASubscriber subscriberWithNext:nextBlock error:errorBlock completed:completedBlock];
    return  [self subscribe:o];
}

/// Convenience method to subscribe to `error` events.
///
/// This corresponds to the `IObserver<T>.OnError` in Rx.
- (DSADisposable *)subscribeError:(void (^)(NSError *error))errorBlock
{
    NSCParameterAssert(errorBlock != NULL);
    
    DSASubscriber *o = [DSASubscriber subscriberWithNext:NULL error:errorBlock completed:NULL];
    return  [self subscribe:o];
}

/// Convenience method to subscribe to `completed` events.
///
/// This corresponds to the `IObserver<T>.OnCompleted` in Rx.
- (DSADisposable *)subscribeCompleted:(void (^)(void))completedBlock
{
    NSCParameterAssert(completedBlock != NULL);
    
    DSASubscriber *o = [DSASubscriber subscriberWithNext:NULL error:NULL completed:completedBlock];
    return  [self subscribe:o];
}

/// Convenience method to subscribe to `next` and `error` events.
- (DSADisposable *)subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock
{
    NSCParameterAssert(nextBlock != NULL);
    NSCParameterAssert(errorBlock != NULL);
    
    DSASubscriber *o = [DSASubscriber subscriberWithNext:nextBlock error:errorBlock completed:NULL];
    return  [self subscribe:o];
}

/// Convenience method to subscribe to `error` and `completed` events.
- (DSADisposable *)subscribeError:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock
{
    NSCParameterAssert(completedBlock != NULL);
    NSCParameterAssert(errorBlock != NULL);
    
    DSASubscriber *o = [DSASubscriber subscriberWithNext:NULL error:errorBlock completed:completedBlock];
    return  [self subscribe:o];
}
@end
