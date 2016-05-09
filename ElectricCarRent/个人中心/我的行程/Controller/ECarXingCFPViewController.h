//
//  ECarXingCFPViewController.h
//  ElectricCarRent
//
//  Created by 彭懂 on 16/3/30.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarBaseViewController.h"

typedef NS_ENUM(NSUInteger, XingChengFangShi) {
    XingChengFangShiDefault = 143,
    XingChengFangShiXingCheng,
    XingChengFangShiVIP,
};

@interface ECarXingCFPViewController : ECarBaseViewController

@property (nonatomic, strong) NSString *allIds;
@property (nonatomic, assign) XingChengFangShi xingChengType;

- (instancetype)initWithPrice:(CGFloat)price;

@end
