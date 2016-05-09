//
//  PDPolygon.h
//  ElectricCarRent
//
//  Created by 彭懂 on 16/1/13.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import <AMapNaviKit/AMapNaviKit.h>

typedef NS_ENUM(NSInteger, PolygonColorType)
{
    PolygonColorGreen       = 1 << 0,          // 绿色
    PolygonColorYellow      = 1 << 1,          // 黄色
    PolygonColorRed         = 1 << 2,          // 红色
    PolygonColorFanWei      = 1 << 3           // 范围控制
};

@interface PDPolygon : MAPolygon

@property (nonatomic, assign) PolygonColorType polygonColorType;

@end
