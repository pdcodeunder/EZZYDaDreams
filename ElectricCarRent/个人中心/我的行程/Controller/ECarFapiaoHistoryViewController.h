//
//  ECarFapiaoHistoryViewController.h
//  ElectricCarRent
//
//  Created by 张钊 on 16/3/30.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarBaseViewController.h"

typedef NS_ENUM(NSInteger, ECarHistoryType){
    ECarHistoryTypeVIP = 1,   /**<VIP历史*/
    ECarHistoryTypeXingcheng,           /**<行程历史*/
};

@interface ECarFapiaoHistoryViewController : ECarBaseViewController

@property (nonatomic, assign)ECarHistoryType historyType;

- (instancetype)initWithTyep:(ECarHistoryType)type;

@end

