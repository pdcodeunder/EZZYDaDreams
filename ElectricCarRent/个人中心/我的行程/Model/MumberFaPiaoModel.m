//
//  MumberFaPiaoModel.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/3/30.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "MumberFaPiaoModel.h"

@implementation MumberFaPiaoModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.mfpTime = dic[@"payTimer"];
        self.mfpPrice = dic[@"payMoney"];
        self.mfpType = dic[@"vipname"];
        self.mfpNumber = dic[@"uid"];
        self.mfpID = dic[@"id"];
    }
    return self;
}

@end
