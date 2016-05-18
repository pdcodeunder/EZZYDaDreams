//
//  ECarConfigs.h
//  ElectricCarRent
//
//  Created by LIKUN on 15/9/11.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECarUser.h"
#import <AMapNaviKit/MAMapKit.h>
#import "ECarEnum.h"

@interface ECarConfigs : NSObject

@property (strong, nonatomic) ECarUser *user;   /**<登录用户*/
@property (copy, nonatomic) NSString *TokenID;  /**<登录token*/
@property (assign, nonatomic) BOOL loginStatue;
@property (assign, nonatomic) CLLocationCoordinate2D userCoordinate; /**<定位坐标*/
@property (copy, nonatomic) NSString *userCity; /**<定位坐标*/
@property (assign, nonatomic) ExitNaviTag exitTag;
@property (assign, nonatomic) LinkStep currentStep; /**<当前的步骤*/
@property (copy, nonatomic) NSString * orignOrderNo; /**<原始订单号*/
@property (copy, nonatomic) NSString * nOrderNo; /**<新订单号*/
@property (copy, nonatomic) NSString * currentCarID;
@property (copy, nonatomic) NSString * currentPrice;
// 点击取消按钮的状态。是点击的还是时间到。
@property (assign, nonatomic) NSInteger cancelStatus;
@property (assign, nonatomic) NSInteger jinruZhuangTai;
@property (assign, nonatomic) NSInteger chaochufanwei;

/**计算汽车和人的信息*/
@property (assign, nonatomic) NSInteger carAndPersonDistancs;
@property (copy, nonatomic) NSString * registerID;
@property (assign, nonatomic) NSInteger zhifuwancheng;
@property (assign, nonatomic) NSInteger cheliangchaochu;

@property (strong, nonatomic) UIAlertView * gengxinAlert;

@property (assign, nonatomic) NSInteger biaoshi;

@property (nonatomic, assign)NSInteger isBaoye; // 包夜的开关
@property (nonatomic, copy) NSString *baoYeOrderId; // 包夜id
@property (nonatomic, copy) NSString * baoyePrice; // 包夜价格

@property (nonatomic, assign) NSInteger buyMemberNotify;

// 运营时间
@property (assign, nonatomic) NSInteger beginTime;
@property (assign, nonatomic) NSInteger endTime;
@property (strong, nonatomic) NSString *timeStr;

+ (instancetype)shareInstance;

@end
