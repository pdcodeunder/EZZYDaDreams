//
//  EZZYMemberModle.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/4/11.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "EZZYMemberModle.h"

@implementation EZZYMemberModle

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.levelCode = [NSString stringWithFormat:@"%@", dic[@"levelCode"]];
        self.levelMoney = [NSString stringWithFormat:@"%@", dic[@"levelMoney"]];
        self.levelName = [NSString stringWithFormat:@"%@", dic[@"levelName"]];
        self.levelUnit = [NSString stringWithFormat:@"%@", dic[@"levelUnit"]];
        self.note = [NSString stringWithFormat:@"%@", dic[@"note"]];
    }
    return self;
}

@end
