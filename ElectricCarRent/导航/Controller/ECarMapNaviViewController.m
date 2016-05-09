//
//  ECarMapNaviViewController.h
//  ElectricCarRent
//
//  Created by 彭懂 on 15/11/8.
//  Copyright © 2015年 彭懂. All rights reserved.
//

#import "ECarMapNaviViewController.h"
#import "AMapSearchManager.h"
#import "ECarMapManager.h"
#import "MBProgressHUD.h"
#import "PDTimerProgressView.h"
#import "PDLanYaLianJie.h"

#import "UIKit+AFNetworking.h"
#import "ECarZhiFuViewController.h"
#define FindTimeCheck   300    //300s 找不到按钮有效

typedef NS_ENUM(NSInteger, TagAlert)
{
    TagAlertFindout = 1001, /**<找不到*/
    TagAlertFinded,   /**<找到*/
    TagAlertService,    /**<客服*/
    TagAlertTimeOut,    /**<超时*/
    TagAlertDelay,  /**<延时*/
    TagAlertCancelOrder,    /**<取消订单*/
    TagAlertOpenFloor,
};

typedef enum : NSUInteger {
    BottomButtonisClickedYES = 300,
    BottomButtonisClickedNO
} BottomButtonisClickedType;

@interface ECarMapNaviViewController ()<UIAlertViewDelegate, PDLanYaLianJieDelegate, UIScrollViewDelegate>
/**
 *  导航路况信息
 */
@property (strong, nonatomic) UIImageView *turnImageView;
@property (strong, nonatomic) UILabel *routeDisatanceLbl;
@property (strong, nonatomic) UILabel *currentRoadLbl;
@property (strong, nonatomic) UILabel *nextRoadLbl;
@property (assign, nonatomic) CLLocationCoordinate2D orignLocation; /**<导航开始的原始位置*/
@property (assign, nonatomic) BOOL alertDelayFindCar;
@property (assign, nonatomic) __block float percent;
@property (strong, nonatomic) ECarMapManager *manager;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) PDTimerProgressView * progressView;

@property (assign, nonatomic) NSInteger  openCarDistance;
@property (assign, nonatomic) BOOL clicked;
@property (strong, nonatomic) UIControl *backControl;
@property (strong, nonatomic) UIView *backView;

/**
 *  下方按钮
 */
@property (strong, nonatomic) UIButton * openClockButton;
@property (strong, nonatomic) UIButton * whistleButton;
@property (strong, nonatomic) UIButton * modelButton;
@property (strong, nonatomic) UIView * navigationView;
@property (nonatomic, assign) CGRect modelButtonFrame;

typedef void(^DelayBlock)();
@property (strong, nonatomic) DelayBlock delayBlock;
@property (strong, nonatomic) UILabel *distanceLbl;
@property (assign, nonatomic) BOOL mimCloseDoor;
@property (strong, nonatomic) NSTimer * daojishiTimer;

//@property (strong, nonatomic) ECarZhiFuViewController * zhifu;


@property (nonatomic, strong) PDLanYaLianJie * lanya;
@property (assign, nonatomic) BOOL isFirst;

@property (nonatomic, strong) UIButton *daohangBtn;
@property (nonatomic, strong) UIImageView *showImageView;

@end

@implementation ECarMapNaviViewController
- (void)dealloc
{
    self.delegate = nil;
    [self.daojishiTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 懒加载

- (ECarMapManager *)manager
{
    if (!_manager) {
        _manager = [[ECarMapManager alloc] init];
    }
    return _manager;
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

- (PDTimerProgressView *)progressView
{
    if (!_progressView) {
        NSString * str = @"请在00:00分钟内找车(京N122222)";
        
        CGSize size = [str boundingRectWithSize:CGSizeMake(0, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.f]} context:nil].size;
        _progressView = [[PDTimerProgressView alloc] initWithFrame:CGRectMake(0, 0, size.width, 30) andCountMiao:30 andCarNo:self.carInfo.carno];
    }
    return _progressView;
}

- (UIButton *)openClockButton
{
    if (!_openClockButton) {
        _openClockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _openClockButton.frame = CGRectMake(kScreenW / 2.f, 49, kScreenW / 2.f, 49);
        [_openClockButton setTitle:@"开锁" forState:UIControlStateNormal];
        _openClockButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _openClockButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _openClockButton;
}

- (UIButton *)whistleButton
{
    if (!_whistleButton) {
        _whistleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _whistleButton.frame = CGRectMake(0, 49, kScreenW / 2.f, 49);
        [_whistleButton setTitle:@"双闪" forState:UIControlStateNormal];
        _whistleButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _whistleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _whistleButton;
}

/**
 *  状态栏控制
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - 类的入口函数
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _clicked = NO;
    self.percent = 1.0;
    self.mimCloseDoor = NO;
    
//    CLLocationCoordinate2D amapCoord = MACoordinateConvert(CLLocationCoordinate2DMake(39.989612,116.480972), macoordinatety)
    
    [self getOpenCarDistance];
}

- (void)checkLanYa
{
    if (!self.carInfo.lanYaName) {
        return;
    }
    self.isFirst = NO;
    self.lanya = [PDLanYaLianJie shareInstance];
    self.lanya.pdDelegate = self;
//    self.carInfo.lanYaName = @"EZZY_CAR100011";
    if (!self.lanya.lanYaStatus) {
        [self.lanya beginBlueToothWithDiverceName:self.carInfo.lanYaName];
    } else {
        [self.lanya deallocSharedLanYa];
        [self.lanya beginBlueToothWithDiverceName:self.carInfo.lanYaName];
    }
}

- (void)stopHud
{
    [self delayHidHUD:@"连接超时"];
}

- (void)getOpenCarDistance{
    [[self.manager getOpenCarDistanceBetweenPersonAndCar] subscribeNext:^(id x) {
        NSDictionary * dic = x;
        _openCarDistance = [dic[@"phoneMsg"] integerValue];
    }];
}

- (instancetype)initWithDelegate:(id<AMapNaviViewControllerDelegate>)delegate
{
    if (self = [super initWithDelegate:delegate]) {
        // 导航转向信息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waldingupdateTurnInfo:) name:@"UpdateAMapNaviInfo" object:nil];
    }
    return self;
}

- (void)waldingupdateTurnInfo:(NSNotification *)notification
{
    self.navigationView.hidden = NO;
    AMapNaviInfo *naviInfo = [notification object];
    int iconType = naviInfo.iconType;
    NSString *pngName = [NSString stringWithFormat:@"ecar_navi_action_%d.png",iconType];
    self.turnImageView.image = [UIImage imageNamed:pngName];
    self.currentRoadLbl.text = [NSString stringWithFormat:@"从 %@ 进入",naviInfo.currentRoadName];
    self.nextRoadLbl.text = naviInfo.nextRoadName;
    self.routeDisatanceLbl.text = [NSString stringWithFormat:@"%zd米后",naviInfo.segmentRemainDistance];
    [ECarConfigs shareInstance].userCoordinate = CLLocationCoordinate2DMake(naviInfo.carCoordinate.latitude, naviInfo.carCoordinate.longitude);
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

#pragma mark - 初始化UI
- (void)initFindCarButtonView
{
    [self setStartPointImage:nil];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 64)];
    topView.backgroundColor = WhiteColor;
    [self.view addSubview:topView];
    
    topView.alpha = 0.83;
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) - 1, kScreenW, 1)];
    v.backgroundColor = GrayColor;
    [topView addSubview:v];
//    
//    [self.daohangBtn addTarget:self action:@selector(daohangBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.daohangBtn];
//    self.daohangBtn.hidden = YES;
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenW, 40)];
    titleLbl.text = @"找车导航";
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont boldSystemFontOfSize:17];
    [topView addSubview:titleLbl];
    
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
    self.navigationView.hidden = YES;
    [self.navigationView addSubview:_turnImageView];
    
    self.currentRoadLbl = [self createLabelFrame:CGRectMake(self.routeDisatanceLbl.frame.origin.x, CGRectGetMaxY(self.routeDisatanceLbl.frame) + 15, withLabel, speace)];
    _currentRoadLbl.font = [UIFont systemFontOfSize:15.0];
    _currentRoadLbl.textAlignment = NSTextAlignmentLeft;
    _currentRoadLbl.textColor = [UIColor blackColor];
    [self.navigationView addSubview:_currentRoadLbl];
    
    self.nextRoadLbl = [self createLabelFrame:CGRectMake(self.routeDisatanceLbl.frame.origin.x, CGRectGetMaxY(self.currentRoadLbl.frame) + 5, withLabel, speace)];
    self.nextRoadLbl.textColor = [UIColor blackColor];
    _nextRoadLbl.font = [UIFont systemFontOfSize:15.0];
    _nextRoadLbl.textAlignment = NSTextAlignmentLeft;
    [self.navigationView addSubview:_nextRoadLbl];
    
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
    
    UIButton *cancelBtn = [self createButtonFrame:CGRectMake(15, 29, 60, 30) title:@"取消订单"];
    [cancelBtn addTarget:self action:@selector(cancelOrderClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:RedColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [topView addSubview:cancelBtn];
    
    UIButton *saverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saverBtn.frame = CGRectMake(kScreenW - 60, 29, 60, 30);
    [saverBtn setImage:[UIImage imageNamed:@"lianxikefu16*17"] forState:UIControlStateNormal];
    [saverBtn addTarget:self action:@selector(callSaver:) forControlEvents:UIControlEventTouchUpInside];
    saverBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [topView addSubview:saverBtn];
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - 98, kScreenW, 98)];
    bottomView.backgroundColor = WhiteColor;
    UIImageView * boimageview = [[UIImageView alloc] initWithFrame:bottomView.bounds];
    boimageview.image = [UIImage imageNamed:@"zhaoche375*99"];
    [self.view addSubview:bottomView];
    [bottomView addSubview:boimageview];
    
    self.progressView.center = CGPointMake(kScreenW / 2.f, 24);
    [bottomView addSubview:self.progressView];
    self.progressView.progressTimer = 0;
    
    [self.openClockButton addTarget:self action:@selector(openClockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setSelected:NO andButton:self.openClockButton];
    [bottomView addSubview:self.openClockButton];
    
    [self.whistleButton addTarget:self action:@selector(whistleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setSelected:NO andButton:self.whistleButton];
    [bottomView addSubview:self.whistleButton];
    
    
    self.daojishiTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerDaoJiShi) userInfo:nil repeats:YES];
    [self.daojishiTimer fire];
    
    [self initYunYingFanWeiView];
    
    /*
     // 找车倒计时
     UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 8)];
     image.image = [UIImage imageNamed:@"jingdutiaobaikuang375*6"];
     [self.view addSubview:image];
     
     self.processView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
     [self.processView setFrame:CGRectMake(3, 67, ScreenWidth - 4, 30)];
     self.processView.progress = 1.0;
     self.processView.trackTintColor = [UIColor colorWithRed:46/255.0 green:45/255.0 blue:52/255.0 alpha:1.0];
     self.processView.progressTintColor = [UIColor colorWithRed:224 / 255.f green:54 / 255.f blue:134 / 255.f alpha:1];
     [self.view addSubview:self.processView];
     */
    
}

- (void)shengYinKaiBtnClicked:(UIButton *)sender
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@(sender.isSelected) forKey:kSoundEffectIsOnKey];
    [userDefaults synchronize];
    sender.selected = !sender.selected;
    if (!sender.isSelected) {
        if ([self.mapNaviDelegate respondsToSelector:@selector(startSpeekingRoadInfo)]) {
            [self.mapNaviDelegate startSpeekingRoadInfo];
        }
    } else {
        if ([self.mapNaviDelegate respondsToSelector:@selector(stopSpeekingRoadInfo)]) {
            [self.mapNaviDelegate stopSpeekingRoadInfo];
        }
    }
}

- (void)daohangBtnClicked
{
    self.isCarLock = YES;
}

- (void)timerDaoJiShi
{
    weak_Self(self);
    static float useTime = 3;
    self.daojimiao ++;
    self.progressView.progressTimer = self.daojimiao;
    self.progressView.carno = self.carInfo.carno;
    weakSelf.percent = 1.0 - self.daojimiao / (30.f * 60.f);
    useTime += 1;
    // 倒计时结束
    if (weakSelf.percent <= 0) {
        [weakSelf.daojishiTimer invalidate];
        UIAlertView *timeOutAlert = [[UIAlertView alloc] initWithTitle:@"找车超时" message:@"请重新选车" delegate:weakSelf cancelButtonTitle:@"确认" otherButtonTitles:nil];
        timeOutAlert.tag = TagAlertTimeOut;
        [timeOutAlert show];
        return;
    }
    if (useTime >= 6.0) {
        // 每10s更新一次位置
        useTime = 0;
        [weakSelf updateDistanceWithin20m:^{
            [weakSelf setSelected:YES andButton:weakSelf.whistleButton];
            [weakSelf setSelected:YES andButton:weakSelf.openClockButton];
        } outside:^{
            [weakSelf setSelected:NO andButton:weakSelf.whistleButton];
            [weakSelf setSelected:NO andButton:weakSelf.openClockButton];
        }];
    }
    // 剩余2分钟时候
    if (weakSelf.percent <= 2 / 30.0 && self.isYanShi != 1) {//2/30.0
        // 找车延时提示
        if (!weakSelf.alertDelayFindCar) {
            UIAlertView *delayAlert = [[UIAlertView alloc] initWithTitle:@"延时找车" message:@"找车时间还剩余2分钟，是否申请延时？" delegate:weakSelf cancelButtonTitle:@"延时" otherButtonTitles:@"取消", nil];
            delayAlert.tag = TagAlertDelay;
            [delayAlert show];
            weakSelf.alertDelayFindCar = YES;
        }
    }
}

- (void)updateDistanceWithin20m:(void(^)())block outside:(void(^)())oblock
{
    AMapSearchManager *searchManager = [AMapSearchManager instance];
    CLLocationCoordinate2D userCoordinate = [ECarConfigs shareInstance].userCoordinate;
    AMapGeoPoint *startPoint = [AMapGeoPoint locationWithLatitude:userCoordinate.latitude longitude:userCoordinate.longitude];
    AMapGeoPoint *desPoint = [AMapGeoPoint locationWithLatitude:[self.carInfo.carLatitude floatValue] longitude:[self.carInfo.carlongitude floatValue]];
    weak_Self(self);
    [searchManager searchDistanceFromUserLocation:startPoint destination:desPoint success:^(NSString *distance) {
        if (_openCarDistance <= 0) {
            _openCarDistance = 100;
        }
        if (distance.floatValue <= weakSelf.openCarDistance || weakSelf.lanya.lanYaStatus) {
            block();
        } else if (distance.floatValue >= 300) {
            oblock();
        }
    } failure:^(NSString *error) {
        
    }];
}

#pragma mark - 按钮点击事件
- (void)cancelOrderClick
{
    [ECarConfigs shareInstance].cancelStatus = 2;
    [self cancelOrderAlert];
}

- (void)cancelOrderAlert
{
    UIAlertView *delayAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否取消订单？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    delayAlert.tag = TagAlertCancelOrder;
    [delayAlert show];
}

- (void)back
{
    [self.lanya deallocSharedLanYa];
    [self.daojishiTimer invalidate];
    self.daojishiTimer = nil;
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
    UILabel *lbl = [[UILabel alloc]initWithFrame:frame];
    lbl.backgroundColor = ClearColor;
    lbl.textAlignment = 1;
    lbl.textColor = [UIColor whiteColor];
    return lbl;
}

- (void)callSaver:(UIButton *)sender
{
    UIAlertView *serviceAlert = [[UIAlertView alloc]initWithTitle:@"联系客服" message:@"400-6507265" delegate:self cancelButtonTitle:@"呼叫" otherButtonTitles:@"取消" , nil];
    serviceAlert.tag = TagAlertService;
    [serviceAlert show];
}

#pragma mark - 加入底部按钮
- (void)openClockButtonClicked:(UIButton *)sender
{
    if (sender.tag == BottomButtonisClickedNO && self.lanya.lanYaStatus == NO) {
        UIAlertView * alerv = [[UIAlertView alloc] initWithTitle:@"提示" message:@"距离目标车辆太远，请您走到车辆附近开锁" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alerv show];
        return;
    }
    if (self.lanya.lanYaStatus == YES) {
        [self openCarByLanYa];
        return;
    }
    [self openCar];
}

- (void)whistleButtonClicked:(UIButton *)sender
{
    if (sender.tag == BottomButtonisClickedNO) {
        UIAlertView * alerv = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您需要在车辆附近" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alerv show];
        return;
    }
    
    if (self.lanya.lanYaStatus == YES) {
        [self delayHidHUD:@"开双闪"];
        [self openLampClicked];
        return;
    }
    
    [self lookingCar];
}

- (void)setSelected:(BOOL)select andButton:(UIButton *)sender
{
    if (select) {
        sender.tag = BottomButtonisClickedYES;
        [sender setTitleColor:RedColor forState:UIControlStateNormal];
    } else {
        sender.tag = BottomButtonisClickedNO;
        [sender setTitleColor:GrayColor forState:UIControlStateNormal];
    }
}

#pragma mark - 中间按钮     (备用可删)
- (void)createModelVButton
{
    [self.modelButton addTarget:self action:@selector(modelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.modelButton];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(modelButtonIsPanning:)];
    [self.modelButton addGestureRecognizer:pan];
}

- (void)modelButtonClicked:(UIButton *)sender
{
    
}

- (void)modelButtonIsPanning:(UIPanGestureRecognizer *)ges
{
    //相对于self.view移动的相对位置
    CGPoint tranlate = [ges translationInView:self.view];
    
    //根据移动的相对位置与原矩阵向加 得到新矩阵在付给圆矩阵
    ges.view.transform = CGAffineTransformTranslate(ges.view.transform, tranlate.x, tranlate.y);
    //最后设置ges相对self.view移动为0    初始化
    [ges setTranslation:CGPointMake(0, 0) inView:self.view];
}

#pragma mark - UIAlertViewDelegate 提示框代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 客服
    if (alertView.tag == TagAlertService) {
        if (buttonIndex == 0) {
            [ToolKit callTelephoneNumber:@"400-6507265" addView:self.view];
        }
    }
    // 超时
    if (alertView.tag == TagAlertTimeOut) {
        // 超时要取消订单
        [ECarConfigs shareInstance].cancelStatus = 3;
        [ECarConfigs shareInstance].exitTag = ExitNaviTagOther;
        [ECarConfigs shareInstance].currentStep = LinkStepBeginFindCar;
        [self back];
    }
    // 延时
    if (alertView.tag == TagAlertDelay) {
        if (buttonIndex == 0) {
            // 延时
            self.daojimiao = self.daojimiao - 15 * 60;
            [[self.manager zhaocheYanshiWithOrder:[ECarConfigs shareInstance].orignOrderNo] subscribeNext:^(id x) {
                
            } completed:^{
                
            }];
        }
    }
    // 取消订单
    if (alertView.tag == TagAlertCancelOrder) {
        if (buttonIndex == 0) {
            [ECarConfigs shareInstance].cancelStatus = 2;
            // 取消
            [self cancelOrder];
        }
    }
}

#pragma mark - 车辆控制方法
- (void)lookingCar
{
    weak_Self(self);
    [self showHUD:@"请稍等..."];
    NSString *orderNo = @"";
    orderNo = [ECarConfigs shareInstance].orignOrderNo;
    [[self.manager lookingCar:orderNo] subscribeNext:^(id x) {
        [self hideHUD];
        [weakSelf delayHidHUD:@"双闪已打开"];
    } error:^(NSError *error) {
        [self hideHUD];
        [weakSelf delayHidHUD:MESSAGE_NoNetwork];
    } completed:^{
    }];
}

// 使用车辆
- (void)openCar
{
    weak_Self(self);
    [self showHUD:@"打开中控锁"];
    ECarConfigs * cong = [ECarConfigs shareInstance];
    [[weakSelf.manager openLock:cong.orignOrderNo] subscribeNext:^(id x) {
        // 开锁成功
        [weakSelf hideHUD];
        
        [ECarConfigs shareInstance].exitTag = ExitNaviTagOpenLockSuccess;
        [ECarConfigs shareInstance].currentStep = LinkStepUseCar;
        [weakSelf openFloorAlert];
    } error:^(NSError *error) {
        [weakSelf hideHUD];
        [weakSelf delayHidHUD:@"网络异常"];
    } completed:^{
        
    }];
}

- (void)openCarByLanYa
{
    weak_Self(self);
    [self showHUD:@"开中控锁"];
    ECarConfigs * cong = [ECarConfigs shareInstance];
    [[weakSelf.manager openLockbyLanYaWithOrderID:cong.orignOrderNo] subscribeNext:^(id x) {
        //开锁成功
        [ECarConfigs shareInstance].exitTag = ExitNaviTagOpenLockSuccess;
        [ECarConfigs shareInstance].currentStep = LinkStepUseCar;
        [weakSelf openLockClicked];
    } error:^(NSError *error) {
        [weakSelf hideHUD];
        [weakSelf delayHidHUD:@"网络异常"];
    } completed:^{
        
    }];
}

- (void)openFloorAlert
{
    [self hideHUD];
    [self showHUD:@"开锁成功,请在30s内打开车门"];
    [self performSelector:@selector(back) withObject:nil afterDelay:4];
}

- (void)openLockClicked {
    _clicked = YES;
    NSString * str = [NSString stringWithFormat:@"%@%@%@", self.carInfo.lanYaPassWord, kOpenLock, kEndCode];
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self.lanya sendMessegeWithData:data];
    [self openFloorAlert];
}

- (void)closeLockClicked {
    _clicked = YES;
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

#pragma mark 取消订单
- (void)cancelOrder
{
    weak_Self(self);
    NSString *orderNo = @"";
    orderNo = [ECarConfigs shareInstance].orignOrderNo;
    ECarConfigs * config = [ECarConfigs shareInstance];
    [weakSelf showHUD:@"正在取消订单中"];
    [[self.manager cancelOrder:config.orignOrderNo carid:config.currentCarID userid:config.user.user_id andStatus:[ECarConfigs shareInstance].cancelStatus] subscribeNext:^(id x) {
        NSDictionary *dic = x;
        [weakSelf hideHUD];
        if ([dic[@"success"] boolValue]) {
            [weakSelf delayHidHUD:@"取消订单成功"];
            [ECarConfigs shareInstance].exitTag = ExitNaviTagOther;
            [weakSelf delay:2.0 excutive:^{
                [weakSelf back];
//                [weakSelf addzhifuViewJieshu];
            }];
        }
        [ECarConfigs shareInstance].currentStep = LinkStepBeginFindCar;
        
    } error:^(NSError *error) {
        [weakSelf hideHUD];
        [weakSelf delayHidHUD:MESSAGE_NoNetwork];
    } completed:^{
    }];
}

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

// 指定蓝牙设备是否连接成功
- (void)LanYaLianJieIsSuccess:(BOOL)isSuccess
{
    if (isSuccess) {
        [self hideHUD];
    } else {
        _isFirst = NO;
        [self.lanya resameCanse];
    }
}

- (void)LanYaXinHaoQiangDu:(NSNumber *)xinC
{
//    float power = (abs(xinC.intValue) - 70) / (10 * 2.0);
//    float poww = pow(10, power);
//    [self.daohangBtn setTitle:[NSString stringWithFormat:@"%.2f米", poww] forState:UIControlStateNormal];
}

// 接收到数据
- (void)LanYaReceiveMessegeData:(NSData *)data
{
    if (_clicked == NO) {
        return;
    }
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (str.length != 6) {
        return;
    }
    [self hideHUD];
    if ([str isEqualToString:@"111222"]) {
//        [self delayHidHUD:@"链接异常，请重新操作"];
        [self.lanya deallocSharedLanYa];
        if (!self.carInfo.lanYaName) {
            return;
        }
        [self.lanya beginBlueToothWithDiverceName:self.carInfo.lanYaName];
        [self openCar];
        return;
    }
    self.clicked = NO;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _showImageView;
}

#pragma mark - HUD
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
        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
        _hud.mode = MBProgressHUDModeText;
        [self.view addSubview:_hud];
    }
    [_hud setLabelText:text];
    [_hud show:YES];
    [_hud hide:YES afterDelay:2];
}

//- (void)delayHidHUD:(NSString *)text
//{
//    if (!self.hud) {
//        self.hud = [[MBProgressHUD alloc] initWithView:self.view];
//        _hud.mode = MBProgressHUDModeText;
//        [self.view addSubview:_hud];
//    }
//    [_hud setLabelText:text];
//    [_hud show:YES];
//    [_hud hide:YES afterDelay:2];
//}

- (void)naviManagerDidEndEmulatorNavi:(AMapNaviManager *)naviManager
{
    
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
