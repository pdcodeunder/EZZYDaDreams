//
//  ECarCarInfo.h
//  ElectricCarRent
//
//  Created by LIKUN on 15/10/7.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECarCarInfo : NSObject

@property (copy, nonatomic) NSString *carno;/**<车牌号*/
@property (copy, nonatomic) NSString *lanYaName; // 蓝牙设备名称
@property (copy, nonatomic) NSString *lanYaServiceName; // 蓝牙服务名称
@property (copy, nonatomic) NSString *lanYaWriteCharacteristiceName; //蓝牙写特性名称
@property (copy, nonatomic) NSString *lanYaNotifyCharacteristiceName; // 蓝牙通知特性名称
@property (copy, nonatomic) NSString *lanYaPassWord; // 蓝牙动态码
@property (copy, nonatomic) NSString *carid;/**<车辆ID*/
@property (copy, nonatomic) NSString *carsn;/**<车辆SN*/
@property (copy, nonatomic) NSString *name;/**<车辆名称*/
@property (copy, nonatomic) NSString *Mileage;/**<续航里程*/
@property (copy, nonatomic) NSString *altitude;/**<车辆高度*/
@property (copy, nonatomic) NSString *carlongitude;/**<车辆经度*/
@property (copy, nonatomic) NSString *carLatitude;/**<车辆纬度*/
@property (copy, nonatomic) NSString *vehicleModel;/**<车辆型号*/
@property (copy, nonatomic) NSString *carDesc;/**<车辆描述*/
@property (copy, nonatomic) NSString *mapmsg;/**<运营范围*/
@property (copy, nonatomic) NSString *status;/**<车辆状态*/
@property (copy, nonatomic) NSString *drivingLicense;/**<行驶证号*/
@property (strong, nonatomic) NSArray *carPictureAry; /**<车辆图片*/
@property (copy, nonatomic) NSString * distance;
@property (strong, nonatomic) NSString * duration;
@property (copy, nonatomic) NSString * locationName;
- (instancetype)initWithResponse:(NSDictionary *)dic;

@end
