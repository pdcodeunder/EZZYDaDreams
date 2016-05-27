//
//  EZZYMemberZhiFuViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/5/10.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "EZZYMemberZhiFuViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <CommonCrypto/CommonDigest.h>
#import "payRequsestHandler.h"
#import "ECarSharedPriceModel.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

/**
 *  支付宝支付
 */
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ECarMapManager.h"
#import "ECarSharedPriceModel.h"

// 调用接口用
#import "ECarUser.h"
#import "ECarUserManager.h"

@interface EZZYMemberZhiFuViewController ()
{
    ECarUser * zz;
    ECarUserManager  * manage;
}
@property (nonatomic, strong) ECarMapManager * mapManager;

@end

@implementation EZZYMemberZhiFuViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ECarConfigs * user = [ECarConfigs shareInstance];
    zz = user.user;
    manage = [ECarUserManager new];
    self.mapManager = [[ECarMapManager alloc] init];
    self.title = @"购买会员";
    
    [self setViewUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyMemberZhiFuFinished) name:@"buyMemberZhiFuFinished" object:nil];
}

- (void)buyMemberZhiFuFinished
{
    NSString * strTitle = @"";
    NSString * strMsg = @"";
    [ECarConfigs shareInstance].zhifuwancheng = 0;
    strTitle = @"支付成功";
    strMsg = @"恭喜您成为EZZY会员";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    alert.tag = 344;
    [alert show];
}

- (void)setViewUI
{
     self.priceUnit = @"元";
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 196 / 667.f * kScreenH)];
    priceLabel.font = [UIFont systemFontOfSize:55.f];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.textColor = RedColor;
    NSString * zongjia = [NSString stringWithFormat:@"%.1f%@", [ECarConfigs shareInstance].currentPrice.doubleValue, self.priceUnit];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:zongjia];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(str.length - self.priceUnit.length, self.priceUnit.length)];
    priceLabel.attributedText = str;
    [self.view addSubview:priceLabel];
    
    UIButton * weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.frame = CGRectMake(0, CGRectGetMaxY(priceLabel.frame) + 33 / 667.f * kScreenH, kScreenW, 70 / 667.f * kScreenH);
    [weixinBtn addTarget:self action:@selector(sendPaymeihoutai) forControlEvents:UIControlEventTouchUpInside];
    [weixinBtn setBackgroundImage:[UIImage imageNamed:@"beijingkuang374*55"] forState:UIControlStateNormal];
    UIImageView * wxImageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weixingzhifu40*40"]];
    wxImageView.frame = CGRectMake(0, 0, 40, 40);
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = WhiteColor;
    view.userInteractionEnabled = NO;
    [view addSubview:wxImageView];
    UILabel * wxLabel = [[UILabel alloc] initWithFrame:CGRectMake(40 / 375.f * kScreenW, 0, 75, 40)];
    wxLabel.text = @"微信支付";
    CGSize size = [wxLabel.text boundingRectWithSize:CGSizeMake(0, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f]} context:nil].size;
    wxLabel.frame = CGRectMake(55, 0, size.width, 40);
    view.frame = CGRectMake(0, 200, wxLabel.frame.size.width + wxImageView.frame.size.width, 40);
    view.center = CGPointMake(weixinBtn.center.x - 9/ 375.f * kScreenW, weixinBtn.center.y);
    [view addSubview:wxLabel];
    [self.view addSubview:weixinBtn];
    [self.view addSubview:view];
    
    // 支付按钮
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 70 / 667.f * kScreenH)];
    UIButton *zhifubaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zhifubaoBtn.frame = CGRectMake(0, CGRectGetMaxY(weixinBtn.frame) - 1, kScreenW, 70 / 667.f * kScreenH);
    [zhifubaoBtn addTarget:self action:@selector(zhifubaoSendPay) forControlEvents:UIControlEventTouchUpInside];
    [zhifubaoBtn setBackgroundImage:[UIImage imageNamed:@"beijingkuang374*55"] forState:UIControlStateNormal];
    
    UIImageView * zfbImageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhifubaozhifu40*40"]];
    zfbImageView.frame = CGRectMake(0, 0, 40, 40);
    [view1 addSubview:zfbImageView];
    
    UILabel * zfbLabel = [[UILabel alloc]initWithFrame:CGRectMake(40 / 375.f * kScreenW, 0, 150, 20)];
    zfbLabel.text = @"支付宝支付";
    CGSize size1 = [zfbLabel.text boundingRectWithSize:CGSizeMake(0, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f]} context:nil].size;
    zfbLabel.frame = CGRectMake(55, 0, size1.width, 40);
    view1.frame = CGRectMake(0, 100, zfbLabel.frame.size.width + zfbImageView.frame.size.width, 40);
    view1.center = zhifubaoBtn.center;
    [view1 addSubview:zfbLabel];
    [self.view addSubview:view1];
    [self.view addSubview:zhifubaoBtn];
    
    if (![WXApi isWXAppInstalled] || [ECarConfigs shareInstance].currentPrice.doubleValue > 3000) {
        wxLabel.hidden = YES;
        weixinBtn.hidden = YES;
        view.hidden = YES;
    }
}

- (void)zhifubaoSendPay
{
    [ECarConfigs shareInstance].zhifuwancheng = 10;
    [ECarSharedPriceModel sharedPriceModel].zhifufangshi = kZhiFuFangShiZhiFuBao;
    NSString *partner = kPernerID;
    NSString *seller = kSallerID;
    NSString *privateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBALjIeXQK8/5NZz8NTDUb2uuyfqeqmak+FicWlmivdbUlqxCAUtGcrJy9C8vTbI1i6zDeuWIjo8RjUOx97BfoXjz+9RPnbJ5fGqBJYCBEnU9bF+eKdYMpOTP8hLg7AoSitHx47naBu0FtbObmDhNbvd+xw+GAx+wHVolqpn2nr6IJAgMBAAECgYEAncLDNtjXIenR2VowEzO5//t/+QRFduJEJZE6TxxmgYcsesUkcEO0d4lLlfTnO/sVU78ERY6qFlS41YBY3ryMH1Hafd76O+Agi2wjamOVtrknemBqDC+LzLbayzQEbOvvHDt+7S4LyXT2b7zTe1SW3e5P+fvxOc0xN9ReJlBXmlUCQQDiaMF09KY/gOaSNvzLLd/C8tItjHRHfEpC41igrteWqTNi7uWHnASqrKp6VDGNSuAC6F4K9phmWiUPF9KgVi3fAkEA0O78Ak9dSRnP6VtRVQ+6okc1PBg4yd0/8pg+2ptD9ewp68bpiTtkKNbhYYNacTV7XY4tKEU/MZwsjOf/QKjdFwJBAJ4acwW+Fh4AYIK4PV2Q4lHbiSPfkg+dXqpI4koK7me6LjUnCEfjjmq0+rND+fplz/qX05wqSZAn4PsiMqZep9cCQQCx8vn81a+0NSHZtQcelZj14gQ7PL4RYDm422adNiS57fz+bZo2Ybk691lafk+noE+ELTXU2LWsAUIIeQf0AF7dAkAwWCKskb9H+bjAFhFN1YUPrh0DrvNayZvSUDByGQvLaMep3F9VkGszzgZ86QL+ix091fD/qmewFYcOPt1Lk/yh";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"支付失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"确认"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    ECarConfigs * confige = [ECarConfigs shareInstance];
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    
    order.tradeNO = confige.orignOrderNo; //订单ID（由商家自行制定）
    order.productName = @"EZZY支付"; //商品标题
    order.productDescription = @"违章扣款费用"; // 商品描述
    order.amount = confige.currentPrice; // 商品价格
    order.notifyURL = kZhiFuBuyMemNotify; // 回调URL@"http://www.dreamers-makers.com"
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    // 应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    // 将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSString * resultStatus = [NSString stringWithFormat:@"%@", resultDic[@"resultStatus"]];
            if (resultStatus.integerValue == 9000 || resultStatus.integerValue == 8000) {
//                NSString * strTitle = [NSString stringWithFormat:@"支付结果"];
                NSString * strTitle = @"";
                NSString * strMsg = @"";
                if ([ECarConfigs shareInstance].zhifuwancheng == 10) {
                    strTitle = @"支付成功";
                    strMsg = @"恭喜您成为EZZY会员";
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                alert.tag = 344;
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付失败" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                alert.tag = 344;
                [alert show];
            }
            [ECarConfigs shareInstance].zhifuwancheng = 0;
        }];
    }
}

- (void)sendPaymeihoutai
{
    [ECarConfigs shareInstance].buyMemberNotify = 4444;
    [ECarConfigs shareInstance].zhifuwancheng = 10;
    [ECarSharedPriceModel sharedPriceModel].zhifufangshi = kZhiFuFangShiWeiXin;
    if (![WXApi isWXAppInstalled]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，您还没有安装微信" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        return;
    }
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    //}}}
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo];
    //        NSLog(@"url:%@",urlString);
    if(dict != nil){
        NSMutableString *retcode = [dict objectForKey:@"retcode"];
        if (retcode.intValue == 0){
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
            //日志输出
            //            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        }else{
            [self alert:@"提示信息" msg:[dict objectForKey:@"retmsg"]];
        }
    } else {
        [ECarConfigs shareInstance].zhifuwancheng = 0;
        [self alert:@"提示信息" msg:@"调用微信失败，请重试"];
    }
}

- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    
    [alter show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 344) {
        if (buttonIndex == 0) {
            if (self.navigationController.viewControllers.count > 1) {
                [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
