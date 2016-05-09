//
//  ITTModel.m
//  AiXinDemo
//
//  Created by shaofa on 14-2-17.
//  Copyright (c) 2014年 shaofa. All rights reserved.
//

/*
     字符串比对结果：NSComparisonResult（在NSObjCRunTime.h中定义）
     
     按照字符的ASCII值进行比对
     
     NSString * str1 = @"abc";
     
     NSString * str2 = @"abd";
     
     NSString * str3 = @"ABC";
     
     NSString * str4 = @"abc";
     
     NSString * str5 = @"123";
     
    **************************************************************
 
     [str1 compare:str2] == NSOrderedAscending(升序)
     
     [str2 compare:str1] == NSOrderedDescending(降序)
     
     [str1 compare:str3] == NSOrderedDescending(降序)
     
     [str1 compare:str4] == NSOrderedSame(同序)
     
     [str1 compare:str5] == NSOrderedDescending(降序)
 */

#import "ITTModel.h"

@implementation ITTModel

- (id)init
{
    self = [super init];
    if (self) {
        NSString *s;
        [s compare:s];
    }
    return self;
}

- (NSComparisonResult)compareNum1:(ITTModel *)model
{
    
    if (self.isUp ? (self.number1 > model.number1) : (self.number1 < model.number1)) {
        
        return NSOrderedDescending; // 降序
    } else if (self.number1 == model.number1) {
        
        return NSOrderedSame; // 同序
    }else {
        
        return NSOrderedAscending; // 升序
    }
}

- (NSComparisonResult)compareNum2:(ITTModel *)model
{
    
    if (self.isUp ? (self.number2 > model.number2) : (self.number2 < model.number2)) {
        
        return NSOrderedDescending;
    } else if (self.number2 == model.number2) {
        
        return NSOrderedSame;
    }else {
        return NSOrderedAscending;
    }
}

- (NSComparisonResult)compareNum3:(ITTModel *)model
{
    
    if (self.isUp ? (self.number3 > model.number3) : (self.number3 < model.number3)) {
        
        return NSOrderedDescending;
    } else if (self.number3 == model.number3) {
        
        return NSOrderedSame;
    }else {
        return NSOrderedAscending;
    }
}

@end
