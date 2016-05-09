//
//  ECarPDDistance.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/1/7.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarPDDistance.h"

@implementation ECarPDDistance

// 获得距离
- (CLLocationDistance) getDistance:(CLLocationCoordinate2D)firstLocation andSecondLocation:(CLLocationCoordinate2D)secondLocation
{
    CLLocationDistance distance;
    CLLocationDistance deltaLat = firstLocation.latitude - secondLocation.latitude;
    CLLocationDistance deltaLon = firstLocation.longitude - secondLocation.longitude;
    distance = sqrt(deltaLat * deltaLat + deltaLon * deltaLon);
    return distance;
}

// 判断是否两点在附近
- (BOOL)isLocationNearToOtherLocation:(CLLocationCoordinate2D)firstLocation andSecondLocation:(CLLocationCoordinate2D)secondLocation andDistance:(CLLocationDistance)distance
{
    BOOL retVal = YES;
    CLLocationDistance dis = [self getDistance:firstLocation andSecondLocation:secondLocation];
    if (dis > distance) {
        retVal = NO;
    }
    return retVal;
}

@end
