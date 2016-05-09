//
//  NSString+Category.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/2/29.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

static void * MyObjectMyCustomPorpertyKey = (void *)@"MyObjectMyCustomPorpertyKey";

- (void)setBiaoShiTag:(id)biaoShiTag
{
    objc_setAssociatedObject(self, MyObjectMyCustomPorpertyKey, biaoShiTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)biaoShiTag
{
    return objc_getAssociatedObject(self, MyObjectMyCustomPorpertyKey);
}

@end
