//
//  ECarFapiaoHistoryModel.h
//  ElectricCarRent
//
//  Created by 张钊 on 16/3/30.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECarFapiaoHistoryModel : NSObject

@property (nonatomic, copy)NSString * state; // 邮寄状态
@property (nonatomic, copy)NSString * name;  // 姓名
@property (nonatomic, copy)NSString * phoneNum;  // 电话
@property (nonatomic, copy)NSString * address;   // 地址
@property (nonatomic, copy)NSString * companyHeader;  // 抬头
@property (nonatomic, copy)NSString * connets;   // 发票内容
@property (nonatomic, copy)NSString * costs;     // 发票花费
@property (nonatomic, copy)NSString * time;      // 开票时间

@property (nonatomic, copy)NSString * invNo;    // 发票编号
@property (nonatomic, copy)NSString * orderID;   // 订单编号
@property (nonatomic, copy)NSString * fanhuiID;   // 返回给后台的id
@property (nonatomic, copy)NSString * userID;    // 用户id
@property (nonatomic, copy)NSString * freeship;   // 是否包邮
@property (nonatomic, copy)NSString * mailCost;   // 邮寄费用
@property (nonatomic, copy)NSString * mailTime;   // 邮寄时间
@property (nonatomic, copy)NSString * expressCompany;  // 快递公司
@property (nonatomic, copy)NSString * expressNumber;   // 快递单号
@property (nonatomic, copy)NSString * invote;    // 备注

+(ECarFapiaoHistoryModel *)parseWithJSONDic:(NSDictionary *)dic;

@end
