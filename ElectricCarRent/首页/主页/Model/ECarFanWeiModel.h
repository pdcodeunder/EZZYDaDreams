//
//  ECarFanWeiModel.h
//  ElectricCarRent
//
//  Created by 彭懂 on 15/11/19.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECarFanWeiModel : NSObject

/**
 *  用于接收位置信息
 */
@property (nonatomic, copy) NSString * topLeftStr;
@property (nonatomic, copy) NSString * topRightStr;
@property (nonatomic, copy) NSString * bottomLeftStr;
@property (nonatomic, copy) NSString * bottomRightStr;

/**
 *  用于获得位置信息
 */
@property (nonatomic, assign) CLLocationCoordinate2D topLeftPoint;
@property (nonatomic, assign) CLLocationCoordinate2D topRightPoint;
@property (nonatomic, assign) CLLocationCoordinate2D bottomRightPoint;
@property (nonatomic, assign) CLLocationCoordinate2D bottomLeftPoint;

/**
 *  获取范围控制中心点
 */
@property (nonatomic, assign) CLLocationCoordinate2D centorPoint;

/**
 *  是否存在范围控制
 */
@property (nonatomic, assign) BOOL fanWeiStatus;

/**
 *  自定义折线覆盖物点坐标数组
 */
@property (nonatomic, strong) NSMutableArray * pointArr;

+ (instancetype)sharedECarFanWeiModel;

@end
