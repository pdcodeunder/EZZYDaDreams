//
//  OrderModel.m
//  ElectricCarRent
//
//  Created by 程元杰 on 15/11/6.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
- (id)initWithContentsOfDic:(NSDictionary *)dic
{
    self = [super initWithContentsOfDic:dic];
    if (self) {
        // 以为字段的名字是关键字所以不能直接映射，我们手动写入
        self.user_id = dic[@"userorderid"];
        self.rmb = [NSString stringWithFormat:@"%@", dic[@"rmb"]];
        self.isfinish = dic[@"isfinish"];
        self.begin = dic[@"begin"];
        self.end = dic[@"end"];
        self.createdate = dic[@"createdate"];
        self.distance = dic[@"distance"];
        self.endPLatitude = [NSString stringWithFormat:@"%@", dic[@"endPLatitude"]];
        self.endPLongitude = [NSString stringWithFormat:@"%@", dic[@"endPLongitude"]];
        self.carPLongtitude = [NSString stringWithFormat:@"%@", dic[@"carSPLongitude"]];
        self.carPLatitude = [NSString stringWithFormat:@"%@", dic[@"carSPLatitude"]];
        self.orderID = dic[@"id"];
        self.powerunit = dic[@"powerunit"];
        NSDictionary * carDic = dic[@"car"];
        self.carno = carDic[@"carno"];
        NSString *createDate = [NSString stringWithFormat:@"%@", dic[@"createdate"]];
        self.yanShiTime = [NSString stringWithFormat:@"%lf", [self timeSinceShengYuTimeWith:createDate]];
        self.isYanShi = [NSString stringWithFormat:@"%@", dic[@"isyanchi"]];
        self.lanYaDic = carDic;
    }
    return self;
}

- (NSTimeInterval)timeSinceShengYuTimeWith:(NSString *)beginTime
{
    NSTimeInterval begin = [beginTime doubleValue] / 1000.f;
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = date.timeIntervalSince1970;
    return timeInterval - begin;
}

@end
