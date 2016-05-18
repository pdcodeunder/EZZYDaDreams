//
//  NewOverNeightViewController.m
//  ElectricCarRent
//
//  Created by 张钊 on 16/5/12.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "NewOverNeightViewController.h"
#import "YLLabel.h"
#import "ECarUserManager.h"
#import "ECarConfigs.h"

#import "WXApi.h"
#import <CommonCrypto/CommonDigest.h>
#import "payRequsestHandler.h"
#import "ECarSharedPriceModel.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

// 支付宝支付
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ECarMapManager.h"
#import "ECarSharedPriceModel.h"

typedef enum : NSUInteger {
    BaoYeErrorType = 211,
    BaoYeSeccesType
} BaoYeType;

@interface NewOverNeightViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong)ECarUserManager * manager;


@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UILabel * costLabel;
@property (nonatomic, strong) UILabel * shuomingLabel;
@property (nonatomic, strong) YLLabel * descLabel;
@property (nonatomic, copy) NSString * money;
@property (nonatomic, copy) NSString * onsid;
@property (nonatomic, strong) UIButton * zhifubaoBtn;
@property (nonatomic, strong) UIButton * weixinBtn;
@property (nonatomic, strong) UIView * view0;
@property (nonatomic, strong) UIView *view1;

@end

@implementation NewOverNeightViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"包夜";
    self.view.backgroundColor = WhiteColor;
    _manager = [[ECarUserManager alloc] init];
    
    [self creatUI];
    [self creatTableView];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(baoYeZhiFuWanCheng) name:@"baoYeZhiFuWanCheng" object:nil];
}

- (void)baoYeZhiFuWanCheng
{
    [ECarConfigs shareInstance].baoYeOrderId = @"";
    [ECarConfigs shareInstance].baoyePrice = @"";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付成功" message:@"您可以夜间使用车辆，我们将不予收回" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = BaoYeSeccesType;
    [alert show];
}

/**
 *  创建UI
 */
- (void)creatUI{
    // cell 1
    _costLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,(229.f / 2 - 30) / 667.f * kScreenH, kScreenW, 60 / 667.f * kScreenH)];
    _costLabel.text = @"";
    //        costLabel.center = cell.contentView.center;
    _costLabel.backgroundColor = WhiteColor;
    _costLabel.font = [UIFont systemFontOfSize:50.f / 667.f * kScreenH];
    _costLabel.textAlignment = NSTextAlignmentCenter;
    _costLabel.textColor = RedColor;
    
    //cell 2
    // 支付按钮
    _zhifubaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _zhifubaoBtn.frame = CGRectMake(0, 0, kScreenW, 55/ 667.f * kScreenH);
    [_zhifubaoBtn addTarget:self action:@selector(zhifubaoSendPayzz) forControlEvents:UIControlEventTouchUpInside];
    [_zhifubaoBtn setBackgroundImage:[UIImage imageNamed:@"beijingkuang374*55"] forState:UIControlStateNormal];
    
    _view1 = [[UIView alloc]init];
    UIImageView * zfbImageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhifubaozhifu40*40"]];
    zfbImageView.frame = CGRectMake(0, 0, 40, 40);
    [_view1 addSubview:zfbImageView];
    UILabel * zfbLabel = [[UILabel alloc]initWithFrame:CGRectMake(40 / 375.f * kScreenW, 0, 150, 20)];
    zfbLabel.text = @"支付宝支付";
    CGSize size1 = [zfbLabel.text boundingRectWithSize:CGSizeMake(0, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f]} context:nil].size;
    zfbLabel.frame = CGRectMake(55, 0, size1.width, 40);
    [_view1 addSubview:zfbLabel];
    
    _view1.frame = CGRectMake(0, 0, zfbLabel.frame.size.width + zfbImageView.frame.size.width, 40);
    _view1.center = _zhifubaoBtn.center;
    
    
    _weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _weixinBtn.frame = CGRectMake(0, CGRectGetMaxY(_zhifubaoBtn.frame) - 1, kScreenW, 55 / 667.f * kScreenH);
    [_weixinBtn addTarget:self action:@selector(weixinSendPaydd) forControlEvents:UIControlEventTouchUpInside];
    [_weixinBtn setBackgroundImage:[UIImage imageNamed:@"beijingkuang374*55"] forState:UIControlStateNormal];
    
    _view0 = [[UIView alloc] init];
    UIImageView * wxImageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weixingzhifu40*40"]];
    wxImageView.frame = CGRectMake(0, 0, 40, 40);
    [_view0 addSubview:wxImageView];
    UILabel * wxLabel = [[UILabel alloc] initWithFrame:CGRectMake(40 / 375.f * kScreenW, 0, 75, 40)];
    wxLabel.text = @"微信支付";
    CGSize size = [wxLabel.text boundingRectWithSize:CGSizeMake(0, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f]} context:nil].size;
    wxLabel.frame = CGRectMake(55, 0, size.width, 40);
    [_view0 addSubview:wxLabel];
    
    _view0.frame = CGRectMake(0, 0, wxImageView.frame.size.width + wxLabel.frame.size.width, 40);
    _view0.center = _weixinBtn.center;
    
    //cell 3
    _shuomingLabel = [[UILabel alloc]initWithFrame:CGRectMake(18 / 375.f * kScreenW, 50.f / 667.f * kScreenH, 100, 16 / 667.f * kScreenH)];
    _shuomingLabel.text = @"包夜说明";
    _shuomingLabel.textAlignment = NSTextAlignmentLeft;
    _shuomingLabel.textColor = RedColor;
    _shuomingLabel.font = FontType;
    
    _descLabel = [[YLLabel alloc]init];
    _descLabel.lineSpacing = 10.f / 667.f * kScreenH;
    _descLabel.firstLineHeadIndent = 30.f / 667.f * kScreenH;
    _descLabel.font = FontType;
    
    if (![WXApi isWXAppInstalled]) {
        _weixinBtn.hidden = YES;
        _view0.hidden = YES;
        wxLabel.hidden = YES;
        wxImageView.hidden = YES;
    }
}

/**
 *  创建tableview
 */
- (void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
    _tableView.backgroundColor = WhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

#pragma mark tableViewDelegate
/**
 *  tableview代理方法
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 229 / 667.f * kScreenH;
    }
    if (indexPath.row == 1) {
        return 110.f / 667.f * kScreenH;
    }
    return _descLabel.height + CGRectGetMaxY(_shuomingLabel.frame) + 20.0f / 667.f * kScreenH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = WhiteColor;
    if (0 == indexPath.row) {
        [cell.contentView addSubview:_costLabel];
    }else if (1 == indexPath.row){
        [cell.contentView addSubview:_view1];
        [cell.contentView addSubview:_zhifubaoBtn];
        [cell.contentView addSubview:_view0];
        [cell.contentView addSubview:_weixinBtn];
    }else if(2 == indexPath.row){
        [cell.contentView addSubview:_shuomingLabel];
        [cell.contentView addSubview:_descLabel];
    }
    return cell;
}

/**
 *  支付宝点击事件
 */
- (void)zhifubaoSendPayzz{
    NSLog(@"支付宝");
    if ([ECarConfigs shareInstance].baoyePrice.length == 0 || [ECarConfigs shareInstance].baoYeOrderId.length == 0) {
        [self delayHidHUD:MESSAGE_NoNetwork];
        return;
    }
    [ECarConfigs shareInstance].zhifuwancheng = 50;
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
    order.tradeNO = _onsid; // 订单ID（由商家自行制定）
    order.productName = @"EZZY支付"; // 商品标题
    order.productDescription = @"感谢使用EZZY汽车"; // 商品描述
    order.amount = self.money; // 商品价格
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
                
                [self baoYeZhiFuWanCheng];
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

/**
 *  微信点击事件
 */
- (void)weixinSendPaydd{
    if ([ECarConfigs shareInstance].baoyePrice.length == 0 || [ECarConfigs shareInstance].baoYeOrderId.length == 0) {
        [self delayHidHUD:MESSAGE_NoNetwork];
        return;
    }
    [ECarConfigs shareInstance].zhifuwancheng = 50;
    [ECarConfigs shareInstance].isBaoye = 789;
//    [ECarConfigs shareInstance].zhifuwancheng = 10;
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
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
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

/**
 *  下载数据
 */
- (void)loadData{
    weak_Self(self);
    [weakSelf showHUD:@"加载中..."];
        ECarConfigs * configs = [ECarConfigs shareInstance];
    [[_manager baoyefeiWithDingdanId:configs.orignOrderNo] subscribeNext:^(id x) {
        NSLog(@"%@",x);
        [weakSelf hideHUD];
        NSDictionary * dic = x;
        NSString * success = [NSString stringWithFormat:@"%@",dic[@"success"]];
        if (success.boolValue == 0) {
            NSString * msg = [NSString stringWithFormat:@"%@",dic[@"msg"]];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alert.tag = BaoYeErrorType;
            [alert show];
            return ;
        }
        NSDictionary * objs = dic[@"attributes"];
        if (objs.count != 0) {
            _costLabel.text = [NSString stringWithFormat:@"￥%.2f",[objs[@"money"] floatValue]];
            weakSelf.money = [NSString stringWithFormat:@"%.2f", [objs[@"money"] floatValue]];
            
            NSString * descStr = [NSString stringWithFormat:@"%@",objs[@"text"]];
            CGSize size = [descStr boundingRectWithSize:CGSizeMake(kScreenW - 28 / 375.f * kScreenW, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FontType} context:nil].size;
            _descLabel.frame = CGRectMake(18 / 375.f * kScreenW, CGRectGetMaxY(_shuomingLabel.frame) + 20.0f / 667.f * kScreenH, kScreenW - 36 / 375.f * kScreenW, size.height + 100 / 667.f * kScreenH);
            [_descLabel setText:descStr];
            _onsid = [NSString stringWithFormat:@"%@", objs[@"onsid"]];
            [ECarConfigs shareInstance].baoYeOrderId = [NSString stringWithFormat:@"%@", objs[@"onsid"]];
            [ECarConfigs shareInstance].baoyePrice = [NSString stringWithFormat:@"%.2f", [objs[@"money"] floatValue]];
            [weakSelf.tableView reloadData];
        }
    } completed:^{
        [weakSelf hideHUD];
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 400) {
        if (buttonIndex == 0) {
            [ToolKit callTelephoneNumber:@"400-6507265" addView:self.view];
        }
    } else if (alertView.tag == BaoYeSeccesType) {
        [self.navigationController popViewControllerAnimated:NO];
    } else if (alertView.tag == BaoYeErrorType) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
