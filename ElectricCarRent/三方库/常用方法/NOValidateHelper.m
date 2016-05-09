//
//  NOValidateHelper.m
//  mallhelper
//
//  Created by cuibaoyin on 15/7/29.
//  Copyright (c) 2015年 malllink. All rights reserved.
//

#import "NOValidateHelper.h"

@implementation NOValidateHelper

+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13，15，18，17开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//身份证号
+ (BOOL) validateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+ (BOOL)validateBlankString:(NSString *)string
{
    if (string == nil || string == NULL || [string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}
+ (NSString *)validateString:(NSString *)string
{
    if (string == nil || string == NULL || [string isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
    {
        return @"";
    }
    return string;
}

+ (BOOL)validateUserName:(NSString *)name
{
    //用户名需为2-16个字符或汉字组成,且不能以数字开头,不能包含空格/特殊字符
    NSString *nameRegex = @"^[a-zA-Z\\u4E00-\\u9FA5\\uF900-\\uFA2D]\\w{2,16}$";
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
    return [namePredicate evaluateWithObject:name];
}

+ (BOOL) validatePassword:(NSString *)passWord
{
    //用户密码需为6-16为数字或字符组成，不能包含特殊符号
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,16}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

@end
