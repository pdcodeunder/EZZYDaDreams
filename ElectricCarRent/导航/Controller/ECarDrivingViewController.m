//
//  ECarDrivingViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 15/10/5.
//  Copyright (c) 2015年 彭懂. All rights reserved.
//

#import "ECarDrivingViewController.h"
#import "ECarMapManager.h"
#import "AMapSearchManager.h"
#import "MBProgressHUD.h"
#import "ECarZhiFuViewController.h"
#import "PDLanYaLianJie.h"
#import "UIKit+AFNetworking.h"

//不带界面的语音合成控件
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import <iflyMSC/IFlySpeechUtility.h>

typedef NS_ENUM(NSInteger, AlertType) {
    AlertTypeEndEngineOpen = 1000,
    AlertTypeEndEngineClosed,
    AlertTypeEndDoorOpen
};

typedef NS_ENUM(NSInteger, CarLockSendStates) {
    CarLockSendStatesDefault = 140,
    CarLockSendStatesOpen,
    CarLockSendStatesClose
};

typedef void(^DelayBlock)();

@interface ECarDrivingViewController ()<UIAlertViewDelegate, PDLanYaLianJieDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) UIImageView               * turnImageView;
@property (strong, nonatomic) UILabel                   * routeDisatanceLbl;
@property (strong, nonatomic) UILabel                   * currentRoadLbl;
@property (strong, nonatomic) UILabel                   * nextRoadLbl;
@property (strong, nonatomic) ECarMapManager            * manager;
@property (strong, nonatomic) MBProgressHUD             * hud;
@property (strong, nonatomic) DelayBlock                  delayBlock;
@property (strong, nonatomic) ECarZhiFuViewController   * zhifu;
@property (strong, nonatomic) UIButton                  * countMoney;
@property (strong, nonatomic) UIButton                  * jifeiButton;
@property (nonatomic, strong) UILabel                   * jifeiLabel;
@property (nonatomic, strong) UILabel                   * yuanLabel;
@property (nonatomic, strong) UIView                    * navigationView;
@property (nonatomic, strong) UILabel                   * chaochuLabel;
@property (nonatomic, strong) UIView                    * jifeiViewq;
@property (nonatomic, strong) UILabel                   * benciLabel;

// 语音
@property (nonatomic, strong) IFlySpeechSynthesizer     * iFlySpeechSynthesizer;
@property (nonatomic, strong) UILabel                   * priceMingxiLabel;
@property (nonatomic, strong) UIView * bottomViews;

@property (nonatomic, strong) PDLanYaLianJie * lanya;
@property (assign, nonatomic) BOOL isFirst;
@property (assign, nonatomic) CarLockSendStates carLockSendStates;
@property (assign, nonatomic) BOOL clicked;

@property (nonatomic, strong) UIButton *daohangBtn;
@property (nonatomic, strong) UIImageView *showImageView;
@property (strong, nonatomic) UIControl *backControl;
@property (strong, nonatomic) UIView *backView;

@end

static BOOL chaochu = YES;
@implementation ECarDrivingViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIButton *)daohangBtn
{
    if (!_daohangBtn) {
        _daohangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_daohangBtn setTitleColor:BlackColor forState:UIControlStateNormal];
        _daohangBtn.backgroundColor = RedColor;
        _daohangBtn.frame = CGRectMake(0, kScreenH / 2.f, 100, 40);
    }
    return _daohangBtn;
}

- (UIButton *)countMoney
{
    if (!_countMoney) {
        _countMoney = [UIButton buttonWithType:UIButtonTypeCustom];
        _countMoney.frame = CGRectMake(0, kScreenH - 49, kScreenW, 49);
        [_countMoney setTitle:@"0.00" forState:UIControlStateNormal];
        _countMoney.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_countMoney setBackgroundImage:[UIImage imageNamed:@"鸣笛用车蓝色块375*98"] forState:UIControlStateNormal];
        [_countMoney setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _countMoney;
}

- (UIControl *)backControl
{
    if (!_backControl) {
        _backControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _backControl.backgroundColor = [UIColor blackColor];
        _backControl.alpha = 0;
    }
    return _backControl;
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 20 / 375.f * kScreenW, 380 / 667.f * kScreenH)];
        _backView.center = CGPointMake(kScreenW / 2.f, kScreenH / 2.f - 10);
    }
    return _backView;
}

static int indexee = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    indexee = 0;
    self.carLockSendStates = CarLockSendStatesDefault;
    self.clicked = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (instancetype)initWithDelegate:(id<AMapNaviViewControllerDelegate>)delegate
{
    if (self = [super initWithDelegate:delegate]) {
        // 导航转向信息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drivingupdateTurnInfo:) name:@"UpdateDrivingNaviInfo" object:nil];
        self.manager = [ECarMapManager new];
        [self initFindCarButtonView];
    }
    return self;
}

- (void)drivingupdateTurnInfo:(NSNotification *)notification
{
    self.navigationView.hidden = NO;
    AMapNaviInfo *naviInfo = [notification object];
    int iconType = naviInfo.iconType;
    NSString * pngName = [NSString stringWithFormat:@"ecar_navi_action_%d.png", iconType];
    self.turnImageView.image = [UIImage imageNamed:pngName];
    self.currentRoadLbl.text = [NSString stringWithFormat:@"从 %@ 进入",naviInfo.currentRoadName];
    self.nextRoadLbl.text = naviInfo.nextRoadName;
    self.routeDisatanceLbl.text = [NSString stringWithFormat:@"%ld米后",(long)naviInfo.segmentRemainDistance];
}

- (void)checkLanYa
{
    if (!self.carInfo.lanYaName) {
        return;
    }
    self.lanya = [PDLanYaLianJie shareInstance];
    self.lanya.pdDelegate = self;
    if (!self.lanya.lanYaStatus) {
//        [self showHUD:@"正在连接"];
//        [self performSelector:@selector(stopHud) withObject:nil afterDelay:10];
        [self.lanya beginBlueToothWithDiverceName:self.carInfo.lanYaName];
    }
}

- (void)stopHud
{
    [self delayHidHUD:@"连接超时"];
}

- (void)initYunYingFanWeiView
{
    self.backControl.hidden = YES;
    [self.backControl addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backControl];
    
    [self.view addSubview:self.backView];
    self.backView.alpha = 0;
    self.backView.hidden = YES;
    self.backView.userInteractionEnabled = YES;
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30 / 375.f * kScreenW, self.backView.width, self.backView.height - 30 / 375.f * kScreenW - 50 / 375.f * kScreenW)];
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 4;
    scrollView.backgroundColor = WhiteColor;
    scrollView.delegate = self;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, 0, 31 / 375.f * kScreenW, 31 / 375.f * kScreenW);
    closeBtn.right = scrollView.right;
    [closeBtn setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:closeBtn];
    [self.backView addSubview:scrollView];
    
    [UIImageView clearCache];
    UIImageView *showImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.height)];
    NSURL * showuUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@car/webpage/pic/yunyingfanwei1.png", ServerURL]];
    NSURLRequest * showRequest = [NSURLRequest requestWithURL:showuUrl];
    weak_Self(self);
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(0, 0, 200, 200);
    activityView.center = showImgView.center;
    [self.backView addSubview:activityView];
    __block UIImageView *blockImage = showImgView;
    
    [activityView startAnimating];
    [showImgView setImageWithURLRequest:showRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, UIImage * _Nonnull image) {
        [blockImage setImage:image];
        [activityView stopAnimating];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSError * _Nonnull error) {
        [weakSelf delayHidHUD:MESSAGE_NoNetwork];
        [activityView stopAnimating];
    }];
    [scrollView addSubview:showImgView];
    self.showImageView = showImgView;
    
    UIImageView *bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(scrollView.left, scrollView.bottom, scrollView.width, 30 / 375.f * kScreenW)];
    bottomImage.image = [UIImage imageNamed:@"tishi"];
    [self.backView addSubview:bottomImage];
}

- (void)closeBtnClicked
{
    [UIView animateWithDuration:0.32 animations:^{
        self.backView.alpha = 0;
        self.backControl.alpha = 0;
    } completion:^(BOOL finished) {
        self.backControl.hidden = YES;
        self.backView.hidden = YES;
    }];
}

- (void)showFanWeiQuYuViewClicked
{
    self.backControl.hidden = NO;
    self.backView.hidden = NO;
    [UIView animateWithDuration:0.32 animations:^{
        self.backView.alpha = 1;
        self.backControl.alpha = 0.7;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)initFindCarButtonView
{
    chaochu = YES;
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 64)];
    topView.backgroundColor = WhiteColor;
    [self.view addSubview:topView];
    
    topView.alpha = 0.83;
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) - 1, kScreenW, 1)];
    v.backgroundColor = GrayColor;
    [topView addSubview:v];
    
//    [self.daohangBtn addTarget:self action:@selector(daohangBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.daohangBtn];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenW, 40)];
    titleLbl.text = @"行车导航";
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont boldSystemFontOfSize:17];
    [topView addSubview:titleLbl];
    
    UIButton *saverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saverBtn.frame = CGRectMake(kScreenW - 60, 29, 60, 30);
    [saverBtn setImage:[UIImage imageNamed:@"lianxikefu16*17"] forState:UIControlStateNormal];
    [saverBtn addTarget:self action:@selector(callSaver:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:saverBtn];
    
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 140 / 667.f * kScreenH)];
    self.navigationView.backgroundColor = WhiteColor;
    self.navigationView.alpha = 0.83;
    self.navigationView.hidden = YES;
    [self.view addSubview:self.navigationView];
    
    CGFloat speace = 30.f / 667.f * kScreenW;
    CGFloat withLabel = kScreenW - 140 / 667.f * kScreenH;
    
    self.routeDisatanceLbl = [self createLabelFrame:CGRectMake(self.navigationView.bounds.size.height, (140 / 667.f * kScreenH - speace * 3) / 2 - 20, withLabel, speace)];
    _routeDisatanceLbl.text = @"";
    _routeDisatanceLbl.textColor = [UIColor blackColor];
    _routeDisatanceLbl.textAlignment = NSTextAlignmentLeft;
    _routeDisatanceLbl.font = [UIFont systemFontOfSize:17.0];
    [self.navigationView addSubview:_routeDisatanceLbl];
    
    self.turnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 92 / 480.f * kScreenH - 60, 60, 60)];
    self.turnImageView.center = CGPointMake(self.navigationView.bounds.size.height / 2.f, self.navigationView.bounds.size.height / 2.f);
    [self.navigationView addSubview:_turnImageView];
    
    self.currentRoadLbl = [self createLabelFrame:CGRectMake(self.routeDisatanceLbl.frame.origin.x, CGRectGetMaxY(self.routeDisatanceLbl.frame) + 15, withLabel, speace)];
    _currentRoadLbl.font = [UIFont systemFontOfSize:15.0];
    _currentRoadLbl.textAlignment = NSTextAlignmentLeft;
    _currentRoadLbl.textColor = [UIColor blackColor];
    [self.navigationView addSubview:_currentRoadLbl];
    
    self.nextRoadLbl = [self createLabelFrame:CGRectMake(self.routeDisatanceLbl.frame.origin.x, CGRectGetMaxY(self.currentRoadLbl.frame) + 5, withLabel, speace)];
    _nextRoadLbl.font = [UIFont systemFontOfSize:15.0];
    _nextRoadLbl.textAlignment = NSTextAlignmentLeft;
    [self.navigationView addSubview:_nextRoadLbl];
    
    self.chaochuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenH - 124 - 75, kScreenW, 75)];
    self.chaochuLabel.text = @"您已驶出运营区域，超区域费为20元/公里，请您迅速行驶回运营区域。";
    self.chaochuLabel.textColor = RedColor;
    self.chaochuLabel.textAlignment = NSTextAlignmentCenter;
    self.chaochuLabel.backgroundColor = WhiteColor;
    self.chaochuLabel.numberOfLines = 0;
    self.chaochuLabel.font = [UIFont boldSystemFontOfSize:15.f];
    self.chaochuLabel.hidden = YES;
    [self.view addSubview:self.chaochuLabel];
    UIView * vi = [[UIView alloc] initWithFrame:CGRectMake(0, self.chaochuLabel.bounds.size.height - 1, kScreenW, 1)];
    vi.backgroundColor = GrayColor;
    [self.chaochuLabel addSubview:vi];
    
    
    UIButton *shengBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shengBtn.frame = CGRectMake(kScreenW - 46 / 375.f * kScreenW, topView.bottom + 10 / 667.f * kScreenH, 40 / 375.f * kScreenW, 40 / 375.f * kScreenW);
    [shengBtn setImage:[UIImage imageNamed:@"labaguan"] forState:UIControlStateSelected];
    shengBtn.selected = YES;
    NSNumber * ison = [[NSUserDefaults standardUserDefaults] objectForKey:kSoundEffectIsOnKey];
    if (ison && ison.boolValue) {
        shengBtn.selected = NO;
    }
    [shengBtn addTarget:self action:@selector(shengYinKaiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage * img = [UIImage imageNamed:@"laba2"];
    UIImageView *shengimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    shengimage.center = shengBtn.center;
    shengimage.animationImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"laba0"], [UIImage imageNamed:@"laba1"], [UIImage imageNamed:@"laba2"], nil];
    shengimage.animationDuration = 1.5;
    [shengimage startAnimating];
    [self.view addSubview:shengimage];
    [self.view addSubview:shengBtn];
    
    UIButton *yunYingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yunYingBtn.frame = CGRectMake(shengBtn.left, shengBtn.bottom + 10 / 667.f * kScreenH, 40 / 375.f * kScreenW, 50 / 375.f * kScreenW);
    [yunYingBtn setImage:[UIImage imageNamed:@"yunyingqu"] forState:UIControlStateNormal];
    [yunYingBtn addTarget:self action:@selector(showFanWeiQuYuViewClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yunYingBtn];
    
    UIButton *closeCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeCarBtn.frame = CGRectMake(yunYingBtn.left, self.navigationView.bottom + 5 / 667.f * kScreenH, 40 / 375.f * kScreenW, 40 / 375.f * kScreenW);
    [closeCarBtn setImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
    [closeCarBtn addTarget:self action:@selector(daohangBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeCarBtn];
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - 124, kScreenW, 124)];
    bottomView.backgroundColor = WhiteColor;
    UIImageView * boimageview = [[UIImageView alloc] initWithFrame:bottomView.bounds];
    boimageview.image = [UIImage imageNamed:@"375*124"];
    [self.view addSubview:bottomView];
    [bottomView addSubview:boimageview];
    self.bottomViews = bottomView;

    NSString * str = @"本次费用为";
    CGSize size = [str boundingRectWithSize:CGSizeMake(0, 49) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.f]} context:nil].size;
    UILabel * nomelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 49)];
    nomelLabel.font = [UIFont systemFontOfSize:14.f];
//    nomelLabel.text = str;
    self.benciLabel = nomelLabel;
    
    NSString * str1 = @"0.00";
    CGSize size1 = [str1 boundingRectWithSize:CGSizeMake(0, 45) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.f]} context:nil].size;
    self.jifeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nomelLabel.frame), 0, size1.width, 45)];
    self.jifeiLabel.textColor = RedColor;
//    self.jifeiLabel.text = str1;
    self.jifeiLabel.font = [UIFont systemFontOfSize:20.f];
    
    NSString * str2 = @"元";
    CGSize size2 = [str2 boundingRectWithSize:CGSizeMake(0, 49) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.f]} context:nil].size;
    self.yuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.jifeiLabel.frame), 0, size2.width, 49)];
//    self.yuanLabel.text = str2;
    self.yuanLabel.font = [UIFont systemFontOfSize:14.f];
    
    UIView * jifeiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, nomelLabel.bounds.size.width + self.jifeiLabel.bounds.size.width + self.yuanLabel.bounds.size.width, 49)];
    self.jifeiViewq = jifeiView;
    
    [jifeiView addSubview:nomelLabel];
    [jifeiView addSubview:self.jifeiLabel];
    [jifeiView addSubview:self.yuanLabel];
    jifeiView.center = CGPointMake(kScreenW / 2.f, 49.f / 2.f);
    [bottomView addSubview:jifeiView];
    
    self.priceMingxiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, kScreenW, 40)];
    self.priceMingxiLabel.font = [UIFont systemFontOfSize:12.f];
    self.priceMingxiLabel.numberOfLines = 0;
    self.priceMingxiLabel.textColor = GrayColor;
    self.priceMingxiLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:self.priceMingxiLabel];
    
    UIView * bView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - 50, kScreenW, 50)];
    UIImageView * bimageview = [[UIImageView alloc] initWithFrame:bView.bounds];
    bimageview.image = [UIImage imageNamed:@"yongkuangdaohangkuang375*50"];
    [bView addSubview:bimageview];
    [self.view addSubview:bView];
    
    UIButton * jieshuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jieshuButton.frame = CGRectMake(0, 0, bottomView.bounds.size.width / 3.f, 49);
    [jieshuButton setImage:[UIImage imageNamed:@"jieshudingdan60*40"] forState:UIControlStateNormal];
    [jieshuButton addTarget:self action:@selector(jiesshubackClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bView addSubview:jieshuButton];
    
    UIButton * kaisuoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    kaisuoBtn.frame = CGRectMake(bottomView.bounds.size.width / 3.f, 0, bottomView.bounds.size.width / 3.f, 49);
    [kaisuoBtn setImage:[UIImage imageNamed:@"kaisuo60*40"] forState:UIControlStateNormal];
    [kaisuoBtn addTarget:self action:@selector(EcarKaiSouClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bView addSubview:kaisuoBtn];
    
    UIButton * guansuoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    guansuoBtn.frame = CGRectMake(bottomView.bounds.size.width / 3.f * 2.f, 0, bottomView.bounds.size.width / 3.f, 49);
    [guansuoBtn setImage:[UIImage imageNamed:@"guansuo60*40"] forState:UIControlStateNormal];
    [guansuoBtn addTarget:self action:@selector(EcarGuanSuoClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bView addSubview:guansuoBtn];
    
    ECarConfigs * conf = [ECarConfigs shareInstance];
    conf.chaochufanwei = 0;
//    weak_Self(self);
//    [[self.manager getMoneyPrice:conf.orignOrderNo] subscribeNext:^(id x) {
//        NSDictionary * dic = x;
//        NSString * str = [NSString stringWithFormat:@"%@", dic[@"phoneMsg"]];
//        if (str.integerValue == 2) {
//            if (chaochu) {
//                weakSelf.chaochuLabel.hidden = NO;
//                [weakSelf fanweiyujing];
//                chaochu = NO;
//            }
//        } else {
//            weakSelf.chaochuLabel.hidden = YES;
//            chaochu = YES;
//        }
//        NSDictionary * obj = dic[@"obj"];
//        NSString * price = [NSString stringWithFormat:@"%@", obj[@"price"]];
//        conf.currentPrice = price;
//        NSString * feiyong = [NSString stringWithFormat:@"%.2lf", price.doubleValue];
//        
//        NSString * qibujia = [NSString stringWithFormat:@"%@", obj[@"qibujia"]];
//        NSString *lichengfei = [NSString stringWithFormat:@"%@", obj[@"lichengfei"]];
//        NSString * disufei = [NSString stringWithFormat:@"%@", obj[@"disufei"]];
//        NSString * fanweiWai = [NSString stringWithFormat:@"%@", obj[@"fanweiwai"]];
//        NSString * prStr = nil;
//        if ([qibujia doubleValue] > 0.001) {
//            prStr = [NSString stringWithFormat:@"起步价%@元", qibujia];
//        }
//        if ([lichengfei doubleValue] > 0.001) {
//            if (prStr) {
//                prStr = [NSString stringWithFormat:@"%@+里程费%@元", prStr, lichengfei];
//            } else {
//                prStr = [NSString stringWithFormat:@"里程费%@元", lichengfei];
//            }
//        }
//        if ([disufei doubleValue] > 0.001) {
//            if (prStr) {
//                prStr = [NSString stringWithFormat:@"%@+低速费%@元", prStr, disufei];
//            } else {
//                prStr = [NSString stringWithFormat:@"低速费%@元", disufei];
//            }
//        }
//        if (prStr) {
//            prStr = [NSString stringWithFormat:@"%@+超区域费%@元", prStr, fanweiWai];
//        } else {
//            prStr = [NSString stringWithFormat:@"超区域费%@元", fanweiWai];
//        }
//        weakSelf.priceMingxiLabel.text = prStr;
//        CGSize size = [feiyong boundingRectWithSize:CGSizeMake(0, 49) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.f]} context:nil].size;
//        weakSelf.jifeiLabel.frame = CGRectMake(weakSelf.jifeiLabel.frame.origin.x, weakSelf.jifeiLabel.frame.origin.y, size.width, 49);
//        weakSelf.jifeiLabel.text = feiyong;
//        
//        weakSelf.yuanLabel.frame = CGRectMake(CGRectGetMaxX(self.jifeiLabel.frame), 0, self.yuanLabel.bounds.size.width, 49);
//    } completed:^{
//        
//    }];
    weak_Self(self);
    [[self.manager getMoneyPrice:conf.orignOrderNo] subscribeNext:^(id x) {
        NSDictionary * dic = x;
        NSDictionary * obj = dic[@"obj"];
        NSString * price = [NSString stringWithFormat:@"%@", obj[@"price"]];
        NSString * feiyong = [NSString stringWithFormat:@"%.2lf", price.doubleValue];
        
        NSString * qibujia = [NSString stringWithFormat:@"%@", obj[@"qibujia"]];
        NSString *lichengfei = [NSString stringWithFormat:@"%@", obj[@"lichengfei"]];
        NSString * disufei = [NSString stringWithFormat:@"%@", obj[@"disufei"]];
        NSString * fanweiWai = [NSString stringWithFormat:@"%@", obj[@"fanweiwai"]];
        NSString * prStr = nil;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        if (qibujia.floatValue > 0.001) {
            [array addObject:[NSString stringWithFormat:@"起步价%@元", qibujia]];
        }
        if (lichengfei.floatValue > 0.001) {
            [array addObject:[NSString stringWithFormat:@"里程费%@元", lichengfei]];
        }
        if (disufei.floatValue > 0.001) {
            [array addObject:[NSString stringWithFormat:@"低速费%@元", disufei]];
        }
        [array addObject:[NSString stringWithFormat:@"超区域费%@元", fanweiWai]];
        prStr = [array componentsJoinedByString:@"+"];
        
        NSDictionary * attribute = dic[@"attributes"];
        NSString * isVIP = [NSString stringWithFormat:@"%@", attribute[@"isvip"]];
        weakSelf.priceMingxiLabel.text = prStr;
        weakSelf.benciLabel.text = @"本次费用为";
        CGSize size = [feiyong boundingRectWithSize:CGSizeMake(0, 49) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.f]} context:nil].size;
        weakSelf.jifeiLabel.frame = CGRectMake(weakSelf.jifeiLabel.frame.origin.x, weakSelf.jifeiLabel.frame.origin.y, size.width, 49);
        weakSelf.jifeiLabel.text = feiyong;
        
        weakSelf.yuanLabel.frame = CGRectMake(CGRectGetMaxX(self.jifeiLabel.frame), 0, self.yuanLabel.bounds.size.width, 49);
        weakSelf.yuanLabel.text = @"元";
        if (isVIP.boolValue == YES) {
            weakSelf.priceMingxiLabel.hidden = YES;
            weakSelf.benciLabel.text = @"超区域费为";
            weakSelf.jifeiViewq.frame = CGRectMake(weakSelf.jifeiViewq.frame.origin.x, weakSelf.jifeiViewq.frame.origin.y + 10, weakSelf.jifeiViewq.frame.size.width, weakSelf.jifeiViewq.frame.size.height);
        }
    } completed:^{
        
    }];
    
    [self initYunYingFanWeiView];
    
    [NSTimer scheduledTimerWithTimeInterval:6.f target:self selector:@selector(countMoneyPrice) userInfo:nil repeats:YES];
}

- (void)shengYinKaiBtnClicked:(UIButton *)sender
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@(sender.isSelected) forKey:kSoundEffectIsOnKey];
    [userDefaults synchronize];
    sender.selected = !sender.selected;
    if (!sender.isSelected) {
        if ([self.drivingDelegate respondsToSelector:@selector(startSpeekingRoadInfo)]) {
            [self.drivingDelegate startSpeekingRoadInfo];
        }
    } else {
        if ([self.drivingDelegate respondsToSelector:@selector(stopSpeekingRoadInfo)]) {
            [self.drivingDelegate stopSpeekingRoadInfo];
        }
    }
}

- (void)daohangBtnClicked
{
    self.isCarLock = YES;
}

- (void)countMoneyPrice
{
    weak_Self(self);
    ECarConfigs * conf = [ECarConfigs shareInstance];
    if (indexee == 4 && conf.jinruZhuangTai != 10) {
        [[self.manager panduanDoorIsOpen:conf.orignOrderNo] subscribeNext:^(id x) {
            NSDictionary * dic = x;
            NSString * successe = [NSString stringWithFormat:@"%@", dic[@"success"]];
            if (successe.integerValue == 0) {
                UIAlertView *oponDoor = [[UIAlertView alloc] initWithTitle:@"您已超时" message:@"车门已自动上锁" delegate:weakSelf cancelButtonTitle:@"结束用车" otherButtonTitles:@"开锁", nil];
                oponDoor.tag = AlertTypeEndDoorOpen;
                [oponDoor show];
            }
        } error:^(NSError *error) {
            
        } completed:^{
            
        }];
    } else if (indexee == 9){
        [[self.manager panduanDoorIsOpen:conf.orignOrderNo] subscribeNext:^(id x) {
            NSDictionary * dic = x;
            NSString * successe = [NSString stringWithFormat:@"%@", dic[@"success"]];
            if (successe.integerValue == 0) {
                UIAlertView *oponDoor = [[UIAlertView alloc] initWithTitle:@"您已超时" message:@"车门已自动上锁" delegate:weakSelf cancelButtonTitle:@"结束用车" otherButtonTitles:nil, nil];
                oponDoor.tag = AlertTypeEndDoorOpen;
                [oponDoor show];
            }
        } error:^(NSError *error) {
            
        } completed:^{
            
        }];
    }
    [[self.manager getMoneyPrice:conf.orignOrderNo] subscribeNext:^(id x) {
        NSDictionary * dic = x;
        NSString * str = [NSString stringWithFormat:@"%@", dic[@"phoneMsg"]];
        if (str.integerValue == 2) {
            if (chaochu) {
                weakSelf.chaochuLabel.hidden = NO;
                [weakSelf fanweiyujing];
                chaochu = NO;
            }
        } else {
            weakSelf.chaochuLabel.hidden = YES;
            chaochu = YES;
        }
        NSDictionary * obj = dic[@"obj"];
        NSString * price = [NSString stringWithFormat:@"%@", obj[@"price"]];
        NSString * feiyong = [NSString stringWithFormat:@"%.2lf", price.doubleValue];
        
        NSString * qibujia = [NSString stringWithFormat:@"%@", obj[@"qibujia"]];
        NSString *lichengfei = [NSString stringWithFormat:@"%@", obj[@"lichengfei"]];
        NSString * disufei = [NSString stringWithFormat:@"%@", obj[@"disufei"]];
        NSString * fanweiWai = [NSString stringWithFormat:@"%@", obj[@"fanweiwai"]];
        NSString * prStr = nil;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        if (qibujia.floatValue > 0.001) {
            [array addObject:[NSString stringWithFormat:@"起步价%@元", qibujia]];
        }
        if (lichengfei.floatValue > 0.001) {
            [array addObject:[NSString stringWithFormat:@"里程费%@元", lichengfei]];
        }
        if (disufei.floatValue > 0.001) {
            [array addObject:[NSString stringWithFormat:@"低速费%@元", disufei]];
        }
        [array addObject:[NSString stringWithFormat:@"超区域费%@元", fanweiWai]];
        prStr = [array componentsJoinedByString:@"+"];
        NSDictionary * attribute = dic[@"attributes"];
        NSString * isVIP = [NSString stringWithFormat:@"%@", attribute[@"isvip"]];
        weakSelf.priceMingxiLabel.text = prStr;
        weakSelf.benciLabel.text = @"本次费用为";
        CGSize size = [feiyong boundingRectWithSize:CGSizeMake(0, 49) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.f]} context:nil].size;
        weakSelf.jifeiLabel.frame = CGRectMake(weakSelf.jifeiLabel.frame.origin.x, weakSelf.jifeiLabel.frame.origin.y, size.width, 49);
        weakSelf.jifeiLabel.text = feiyong;
        
        weakSelf.yuanLabel.frame = CGRectMake(CGRectGetMaxX(self.jifeiLabel.frame), 0, self.yuanLabel.bounds.size.width, 49);
        weakSelf.yuanLabel.text = @"元";
        if (isVIP.boolValue == YES) {
            weakSelf.priceMingxiLabel.hidden = YES;
            weakSelf.benciLabel.text = @"超区域费为";
        }
    } completed:^{
        
    }];
    indexee ++;
}

#pragma mark - 按钮响应事件
- (void)EcarKaiSouClicked:(UIButton *)sender
{
    
    if (self.lanya.lanYaStatus == YES) {
        [self delayHidHUD:@"开锁"];
        [self openLockClicked];
        return;
    }
    [self showHUD:@"开锁"];
    weak_Self(self);
    [[self.manager useCarOpenDoorWith:[ECarConfigs shareInstance].orignOrderNo] subscribeNext:^(id x) {
        NSDictionary * dic = x;
        [weakSelf hideHUD];
        NSNumber * success = dic[@"success"];
        if (success.integerValue == 0) {
            NSString * msg = dic[@"msg"];
            [weakSelf delayHidHUD:msg];
            return;
        }
        [weakSelf delayHidHUD:@"开锁成功"];
    } error:^(NSError *error) {
        [weakSelf hideHUD];
        [weakSelf delayHidHUD:MESSAGE_NoNetwork];
    }];
}

- (void)errorLanYa
{
    [self hideHUD];
    if (_clicked == NO) {
        return;
    }
    _clicked = NO;
    self.carLockSendStates = CarLockSendStatesDefault;
}

- (void)EcarGuanSuoClicked:(UIButton *)sender
{
    
    if (self.lanya.lanYaStatus == YES) {
        [self delayHidHUD:@"关锁"];
        [self closeLockClicked];
        return;
    }
    [self showHUD:@"关锁"];
    weak_Self(self);
    [[self.manager useCarCloseDoorWith:[ECarConfigs shareInstance].orignOrderNo] subscribeNext:^(id x) {
        NSDictionary * dic = x;
        [weakSelf hideHUD];
        NSNumber * success = dic[@"success"];
        if (success.integerValue == 0) {
            NSString * msg = dic[@"msg"];
            [weakSelf delayHidHUD:msg];
            return;
        }
        [weakSelf delayHidHUD:@"车锁已关"];
    } error:^(NSError *error) {
        [weakSelf hideHUD];
        [weakSelf delayHidHUD:MESSAGE_NoNetwork];
    }];
}

- (void)jiesshubackClicked:(UIButton *)sender
{
    [self endUseCar];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _showImageView;
}

#pragma mark  结束用车
- (void)endUseCar
{
    // 判断引擎状态
    weak_Self(self);
    NSString *msg = @"";
    msg = @"请确认是否要结束用车";
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"结束使用" message:msg delegate:weakSelf cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alertV.tag = AlertTypeEndEngineClosed;
    [alertV show];
}

- (void)endOrder:(BOOL)engine
{
    if (engine) {
        return;
    }
    weak_Self(self);
    [self showHUD:@"正在结算"];
    ECarConfigs * confige = [ECarConfigs shareInstance];
    [[self.manager endOrderNo:confige.orignOrderNo] subscribeNext:^(id x) {
        [weakSelf hideHUD];
        NSDictionary * dic = x;
        NSString * seccse = [NSString stringWithFormat:@"%@", dic[@"success"]];
        if (seccse.integerValue == 0) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"msg"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            NSString * obj = [NSString stringWithFormat:@"%@", dic[@"obj"]];
            confige.currentPrice = obj;
            UIAlertView * alert  = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您下车并关好车门，一分钟后车门自动关锁" delegate:weakSelf cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alert.tag = 2434;
            [alert show];
        }
    } error:^(NSError *error) {
        [weakSelf hideHUD];
        [weakSelf delayHidHUD:@"网络异常，结束用车失败"];
    }];
}

- (void)callSaver:(UIButton *)sender
{
    UIAlertView *serviceAlert = [[UIAlertView alloc] initWithTitle:@"联系客服" message:@"400-6507265" delegate:self cancelButtonTitle:@"呼叫" otherButtonTitles:@"取消", nil];
    serviceAlert.tag = 400;
    [serviceAlert show];
}

#pragma mark - 蓝牙代理实现
// 蓝牙是否打开
- (void)LanYaIsOpen:(BOOL)isOpen
{
    [self hideHUD];
    if (isOpen == YES) {
        if (_isFirst == YES) {
            _isFirst = NO;
            [self.lanya resameCanse];
        }
    }
}

// 是否发现指定蓝牙设备
- (void)LanYaFindDiverceNameIsSuccess:(BOOL)isSuccess
{
    if (!_isFirst && isSuccess) {
        _isFirst = YES;
        [self.lanya linkLanYaDiverceBeginWithServiceName:@"FF00" writeCharacteristice:@"FF01" andNotifyCharacteristice:@"FF02"];
    } else {
        _isFirst = NO;
    }
}

- (void)LanYaXinHaoQiangDu:(NSNumber *)xinC
{
//    float power = (abs(xinC.intValue) - 80) / (10 * 2.0);
//    float poww = pow(10, power);
//
//    [self.daohangBtn setTitle:[NSString stringWithFormat:@"%.2f米", poww] forState:UIControlStateNormal];
}

// 指定蓝牙设备是否连接成功
- (void)LanYaLianJieIsSuccess:(BOOL)isSuccess
{
    if (isSuccess) {
        [self hideHUD];
//        [self delayHidHUD:@"蓝牙连接成功"];
    } else {
//        [self delayHidHUD:@"蓝牙连接失败，正在重新连接"];
        _isFirst = NO;
        [self.lanya resameCanse];
    }
}

// 接收到数据
- (void)LanYaReceiveMessegeData:(NSData *)data
{
    if (self.clicked == NO) {
        return;
    }
    self.clicked = NO;
    [self hideHUD];
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (str.length != 6) {
        return;
    }
    if ([str isEqualToString:@"111222"]) {
        //        [self delayHidHUD:@"链接异常，请重新操作"];
        [self.lanya deallocSharedLanYa];
        if (self.carLockSendStates == CarLockSendStatesOpen) {
            [self EcarKaiSouClicked:nil];
        } else if (self.carLockSendStates == CarLockSendStatesClose) {
            [self EcarGuanSuoClicked:nil];
        }
        if (!self.carInfo.lanYaName) {
            return;
        }
        [self.lanya beginBlueToothWithDiverceName:self.carInfo.lanYaName];
        return;
    }
//    int count = 0;
//    int zhiding = 0;
//    if ([str characterAtIndex:0] - 48 == 1) {
//        count ++;
//        zhiding = 1;
//    }
//    if ([str characterAtIndex:1] - 48 == 1) {
//        count ++;
//        zhiding = 2;
//    }
//    if ([str characterAtIndex:2] - 48 == 1) {
//        count ++;
//        zhiding = 3;
//    }
//    if ([str characterAtIndex:3] - 48 == 1) {
//        count ++;
//        zhiding = 4;
//    }
//    if ([str characterAtIndex:4] - 48 == 1) {
//        count ++;
//        zhiding = 5;
//    }
//    if (count > 1) {
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请将车门关好再关闭车锁。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//        return;
//    } else if (zhiding > 0) {
//        NSArray * array = @[@"右前门", @"右后门", @"左前门", @"左后门", @"后备箱"];
//        NSString * meg = [NSString stringWithFormat:@"%@没有关好，请重新关闭车门再关闭车锁。", array[zhiding - 1]];
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:meg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//        return;
//    }
//    if ([str characterAtIndex:5] - 48 == 1 && self.carLockSendStates == CarLockSendStatesOpen) {
//        [self delayHidHUD:@"中控开启"];
//        self.carLockSendStates = CarLockSendStatesDefault;
//    } else if ([str characterAtIndex:5] - 48 == 0 && self.carLockSendStates == CarLockSendStatesClose) {
//        [self delayHidHUD:@"中控关闭"];
//        self.carLockSendStates = CarLockSendStatesDefault;
//    }
}

- (void)openLockClicked {
    _clicked = YES;
    self.carLockSendStates = CarLockSendStatesOpen;
    NSString * str = [NSString stringWithFormat:@"%@%@%@", self.carInfo.lanYaPassWord, kOpenLock, kEndCode];
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self.lanya sendMessegeWithData:data];
}

- (void)closeLockClicked {
    _clicked = YES;
    self.carLockSendStates = CarLockSendStatesClose;
    NSString * str = [NSString stringWithFormat:@"%@%@%@", self.carInfo.lanYaPassWord, kCloseLock, kEndCode];
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self.lanya sendMessegeWithData:data];
}

- (void)openLampClicked {
    NSString * str = [NSString stringWithFormat:@"%@%@%@", self.carInfo.lanYaPassWord, kOpenLamp, kEndCode];
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self.lanya sendMessegeWithData:data];
}

- (void)closeLampClicked {
    NSString * str = [NSString stringWithFormat:@"%@%@%@", self.carInfo.lanYaPassWord, kCloseLamp, kEndCode];
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self.lanya sendMessegeWithData:data];
}

#pragma mark  － 范围预警语音
- (void)fanweiyujing{
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"561f5c54"];
    [IFlySpeechUtility createUtility:initString];
    // 创建合成对象，为单例模式
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    //设置语音合成的参数
    // 语速,取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50" forKey:@"speed"];
    // 音量;取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50" forKey: @"volume"];
    // 发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表
    [_iFlySpeechSynthesizer setParameter:@" xiaoyan " forKey: @"voice_name"];
    // 音频采样率,目前支持的采样率有 16000 和 8000
    [_iFlySpeechSynthesizer setParameter:@"8000" forKey: @"sample_rate"];
    // asr_audio_path保存录音文件路径，如不再需要，设置value为nil表示取消，默认目录是documents
    [_iFlySpeechSynthesizer setParameter:@" tts.pcm" forKey: @"tts_audio_path"];
    // 启动合成会话
    [_iFlySpeechSynthesizer startSpeaking: @"您已驶出运营区域，超区域费为二十元每公里，请您迅速行驶回运营区域。"];
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AlertTypeEndEngineOpen) {
        if (buttonIndex == 0) {
            [self endOrder:YES];
            return;
        }
    } else if (alertView.tag == AlertTypeEndEngineClosed) {
        if (buttonIndex == 0) {
            [self endOrder:NO];
        }
    } else if (alertView.tag == 400) {
        if (buttonIndex == 0) {
            [ToolKit callTelephoneNumber:@"400-6507265" addView:self.view];
        }
    } else if (alertView.tag == AlertTypeEndDoorOpen)
    {
        if (buttonIndex == 0) {
            ECarConfigs * conf = [ECarConfigs shareInstance];
            conf.currentPrice = @"0";
            [self endOrder:NO];
        } else {
            
        }
    } else if (alertView.tag == 2434)
    {
        [ECarConfigs shareInstance].exitTag = ExitNaviTagEnd;
        
        [self back];
    }
}

- (void)back
{
    [self.lanya deallocSharedLanYa];
    [self hideHUD];
    [self.delegate naviViewControllerCloseButtonClicked:self];
}
- (UIButton *)createButtonFrame:(CGRect)frame title:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setFrame:frame];
    return btn;
}
- (UILabel *)createLabelFrame:(CGRect)frame
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
    lbl.backgroundColor = ClearColor;
    lbl.textAlignment = 1;
    lbl.textColor = [UIColor blackColor];
    return lbl;
}

#pragma mark ---HUD
- (void)showHUD:(NSString *)text
{
    if (!self.hud) {
        self.hud = [[MBProgressHUD alloc] initWithView:self.view];
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
    [_hud hide:YES afterDelay:2];
}

#pragma mark --- 延时
- (void)delay:(float)second excutive:(void(^)())block
{
    self.delayBlock = block;
    [self performSelector:@selector(excutive) withObject:nil afterDelay:second];
}

- (void)excutive
{
    if (self.delayBlock) {
        self.delayBlock();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
