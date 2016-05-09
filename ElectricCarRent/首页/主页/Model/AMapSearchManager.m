//
//  AMapSearchManager.m
//  mallhelper
//
//  Created by LIKUN on 15/7/12.
//  Copyright (c) 2015年 malllink. All rights reserved.
//

#import "AMapSearchManager.h"
#import "NSString+Category.h"

@implementation AMapSearchManager

static AMapSearchManager *manager = nil;

+(instancetype)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AMapSearchManager alloc] init];
    });
    return manager;
}
//
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.searchApi = [[AMapSearchAPI alloc] initWithSearchKey:AMapKey Delegate:self];
    }
    return self;
}
#pragma mark ----搜索
- (void)initRequestSearchWithUserLocation:(AMapGeoPoint *)upoint destination:(AMapGeoPoint *)dpoint searchType:(AMapSearchType)type
{
    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
    naviRequest.searchType = type;
    naviRequest.requireExtension = YES;
    naviRequest.origin = upoint;
    naviRequest.destination = dpoint;
    //发起路径搜索
    [_searchApi AMapNavigationSearch: naviRequest];

}
//路径的搜索
- (void)searchPathDestination:(AMapGeoPoint *)dpoint userLocation:(AMapGeoPoint *)upoint success:(void(^)(NSArray *ary))block failure:(void(^)(NSString *error))errBlock
{
    self.pathBlock = block;
    self.errorBlock = errBlock;
    [self initRequestSearchWithUserLocation:upoint destination:dpoint searchType:AMapSearchType_NaviDrive];
}
//搜索两个地点之间的距离
- (void)searchDistanceFromUserLocation:(AMapGeoPoint *)upoint destination:(AMapGeoPoint *)dpoint success:(void(^)(NSString *distance))block failure:(void(^)(NSString *error))errBlock
{
    self.distanceBlock = block;
    self.errorBlock = errBlock;
    [self initRequestSearchWithUserLocation:upoint destination:dpoint searchType:AMapSearchType_NaviWalking];
}
//定位城市
- (void)locationCityWithLatitude:(float)latitude longitude:(float)longitude success:(void(^)(NSString *city))block faliure:(void(^)(NSString *error))errBlock
{
    self.locationBlock = block;
    self.errorBlock = errBlock;
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    //发起逆地理编码
    [_searchApi AMapReGoecodeSearch: regeoRequest];
}
// 定位道路信息
- (void)locationRoadWithLatitude:(float)latitude longitude:(float)longitude success:(void(^)(NSString *road))block faliure:(void(^)(NSString *error))errBlock
{
    self.roadBlock = block;
    self.errorBlock = errBlock;
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    //发起逆地理编码
    [_searchApi AMapReGoecodeSearch:regeoRequest];
}

//POI周边搜索
- (void)searchAroundPlaceWithUserLocation:(AMapGeoPoint *)location keywords:(NSString *)keyword city:(NSString *)city success:(void(^)(NSArray *ary))block failure:(void(^)(NSString *error))errBlock
{
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceAround;
    poiRequest.keywords = keyword;
    poiRequest.city = @[city];
    poiRequest.types = @[@"交通设施服务;地铁站;地铁站",@"交通设施服务;公交车站;普通公交站"];//
    poiRequest.requireExtension = YES;
    poiRequest.location = location;
    self.poiBlock = block;
    //发起POI搜索
    [_searchApi AMapPlaceSearch: poiRequest];
}
//POI关键字搜索
- (void)searchPlaceWithKeywords:(NSString *)keyword city:(NSString *)city success:(void(^)(NSArray *ary))block failure:(void(^)(NSString *error))errBlock
{
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceKeyword;
    poiRequest.keywords = keyword;
    poiRequest.city = @[city];
    poiRequest.requireExtension = YES;
    self.poiBlock = block;
    self.errBlock = errBlock;
    // 发起POI搜索
    [_searchApi AMapPlaceSearch:poiRequest];
}

#pragma mark ----- 搜索的delegate
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response
{
    if(response.route == nil)return;
    NSArray *pathAry = response.route.paths;
//    PDLog(@"pathAry.count = %lu",(unsigned long)pathAry.count);
    AMapPath *path = pathAry[0];
    NSArray *_polylinesAry = [self polylinesForPath:path];
    
    if (self.pathBlock) {
        self.pathBlock(_polylinesAry);
    }
    
    if (self.distanceBlock) {
        NSString *distance = [NSString stringWithFormat:@"%ld",(long)path.distance];
        self.distanceBlock(distance);
    }
    //    [_mapView showAnnotations:@[response.route.destination, _mapView.userLocation] animated:YES];
}
#pragma mark ----实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        // 通过AMapReGeocodeSearchResponse对象处理搜索结果
//        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
//        PDLog(@"ReGeo: %@", result);
        //获取定位到得城市,如果是直辖市的话，city字段为空，则取省份
        NSString *province = response.regeocode.addressComponent.province;
        NSString *city = response.regeocode.addressComponent.city;
//        PDLog(@"province = %@ city = %@",province,city);
        NSString *arg = @"";
        if (city.length == 0) arg = province;
        //去掉城市名中‘市’
        if (arg.length != 0) {
            arg = [arg stringByReplacingOccurrencesOfString:@"市" withString:@""];
        }
        [ECarConfigs shareInstance].userCity = arg;
        if (self.locationBlock) {
            self.locationBlock(arg);
        }
        if (self.roadBlock) {
            self.roadBlock(response.regeocode.formattedAddress);
        }
    }
}

#pragma mark ----POI搜索的代理
- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
//    if (self.errBlock) {
//        self.errBlock(@"cuowu");
//    }
}

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    NSInteger biaoshi = [ECarConfigs shareInstance].biaoshi;
    NSString * str = request.keywords;
    if (self.poiBlock) {
        NSNumber * numBiao = (NSNumber *)str.biaoShiTag;
        if ((numBiao.integerValue != 0 && numBiao.integerValue > biaoshi) || numBiao.integerValue == 50000) {
            if (numBiao.integerValue != 50000) {
                [ECarConfigs shareInstance].biaoshi = numBiao.integerValue;
            }
            self.poiBlock(response.pois);
        }
    }
    return;
    
    //通过AMapPlaceSearchResponse对象处理搜索结果
//    NSString *strCount = [NSString stringWithFormat:@"count: %ld",(long)response.count];
//    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
//    NSString *strPoi = @"";
//    for (AMapPOI *p in response.pois) {
//        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
//    }
//    PDLog(@"strPoi: %@", strPoi);
//    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
//    PDLog(@"Place: %@", result);
}

#pragma mark ---- 解析搜索路径
- (NSArray *)polylinesForPath:(AMapPath *)path {
    if (path == nil || path.steps.count == 0)   return nil;
    NSMutableArray *polylines = [NSMutableArray array];
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        NSUInteger count = 0;
        CLLocationCoordinate2D *coordinates = [self coordinatesForString:step.polyline  coordinateCount:&count  parseToken:@";"];
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
        [polylines addObject:polyline];
        free(coordinates), coordinates = NULL;
    }];
    return polylines;
}
- (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string coordinateCount:(NSUInteger *)coordinateCount parseToken:(NSString *)token {
    if (string == nil)  return NULL;
    if (token == nil){
        token = @",";
    }
    NSString *str = @"";
    if (![token isEqualToString:@","]){
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }else{
        str = [NSString stringWithString:string];
    }
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL){
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < count; i++){
        coordinates[i].longitude = [[components objectAtIndex:2 * i]doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    return coordinates;
}

@end
