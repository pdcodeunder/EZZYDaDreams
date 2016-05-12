//
//  ECarZhiFuViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 15/11/8.
//  Copyright © 2015年 LIKUN. All rights reserved.
//

#import "ECarZhiFuViewController.h"
#import "WXApi.h"
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

@interface ECarZhiFuViewController () <UIAlertViewDelegate, UITextFieldDelegate>

{
    UIButton * zhifubaoBtn;
    ECarUser * zz;
    ECarUserManager  * manage;
}
@property (nonatomic, strong) UIButton * weixinBtn;
@property (nonatomic, strong) ECarMapManager * mapManager;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong ,nonatomic) UIView * topView;
@property (strong, nonatomic) UITextField * t;
@property (strong, nonatomic) UIView * v;
@property (strong, nonatomic) NSString *str;
@property (strong, nonatomic) UIView *detailView;
/**
 *  价格明细
 */
@property (strong, nonatomic) UILabel * qbLabel1;
@property (strong, nonatomic) UILabel * lcLabel1;
@property (strong, nonatomic) UILabel * daLabel1;
@property (strong, nonatomic) UILabel * fkLabel1;

// 界面价格
@property (strong, nonatomic) UILabel * pricelabel;
@property (strong, nonatomic) UILabel * unitLabel;

@end

@implementation ECarZhiFuViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ECarConfigs * user = [ECarConfigs shareInstance];
    zz = user.user;
    manage = [ECarUserManager new];
    
    self.view.backgroundColor = WhiteColor;
    self.mapManager = [[ECarMapManager alloc] init];
    self.title = @"购买会员";
    self.str = @"";
    if (self.canBack) {
        [self creatNavBar];
        [self setViewUI];
    } else {
        self.navigationController.navigationBarHidden = YES;
        [self setViewUI];
        UILabel * titLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreenW, 44)];
        titLabel.text = @"支付订单";
        titLabel.font = [UIFont boldSystemFontOfSize:17.f];
        titLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:titLabel];
        // 添加灰线
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, kScreenW, 1)];
        label.backgroundColor = GrayColor;
        [self.view addSubview:label];
    }
}

- (void)getjiagemingxi
{
    weak_Self(self);
    ECarConfigs * cong = [ECarConfigs shareInstance];
    [[self.mapManager getJiaGeMingXiWithOrder:cong.orignOrderNo] subscribeNext:^(id x) {
        NSDictionary * dic = x;
        NSString * success = [NSString stringWithFormat:@"%@", dic[@"success"]];
        if (success.boolValue == 1) {
            NSDictionary * obj = dic[@"obj"];
            weakSelf.qbLabel1.text = [NSString stringWithFormat:@"%@元", obj[@"qibujia"]];
            weakSelf.lcLabel1.text = [NSString stringWithFormat:@"%@元", obj[@"lichengfei"]];
            weakSelf.daLabel1.text = [NSString stringWithFormat:@"%@元", obj[@"disufei"]];
            weakSelf.fkLabel1.text = [NSString stringWithFormat:@"%@元", obj[@"fanweiwai"]];
            weakSelf.detailView.hidden = NO;
        }
    } error:^(NSError *error) {
        
    }];
}

- (void)creatNavBar {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, -10, 30, 30);
    [button setImage:[UIImage imageNamed:@"fanhui9*14"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setViewUI
{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 64)];
    _topView.alpha = 1.0f;
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenW, 44)];
    titleLbl.tintColor = [UIColor blackColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:titleLbl];
    [self.view addSubview:_topView];
    
    // 界面搭建
    _pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120 / 667.f * kScreenH, kScreenW , 100 / 667.f * kScreenH)];
    _pricelabel.textColor = RedColor;
    _pricelabel.textAlignment = NSTextAlignmentCenter;
    _pricelabel.font = [UIFont systemFontOfSize:70.f];
    
    if (self.sendType == sendToHouTaiByVip) {
        NSString * zongjia = [NSString stringWithFormat:@"%@%@", self.priceCar, self.priceUnit];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:zongjia];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(str.length- self.priceUnit.length, self.priceUnit.length)];
        _pricelabel.attributedText = str;
    } else {
        _pricelabel.text = [NSString stringWithFormat:@"%@",self.priceCar];
    }
    [self.view addSubview:_pricelabel];
    
    //  价格明细
    double width = (kScreenW - 140 / 375.f * kScreenW) / 5.f ;
    double w = (kScreenW - 40 / 375.f * kScreenW) / 5.f;
    double height = 20 / 667.0f * kScreenH;
    double gap =  40 / 375.f * kScreenW;
    double jiagap = 20 / 375.0f * kScreenW;
    
    self.detailView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_pricelabel.frame), kScreenW, 60 / 667.0f * kScreenH)];
    
    UILabel *qbLabel = [[UILabel alloc]initWithFrame:CGRectMake(gap, 0, width, height)];
    qbLabel.text = @"起步价";
    qbLabel.font = [UIFont systemFontOfSize:13.0f];
    qbLabel.textColor = GrayColor;
    [self.detailView addSubview:qbLabel];
    
    self.qbLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(gap, CGRectGetMaxY(qbLabel.frame), w, height)];
    self.qbLabel1.center = CGPointMake(qbLabel.center.x + 10, qbLabel.center.y + height);
    self.qbLabel1.text = [NSString stringWithFormat:@"30元"];
    self.qbLabel1.font = [UIFont systemFontOfSize:14.0f];
    self.qbLabel1.textColor = RedColor;
    [self.detailView addSubview:self.qbLabel1];
    
    UILabel * jiaLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(qbLabel.frame), 0, jiagap, height * 2)];
    jiaLabel1.textColor = RedColor;
    jiaLabel1.text = @"+";
    jiaLabel1.font = [UIFont systemFontOfSize:14.0f];
    [self.detailView addSubview:jiaLabel1];
    
    UILabel *lcLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(jiaLabel1.frame), 0, width, height)];
    lcLabel.text = @"里程费";
    lcLabel.font = [UIFont systemFontOfSize:13.0f];
    lcLabel.textColor = GrayColor;
    [self.detailView addSubview:lcLabel];
    
    self.lcLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(jiaLabel1.frame), CGRectGetMaxY(lcLabel.frame), w, height)];
    self.lcLabel1.text = [NSString stringWithFormat:@"30元"];
    self.lcLabel1.center = CGPointMake(lcLabel.center.x + 10 / 375.f * kScreenW, lcLabel.center.y + height);
    self.lcLabel1.font = [UIFont systemFontOfSize:14.0f];
    self.lcLabel1.textColor = RedColor;
    [self.detailView addSubview:self.lcLabel1];
    
    UILabel * jiaLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lcLabel.frame), 0, jiagap, height * 2)];
    jiaLabel2.textColor = RedColor;
    jiaLabel2.text = @"+";
    jiaLabel2.font = [UIFont systemFontOfSize:14.0f];
    [self.detailView addSubview:jiaLabel2];
    
    
    UILabel *dsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(jiaLabel2.frame), 0, width, height)];
    dsLabel.text = @"低速费";
    dsLabel.font = [UIFont systemFontOfSize:13.0f];
    dsLabel.textColor = GrayColor;
    [self.detailView addSubview:dsLabel];
    
    self.daLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(jiaLabel2.frame), CGRectGetMaxY(dsLabel.frame), w, height)];
    self.daLabel1.text = [NSString stringWithFormat:@"30元"];
    self.daLabel1.center = CGPointMake(dsLabel.center.x + 10 / 375.f * kScreenW, dsLabel.center.y + height);
    self.daLabel1.font = [UIFont systemFontOfSize:14.0f];
    self.daLabel1.textColor = RedColor;
    [self.detailView addSubview:self.daLabel1];
    
    UILabel * jiaLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dsLabel.frame), 0, jiagap, height * 2)];
    jiaLabel3.textColor = RedColor;
    jiaLabel3.text = @"+";
    jiaLabel3.font = [UIFont systemFontOfSize:14.0f];
    [self.detailView addSubview:jiaLabel3];
    
    
    UILabel *fkLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(jiaLabel3.frame), 0, width * 2, height)];
    fkLabel.text = @"运营区域外费";
    fkLabel.font = [UIFont systemFontOfSize:13.0f];
    fkLabel.textColor = GrayColor;
    [self.detailView addSubview:fkLabel];
    
    self.fkLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(jiaLabel3.frame), CGRectGetMaxY(dsLabel.frame), w, height)];
//    self.fkLabel1.center = jiaLabel3.center;
    self.fkLabel1.center = CGPointMake(fkLabel.center.x + 10, fkLabel.center.y + height);
    self.fkLabel1.font = [UIFont systemFontOfSize:14.0f];
    self.fkLabel1.textColor = RedColor;
    [self.detailView addSubview:self.fkLabel1];
    
    [self.view addSubview:self.detailView];
    
    self.detailView.hidden = YES;
    
    // 支付按钮
    UIView * view1 = [[UIView alloc]init];
    zhifubaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zhifubaoBtn.frame = CGRectMake(0, ((CGRectGetMaxY(self.detailView.frame) + 30)/ 667.f * kScreenH), kScreenW, 70/ 667.f * kScreenH);
    [zhifubaoBtn addTarget:self action:@selector(zhifubaoSendPay) forControlEvents:UIControlEventTouchUpInside];
    [zhifubaoBtn setBackgroundImage:[UIImage imageNamed:@"beijingkuang374*55"] forState:UIControlStateNormal];
    UIImageView * zfbImageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhifubaozhifu40*40"]];
    zfbImageView.frame = CGRectMake(0, 0, 40, 40);
    [view1 addSubview:zfbImageView];
    UILabel * zfbLabel = [[UILabel alloc]initWithFrame:CGRectMake(40 / 375.f * kScreenW, 0, 150, 20)];
    zfbLabel.text = @"支付宝支付";
    CGSize size1 = [zfbLabel.text boundingRectWithSize:CGSizeMake(0, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f]} context:nil].size;
    zfbLabel.frame = CGRectMake(55, 0, size1.width, 40);
    view1.frame = CGRectMake(0, 0, zfbLabel.frame.size.width + zfbImageView.frame.size.width, 40);
    [view1 addSubview:zfbLabel];
    view1.center = zhifubaoBtn.center;
    [self.view addSubview:view1];
    [self.view addSubview:zhifubaoBtn];
    
    self.weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.weixinBtn.frame = CGRectMake(0, CGRectGetMaxY(zhifubaoBtn.frame) - 1, kScreenW, 70 / 667.f * kScreenH);
    [self.weixinBtn addTarget:self action:@selector(sendPaymeihoutai) forControlEvents:UIControlEventTouchUpInside];
    [self.weixinBtn setBackgroundImage:[UIImage imageNamed:@"beijingkuang374*55"] forState:UIControlStateNormal];
    UIImageView * wxImageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weixingzhifu40*40"]];
    wxImageView.frame = CGRectMake(0, 0, 40, 40);
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = WhiteColor;
    view.userInteractionEnabled = NO;
    [view addSubview:wxImageView];
    UILabel * wxLabel = [[UILabel alloc] initWithFrame:CGRectMake(40 / 375.f * kScreenW, 0, 75, 40)];
    wxLabel.text = @"微信支付";
    CGSize size = [wxLabel.text boundingRectWithSize:CGSizeMake(0, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f]} context:nil].size;
    wxLabel.frame = CGRectMake(55, 0, size.width, 40);
    view.frame = CGRectMake(0, 0, wxLabel.frame.size.width + wxImageView.frame.size.width, 40);
    view.center = CGPointMake(self.weixinBtn.center.x - 9/ 375.f * kScreenW, self.weixinBtn.center.y);
    [view addSubview:wxLabel];
    [self.view addSubview:self.weixinBtn];
    [self.view addSubview:view];
    
    if (![WXApi isWXAppInstalled]) {
        wxLabel.hidden = YES;
        self.weixinBtn.hidden = YES;
        view.hidden = YES;
    }
    
    // 上面的灰线
//    UILabel * labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weixinBtn.frame) - 70, kScreenW, 1)];
//    labelLine.backgroundColor = GrayColor;
//    [self.view addSubview:labelLine];

    // 判断传入方式
    if (!(self.sendType == sendToHouTaiByVip)) {
        _pricelabel.frame = CGRectMake(0, 120 / 667.f * kScreenH, kScreenW, 100 / 667.f * kScreenH);
        _unitLabel.hidden = YES;
        [self getjiagemingxi];
        [self creatOnceFreeView];
    }
    // 自定义键盘
    self.t = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.t.keyboardType = UIKeyboardTypeNumberPad;
    self.t.delegate = self;
    
    self.v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 70)];
    self.v.backgroundColor = WhiteColor;
    
    for (NSInteger i = 0; i < 7; i ++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake((kScreenW - 7 * 44)/2+(i * 44), 10, 40, 40)];
        label.tag = 110 + i;
        label.textColor = RedColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderWidth = 1.0f;
        label.layer.borderColor = [GrayColor CGColor];
        [self.v addSubview:label];
    }
    self.t.inputAccessoryView = self.v;
    [self.view addSubview:self.t];
}

- (void)creatOnceFreeView{
    // 单次邀请码输入
    UIView * view = [[UIView alloc]init];
    UIButton * onceFreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    onceFreeBtn.frame = CGRectMake(0, CGRectGetMaxY(self.weixinBtn.frame) - 1, kScreenW, 70/ 667.f * kScreenH);
    [onceFreeBtn addTarget:self action:@selector(onceFree) forControlEvents:UIControlEventTouchUpInside];
    [onceFreeBtn setBackgroundImage:[UIImage imageNamed:@"beijingkuang374*55"] forState:UIControlStateNormal];
    
    UIImageView * onceFreeView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"duihuanyouhuima40*40"]];
    onceFreeView.frame = CGRectMake(0, 0, 40, 40);
    [view addSubview:onceFreeView];
    UILabel * onceFreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(onceFreeView.frame) + 7.5, 25, 150, 20)];
    onceFreeLabel.text = @"优惠码支付";
    CGSize  size = [onceFreeLabel.text boundingRectWithSize:CGSizeMake(0, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f]} context:nil].size;
    onceFreeLabel.frame = CGRectMake(55, 0, size.width, 40);
    view.frame = CGRectMake(0, 0, onceFreeLabel.frame.size.width + onceFreeView.frame.size.width, 40);
    [view addSubview:onceFreeLabel];
    view.center = onceFreeBtn.center;
    [self.view addSubview:view];
    [self.view addSubview:onceFreeBtn];
}

// 点击事件
- (void)onceFree {
    UIControl * cont = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 500)];
    cont.tag = 110;
    cont.alpha = 0;
    [cont addTarget:self action:@selector(contAction) forControlEvents:UIControlEventTouchUpInside];
    cont.backgroundColor = BlackColor;
    [self.view addSubview:cont];
    [UIView animateWithDuration:.35 animations:^{
        cont.alpha = 0.5;
    }];
    for (NSInteger i = 0; i < 7; i ++) {
        UILabel * label = (UILabel *)[self.v viewWithTag:110 + i];
        label.text = @" ";
        self.t.text = nil;
    }
    [self.t becomeFirstResponder];
}

- (void)contAction
{
    for (NSInteger i = 0; i < 7; i ++) {
        UILabel * label = (UILabel *)[self.v viewWithTag:110 + i];
        label.text = @" ";
        //        self.t.text = nil;
    }
    [self.t resignFirstResponder];
    UIControl * cont = [self.view viewWithTag:110];
    [cont removeFromSuperview];
}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    for (NSInteger i = 0; i < 7; i ++) {
//        UILabel * label = (UILabel *)[self.v viewWithTag:110 + i];
//        label.text = @" ";
////        self.t.text = nil;
//    }
//    [self.t resignFirstResponder];
//}

// textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    switch (range.location) {
        case 0:
        {
            UILabel * label = (UILabel *)[self.v viewWithTag:110];
            if (range.length == 0) {
                label.text = string;
            } else {
                label.text = @" ";
            }
            break;
        }
        case 1:
        {
            UILabel * label = (UILabel *)[self.v viewWithTag:111];
            if (range.length == 0) {
                label.text = string;
            } else {
                label.text = @" ";
            }
            break;
        }
        case 2:
        {
            UILabel * label = (UILabel *)[self.v viewWithTag:112];
            if (range.length == 0) {
                label.text = string;
            } else {
                label.text = @" ";
            }
            break;
        }
        case 3:
        {
            UILabel * label = (UILabel *)[self.v viewWithTag:113];
            if (range.length == 0) {
                label.text = string;
            } else {
                label.text = @" ";
            }
            break;
        }
        case 4:
        {
            UILabel * label = (UILabel *)[self.v viewWithTag:114];
            if (range.length == 0) {
                label.text = string;
            } else {
                label.text = @" ";
            }
            break;
        }
        case 5:
        {
            UILabel * label = (UILabel *)[self.v viewWithTag:115];
            if (range.length == 0) {
                label.text = string;
            } else {
                label.text = @" ";
            }
            break;
        }
        case 6:
        {
            UILabel * label = (UILabel *)[self.v viewWithTag:116];
            if (range.length == 0) {
                label.text = string;
                [self.t resignFirstResponder];
            } else {
                label.text = @" ";
            }
            for (NSInteger i = 0; i < 7; i++) {
                UILabel * label = (UILabel *)[self.v viewWithTag:(110 + i)];
                self.str = [NSString stringWithFormat:@"%@%@",self.str,label.text];
            }
            UIControl * cont = [self.view viewWithTag:110];
            [cont removeFromSuperview];
            [self diaoyongHouTai];
            [self.t resignFirstResponder];
            self.str = @"";
            break;
        }
        default:
        {
            [self.t resignFirstResponder];
            return NO;
            break;
        }
    }
    return YES;
}

// 调用单次优惠码接口
- (void)diaoyongHouTai{
    ECarConfigs * user = [ECarConfigs shareInstance];
    [self showHUD:@"请稍等..."];
    weak_Self(self);
    [[manage sendBuyMemberInfodingdanID:user.orignOrderNo freeCode:self.str] subscribeNext:^(id x) {
        NSDictionary * dicx = x;
        [weakSelf hideHUD];
        // true false 判断
        NSString * succes = [NSString stringWithFormat:@"%@", [dicx objectForKey:@"success"]];
        if (succes.boolValue == 0) {
            UIAlertView * falseAlert = [[UIAlertView alloc]initWithTitle:@"错误" message:[NSString stringWithFormat:@"%@", [dicx objectForKey:@"msg"]] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [falseAlert show];
        }else{
            UIAlertView * tishi = [[UIAlertView alloc]initWithTitle:@"恭喜您!" message:[NSString stringWithFormat:@"%@", [dicx objectForKey:@"msg"]] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            tishi.tag = 987;
            [tishi show];
        }
    } error:^(NSError *error) {
        [weakSelf hideHUD];
        [weakSelf delayHidHUD:@"网络错误"];
    }];
}


- (void)zhifubaoSendPay
{
    if (self.sendType == sendToHouTaiByVip) {
        [ECarConfigs shareInstance].zhifuwancheng = 10;
    } else {
        [ECarConfigs shareInstance].zhifuwancheng = 0;
    }
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
    order.tradeNO = confige.orignOrderNo; // 订单ID（由商家自行制定）
    order.productName = @"EZZY支付"; // 商品标题
    order.productDescription = @"感谢使用EZZY汽车"; // 商品描述
    order.amount = [NSString stringWithFormat:@"%.2lf", confige.currentPrice.floatValue]; // 商品价格
    PDLog(@"asdf   %@    %@  %@", confige.orignOrderNo, [NSString stringWithFormat:@"%.2lf", confige.currentPrice.floatValue], confige.currentPrice);
    order.notifyURL =  kZhiFuNotify; // 回调URL
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
                } else {
                    strTitle = @"支付成功";
                    strMsg = @"为了方便下一位用户顺利使用车辆，请您下车后关闭车门，感谢您的配合";
                }
                if ([ECarConfigs shareInstance].cheliangchaochu == 20) {
                    [ECarConfigs shareInstance].cheliangchaochu = 0;
                    strTitle = @"支付成功";
                    strMsg = @"为了方便下一位用户顺利使用车辆，请您下车后关闭车门，感谢您的配合";
                }
                [ECarConfigs shareInstance].zhifuwancheng = 0;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                alert.tag = 324;
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
            }
            if ([ECarConfigs shareInstance].zhifuwancheng == 10) {
                if (self.navigationController.viewControllers.count > 1) {
                    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                }
            }
        }];
    }
}

- (void)weixinSendPay
{
    [ECarSharedPriceModel sharedPriceModel].zhifufangshi = kZhiFuFangShiWeiXin;
    if (![WXApi isWXAppInstalled]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有安装微信" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self showHUD:@"正在打开..."];
    time_t now;
    time(&now);
    NSString * time_stamp  = [NSString stringWithFormat:@"%ld", now];
    [[self.mapManager weixinzhifuOrderWithID:self.orderID andTimestamp:time_stamp] subscribeNext:^(id x) {
        [self hideHUD];
        NSDictionary * dictx = x;
        NSDictionary * dict = dictx[@"obj"];
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
            }else{
                [self delayHidHUD:[dict objectForKey:@"retmsg"]];
            }
        }else{
            [self delayHidHUD:@"服务器返回错误，打开微信失败"];
        }
    } error:^(NSError *error) {
        [self hideHUD];
    } completed:^{
        
    }];
}

- (void)diaoquhoutaiWinXinZhiFuByDingDan
{
    [[self.mapManager sendHouTaiWithOrderID:[ECarConfigs shareInstance].orignOrderNo] subscribeNext:^(id x) {
        
    } completed:^{
        
    }];
}

- (void)diaoquhoutaiWinXinZhiFuByVIP
{
    [[self.mapManager sendHouTaiVipWithOrderID:self.orderID] subscribeNext:^(id x) {
        
    } completed:^{
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 324) {
        if (buttonIndex == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"zhifuwancheng" object:nil userInfo:nil];
        }
    }
    if (buttonIndex == 0 && alertView.tag == 212) {
        [ToolKit callTelephoneNumber:@"400-6507265" addView:self.view];
    }
    if (alertView.tag == 987) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"zhifuwancheng" object:nil userInfo:nil];
    }
}

- (void)sendPaymeihoutai
{
    if (self.sendType == sendToHouTaiByVip) {
        [ECarConfigs shareInstance].zhifuwancheng = 10;
    } else {
        [ECarConfigs shareInstance].zhifuwancheng = 0;
    }
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
        
        if (self.sendType == sendToHouTaiByVip) {
            [self diaoquhoutaiWinXinZhiFuByVIP];
        }else{
            [self diaoquhoutaiWinXinZhiFuByDingDan];
        }
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
        } else {
            [self alert:@"提示信息" msg:[dict objectForKey:@"retmsg"]];
        }
        
    }else{
        [ECarConfigs shareInstance].zhifuwancheng = 0;
        [self alert:@"提示信息" msg:@"调用微信失败，请重试"];
    }
}

- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alter show];
}

- (void)callSaver:(UIButton *)sender
{
    UIAlertView *serviceAlert = [[UIAlertView alloc] initWithTitle:@"联系客服" message:@"400-6507265" delegate:self cancelButtonTitle:@"呼叫" otherButtonTitles:@"取消" , nil];
    serviceAlert.tag = 212;
    [serviceAlert show];
}

#pragma mark ---HUD
- (void)showHUD:(NSString *)text
{
    if (!self.hud) {
        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
        _hud.mode = MBProgressHUDAnimationFade;
        [self.view addSubview:_hud];
    }
    [_hud setLabelText:text];
    [_hud show:YES];
}
- (void)hideHUD
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.hud = nil;
}
- (void)delayHidHUD:(NSString *)text
{
    if (!self.hud) {
        self.hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.mode = MBProgressHUDModeText;
        [self.view addSubview:_hud];
    }
    [_hud setLabelText:text];
    [_hud show:YES];
    [_hud hide:YES afterDelay:3];
}

@end
