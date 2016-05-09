//
//  ECarZhiFuViewController.h
//  ElectricCarRent
//
//  Created by 彭懂 on 15/11/8.
//  Copyright © 2015年 LIKUN. All rights reserved.
//

/**
 *  行车导航界面
 */
#import <AMapNaviKit/AMapNaviKit.h>
#import "ECarCarInfo.h"

@protocol ECarDrivingViewControllerDelegate <NSObject>

- (void)startSpeekingRoadInfo;
- (void)stopSpeekingRoadInfo;
- (void)zhifuViewPresentWithState:(BOOL)State;

@end

@interface ECarDrivingViewController : AMapNaviViewController

@property (strong, nonatomic) ECarCarInfo *carInfo;
@property (assign, nonatomic) id <ECarDrivingViewControllerDelegate> drivingDelegate;

- (void)checkLanYa;

@end
