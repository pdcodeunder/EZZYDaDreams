//
//  OrderModel.h
//  ElectricCarRent
//
//  Created by 程元杰 on 15/11/6.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "BaseModel.h"

@interface OrderModel : BaseModel

@property (nonatomic, strong) NSString * stateLbale;//订单状态
@property (nonatomic, copy) NSString * carno;
@property (nonatomic, copy) NSString * orderID;
@property (nonatomic, strong) NSNumber * createdate;
@property (nonatomic, strong) NSNumber * distance;
@property (nonatomic, strong) NSNumber * isfinish;
@property (nonatomic, strong) NSString * begin;
@property (nonatomic, strong) NSString * end;
@property (nonatomic, strong) NSString * user_id;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * rmb;
@property (nonatomic, copy)   NSString * powerunit;
/**
 *  剩余时间
 */
@property (nonatomic, strong) NSString * yanShiTime;
// 是否延时
@property (nonatomic, strong) NSString * isYanShi;
// 目的地经纬度
@property (nonatomic, copy) NSString * endPLongitude;
@property (nonatomic, copy) NSString * endPLatitude;
// 车经纬度
@property (nonatomic, copy) NSString * carPLongtitude;
@property (nonatomic, copy) NSString * carPLatitude;
@property (nonatomic, strong) NSDictionary * lanYaDic;

@end
