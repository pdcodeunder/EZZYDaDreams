//
//  EZZYDrivingViewController.h
//  ElectricCarRent
//
//  Created by 彭懂 on 16/5/11.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarBaseViewController.h"
#import "ECarCarInfo.h"

@protocol EZZYDrivingViewControllerDelegate <NSObject>

- (void)endOrderBackZhiFu;

@end

@interface EZZYDrivingViewController : ECarBaseViewController

@property (strong, nonatomic) ECarCarInfo *carInfo;
@property (strong, nonatomic) NSArray *polyArray;

- (void)checkLanYa;

@end
