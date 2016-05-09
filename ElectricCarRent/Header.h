//
//  Header.h
//  ElectricCarRent
//
//  Created by 彭懂 on 15/12/29.
//  Copyright © 2015年 彭懂. All rights reserved.
//

#ifndef Header_h
#define Header_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ECarBaseViewController.h"
#import "PDCenterBaseViewController.h"
#import "PDOtherBaseViewController.h"

#import "ToolKit.h"
#import "ECarConfigs.h"
#import "ECarCarInfo.h"
#import "ECarEnum.h"
#import "UIViewExt.h"
#import "UIColorExt.h"

#define AlertMsg(title,msg)      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];[alert show];
#define StoryBoardViewController(sbName,sbID)   [[UIStoryboard storyboardWithName:sbName bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:sbID];

#define MESSAGE_NoNetwork @"网络异常，加载失败"

#define weak_Self(id) __weak typeof(id) weakSelf = id
#define AMapKey  @"2fca9ee9881d8dbfb6e8ec87ac2f807f"
#define kColorStr [UIColor colorWithHexString:@"#d0d0d0"]

// 3.5英寸 4英寸 4.7英寸 5.5英寸
#define ScreenInch35 (ScreenWidth == 320 && ScreenHeight == 480)
#define ScreenInch4 (ScreenWidth == 320 && ScreenHeight == 568)
#define ScreenInch47 (ScreenWidth == 375 && ScreenHeight == 667)
#define ScreenInch55 (ScreenWidth == 414 && ScreenHeight == 736)

#define IPHONE4S (([[UIScreen mainScreen] bounds].size.width == 320) && ([[UIScreen mainScreen] bounds].size.height == 480))
#define IPHONE5S (([[UIScreen mainScreen] bounds].size.width == 320) && ([[UIScreen mainScreen] bounds].size.height == 568))
#define IPHONE6  (([[UIScreen mainScreen] bounds].size.width == 375) && ([[UIScreen mainScreen] bounds].size.height == 667))
#define IPHONE6P (([[UIScreen mainScreen] bounds].size.width == 414) && ([[UIScreen mainScreen] bounds].size.height == 736))

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define ScreenInchSmall (kScreenW < 375 && kScreenH < 667)

#ifdef  DEBUG
#define PDLog(...) NSLog(__VA_ARGS__)
#else
#define PDLog(...)
#endif

#define TokenPrams  [ECarConfigs shareInstance].TokenID, @"tokenid"

#pragma mark - 微信支付
#define kWXAppKey       @"wx58f31b6ebd22d7b1"
#define APP_ID          @"wx58f31b6ebd22d7b1"               // APPID
#define APP_SECRET      @"d4624c36b6795d1d99dcf0547af5443d" // appsecret
// 商户号，填写商户对应参数
#define MCH_ID          @"1285274401"
// 商户API密钥，填写相应参数
#define PARTNER_ID      @"DadreamsTech9581mOOv1111khcycxme"
// 支付结果回调页面
#define NOTIFY_URL      [NSString stringWithFormat:@"%@car/pay/wxpayCar.do", ServerURL]
// 获取服务器端支付数据地址（商户自定义）
#define SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"

#pragma mark - 支付宝支付
#define kPernerID       @"2088121166116940"
#define kSallerID       @"company@dadreams.com"
#define kZhiFuTag       12321
#define kZhiFuNotify    [NSString stringWithFormat:@"%@car/pay/alipayCar.do", ServerURL]

// 测试阿里云（后台）
#define  OSSAccessKey   @"u4j7YHkgHEwnVFoQ"
#define  OSSSecretKey   @"KmAlwsQlSb4tQzkrwhJCNjxX2hQSsn"
#define  OSSBucketServer   @"oss-moov-beijing"

#define  OSSHostID   @"oss-cn-beijing.aliyuncs.com"



//#define  ServerURL @"http://123.57.227.139:9888/"



//#define  ServerURL @"http://101.201.196.43:9888/"



#define  ServerURL @"http://192.168.0.50:8080/"

//登录检测
#define CheckLogin(VC)          if (![ECarConfigs shareInstance].loginStatue) { \
UINavigationController *loginVC = StoryBoardViewController(@"ECarLogin", @"LoginNavigationController"); \
[VC.navigationController presentViewController:loginVC animated:NO completion:nil]; \
return; \
} \

//定位检测
#define LocationCheck(VC)      if([CLLocationManager locationServicesEnabled]&&[CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) { UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"为方便您尽快找到目标车辆，请打开GPS。"  delegate:VC cancelButtonTitle:@"确认" otherButtonTitles:nil];    [alertView show]; return;}

#define FloatToString(XX) [NSString stringWithFormat:@"%f",XX]
#define IntegerToString(XX) [NSString stringWithFormat:@"%zd",XX]

#pragma mark - 颜色和字体
#define RedColor [UIColor colorWithRed:224 / 255.f green:54 / 255.f blue:134 / 255.f alpha:1]
#define WhiteColor [UIColor colorWithRed:249 / 255.f green:249 / 255.f blue:249 / 255.f alpha:1]
#define BlackColor [UIColor colorWithRed:5 / 255.0 green:5 / 255.0 blue:5 / 255.0 alpha:1.0]
#define ClearColor  [UIColor clearColor]


#define GrayColor [UIColor colorWithRed:197 / 255.f green:197 / 255.f blue:197 / 255.f alpha:1]

#define FontSizeMax   [UIFont systemFontOfSize:23 / 667.f * kScreenH]
#define FontSizeMiddle   [UIFont systemFontOfSize:21 / 667.f * kScreenH]
#define FontSizeMin   [UIFont systemFontOfSize:18 / 667.f * kScreenH]
#define FontType  [UIFont systemFontOfSize:15.f / 667.f * kScreenH]
#define FontMinSize [UIFont systemFontOfSize:12 / 667.f * kScreenH]

#define kSoundEffectIsOnKey @"kSoundEffectIsOnKey"

#define kOpenLock @"4101"
#define kCloseLock @"4100"

#define kOpenLamp @"4201"
#define kCloseLamp @"4200"

#define kOpenWhistle @"4301"
#define kCloseWhistle @"4300"

#define kEndCode @";\n"

#endif /* Header_h */
