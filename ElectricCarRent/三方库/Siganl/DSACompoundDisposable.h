//
//  DSACompoundDisposable.h
//  MVVMDemo
//
//  Created by 汪亚强 on 15-1-28.
//  Copyright (c) 2015年 bitcar. All rights reserved.
//

#import "DSADisposable.h"

@interface DSACompoundDisposable : DSADisposable
+ (instancetype)compoundDisposable;
@end
