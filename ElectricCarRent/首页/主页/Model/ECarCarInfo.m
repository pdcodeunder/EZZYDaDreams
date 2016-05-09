//
//  ECarCarInfo.m
//  ElectricCarRent
//
//  Created by LIKUN on 15/10/7.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarCarInfo.h"
#import "ECarGPSChange.h"
#import <CoreLocation/CLLocation.h>
@implementation ECarCarInfo
- (instancetype)initWithResponse:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.carno = dic[@"carno"];                         /**<车牌号*/
        self.carid = dic[@"id"];                            /**<车辆ID*/
        self.carsn = dic[@"sn"];                            /**<车辆SN*/
        self.name = dic[@"name"];                           /**<车辆名称*/
        self.Mileage = dic[@"Mileage"];                     /**<续航里程*/
        self.altitude = dic[@"altitude"];                   /**<车辆高度*/
        [self change:[dic[@"latitude"]floatValue] longtd:[dic[@"longitude"] floatValue]];
        self.vehicleModel = dic[@"vehicleModel"];            /**<车辆型号*/
        self.carDesc = dic[@"info"];                         /**<车辆描述*/
        self.mapmsg = dic[@"mapmsg"];                        /**<运营范围*/
        self.status = dic[@"status"];                        /**<车辆状态*/
        self.drivingLicense = dic[@"drivingLicense"];        /**<行驶证号*/
        self.duration = dic[@"duration"];                   /**<步行时间*/
        self.distance = [NSString stringWithFormat:@"%@", dic[@"distance"]]; /**<距离*/
//        self.carPictureAry = @[dic[@"carPicturePath1"], dic[@"carPicturePath2"],dic[@"carPicturePath3"],dic[@"carPicturePath4"], dic[@"carPicturePath5"]]; /**<车辆图片*/
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ECarCarInfo *copy = [[self class] allocWithZone: zone];
    copy.carno = _carno;
    copy.carid = _carid;
    copy.carsn = _carsn;
    copy.name = _name;
    copy.Mileage = _Mileage;
    copy.altitude = _altitude;
    copy.vehicleModel = _vehicleModel;
    copy.carDesc = _carDesc;
    copy.carLatitude = _carLatitude;
    copy.carlongitude = _carlongitude;
    copy.mapmsg = _mapmsg;
    copy.status = _status;
    copy.drivingLicense = _drivingLicense;
    copy.distance = _distance;
    copy.duration = _duration;
    copy.carPictureAry = _carPictureAry;
    return copy;
}

- (void)change:(float)latitude longtd:(float)longitude
{
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude, longitude);
//    CLLocationCoordinate2D newLocation = MACoordinateConvert(location, MACoordinateTypeGPS);
    self.carLatitude = FloatToString(location.latitude);
    self.carlongitude = FloatToString(location.longitude);
}
@end
