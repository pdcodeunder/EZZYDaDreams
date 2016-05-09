//
//  DSASubject.h
//  MVVMDemo
//
//  Created by 汪亚强 on 15-1-27.
//  Copyright (c) 2015年 bitcar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSASignal.h"
#import "DSASubscriber.h"
@interface DSASubject : DSASignal<DSASubscriber>
+ (instancetype)subject;

- (void)setDispose:(void (^)(void))dispose;
@end
