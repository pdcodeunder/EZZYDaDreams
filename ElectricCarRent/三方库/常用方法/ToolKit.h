//
//  CommonTool.h
//  AlgorithmDemo
//
//  Created by LIKUN on 15/7/24.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "AFNetworking.h"
#import <sys/sysctl.h>

@interface ToolKit : NSObject

#pragma mark - 设备信息
/**
 *  获取App版本号
 *
 *  @return CFBundleVersion
 */
+ (NSString *)getBuildVersion;

/**
 *  获取App版本号
 *
 *  @return CFBundleShortVersionString
 */
+ (NSString *)getVersionNum;

/**
 *  获取App的BundleId
 *
 *  @return BundleId
 */
+ (NSString *)getBundleIdentifier;

/**
 *  获取设备名称
 *
 *  @return 设备名称
 */
+ (NSString *)getDeviceSystemName;

/**
 *  获取设备系统型号
 *
 *  @return 系统版本号
 */
+ (NSString *)getDeviceSystemVersion;

#pragma mark - 消息相关
/**
 *  拨打电话
 *
 *  @param num  电话号码
 *  @param view Controller的view
 */
+ (void)callTelephoneNumber:(NSString *)num addView:(UIView *)view;

#pragma mark - 类属性相关
/**
 *  属性类型
 *
 *  @param property property
 *
 *  @return 类型
 */
const char * getPropertyType(objc_property_t property);

/**
 *  获取类的全部属性
 *
 *  @param objectName 类名
 *
 *  @return 属性数组
 */
+ (NSArray *)getAllPropertysWithClassName:(NSString *)objectName;

/**
 *  中文转换为全拼
 *
 *  @param sourceString 中文
 *
 *  @return 全拼
 */
+ (NSString *)phonetic:(NSString*)sourceString;

#pragma mark - 颜色相关
/**
 *  颜色转换
 *
 *  @param color #00ff99、0x00ff99
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString: (NSString *)color;

#pragma mark - 高度相关
/**
 *  动态计算label高度
 *
 *  @param font  字体
 *  @param width label的宽度
 *  @param msg   文字
 *
 *  @return label的size
 */
+ (CGSize)getSizeByFont:(UIFont *)font labelWidth:(CGFloat)width message:(NSString *)msg;

#pragma mark - JSON转换
/**
 *  转换Json
 *
 *  @param dic 数据字典
 *
 *  @return json字符串
 */
+ (NSString *)JSONEncodeFromDictionary:(NSMutableDictionary *)dic;

/**
 *  json解析
 *
 *  @param string json字串
 *
 *  @return 数据字典
 */
+ (id)JSONDecodeFromString:(NSString *)string;

#pragma mark - 时间相关
/**
 *  获取当前的时间戳
 *
 *  @return 时间戳
 */
+ (NSString *)nowTimeStamp;

/**
 *  两个时间戳之间的间隔
 *
 *  @param stmp1 第一个时间戳
 *  @param stmp2 第二个时间戳
 *
 *  @return 时间间隔（day）
 */
+ (float)intervalFromStamp:(NSString *)stmp1 toStamp:(NSString *)stmp2;

/**
 *  日期格式转化成年月日格式
 *
 *  @param date 日期
 *
 *  @return 2012年12月23日样式
 */
+ (NSString *)dateToNYRString:(NSDate *)date;
+ (NSString *)dateToNString:(NSDate *)date;
+ (NSString *)dateToYString:(NSDate *)date;

/**
 *  根据文字计算占用高度
 *
 *  @param fullDescAndTagStr 文字内容
 *  @param font              字体
 *  @param labelWidth        宽度
 *
 *  @return 返回高度
 */
+ (CGFloat)getHeightWithString:(NSString *)fullDescAndTagStr font:(UIFont *)font labelWidth:(CGFloat)labelWidth;
/**
 *  根据文字计算占用宽度
 *
 *  @param font   字体
 *  @param height 高度
 *  @param text   文字内容
 *
 *  @return 返回宽度
 */
+ (CGFloat) widthWithFont:(UIFont *)font height:(CGFloat)height text:(NSString *)text;
/**
 *  判断网络
 *
 *  @return ~
 */
+ (AFNetworkReachabilityStatus)checkNetwork;
/**
 *  获得设备机型
 *
 *  @return 机型信息
 */
+ (NSString *)getCurrentDeviceModel;
/**
 *  判断机型是否支持ECar
 *
 *  @return BOOL
 */
+ (BOOL)checkDeviceSupportECar;
+ (NSString *)nullString:(NSString *)str;
+ (void)checkNetworkStatue:(void(^)(AFNetworkReachabilityStatus statue))block;

#pragma mark - 检测相关

@end
