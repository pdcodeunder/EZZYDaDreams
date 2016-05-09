//
//  FaPiaoModel.h
//  ElectricCarRent
//
//  Created by 彭懂 on 16/3/30.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaPiaoModel : NSObject

@property (nonatomic, strong) NSNumber *fpTime;
@property (nonatomic, copy) NSString *fpBeginAdd;
@property (nonatomic, copy) NSString *fpEndAdd;
@property (nonatomic, copy) NSString *fpPrice;
@property (nonatomic, copy) NSString *fpNumber;
@property (nonatomic, copy) NSString *fpId;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
