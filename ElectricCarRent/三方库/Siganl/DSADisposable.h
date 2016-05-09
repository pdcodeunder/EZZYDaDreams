//
//  DSADisposable.h
//  MVVMDemo
//
//  Created by 汪亚强 on 15-1-27.
//  Copyright (c) 2015年 bitcar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSADisposable : NSObject
@property (atomic, assign, getter = isDisposed, readonly) BOOL disposed;
@property(nonatomic,strong)NSMutableArray *disposablesArray;
+ (instancetype)disposableWithBlock:(void (^)(void))block;

/// Performs the disposal work. Can be called multiple times, though subsequent
/// calls won't do anything.
- (void)dispose;
- (void)addDisposable:(DSADisposable *)disposable;
- (void)removeDisposable:(DSADisposable *)disposable;
@end
