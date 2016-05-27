//
//  EZZYMemberModle.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/4/11.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "EZZYMemberModle.h"
#import "EZZYOnSaleMemberModel.h"

@implementation EZZYMemberModle

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.subModels = [[NSMutableArray alloc] init];
        self.levelName = [NSString stringWithFormat:@"%@", dic[@"levelName"]];
        self.note = [NSString stringWithFormat:@"%@", dic[@"note"]];
        NSArray *array = [[NSArray alloc] initWithArray:dic[@"viplist"]];
        NSString *str = @"";
        for (NSDictionary *sDic in array) {
            NSString *month = [NSString stringWithFormat:@"%@", sDic[@"effeTime"]];
            if ([month isEqualToString:@"1"]) {
                str = [NSString stringWithFormat:@"%@", sDic[@"levelMoney"]];
            }
        }
        for (NSDictionary *subDic in array) {
            EZZYOnSaleMemberModel *model = [[EZZYOnSaleMemberModel alloc] initWithOnSaleModelDic:subDic];
            model.yuanjia = [NSString stringWithFormat:@"%zd", model.mothly.integerValue * str.integerValue];
            [self.subModels addObject:model];
        }
    }
    return self;
}

@end
