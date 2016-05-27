//
//  EZZYOnSaleMemberModel.h
//  ElectricCarRent
//
//  Created by 彭懂 on 16/5/13.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZZYOnSaleMemberModel : NSObject

@property (nonatomic, strong) NSString *mothly;
@property (nonatomic, strong) NSString *yuanjia;
@property (nonatomic, strong) NSString *levelCode;
@property (nonatomic, strong) NSString *dazhe;
@property (nonatomic, strong) NSString *xianjia;
@property (nonatomic, strong) NSString *orderId;

- (instancetype)initWithOnSaleModelDic:(NSDictionary *)dic;

@end
