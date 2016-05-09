//
//  ECarSharedPriceModel.h
//  ElectricCarRent
//
//  Created by 彭懂 on 15/11/25.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, kZhiFuFangShi) {
    kZhiFuFangShiZhiFuBao = 1 << 1,
    kZhiFuFangShiWeiXin = 1 << 2
};

@interface ECarSharedPriceModel : NSObject

@property (nonatomic, assign) kZhiFuFangShi zhifufangshi;

+ (instancetype)sharedPriceModel;

@end
