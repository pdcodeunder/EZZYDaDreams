//
//  ECarMyCenterViewController.h
//  ElectricCarRent
//
//  Created by 彭懂 on 15/10/30.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ECarOrderViewController.h"

@protocol ECarMyCenterViewControllerDelegate <NSObject>

- (void)clickedCellWithRow:(NSInteger)row;

@end

@interface ECarMyCenterViewController : UIViewController

@property (nonatomic, assign) id <ECarMyCenterViewControllerDelegate, ECarOrderViewControllerDelegate> myCenterViewDelegate;

@end
