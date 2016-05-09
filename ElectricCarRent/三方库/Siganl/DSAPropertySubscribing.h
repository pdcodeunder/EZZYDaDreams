//
//  DSAPropertySubscribing.h
//  MVVMDemo
//
//  Created by 汪亚强 on 15-1-28.
//  Copyright (c) 2015年 bitcar. All rights reserved.
//

#define DSAObserve(TARGET, KEYPATH) \
[(id)(TARGET) rac_valuesForKeyPath:@keypath(TARGET, KEYPATH) observer:self]
#import <Foundation/Foundation.h>
#import "DSASignal.h"
typedef void (^DSAKVOBlock)(id target, id observer, NSDictionary *change);
@interface NSObject(DSAPropertySubscribing)
@property (atomic, readonly, strong) DSADisposable *rac_deallocDisposable;
- (DSASignal *)rac_valuesForKeyPath:(NSString *)keyPath observer:(NSObject *)observer;

- (DSASignal *)rac_valuesAndChangesForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options observer:(NSObject *)observer;
@end
