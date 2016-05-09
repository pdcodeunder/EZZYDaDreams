//
//  ECarWeiZhangModel.h
//  ElectricCarRent
//
//  Created by 彭懂 on 16/4/12.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECarWeiZhangModel : NSObject

@property (nonatomic, strong) NSNumber *wzTime;
@property (nonatomic, strong) NSString *wzAddress;
@property (nonatomic, strong) NSString *wzPrice;
@property (nonatomic, strong) NSString *wzKouFen;
@property (nonatomic, strong) NSString *weizhangID;
@property (nonatomic, strong) NSString *wzMemberId;
@property (nonatomic, strong) NSString *wzFuWuFei;
@property (nonatomic, strong) NSString *carType;
@property (nonatomic, strong) NSString *carNo;
@property (nonatomic, strong) NSString *carColor;
@property (nonatomic, strong) NSString *carNoColor;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *processingStatus;
@property (nonatomic, strong) NSNumber *enteringTime;
@property (nonatomic, strong) NSNumber *processingTime;
@property (nonatomic, strong) NSNumber *endTime;
@property (nonatomic, strong) NSString *processingType; // 处理类型：0 自行处理 1委托
@property (nonatomic, strong) NSString *remarks;  // 备注
@property (nonatomic, strong) NSString *payMethod; // 支付方式
@property (nonatomic, strong) NSString *ticketNo; // 违章单单号
@property (nonatomic, strong) NSString *peccancycause;// 违章原因

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
