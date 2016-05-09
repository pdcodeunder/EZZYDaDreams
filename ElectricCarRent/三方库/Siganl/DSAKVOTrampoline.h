//
//  DSAKVOTrampoline.h
//  MVVMDemo
//
//  Created by 汪亚强 on 15-1-28.
//  Copyright (c) 2015年 bitcar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSAPropertySubscribing.h"
#import "DSADisposable.h"
@interface DSAKVOTrampoline : DSADisposable
//- (DSAKVOTrampoline *)rac_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(DSAKVOBlock)block {
//    return [[RACKVOTrampoline alloc] initWithTarget:self observer:observer keyPath:keyPath options:options block:block];
//}
- (id)initWithTarget:(NSObject *)target observer:(NSObject *)observer keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(DSAKVOBlock)block;
@end
