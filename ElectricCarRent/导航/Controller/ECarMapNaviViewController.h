//
//
//  ECarZhiFuViewController.h
//  ElectricCarRent
//
//  Created by 彭懂 on 15/11/8.
//  Copyright © 2015年 LIKUN. All rights reserved.
//

#import <AMapNaviKit/AMapNaviKit.h>
#import "ECarCarInfo.h"

typedef void (^DrivingNaviBeganBlock)();

@protocol ECarMapNaviViewControllerDelegate <NSObject>

- (void)startSpeekingRoadInfo;
- (void)stopSpeekingRoadInfo;

@end

@interface ECarMapNaviViewController : AMapNaviViewController

@property (strong, nonatomic) ECarCarInfo *carInfo;
@property (assign, nonatomic) FindCarType findType;
@property (assign, nonatomic) id <ECarMapNaviViewControllerDelegate> mapNaviDelegate;
@property (assign, nonatomic) NSInteger daojimiao;
@property (assign, nonatomic) NSInteger isYanShi;

- (instancetype)initWithDelegate:(id<AMapNaviViewControllerDelegate>)delegate;

- (void)initFindCarButtonView;

- (void)checkLanYa;

@end
