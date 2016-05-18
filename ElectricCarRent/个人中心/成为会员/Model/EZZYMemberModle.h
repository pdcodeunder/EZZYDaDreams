//
//  EZZYMemberModle.h
//  ElectricCarRent
//
//  Created by 彭懂 on 16/4/11.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZZYMemberModle : NSObject

@property (nonatomic, strong) NSString *levelName;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSMutableArray *subModels;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
