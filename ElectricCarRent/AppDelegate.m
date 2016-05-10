//
//  AppDelegate.m
//  ElectricCarRent
//
//  Created by 彭懂 on 15/12/29.
//  Copyright © 2015年 彭懂. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ECarMainViewController.h"
#import "ECarMapManager.h"
#import "ECarSharedPriceModel.h"
#import "ECarUserManager.h"
#import "PDLanYaLianJie.h"

@interface AppDelegate ()

@property (strong, nonatomic) ECarMapManager * mapManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [ UMSocialData setAppKey:@"565fc9f367e58ebf8e0014ff"];
    [UMSocialWechatHandler setWXAppId:@"wx58f31b6ebd22d7b1" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"https://itunes.apple.com/cn/app/id1047071972?mt=8"];
    [WXApi registerApp:kWXAppKey];
    UIApplication * app = [UIApplication sharedApplication];
    
    // 设置允许接收的通知类型
    // alert：消息提醒  badge：右上角的数字提醒  sound：声音提醒
    UIUserNotificationSettings * setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
    
    // 完成注册
    [app registerUserNotificationSettings:setting];
    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    [self JPushconfig:launchOptions];
    self.window.backgroundColor = WhiteColor;

    return YES;
}

#pragma mark - 极光推送
- (void)JPushconfig:(NSDictionary *)launchOptions
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
         categories:nil];
    }
#else
    [APService
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert)
     categories:nil];
#endif
    [APService setupWithOption:launchOptions];
    
    //自定义消息
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    NSInteger badgeValue = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badgeValue >0)
    {
        if ([[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue] >= 1)
        {
            badgeValue = [[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue];
        }
        badgeValue -= 1;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeValue];
        [APService setBadge:badgeValue];
    }
    else
    {
        [APService resetBadge];
    }
    // 向JPUSH上报收到APNS消息
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark 推送通知响应事件
- (void)networkDidSetup:(NSNotification *)notification
{
    
}
- (void)networkDidClose:(NSNotification *)notification
{
    
}
- (void)networkDidRegister:(NSNotification *)notification
{
    
}
- (void)networkDidLogin:(NSNotification *)notification
{
    [ECarConfigs shareInstance].registerID = [APService registrationID];
}
//接收自定义消息
- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    //    NSLog(@"自定义消息%@",notification);
}

- (void)serviceError:(NSNotification *)notification
{
    
}

#pragma mark - 微信支付宝回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // 跳转支付宝钱包进行支付，处理支付结果
    if ([ECarSharedPriceModel sharedPriceModel].zhifufangshi == kZhiFuFangShiZhiFuBao) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        }];

        return YES;
    }
    return [WXApi handleOpenURL:url delegate:self];
}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        //        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        //        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        alert.tag = 1000;
        //        [alert show];
        //        [alert release];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        //        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        //        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        //        WXAppExtendObject *obj = msg.mediaObject;
        
        //        NSString *strTitle = [NSString stringWithFormat:@"微信分享"];
        //        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n\n", msg.title, msg.description, obj.extInfo];
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
        //        [alert release];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        //        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        //        NSString *strMsg = @"这是从微信启动的消息";
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
        //        [alert release];
    }
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"感谢您的配合！"];
    NSString *strTitle = @"提示";
    self.mapManager = [ECarMapManager new];
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"提示"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                ECarConfigs * config = [ECarConfigs shareInstance];
                if (config.zhifuwancheng == 30) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"weizhangzhifuwancheng" object:nil userInfo:nil];
                    return;
                }
                if (config.zhifuwancheng == 10) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"buyMemberZhiFuFinished" object:nil userInfo:nil];
                    return;
                }
                strTitle = @"支付成功";
                strMsg = @"为了方便下一位用户顺利使用车辆，请您下车后关闭车门，感谢您的配合";
                [ECarConfigs shareInstance].cheliangchaochu = 0;
                [ECarConfigs shareInstance].zhifuwancheng = 0;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"zhifuwancheng" object:nil userInfo:nil];
                
//                [[self.mapManager finishOrderWithID:config.orignOrderNo] subscribeError:^(NSError *error) {
//                    
//                } completed:^{
//                    
//                }];
                
                break;
            }
            default: {
                strMsg = [NSString stringWithFormat:@"支付失败"];
                break;
            }
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    
    [alter show];
}

#pragma mark - AppDelegate代理方法 应用生命周期函数
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    if ([ECarConfigs shareInstance].gengxinAlert) {
        [[ECarConfigs shareInstance].gengxinAlert show];
    }
    [ToolKit checkNetworkStatue:^(AFNetworkReachabilityStatus statue) {
        if (statue == AFNetworkReachabilityStatusUnknown || statue == AFNetworkReachabilityStatusNotReachable) {
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常，请重新连接。" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alertV show];
        }
    }];
    
//    PDLanYaLianJie *lanya = [PDLanYaLianJie shareInstance];
//    if (lanya.lanYaStatus == NO) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"哈哈" message:@"dsaf" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    
    ECarUserManager * manager = [[ECarUserManager alloc] init];
    ECarUser * user = [[ECarUser alloc] init];
    
    [[manager memberTranslationRemaind:user.phone] subscribeNext:^(id x) {
        NSDictionary * dic = x;
        NSDictionary * attributes = dic[@"attributes"];
        NSString * beginTime = attributes[@"begintime"];
        NSString * endTIme = attributes[@"endtime"];
        [ECarConfigs shareInstance].beginTime = beginTime.integerValue;
        [ECarConfigs shareInstance].endTime = endTIme.integerValue;
        [ECarConfigs shareInstance].timeStr = dic[@"phoneMsg"];
        NSString * str = dic[@"msg"];
        if (str.length == 0) {
            return ;
        } else {
            UIAlertView *alertV1= [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alertV1 show];
        }
    } completed:^{
        
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
