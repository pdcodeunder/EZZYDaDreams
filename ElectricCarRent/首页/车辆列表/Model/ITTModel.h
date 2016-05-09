//
//  ITTModel.h
//  AiXinDemo
//
//  Created by shaofa on 14-2-17.
//  Copyright (c) 2014年 shaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITTModel : NSObject

@property(nonatomic, assign)int number1;
@property(nonatomic, assign)int number2;
@property(nonatomic, assign)int number3;
@property(nonatomic, assign)BOOL isUp;

- (NSComparisonResult)compareNum1:(ITTModel *)model;
- (NSComparisonResult)compareNum2:(ITTModel *)model;
- (NSComparisonResult)compareNum3:(ITTModel *)model;

@end
