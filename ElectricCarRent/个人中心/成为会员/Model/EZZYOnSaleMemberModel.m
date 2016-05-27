//
//  EZZYOnSaleMemberModel.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/5/13.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "EZZYOnSaleMemberModel.h"

@implementation EZZYOnSaleMemberModel

- (instancetype)initWithOnSaleModelDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.mothly = [NSString stringWithFormat:@"%@", dic[@"effeTime"]];
        self.dazhe = [NSString stringWithFormat:@"%@", dic[@"sale"]];
        NSString *strr = [NSString stringWithFormat:@"%@", dic[@"levelMoney"]];
        self.xianjia = [NSString stringWithFormat:@"%zd", strr.integerValue];
        self.levelCode = [NSString stringWithFormat:@"%@", dic[@"levelCode"]];
    }
    return self;
}

@end
