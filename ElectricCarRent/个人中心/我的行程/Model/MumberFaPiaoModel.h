//
//  MumberFaPiaoModel.h
//  ElectricCarRent
//
//  Created by 彭懂 on 16/3/30.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MumberFaPiaoModel : NSObject

@property (nonatomic, copy) NSNumber *mfpTime;
@property (nonatomic, copy) NSString *mfpType;
@property (nonatomic, copy) NSString *mfpPrice;
@property (nonatomic, copy) NSString *mfpNumber;
@property (nonatomic, copy) NSString *mfpID;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
