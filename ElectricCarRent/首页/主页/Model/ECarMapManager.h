//
//  ECarMapManager.h
//  ElectricCarRent
//
//  Created by LIKUN on 15/9/14.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKHttpServices.h"
#import "DSASubject.h"

@interface ECarMapManager : NSObject
/**
 *  创建订单<over>
 *
 *  @param carid           车id
 *  @param user_id         userid
 *  @param finish          是否完成
 *  @param destination     目的地描述
 *  @param area            地区
 *  @param distance        距离
 *  @param power           耗电量
 *  @param endPLatitude    目的地纬度
 *  @param endPLongitude   目的地经度
 *  @param userSPLatitude  用户位置纬度
 *  @param userSPLongitude 用户位置经度
 *  @param order_id        关联订单id
 *  @param orderLink       订单环节（找车环节0，用车环节1）
 *
 *  @return subject
 */
- (DSASubject *)createOrder:(NSString *)carid
                     userID:(NSString *)user_id
                      begin:(NSString *)begin
                destination:(NSString *)destination
                       area:(NSString *)area
                      power:(NSString *)power
                endLatitude:(NSString *)endPLatitude
               endLongitude:(NSString *)endPLongitude
               userLatitude:(NSString *)userSPLatitude
              userLongitude:(NSString *)userSPLongitude
             theCarLatitude:(NSString *)theCarLatitude
            theCarLongitude:(NSString *)theCarLongitude
             andCarLocation:(NSString *)carLocation;
/**
    订单列表
 */
- (DSASubject *)orderList:(NSString *)user_id page:(NSInteger)page;

/**
    车辆列表
 */
-(DSASubject *)carTableListUserCoordinate:(CLLocationCoordinate2D)userCoordinate
                                    order:(NSString *)orderStr
                                     type:(NSString *)typeStr
                                   states:(NSString *)states
                                  andPage:(NSString *)page;

/**
 *  得到价格明细
 */
- (DSASubject *)getJiaGeMingXiWithOrder:(NSString *)orderID;

/**
 *  支付宝支付完成回调
 */
- (DSASubject *)zhifubaofinishOrderWithID:(NSString *)orderNo andCanshu:(NSString *)canshu;

/**
 *  点击微信支付掉用
 */
- (DSASubject *)sendHouTaiWithOrderID:(NSString *)orderID;

// vip
- (DSASubject *)sendHouTaiVipWithOrderID:(NSString *)orderID;

/**
 *  微信支付
 */
- (DSASubject *)weixinzhifuOrderWithID:(NSString *)orderNo andTimestamp:(NSString *)timestamp;

/**
 *  范围控制 (图片和四点折线)
 */
- (DSASubject *)getFanWeiKongZhi;

/**
 *  范围控制 (自定义折线控制)
 */
- (DSASubject *)getZiDingYiFanWeiKongZhiWithVersion:(NSString *)version;

/**
 *  延时
 */
- (DSASubject *)zhaocheYanshiWithOrder:(NSString *)orderID;

/**
 *  双闪
 *
 *  @param carid 车id
 *
 *  @return subject
 */
- (DSASubject *)lookingCar:(NSString *)carid;

/**
 *  取消订单
 *
 *  @param orderNo 订单号
 *
 *  @param flag 0:找车 1:用车
 *
 *  @return subject
 */
- (DSASubject *)cancelOrder:(NSString *)orderID carid:(NSString *)carid userid:(NSString *)userid andStatus:(NSInteger)status;

/**
 *  开中控锁
 *
 *  @param carid 车id
 *
 *  @return subject
 */
- (DSASubject *)openLock:(NSString *)carid;

/**
 *  得到价格
 *
 *  @param orderID 订单id
 *  @param carid   汽车id
 *
 */
- (DSASubject *)getMoneyPrice:(NSString *)orderID;

/**
 *  用车导航开锁
 */
- (DSASubject *)useCarOpenDoorWith:(NSString *)orderID;

/**
 *  用车导航关锁
 */
- (DSASubject *)useCarCloseDoorWith:(NSString *)orderID;

/**
 *  判断车门是否开过
 */
- (DSASubject *)panduanDoorIsOpen:(NSString *)orderNo;

/**
 *  结束用车
 *
 *  @param orderNo 订单号
 *
 *  @return subject
 */
- (DSASubject *)endOrderNo:(NSString *)orderID;

/*
    支付完成调用
 */
- (DSASubject *)finishOrderWithID:(NSString *)orderNo;

/**
 * 附近车辆<over>
 *
 *  @param latitude  纬度
 *  @param longitude 经度
 *
 *  @return subject
 */
- (DSASubject *)findNearCarsUserCoordinate:(CLLocationCoordinate2D)userCoordinate andDestination:(CLLocationCoordinate2D)destination andAllSelect:(BOOL)isAll;

/**
 *  获得估计价格<over>
 *
 *  @param latitude  纬度
 *  @param longitude 经度
 *
 *  @return subject
 */
- (DSASubject *)getGuJiFeiYongWithStartCoordinate:(CLLocationCoordinate2D)beginCoordinate andDestination:(CLLocationCoordinate2D)destination andUserID:(NSString *)userid;

/**
 *  发送位置
 */
- (DSASubject *)sendUserLocationWithPhone:(NSString *)phone latitude:(NSString *)latitude longtitude:(NSString *)lontitude;

// 获取人和车开锁的距离
- (DSASubject *)getOpenCarDistanceBetweenPersonAndCar;

- (DSASubject *)openLockbyLanYaWithOrderID:(NSString *)orderID;

// 违章扣款支付完成回调
- (DSASubject *)weiZhangKouKuanFinishOrderWithID:(NSString *)orderNo Type:(NSString *)type andPayMethod:(NSString *)payMethod;

@end
