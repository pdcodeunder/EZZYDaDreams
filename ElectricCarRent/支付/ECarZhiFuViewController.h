//
//  ECarZhiFuViewController.h
//  ElectricCarRent
//
//  Created by 彭懂 on 15/11/8.
//  Copyright © 2015年 LIKUN. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WXApiObject.h"

@protocol ECarZhiFuViewControllerDelegate <NSObject>
- (void) sendPay;
@end

typedef void(^zhifuBlock)();
typedef void(^backBlock)();
@interface ECarZhiFuViewController : UIViewController

@property (nonatomic, assign) BOOL canBack;
@property (nonatomic, strong) UIButton * backButton;
@property (nonatomic, strong) UIButton * zhifuButton;
@property (nonatomic, copy) NSString * priceCar;
@property (nonatomic, copy) NSString * priceUnit;
@property (nonatomic, copy) NSString * orderID;
@property (nonatomic, assign) BOOL panduan;
@property (nonatomic, copy) zhifuBlock zhifublock;
@property (nonatomic, copy) backBlock backblock;
@property (nonatomic, assign) BOOL youhuima;
@property (nonatomic, assign) id<ECarZhiFuViewControllerDelegate, NSObject> delegate;

// 回调后台的类型
@property (nonatomic, assign)sendToHouTaiType sendType;

@end
