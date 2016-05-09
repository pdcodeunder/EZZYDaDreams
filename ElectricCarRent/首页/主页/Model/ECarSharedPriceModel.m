//
//  ECarSharedPriceModel.m
//  ElectricCarRent
//
//  Created by 彭懂 on 15/11/25.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarSharedPriceModel.h"

@implementation ECarSharedPriceModel

+ (instancetype)sharedPriceModel
{
    static ECarSharedPriceModel * model = nil;
    if (model == nil) {
        model = [[ECarSharedPriceModel alloc] init];
    }
    return model;
}

@end
