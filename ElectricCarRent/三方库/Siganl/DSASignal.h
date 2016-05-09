//
//  DSASignal.h
//  MVVMDemo
//
//  Created by 汪亚强 on 15-1-27.
//  Copyright (c) 2015年 bitcar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSADisposable.h"
#import "DSASubscriber.h"
@interface DSASignal : NSObject
+ (DSASignal *)createSignal:(DSADisposable * (^)(id<DSASubscriber> subscriber))didSubscribe;
/// Convenience method to subscribe to the `next` event.
///
/// This corresponds to `IObserver<T>.OnNext` in Rx.
- (DSADisposable *)subscribeNext:(void (^)(id x))nextBlock;

/// Convenience method to subscribe to the `next` and `completed` events.
- (DSADisposable *)subscribeNext:(void (^)(id x))nextBlock completed:(void (^)(void))completedBlock;

/// Convenience method to subscribe to the `next`, `completed`, and `error` events.
- (DSADisposable *)subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock;

/// Convenience method to subscribe to `error` events.
///
/// This corresponds to the `IObserver<T>.OnError` in Rx.
- (DSADisposable *)subscribeError:(void (^)(NSError *error))errorBlock;

/// Convenience method to subscribe to `completed` events.
///
/// This corresponds to the `IObserver<T>.OnCompleted` in Rx.
- (DSADisposable *)subscribeCompleted:(void (^)(void))completedBlock;

/// Convenience method to subscribe to `next` and `error` events.
- (DSADisposable *)subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock;

/// Convenience method to subscribe to `error` and `completed` events.
- (DSADisposable *)subscribeError:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock;
@end
