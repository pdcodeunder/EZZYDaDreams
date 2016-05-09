//
//  ECarHomeAndCompViewController.h
//  ElectricCarRent
//
//  Created by 程元杰 on 15/12/8.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarBaseViewController.h"
@interface ECarHomeAndCompViewController : ECarBaseViewController
@property (nonatomic, strong)UIImageView * homeImageView;
@property (nonatomic, strong)UIImageView * compImageView;
@property (nonatomic, strong)UILabel * homesLabel;
@property (nonatomic, strong)UILabel * compsLabel;
@property (nonatomic, strong)UIImageView * xiaoImageView;
@property (nonatomic, strong)UIImageView * xiaocompImageView;
@property (strong , nonatomic) NSMutableDictionary *usualDic;
@property (nonatomic, strong)UILabel * homeDetilLabel;
@property (nonatomic, strong)UILabel * copmDetillbel;
@property (nonatomic, strong)UILabel * dizhiLabel;
@property (nonatomic, strong)UILabel * compdizhiLable;
@property (nonatomic, assign)int intType;
@end
