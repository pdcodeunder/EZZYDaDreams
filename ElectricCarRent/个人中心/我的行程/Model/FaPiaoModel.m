//
//  FaPiaoModel.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/3/30.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "FaPiaoModel.h"

@implementation FaPiaoModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.fpTime = dic[@"begindate"];
        self.fpPrice = dic[@"rmb"];
        self.fpBeginAdd = dic[@"begin"];
        self.fpEndAdd = dic[@"end"];
        self.fpNumber = dic[@"userorderid"];
        self.fpId = dic[@"id"];
    }
    return self;
}

@end
