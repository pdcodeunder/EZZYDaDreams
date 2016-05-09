//
//  AMapSearchManager.h
//  mallhelper
//
//  Created by LIKUN on 15/7/12.
//  Copyright (c) 2015年 malllink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapNaviKit/MAMapKit.h>

@interface AMapSearchManager : NSObject<AMapSearchDelegate>

@property (nonatomic,strong)AMapSearchAPI *searchApi;
+(instancetype)instance;

typedef void (^ErrorBlock)(NSString *error);
@property (nonatomic,copy)ErrorBlock errorBlock;

typedef void (^SearchPathBlock)(NSArray *ary);
@property (nonatomic,copy)SearchPathBlock pathBlock;
/**
 *  搜索路径
 *
 *  @param dpoint   目标地址坐标
 *  @param upoint   我得位置坐标
 *  @param block    成功回调
 *  @param errBlock 失败回调
 */
- (void)searchPathDestination:(AMapGeoPoint *)dpoint userLocation:(AMapGeoPoint *)upoint success:(void(^)(NSArray *ary))block failure:(void(^)(NSString *error))errBlock;

typedef void (^SearchDistanceBlock)(NSString *distance);
@property (nonatomic,copy)SearchDistanceBlock distanceBlock;
/**
 *  搜索两点之间的距离
 *
 *  @param upoint   目标地址坐标
 *  @param dpoint   我得位置坐标
 *  @param block    成功回调
 *  @param errBlock 失败回调
 */
- (void)searchDistanceFromUserLocation:(AMapGeoPoint *)upoint destination:(AMapGeoPoint *)dpoint success:(void(^)(NSString *distance))block failure:(void(^)(NSString *error))errBlock;


typedef void (^LocationCityBlock)(NSString *city);
@property (nonatomic,copy)LocationCityBlock locationBlock;
/**
 *  定位所属城市的回调
 *
 *  @param latitude  纬度
 *  @param longitude 经度
 *  @param block     成功回调
 *  @param errBlock  失败回调
 */
- (void)locationCityWithLatitude:(float)latitude longitude:(float)longitude success:(void(^)(NSString *city))block faliure:(void(^)(NSString *error))errBlock;

typedef void (^LocationRoadBlock)(NSString *road);
@property (nonatomic,copy)LocationCityBlock roadBlock;
/**
 *  定位道路信息
 *
 *  @param latitude   纬度
 *  @param longitude 经度
 *  @param block     成功回调
 *  @param errBlock  失败回调
 */
- (void)locationRoadWithLatitude:(float)latitude longitude:(float)longitude success:(void(^)(NSString *road))block faliure:(void(^)(NSString *error))errBlock;
typedef void (^POISearchBlock)(AMapGeoPoint *point);
@property (nonatomic,copy)POISearchBlock searchBlock;
/**
 *  POI搜索
 *
 *  @param keyword  关键字
 *  @param city     所在城市
 *  @param block    成功回调
 *  @param errBlock 失败回调
 */
typedef void (^SearchPOIBlock)(NSArray *ary);
@property (copy, nonatomic) SearchPOIBlock poiBlock;

/**
    poi搜索失败回调
 */
typedef void (^SearchPOIErrBlock)(NSString *error);
@property (copy, nonatomic) SearchPOIErrBlock errBlock;

- (void)searchAroundPlaceWithUserLocation:(AMapGeoPoint *)location keywords:(NSString *)keyword city:(NSString *)city success:(void(^)(NSArray *ary))block failure:(void(^)(NSString *error))errBlock;
/**
 *  POI关键字搜索
 *
 *  @param keyword  关键字
 *  @param city     城市
 *  @param block    成功
 *  @param errBlock 失败
 */
- (void)searchPlaceWithKeywords:(NSString *)keyword city:(NSString *)city success:(void(^)(NSArray *ary))block failure:(void(^)(NSString *error))errBlock;
@end
