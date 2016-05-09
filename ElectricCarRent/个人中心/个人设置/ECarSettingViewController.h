//
//  ECarSettingViewController.h
//  ElectricCarRent
//
//  Created by 程元杰 on 15/12/8.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarBaseViewController.h"
#import "ECarHomeAndCompViewController.h"
@interface ECarSettingViewController : ECarBaseViewController
@property(nonatomic, strong)NSArray * titleList;
@property(nonatomic, strong)UIImageView * listView;
@property(nonatomic, strong)UIImageView * listView1;
@property(nonatomic, strong)UILabel * meslabel;
@property(nonatomic, strong) UISwitch * switchBar;
@end
