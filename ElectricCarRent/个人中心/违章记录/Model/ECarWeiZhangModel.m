//
//  ECarWeiZhangModel.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/4/12.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarWeiZhangModel.h"

@implementation ECarWeiZhangModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.weizhangID = [NSString stringWithFormat:@"%@", dic[@"id"]];
        NSDictionary * member = dic[@"member"];
        self.wzMemberId = member[@""];
        self.wzTime = dic[@"peccancyTime"];
        self.wzAddress = [NSString stringWithFormat:@"%@", dic[@"peccancyPlace"]];
        self.wzPrice = [NSString stringWithFormat:@"%@", dic[@"peccancyMoney"]];
        self.wzKouFen = [NSString stringWithFormat:@"%@", dic[@"illegalDeduction"]];
        self.processingType = [NSString stringWithFormat:@"%@", dic[@"processingType"]];
        self.endTime = dic[@"endTime"];
        self.processingTime = dic[@"processingTime"];
        self.enteringTime = dic[@"enteringTime"];
        self.processingStatus = [NSString stringWithFormat:@"%@", dic[@"processingStatus"]];
        self.orderId = [NSString stringWithFormat:@"%@", dic[@"orderid"]];
        self.carNoColor = [NSString stringWithFormat:@"%@", dic[@"carnocolor"]];
        self.carColor = [NSString stringWithFormat:@"%@", dic[@"carcolor"]];
        self.carNo = [NSString stringWithFormat:@"%@", dic[@"carno"]];
        self.carType = [NSString stringWithFormat:@"%@", dic[@"cartype"]];
        self.wzFuWuFei = [NSString stringWithFormat:@"%@", dic[@"serviceMoney"]];
        self.remarks = [NSString stringWithFormat:@"%@", dic[@"remarks"]];
        self.payMethod = [NSString stringWithFormat:@"%@", dic[@"payMethod"]];
        self.ticketNo = [NSString stringWithFormat:@"%@", dic[@"ticketNo"]];
        self.peccancycause = [NSString stringWithFormat:@"%@", dic[@"peccancycause"]];
    }
    return self;
}

@end
