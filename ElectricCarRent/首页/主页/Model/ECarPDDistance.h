//
//  ECarPDDistance.h
//  ElectricCarRent
//
//  Created by 彭懂 on 16/1/7.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapNaviKit/MAMapKit.h>

@interface ECarPDDistance : NSObject

/**
    得到两点距离
 */
- (CLLocationDistance) getDistance:(CLLocationCoordinate2D)firstLocation andSecondLocation:(CLLocationCoordinate2D)secondLocation;

/**
    判断两点是否在附近
 */
- (BOOL)isLocationNearToOtherLocation:(CLLocationCoordinate2D)firstLocation andSecondLocation:(CLLocationCoordinate2D)secondLocation andDistance:(CLLocationDistance)distance;

@end
