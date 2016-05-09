//
//  ECarConfigs.m
//  ElectricCarRent
//
//  Created by LIKUN on 15/9/11.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarConfigs.h"

static ECarConfigs *config = nil;

@implementation ECarConfigs
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[ECarConfigs alloc] init];
        config.cancelStatus = 2;
    });
    return config;
}
- (instancetype)init
{
    if (self = [super init]) {
        _user = [[ECarUser alloc] init];
    }
    return self;
}

//- (BOOL)loginStatue
//{
//    return YES;
//}
@end
