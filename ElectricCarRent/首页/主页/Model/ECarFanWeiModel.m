//
//  ECarFanWeiModel.m
//  ElectricCarRent
//
//  Created by 彭懂 on 15/11/19.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarFanWeiModel.h"

@implementation ECarFanWeiModel

+ (instancetype)sharedECarFanWeiModel
{
    static ECarFanWeiModel * model = nil;
    if (!model) {
        model = [[ECarFanWeiModel alloc] init];
        model.fanWeiStatus = NO;
    }
    return model;
}

- (CLLocationCoordinate2D)topLeftPoint
{
    NSArray * array = [self.topLeftStr componentsSeparatedByString:@","];
    NSString * longi = array[0];
    NSString * latitu = array[1];
    _topLeftPoint = CLLocationCoordinate2DMake(latitu.doubleValue, longi.doubleValue);
    return _topLeftPoint;
}

- (CLLocationCoordinate2D)topRightPoint
{
    NSArray * array = [self.topRightStr componentsSeparatedByString:@","];
    NSString * longi = array[0];
    NSString * latitu = array[1];
    _topRightPoint = CLLocationCoordinate2DMake(latitu.doubleValue, longi.doubleValue);
    return _topRightPoint;
}

- (CLLocationCoordinate2D)bottomLeftPoint
{
    NSArray * array = [self.bottomLeftStr componentsSeparatedByString:@","];
    NSString * longi = array[0];
    NSString * latitu = array[1];
    _bottomLeftPoint = CLLocationCoordinate2DMake(latitu.doubleValue, longi.doubleValue);
    return _bottomLeftPoint;
}

- (CLLocationCoordinate2D)bottomRightPoint
{
    NSArray * array = [self.bottomRightStr componentsSeparatedByString:@","];
    NSString * longi = array[0];
    NSString * latitu = array[1];
    _bottomRightPoint = CLLocationCoordinate2DMake(latitu.doubleValue, longi.doubleValue);
    return _bottomRightPoint;
}

- (CLLocationCoordinate2D)centorPoint
{
    _centorPoint = CLLocationCoordinate2DMake((self.topLeftPoint.latitude + self.bottomRightPoint.latitude) / 2.f, (self.topLeftPoint.longitude + self.bottomRightPoint.longitude) / 2.f);
    return _centorPoint;
}

@end
