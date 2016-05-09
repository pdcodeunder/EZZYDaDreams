//
//  NOValidateHelper.h
//  mallhelper
//
//  Created by cuibaoyin on 15/7/29.
//  Copyright (c) 2015年 malllink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOValidateHelper : NSObject

/**
 *  检测字符串是否为手机号
 *
 *  @param mobile 需要验证的字符串
 *
 *  @return 如果是手机号码返回YES,否则返回NO
 */
+ (BOOL)validateMobile:(NSString *)mobile;

/**
 *  检测字符串是否为邮箱
 *
 *  @param string 需要检测的字符串
 *
 *  @return 如果为邮箱返回YES,否则返回NO
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 *  检测字符串是否为身份证号
 *
 *  @param string 需要检测的字符串
 *
 *  @return 如果为身份证号返回YES,否则返回NO
 */
+ (BOOL) validateIdentityCard:(NSString *)identityCard;

/**
 *  检测字符串是否为空
 *
 *  @param string 需要检测的字符串
 *
 *  @return 如果为空返回YES,否则返回NO
 */
+ (BOOL)validateBlankString:(NSString *)string;
/**
 *  检查字符串是否有效
 *
 *  @param string 需要检测的字符串
 *
 *  @return 无效返回空，有效返回string
 */
+ (NSString *)validateString:(NSString *)string;
/**
 *  检测用户名是否符合要求
 *
 *  @param string 需要检测的字符串
 *
 *  @return 如果符合要求返回YES,否则返回NO
 */
+ (BOOL)validateUserName:(NSString *)name;

/**
 *  检测用户密码是否符合要求
 *
 *  @param string 需要检测的字符串
 *
 *  @return 如果符合要求返回YES,否则返回NO
 */
+ (BOOL)validatePassword:(NSString *)passWord;

@end
