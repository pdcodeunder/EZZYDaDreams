
//
//  ECarMainViewController.m
//  ECarDreams
//
//  Created by 彭懂 on 15/12/28.
//  Copyright © 2015年 彭懂. All rights reserved.
//

#import "ECarMainViewController.h"
/*
    地图
 */
#import "AMapSearchManager.h"
#import <AMapNaviKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "CustomAnnotationView.h"
#import "ECarFanWeiModel.h"
#import "ECarPDDistance.h"
#import "PDPolygon.h"

// 语音
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import <iflyMSC/IFlySpeechUtility.h>

// 首页
#import "ECarCarDetailView.h"
#import "ECarInputViewController.h"
#import "AMBlurView.h"
#import "jiagemingxiViewController.h"

// 个人中心
#import "ECarMyCenterViewController.h"
#import "ECarOrderViewController.h"
#import "ECarTableController.h"

// 登录
#import "ECarLoginRegisterManager.h"
#import "ECarLoginViewController.h"

// 导航
#import "ECarMapNaviViewController.h"
//#import "ECarDrivingViewController.h"
#import "EZZYDrivingViewController.h"

// 支付
#import "ECarZhiFuViewController.h"
#import "ECarZhiFuWanChengViewController.h"

#import "ECarGPSChange.h"

#import "PDUUID.h"

#define kPickterSalus 0.0124374
#define BTNCOLOR [UIColor colorWithRed:220.f/250 green:50.f/250 blue:130.f/250 alpha:1]
#define kYunYingTimer 30

typedef NS_ENUM(NSInteger, AlertTag)
{
    AlertTagShuRuMuDiDi = 1 << 1, // 请输入目的地弹出框
    AlertTagFindCar = 1 << 2,     // 找车弹出框
    AlertTagUseCar = 1 << 3,      // 用车弹出框
    AlertTagChaoChuYunYingFanWei = 1 << 4,  // 超出运营范围
    AlertTagLianXiKeFu = 1 << 5,             // 联系客服
    AlertTagWeiWanChengDingDan = 1 << 6, // 未完成订单
    AlertTagFanHuiGeRenZhongXin    // 返回个人中心
};

typedef NS_ENUM(NSInteger, PopoverAlert)
{
    PopoverAlertTypeOne = 1100,     // 一个按钮
    PopoverAlertTypeTow,            // 两个按钮
    PopoverAlertTypeThree           // 版本更新
};

typedef void (^BookCarBlock)(id model);

@interface ECarMainViewController () <MAMapViewDelegate, AMapNaviManagerDelegate,EZZYDrivingViewControllerDelegate, IFlySpeechSynthesizerDelegate, ECarOrderViewControllerDelegate, ECarMyCenterViewControllerDelegate, AMapNaviViewControllerDelegate, UIAlertViewDelegate, UIScrollViewDelegate, ECarMapNaviViewControllerDelegate>

// UI
//@property (strong, nonatomic) UILabel               * mudiLabel;
@property (nonatomic, strong) MAMapView             * mapView;          // 地图
@property (strong, nonatomic) ECarCarDetailView     * detailView;       // 车辆信息气泡
@property (strong, nonatomic) UIView                * bottomView;       // 估计价格底部view
@property (strong, nonatomic) ECarMyCenterViewController * myCenter;    // 个人中心首页
@property (strong, nonatomic) UIAlertView           * popAlertView;
@property (strong, nonatomic) UIScrollView          * scrollView;       // 引导页
@property (strong, nonatomic) UIButton * gjFyBtn;
@property (strong, nonatomic) UIView *timeView;
@property (strong, nonatomic) UILabel *timeLabel;

// 逻辑
@property (nonatomic, strong) CLLocationManager     * locationManager;  // 位置管理类
@property (nonatomic, strong) NSMutableArray        * annotationAry;    // 存放大头针数据
@property (nonatomic, strong) NSDictionary          * dingdanDic;       // 自动登录订单字典
@property (nonatomic, strong) NSMutableArray        * ecarsAry;         // 汽车大头针数组
@property (nonatomic, strong) ECarCarInfo           * carInfo;          // 这辆信息
@property (nonatomic, strong) ECarMapManager        * manager;          // 网络请求
@property (nonatomic, strong) NSString              * currentRoadInfo;  // 用户当前位置信息
@property (nonatomic, strong) AMapNaviManager       * naviManager;      // 导航Manager
@property (nonatomic, strong) ECarCarInfo           * selectCar;        // 所选车辆
@property (nonatomic, strong) AMapPOI               * userDestitation;  // 目的地
@property (nonatomic, strong) ECarPDDistance        * pdDistance;       // 判断两点的距离
@property (nonatomic, strong) NSDictionary          * gujiDictionary;   // 估计价格字典
@property (nonatomic, strong) UILabel               * startLabel;       // 估计价格的起点
@property (nonatomic, strong) UILabel               * fyLabel;          // 估计价格
@property (nonatomic, strong) UILabel               * mdLabel;          // 目的地label
@property (nonatomic, strong) NSMutableArray        * sigleAnnotation;  // 单个大头针
@property (nonatomic, strong) NSMutableArray        * polyArray;        // 覆盖层数组
@property (nonatomic, strong) jiagemingxiViewController * gufeiVC;      // 费用估计
@property (nonatomic, assign) CLLocationCoordinate2D  userCoordinate;   // 定位坐标
@property (nonatomic, assign) NavigationTypes         naviType;         // 导航类型
@property (nonatomic, assign) BOOL                    isWalkingNav;     // 判断是否是步行导航
@property (nonatomic, assign) BOOL                    hiddenDetailView; // 判断是否隐藏车辆信息
@property (nonatomic, assign) BOOL                    persentNav;       // 判断是否从导航跳入
@property (nonatomic, assign) BOOL                    isFirst;          // 用于定位，判断是否第一次定位
@property (nonatomic, assign) BOOL                    locationSuccess;  // 判断是否成功定位
@property (nonatomic, assign) BOOL                    carListStatue;    // 判断是否进入了目的地输入
@property (nonatomic, copy)   BookCarBlock            bookBlock;        // 预订车辆block
@property (nonatomic, assign) double                  salcus;           // 缩放倍数
@property (nonatomic, assign) double                  juheBili;         // 聚合比例
@property (nonatomic, assign) BOOL                    polyBool;         // 判断bool

// 语音导航
@property (nonatomic, strong) IFlySpeechSynthesizer         * iFlySpeechSynthesizer;    // 语音
@property (nonatomic, strong) ECarMapNaviViewController     * warkingNaviewContoller;   // 步行导航
//@property (nonatomic, strong) ECarDrivingViewController     * dringNaviViewController;  // 行车导航
@property (nonatomic, strong) AMapNaviPoint                 * startPoint;               // 导航起点
@property (nonatomic, strong) AMapNaviPoint                 * endPoint;                 // 导航终点
@property (nonatomic, assign) NavManagerTravelType            navManagerTravelType;     // 导航判断是驾车还是步行
@property (nonatomic, assign) BOOL                            registerJpushFirst;       // 向后台发报位置
@property (nonatomic, assign) BOOL                            locationUserFirst;        // 避免重复定位

@property (nonatomic, assign) ECarConfigs                   * config;
// 支付
//@property (nonatomic, strong) ECarZhiFuViewController       * zhifu;                    // 支付页面

@end

@implementation ECarMainViewController

#pragma mark - 懒加载
- (ECarCarDetailView *)detailView
{
    if (!_detailView) {
        _detailView = [[ECarCarDetailView alloc] initWithFrame:CGRectMake(0, 235.f / 667.f * kScreenH, kScreenW, kScreenH - 235.f / 667.f * kScreenH)];
    }
    return _detailView;
}

#pragma mark 两点距离
- (ECarPDDistance *)pdDistance
{
    if (!_pdDistance) {
        _pdDistance = [[ECarPDDistance alloc] init];
    }
    return _pdDistance;
}

#pragma mark 个人中心

- (NSMutableArray *)polyArray
{
    if (!_polyArray) {
        _polyArray = [[NSMutableArray alloc] init];
    }
    return _polyArray;
}

- (NSMutableArray *)sigleAnnotation
{
    if (!_sigleAnnotation) {
        _sigleAnnotation = [[NSMutableArray alloc] init];
    }
    return _sigleAnnotation;
}

- (UIView *)timeView
{
    if (!_timeView) {
        _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, -65, kScreenW, 64)];
        _timeView.backgroundColor = BlackColor;
        _timeView.alpha = 0.8f;
    }
    return _timeView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kYunYingTimer, 0, kScreenW - 2 * kYunYingTimer, 64)];
        _timeLabel.backgroundColor = ClearColor;
        _timeLabel.textColor = GrayColor;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.numberOfLines = 0;
        _timeLabel.font = FontType;
    }
    return _timeLabel;
}

#pragma mark - ViewController生命周期函数
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hiddenYunYingTime];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (_detailView && _hiddenDetailView == NO) {
        [self detailViewHidde:YES];
    }
    _hiddenDetailView = NO;
    if (self.config.timeStr.length != 0) {
        [self showYunYingTime];
        [self performSelector:@selector(hiddenYunYingTime) withObject:nil afterDelay:5];
    }
}

- (void)showYunYingTime
{
    self.timeLabel.text = self.config.timeStr;
    [UIView animateWithDuration:0.3 animations:^{
        self.timeView.frame = CGRectMake(0, 0, kScreenW, 64);
    }];
}

- (void)hiddenYunYingTime
{
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH"];
    NSString * locationString = [dateformatter stringFromDate:senddate];
    NSInteger time = locationString.integerValue;
    if (time < 7 || time >= 23) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.timeView.frame = CGRectMake(0, -65, kScreenW, 64);
    }];
}

- (void)detailViewHidde:(BOOL)hide
{
    if (hide) {
        [UIView animateWithDuration:0.3 animations:^{
            self.detailView.frame = CGRectMake(0, kScreenH, kScreenW, kScreenH - 235.f / 667.f * kScreenH);
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.detailView.frame = CGRectMake(0, 235.f / 667.f * kScreenH, kScreenW, kScreenH - 235.f / 667.f * kScreenH);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.config = [ECarConfigs shareInstance];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.currentRoadInfo = @"null";
    self.userCoordinate = CLLocationCoordinate2DMake(39.90815613, 116.3973999);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notDidFinishOrder:) name:@"YouWeiWanChengDingDan" object:nil];
    
    [self initViewFun];
    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    // 第一次读取 = NO,以后再运行
//    BOOL isFirst = [userDefault boolForKey:@"isFirst"];
//    if (!isFirst) {
//        [self createScrollView];
//        //修改本地化，
//        [userDefault setBool:YES forKey:@"isFirst"];
//    } else {
//        [self initViewFun];
//    }
//    [self testAnnotation];    // 测试GPS
}

- (void)initViewFun
{
    [self autoLogin];           // 自动登录
    
    [self chushihua];           // 一些初始化设置
    
    [self createMapView];       // 配置地图
    
    LocationCheck(self);        // 检测GPS是否打开
    
    [self create3UI];           // 创建UI
    
    [self createCarDetailView]; // 创建
}

- (void)createScrollView{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:
                   CGRectMake(0, 0, kScreenW, kScreenH)];
    _scrollView.showsHorizontalScrollIndicator = NO;//不出现滑动条
    _scrollView.showsVerticalScrollIndicator =  NO;
    // 本来就是用来让用户每次只在一个方向上滚动，竖直或者水平，但是如果初始移动方向处于45°左右的时候，这个锁就失效了。
    _scrollView.directionalLockEnabled = NO;
    [self.view addSubview:_scrollView];
    
    // 设置内容尺寸
    _scrollView.contentSize = CGSizeMake(kScreenW * 3, kScreenH);
    _scrollView.pagingEnabled = YES; // 分页效果
    _scrollView.bounces = NO; // 不反弹
    
    for (NSInteger i = 0; i < 3; i++) {
        
        NSString *imgName = [NSString stringWithFormat:@"yindaoye%zd",i + 1];
        // 图片视图
        UIImageView *_imageView = [[UIImageView alloc] initWithFrame:
                                   CGRectMake(i * kScreenW, 0, kScreenW, kScreenH)];
        _imageView.image = [UIImage imageNamed:imgName];
        [_scrollView addSubview:_imageView];
        if (i == 2) {
            // 界面响应触摸
            _imageView.userInteractionEnabled = YES;
            
            // 点击进入首页进行浏览体验
            UIButton *touristBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            touristBtn.frame = CGRectMake(0, 0, 110, 35);
            touristBtn.center = CGPointMake(kScreenW / 2.0, kScreenH - 140 / 667.0 * kScreenH);
            [touristBtn setTitle:@"立即体验" forState:UIControlStateNormal];
            [touristBtn setTitleColor:BTNCOLOR forState:UIControlStateNormal];
            touristBtn.layer.cornerRadius = 5;
            touristBtn.layer.borderWidth = 1;
            [touristBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            touristBtn.layer.borderColor =[BTNCOLOR CGColor];
            [touristBtn addTarget:self
                           action:@selector(leftAction:)
                 forControlEvents:UIControlEventTouchUpInside];
            [_imageView addSubview:touristBtn];
        }
    }
}

- (void)leftAction:(UIButton*)button{
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    [self initViewFun];
}

- (void)testAnnotation
{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = MACoordinateConvert(CLLocationCoordinate2DMake(39.94243, 116.3448), MACoordinateTypeGPS);
    [self.mapView addAnnotation:pointAnnotation];
    
//    MAPointAnnotation *pointAnnotation2 = [[MAPointAnnotation alloc] init];
//    pointAnnotation2.coordinate = CLLocationCoordinate2DMake(39.93278, 116.43884);
//    [self.mapView addAnnotation:pointAnnotation2];
}

#pragma mark - 创建订单
- (void)createOrder:(id)model success:(void(^)())block andFail:(void(^)(NSString * msg))failBlock
{
    weak_Self(self);
    CLLocationCoordinate2D userCoordinate = self.config.userCoordinate;
    ECarCarInfo *ecarInfo = model;
    ECarUser *userInfo = self.config.user;
    self.config.currentCarID = ecarInfo.carid;
    
    [[self.manager createOrder:ecarInfo.carid userID:userInfo.user_id begin:self.currentRoadInfo area:@"beijing" userLatitude:FloatToString(userCoordinate.latitude) userLongitude:FloatToString(userCoordinate.longitude)] subscribeNext:^(id x) {
        NSDictionary * dic = x;
        NSString *order = dic[@"obj"];
        NSDictionary * attributes = dic[@"attributes"];
        if (attributes) {
            weakSelf.selectCar.lanYaName = attributes[@"lanYaName"];
            weakSelf.selectCar.lanYaPassWord = attributes[@"lanYaPassWord"];
            weakSelf.selectCar.lanYaServiceName = attributes[@"lanYaServiceName"];
            weakSelf.selectCar.lanYaWriteCharacteristiceName = attributes[@"lanYaWriteCharacteristiceName"];
            weakSelf.selectCar.lanYaNotifyCharacteristiceName = attributes[@"lanYaNotifyCharacteristiceName"];
            
            weakSelf.carInfo.lanYaName = attributes[@"lanYaName"];
            weakSelf.carInfo.lanYaPassWord = attributes[@"lanYaPassWord"];
            weakSelf.carInfo.lanYaServiceName = attributes[@"lanYaServiceName"];
            weakSelf.carInfo.lanYaWriteCharacteristiceName = attributes[@"lanYaWriteCharacteristiceName"];
            weakSelf.carInfo.lanYaNotifyCharacteristiceName = attributes[@"lanYaNotifyCharacteristiceName"];
        }
        NSNumber * success = dic[@"success"];
        if (success.integerValue == 0) {
            NSString * phoneMsg = dic[@"phoneMsg"];
            failBlock(phoneMsg);
            return;
        }
        self.config.orignOrderNo = order;
        block();
    } error:^(NSError *error) {
        [weakSelf hideHUD];
        [weakSelf delayHidHUD:@"网络连接失败"];
    } completed:^{
    }];
}

#pragma mark - 自动登录判断是否有未完成的订单
- (void)notDidFinishOrder:(NSNotification *)info
{
    self.dingdanDic = info.userInfo;
    UIAlertView * alerview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您有未完成的订单，是否继续？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    alerview.tag = AlertTagWeiWanChengDingDan;
    [alerview show];
}

#pragma mark - 一些必要初始化
- (void)chushihua
{
    self.userDestitation = [[AMapPOI alloc] init];
    self.userDestitation.location = [AMapGeoPoint locationWithLatitude:39.90815613 longitude:116.3973999];
    self.persentNav = NO;
    self.navManagerTravelType = NavManagerTravelTypeDefault;
    _isWalkingNav = NO;
    self.manager = [ECarMapManager new];
    self.annotationAry = [[NSMutableArray alloc] init];
    _isFirst = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    weak_Self(self);
    self.bookBlock = ^(id model){
        PDLog(@"预订车辆子类");
        ECarCarInfo * carInfo = model;
        weakSelf.carInfo = model;
        [weakSelf detailViewHidde:NO];
        [weakSelf refreshDetailViewWithModel:model];
        CGPoint carpoint = [weakSelf.mapView convertCoordinate:CLLocationCoordinate2DMake(carInfo.carLatitude.floatValue, carInfo.carlongitude.floatValue) toPointToView:weakSelf.view];
        CGPoint centerpoint = CGPointMake(carpoint.x, carpoint.y + 216 / 667.f * kScreenH);
        CLLocationCoordinate2D coordinat = [weakSelf.mapView convertPoint:centerpoint toCoordinateFromView:weakSelf.view];
        [weakSelf.mapView setCenterCoordinate:coordinat animated:YES];
    };
}

#pragma mark - 自动登录
- (void)autoLogin
{
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    NSString *code = [[NSUserDefaults standardUserDefaults] objectForKey:@"verifyCode"];
    if (phone.length == 0||code.length == 0) {
        return;
    }
    self.config.loginStatue = YES;
    [ECarConfigs shareInstance].user.phone = phone;
    NSString *identifierForDevice = [PDUUID getUUID];
    // 网络请求
    [[[ECarLoginRegisterManager new] apploginWithPhone:phone pwd:code andUUID:identifierForDevice] subscribeNext:^(id x) {
        NSMutableDictionary *responseJsonOB = x;
        NSNumber *value = [responseJsonOB objectForKey:@"success"];
        // 去主页面
        if(value.boolValue == true){
            self.config.TokenID = code;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginFinished" object:nil];
            NSDictionary *objDic = responseJsonOB[@"obj"];
            ECarUser *user = [[ECarUser alloc] initWithResponse:objDic];
            self.config.user = user;
            NSNumber * phoneMsg = responseJsonOB[@"phoneMsg"];
            if (phoneMsg != nil && phoneMsg.boolValue == 0) {
                NSDictionary * objNo2 = responseJsonOB[@"objNo2"];
                PDLog(@"objNo2objNo2 :  %@", objNo2);
                self.dingdanDic = objNo2;
                UIAlertView * alerview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您有未完成的订单，是否继续？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
                alerview.tag = AlertTagWeiWanChengDingDan;
                [alerview show];
            }
            self.config.loginStatue = YES;
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phone"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"verifyCode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _config.loginStatue = NO;
            [ECarConfigs shareInstance].user.phone = @"";
        }
    } error:^(NSError *error) {
    } completed:^{
        
    }];
}

#pragma mark - 地图配置
- (void)createMapView
{
    [MAMapServices sharedServices].apiKey = AMapKey;
    [AMapNaviServices sharedServices].apiKey = AMapKey;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    [self.mapView setDelegate:self];
    [self.view insertSubview:self.mapView atIndex:0];
    // 配置地图
    [self configMagView];
    
    // 自定义折线范围控制
    [self getZheXianFanWeiKongZhi];
}

- (void)configMagView
{
    _mapView.rotateCameraEnabled = NO;
    _mapView.pausesLocationUpdatesAutomatically = YES;
    _mapView.showsUserLocation = YES;
    self.mapView.showsScale = NO;
    self.mapView.showsCompass = NO;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    [self locationAlert];
    // 范围控制 (四点和图片)
//    [self getFanWeiKongZhi];
    
//    [self addStartInMapView];
    // 配置导航
    [self initAMapNavigation];
}

// 添加永利国际星
- (void)addStartInMapView
{
    CustomAnnotationView *pointAnnotation = [[CustomAnnotationView alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.93479907, 116.44466579);
    pointAnnotation.image = [UIImage imageNamed:@"xing36*51"];
    pointAnnotation.carDataModel = nil;
    pointAnnotation.annotationCount = 1;
    [self.mapView addAnnotations:@[pointAnnotation]];
}

- (void)locationAlert
{
    self.locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                // 用这个方法，plist里要加字段NSLocationWhenInUseUsageDescription
                [self.locationManager performSelector:@selector(requestWhenInUseAuthorization)];
            }
        }
    }
}

- (void)locationUser
{
    [self.mapView setZoomLevel:15.f animated:YES];
    [_mapView setCenterCoordinate:self.userCoordinate animated:YES];
}

#pragma mark 网络请求范围控制
- (void)getFanWeiKongZhi
{
    weak_Self(self);
    [[self.manager getFanWeiKongZhi] subscribeNext:^(id x) {
        NSDictionary * dic = x;
        NSString * success = [NSString stringWithFormat:@"%@", dic[@"success"]];
        if (success.intValue == 1) {
            ECarFanWeiModel * model = [ECarFanWeiModel sharedECarFanWeiModel];
            NSString * str = dic[@"phoneMsg"];
            [weakSelf delayHidHUD:@"运营区域"];
            // 得到坐标点
            NSArray * array = [str componentsSeparatedByString:@"|"];
            model.topLeftStr = array[0];
            model.bottomLeftStr = array[1];
            model.bottomRightStr = array[2];
            model.topRightStr = array[3];
            model.fanWeiStatus = YES;
            // 图片覆盖物
            [weakSelf setPickterViewCoverMapview];
            // 折线覆盖物
//            [weakSelf createCoverViewOnMapView];
            self.mapView.zoomLevel = 11.5f;
            [weakSelf.mapView setCenterCoordinate:model.centorPoint animated:YES];
        }
    } error:^(NSError *error) {
    } completed:^{
        
    }];
}

#pragma mark 自定义折线范围控制
- (void)getZheXianFanWeiKongZhi
{
    weak_Self(self);
    NSDictionary * bundleDic = [[NSBundle mainBundle]infoDictionary];
    NSString * version = [bundleDic objectForKey:@"CFBundleShortVersionString"];
    [[self.manager getZiDingYiFanWeiKongZhiWithVersion:version] subscribeNext:^(id x) {
        NSDictionary * dic = x;
        NSString * timeStr = dic[@"phoneMsg"];
        if (timeStr.length != 0) {
            NSDictionary * attributes = dic[@"attributes"];
            NSString * beginTime = attributes[@"begintime"];
            NSString * endTIme = attributes[@"endtime"];
            self.config.beginTime = beginTime.integerValue;
            self.config.endTime = endTIme.integerValue;
            weakSelf.timeLabel.text = timeStr;
            self.config.timeStr = timeStr;
            
            [weakSelf showYunYingTime];
            [weakSelf performSelector:@selector(hiddenYunYingTime) withObject:nil afterDelay:5];
        }
        NSDictionary * attributes = dic[@"attributes"];
        if (attributes) {
            NSString * type = [NSString stringWithFormat:@"%@", attributes[@"type"]];
            NSString * title = @"提示";
            NSString * information = @"欢迎光临";
            NSString * leftBtn = @"确定";
            NSString * rightBtn = @"取消";
            if (attributes[@"title"]) {
                title = attributes[@"title"];
            }
            if (attributes[@"information"]) {
                information = attributes[@"information"];
            }
            if (attributes[@"leftbtn"]) {
                leftBtn = attributes[@"leftbtn"];
            }
            if (attributes[@"rightbtn"]) {
                rightBtn = attributes[@"rightbtn"];
            }
            switch (type.integerValue) {
                case 0:
                {
                    break;
                }
                case 1:
                {
                    self.popAlertView = [[UIAlertView alloc] initWithTitle:title message:information delegate:self cancelButtonTitle:leftBtn otherButtonTitles:nil, nil];
                    self.popAlertView.tag = PopoverAlertTypeOne;
                    [self.popAlertView show];
                    break;
                }
                case 2:
                {
                    self.popAlertView = [[UIAlertView alloc] initWithTitle:title message:information delegate:self cancelButtonTitle:leftBtn otherButtonTitles:rightBtn, nil];
                    self.popAlertView.tag = PopoverAlertTypeTow;
                    [self.popAlertView show];
                    break;
                }
                case 3:
                {
                    if (!attributes[@"rightbtn"]) {
                        rightBtn = nil;
                    }
                    if (!attributes[@"title"]) {
                        title = nil;
                    }
                    self.popAlertView = [[UIAlertView alloc] initWithTitle:title message:information delegate:self cancelButtonTitle:leftBtn otherButtonTitles:rightBtn, nil];
                    self.popAlertView.tag = PopoverAlertTypeThree;
                    self.config.gengxinAlert = self.popAlertView;
                    [self.popAlertView show];
                    break;
                }
                default:
                    break;
            }
        }
        
        NSString * success = [NSString stringWithFormat:@"%@", dic[@"success"]];
        if (success.intValue == 1) {
            [weakSelf delayHidHUD:@"运营区域"];
            ECarFanWeiModel * model = [ECarFanWeiModel sharedECarFanWeiModel];
            NSArray * objArr = dic[@"obj"];
            if (objArr.count > 0) {
                if (weakSelf.polyArray.count > 0) {
                    [weakSelf.polyArray removeAllObjects];
                }
                // 得到坐标点
                NSArray * array = objArr[0];
                model.pointArr = [[NSMutableArray alloc] initWithArray:array];
                [weakSelf createZiDingYiCoverViewOnMapViewWithPointArr:array andTag:0];
                model.fanWeiStatus = YES;
                // 图片覆盖物
//                [weakSelf setPickterViewCoverMapview];
                for (int i = 1; i < objArr.count; i++) {
                    NSArray * pointArr = objArr[i];
                    if (pointArr.count > 0) {
                        [weakSelf createZiDingYiCoverViewOnMapViewWithPointArr:pointArr andTag:i];
                    }
                }
                [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.90815613, 116.3973999) animated:YES];
                [self.mapView setZoomLevel:11.5f animated:YES];
            }
        }
        // 折线区域范围
        /**
        NSDictionary * dic = x;
        NSString * success = [NSString stringWithFormat:@"%@", dic[@"success"]];
        if (success.intValue == 1) {
            ECarFanWeiModel * model = [ECarFanWeiModel sharedECarFanWeiModel];
            [weakSelf delayHidHUD:@"运营区域"];
            // 得到坐标点
            model.pointArr = dic[@"obj"];
            model.fanWeiStatus = YES;
            // 自定义折线覆盖物
            [weakSelf createZiDingYiCoverViewOnMapView];
            // 设置中心点和缩放倍数
            self.mapView.zoomLevel = 10.5f;
            [weakSelf.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.90960456049752, 116.3972282409668) animated:YES];
        }
         */
    } error:^(NSError *error) {
        [weakSelf delayHidHUD:@"网络异常"];
    } completed:^{
//        self.mapView.showsUserLocation = YES;
        [weakSelf performSelector:@selector(userCentor) withObject:nil afterDelay:2.5];
    }];
}

- (void)userCentor
{
    [self.mapView setZoomLevel:15.f animated:YES];
    if (self.userCoordinate.latitude == 0 || self.userCoordinate.longitude == 0) {
        return;
    }
    [self.mapView setCenterCoordinate:self.userCoordinate animated:YES];
}

#pragma mark 导航管理初始化，语音类初始化
- (void)initAMapNavigation
{
    if (self.naviManager == nil) {
        self.naviManager = [[AMapNaviManager alloc] init];
    }
    self.naviManager.delegate = self;
    self.iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    self.iFlySpeechSynthesizer.delegate = self;
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",@"561f5c54",@"20000"];
    [IFlySpeechUtility createUtility:initString];
    [self.iFlySpeechSynthesizer setParameter:@"50" forKey:@"speed"];
    [self.iFlySpeechSynthesizer setParameter:@"100" forKey:@"volume"];
}

#pragma mark 图片覆盖物显示
- (void)setPickterViewCoverMapview
{
    ECarFanWeiModel * model = [ECarFanWeiModel sharedECarFanWeiModel];
    MACoordinateBounds coordinateBounds = MACoordinateBoundsMake(CLLocationCoordinate2DMake(model.topLeftPoint.latitude + kPickterSalus, model.topLeftPoint.longitude - kPickterSalus), CLLocationCoordinate2DMake(model.bottomRightPoint.latitude - kPickterSalus, model.bottomRightPoint.longitude + kPickterSalus));
    MAGroundOverlay * groundOverlay = [MAGroundOverlay groundOverlayWithBounds:coordinateBounds icon:[UIImage imageNamed:@"fanwei308*328"]];
    [self.mapView addOverlay:groundOverlay];
    self.mapView.visibleMapRect = groundOverlay.boundingMapRect;
}

#pragma mark 构造地图四点折线覆盖物
- (void)createCoverViewOnMapView
{
    //构造多边形数据对象
    ECarFanWeiModel * model = [ECarFanWeiModel sharedECarFanWeiModel];
    CLLocationCoordinate2D coordinates[4];
    coordinates[0] = model.topLeftPoint;
    coordinates[1] = model.bottomLeftPoint;
    coordinates[2] = model.bottomRightPoint;
    coordinates[3] = model.topRightPoint;
    MAPolygon * poly = [MAPolygon polygonWithCoordinates:coordinates count:4];
    [self.mapView addOverlay:poly];
}

#pragma mark 构造自定义折线覆盖物
- (void)createZiDingYiCoverViewOnMapViewWithPointArr:(NSArray *)pointArr andTag:(NSInteger)tag
{
    // 构造多边形数据对象
    NSInteger numberOfPoints = [pointArr count];
    if (numberOfPoints > 2)
    {
        CLLocationCoordinate2D points[numberOfPoints];
        for (NSInteger i = 0; i < numberOfPoints; i++) {
            NSString * point = [pointArr objectAtIndex:i];
            NSArray * array = [point componentsSeparatedByString:@","];
            NSString * longi = array[0];
            NSString * latitu = array[1];
            points[i] = CLLocationCoordinate2DMake(latitu.doubleValue, longi.doubleValue);
        }
        PDPolygon * poly = [PDPolygon polygonWithCoordinates:points count:numberOfPoints];
        if (tag == 0) {
            poly.polygonColorType = PolygonColorFanWei;
        } else if (tag == 1) {
            poly.polygonColorType = PolygonColorGreen;
        } else if (tag == 2)
        {
            poly.polygonColorType = PolygonColorYellow;
        } else if (tag > 2) {
            poly.polygonColorType = PolygonColorRed;
        }
        [self.polyArray addObject:poly];
        [self.mapView addOverlay:poly];
    }
}

#pragma mark 添加地图点击事件让大头针消失
- (void)addTouchMapView
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouches:)];
    [self.mapView addGestureRecognizer:tap];
}

- (void)tapTouches:(UITapGestureRecognizer *)tap
{
    if (_detailView) {
        [self detailViewHidde:YES];
        for (CustomAnnotationView * view in self.mapView.annotations) {
            if ([view isKindOfClass:[CustomAnnotationView class]]) {
                [view setSelected:NO animated:YES];
            }
        }
    }
}

#pragma mark - 创建UI界面
- (void)create3UI
{
    // 底部view
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(56 / 375.f * kScreenW, 0, kScreenW - 112 / 375.f * kScreenW, 45 / 667.0 * kScreenH)];
    bottomView.bottom = kScreenH - 22;
    UIImageView * dituImage = [[UIImageView alloc] initWithFrame:bottomView.bounds];
    dituImage.image = [UIImage imageNamed:@"shouyebutton"];
//    bottomView.alpha = 0.8f;
    [bottomView addSubview:dituImage];
    
    [self.view addSubview:bottomView];
    
//    UIImageView * sousuoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
//    sousuoImage.center = CGPointMake(28, 22);
//    sousuoImage.image = [UIImage imageNamed:@"sousuohuise21*21"];
//    [bottomView addSubview:sousuoImage];
    
    // 目的地输入框
//    self.mudiLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sousuoImage.frame) + 7, 0, bottomView.bounds.size.width - CGRectGetMaxX(sousuoImage.frame) - 7, 45)];
//    self.mudiLabel.textColor = GrayColor;
//    self.mudiLabel.text = @"输入目的地";
//    self.mudiLabel.font = FontType;
//    [bottomView addSubview:self.mudiLabel];
//    UIButton * mudiButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    mudiButton.frame = CGRectMake(0, 0, kScreenW - 30, 49);
//    [mudiButton addTarget:self action:@selector(mudidiButtonCliecked:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:mudiButton];
    
    // 底部button
    CGFloat w = bottomView.bounds.size.width;
    
    UIButton * luopanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    luopanButton.frame = CGRectMake(bottomView.frame.origin.x, bottomView.frame.origin.y, w / 4.f, bottomView.height);
    [luopanButton setImage:[UIImage imageNamed:@"yuandian"] forState:UIControlStateNormal];
    [luopanButton addTarget:self action:@selector(luoPanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:luopanButton];
    
    // 车辆列表
    UIButton * qicheliebiao = [UIButton buttonWithType:UIButtonTypeCustom];
    qicheliebiao.frame = CGRectMake(bottomView.frame.origin.x + w / 4.f, bottomView.frame.origin.y, w / 4.f, bottomView.height);
    [qicheliebiao setImage:[UIImage imageNamed:@"liebiao"] forState:UIControlStateNormal];
    [qicheliebiao addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qicheliebiao];
    
    // 我的行程
    UIButton * songche = [UIButton buttonWithType:UIButtonTypeCustom];
    songche.frame = CGRectMake(bottomView.frame.origin.x + w / 2.f, bottomView.frame.origin.y, w / 4.f, bottomView.height);
    [songche setImage:[UIImage imageNamed:@"yunyingqushouye"] forState:UIControlStateNormal];
    [songche addTarget:self action:@selector(wodeXingChengClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:songche];
    
    // 个人中心首页
    UIButton * youhui = [UIButton buttonWithType:UIButtonTypeCustom];
    youhui.frame = CGRectMake(bottomView.frame.origin.x + w / 4.f * 3, bottomView.frame.origin.y, w / 4.f, bottomView.height);
    [youhui setImage:[UIImage imageNamed:@"wode"] forState:UIControlStateNormal];
    [youhui addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:youhui];
    
//    [self createGuJiFeiYong];
    
    [self.timeView addSubview:self.timeLabel];
    [self.view addSubview:self.timeView];
}

#pragma mark - 估计价格界面view
//- (void)createGuJiFeiYong
//{
//    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 356 / 375.f * kScreenW, 214 / 667.f * kScreenH)];
//    self.bottomView.center = CGPointMake(kScreenW / 2.f, 549.f / 667.f * kScreenH);
//    self.bottomView.backgroundColor = WhiteColor;
//    self.bottomView.hidden = YES;
//    [self.view addSubview:self.bottomView];
//    
//    UIImageView * botImage = [[UIImageView alloc] initWithFrame:self.bottomView.bounds];
//    botImage.image = [UIImage imageNamed:@"yugujiage356*214"];
//    [self.bottomView addSubview:botImage];
//    
//    self.startLabel = [[UILabel alloc] initWithFrame:CGRectMake(27 / 375.f * kScreenW, 0, self.bottomView.bounds.size.width - 27 / 375.f * kScreenW, 51.f / 667.f * kScreenH)];
//    self.startLabel.font = [UIFont systemFontOfSize:14];
//    [self.bottomView addSubview:self.startLabel];
//    
//    UIButton * gfmudiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    gfmudiBtn.frame = CGRectMake(27 / 375.f * kScreenW, CGRectGetMaxY(self.startLabel.frame), self.bottomView.bounds.size.width - 27 / 375.f * kScreenW, 51.f / 667.f * kScreenH);
//    [gfmudiBtn addTarget:self action:@selector(mudidiClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.bottomView addSubview:gfmudiBtn];
//    
//    self.mdLabel = [[UILabel alloc] initWithFrame:gfmudiBtn.frame];
//    self.mdLabel.font = [UIFont systemFontOfSize:14];
//    [self.bottomView addSubview:self.mdLabel];
//    
//    UIButton * gjFyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    gjFyButton.frame = CGRectMake(0, CGRectGetMaxY(gfmudiBtn.frame), self.bottomView.bounds.size.width, 66.f / 667.f * kScreenH);
//    [gjFyButton addTarget:self action:@selector(gujifeiyongButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    gjFyButton.enabled = NO;
//    [self.bottomView addSubview:gjFyButton];
//    self.gjFyBtn = gjFyButton;
//    
//    self.fyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(gfmudiBtn.frame), self.bottomView.bounds.size.width, 66.f / 667.f * kScreenH)];
//    self.fyLabel.font = [UIFont systemFontOfSize:14];
//    self.fyLabel.textAlignment = NSTextAlignmentCenter;
//    [self.bottomView addSubview:self.fyLabel];
//    
//    UIButton * shiyongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    shiyongBtn.frame = CGRectMake(0, CGRectGetMaxY(self.fyLabel.frame), self.bottomView.bounds.size.width / 2.f, 49.f / 667.f * kScreenH);
//    [shiyongBtn addTarget:self action:@selector(shiYongButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.bottomView addSubview:shiyongBtn];
//    
//    UIButton * quXiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    quXiaoBtn.frame = CGRectMake(self.bottomView.bounds.size.width / 2.f, CGRectGetMaxY(self.fyLabel.frame), self.bottomView.bounds.size.width / 2.f, 49.f / 667.f * kScreenH);
//    [quXiaoBtn addTarget:self action:@selector(quxiaoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.bottomView addSubview:quXiaoBtn];
//}
//
//- (void)gujifeiyongButtonClicked:(UIButton *)sender
//{
//    [self creatJiagemingxiView];
//}

// 价格明细方法
- (void)creatJiagemingxiView {
    if (!self.gujiDictionary) {
        [self delayHidHUD:@"网络异常，请重新操作"];
        return;
    }
    jiagemingxiViewController * jiaVC = [[jiagemingxiViewController alloc] initWithDic:self.gujiDictionary];
    self.gufeiVC = jiaVC;
    jiaVC.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:jiaVC.view];
}

//- (void)mudidiClicked:(UIButton *)sender
//{
//    weak_Self(self);
//    ECarInputViewController * destinationVC = [[ECarInputViewController alloc] init];
//    destinationVC.destinationBlock = ^(AMapPOI *poi){
//        weakSelf.userDestitation = poi;
//        weakSelf.mudiLabel.text = poi.name;
//        weakSelf.mdLabel.text = poi.name;
//        [weakSelf getGujiFeiYong];
//    };
//    destinationVC.currentPOI = self.userDestitation;
//    [self.navigationController pushViewController:destinationVC animated:YES];
//}

- (void)quxiaoButtonClicked:(UIButton *)sender
{
    self.bottomView.hidden = YES;
    [self.mapView removeAnnotations:self.sigleAnnotation];
    
    [self.mapView addAnnotations:self.annotationAry];
}

- (void)shiYongButtonClicked:(UIButton *)sender
{
    [self showHUD:@"正在预定..."];
    // 创建订单
    [self createOrder:self.selectCar success:^{
        [self hideHUD];
        [self delayHidHUD:@"预定成功"];
        [self gotoFindCarNavi:self.selectCar];
    } andFail:^(NSString *msg) {
        [self hideHUD];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)setShiYongButtonHiddenNo
{
    [self.mapView removeAnnotations:self.annotationAry];
    [self.mapView removeAnnotations:self.sigleAnnotation];
    [self.sigleAnnotation removeAllObjects];
    
    CustomAnnotationView *pointAnnotation = [[CustomAnnotationView alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.selectCar.carLatitude.floatValue, self.selectCar.carlongitude.floatValue);
    pointAnnotation.carDataModel = self.selectCar;
    pointAnnotation.sigleCount = 100;
    pointAnnotation.annotationCount = 1;
    [self.mapView addAnnotations:@[pointAnnotation]];
    [self.sigleAnnotation addObject:pointAnnotation];
    
    self.bottomView.hidden = NO;
    if (self.detailView.locationLabel.text == nil) {
        [[AMapSearchManager instance] locationRoadWithLatitude:self.selectCar.carLatitude.floatValue longitude:self.selectCar.carlongitude.floatValue success:^(NSString *road) {
            self.startLabel.text = road;
        } faliure:^(NSString *error) {
        }];
    } else {
        self.startLabel.text = self.detailView.locationLabel.text;
    }
    [self getGujiFeiYong];
}

#pragma mark 获得估计价格
- (void)getGujiFeiYong
{
    weak_Self(self);
    NSString * userid = self.config.user.user_id;
    if (!userid) {
        userid = @"dashabi";
    }
    [[self.manager getGuJiFeiYongWithStartCoordinate:CLLocationCoordinate2DMake(self.selectCar.carLatitude.doubleValue, self.selectCar.carlongitude.doubleValue) andDestination:CLLocationCoordinate2DMake(self.userDestitation.location.latitude, self.userDestitation.location.longitude) andUserID:userid] subscribeNext:^(id x) {
        NSDictionary * dic = x;
        weakSelf.gujiDictionary = dic[@"obj"];
        if (weakSelf.gujiDictionary == nil) {
            return ;
        }
        NSString * obj2 = [NSString stringWithFormat:@"%@", dic[@"objNo2"]];
        if (!obj2.boolValue) {
            NSString * zongjia = [NSString stringWithFormat:@"约%@元", [weakSelf.gujiDictionary objectForKey:@"zongjia"]];
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:zongjia];
            [str addAttribute:NSForegroundColorAttributeName value:RedColor range:NSMakeRange(1, str.length - 2)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(1, str.length - 2)];
            weakSelf.fyLabel.attributedText = str;
            weakSelf.gjFyBtn.enabled = YES;
        } else {
            weakSelf.fyLabel.text = @"";
            weakSelf.fyLabel.attributedText = nil;
            weakSelf.gjFyBtn.enabled = NO;
        }
    } error:^(NSError *error) {
        [weakSelf delayHidHUD:MESSAGE_NoNetwork];
    } completed:^{
        
    }];
}

#pragma mark 底部button点击事件
// 我的行程点击事件
- (void)wodeXingChengClicked:(UIButton *)sender
{
//    EZZYDrivingViewController *drivingViewController = [[EZZYDrivingViewController alloc] init];
//    drivingViewController.polyArray = self.polyArray;
//    [self.navigationController pushViewController:drivingViewController animated:YES];
//    return;
    
    self.polyBool = !self.polyBool;
    if (self.polyBool) {
        [self.mapView removeOverlays:self.polyArray];
    } else {
        [self.mapView addOverlays:self.polyArray];
    }
    if (self.polyArray.count == 0) {
        // 自定义折线范围控制
        [self getZheXianFanWeiKongZhi];
    }
    
    /**
    if (!self.config.loginStatue) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ECarLogin" bundle:[NSBundle mainBundle]];
        UIViewController *controller = (UIViewController *)[storyboard instantiateInitialViewController];
        [self.navigationController presentViewController:controller animated:NO completion:nil];
        return;
    }
    ECarOrderViewController * orderVC = [[ECarOrderViewController alloc] init];
    orderVC.mainViewOrder = 5;
    orderVC.orderDelegate = self;
    [self.navigationController pushViewController:orderVC animated:YES];
     */
}

// 输入目的地点击事件
- (void)mudidiButtonCliecked:(UIButton *)sender
{
//    [self sousuoliebiao];
}

// 电子罗盘归位点击事件
- (void)luoPanButtonClicked:(UIButton *)sender
{
    [self.mapView setZoomLevel:15.f animated:YES];
    [self.mapView setCenterCoordinate:self.userCoordinate animated:YES];
    [self.mapView setRotationDegree:0 animated:YES duration:0.2];
    
    [self fetchCarLocationDataisAll:YES andLocationCoordinate:CLLocationCoordinate2DMake(self.userCoordinate.latitude, self.userCoordinate.longitude)];
}

// 车辆列表点击事件
- (void)rightClick
{
    weak_Self(self);
    ECarTableController * carLsitVC=[[ECarTableController alloc ] init];
    
    carLsitVC.refrashBlock = ^(){
        [weakSelf fetchCarLocationDataisAll:YES andLocationCoordinate:CLLocationCoordinate2DMake(0, 0)];
    };
    carLsitVC.backBlock = ^(ECarCarInfo * car){
        weakSelf.hiddenDetailView = YES;
        weakSelf.carInfo = car;
        weakSelf.selectCar = car;
        [weakSelf detailViewHidde:NO];
        [weakSelf refreshDetailViewWithModel:car];
        
        CGPoint carpoint = [weakSelf.mapView convertCoordinate:CLLocationCoordinate2DMake(car.carLatitude.floatValue, car.carlongitude.floatValue) toPointToView:weakSelf.view];
        CGPoint centerpoint = CGPointMake(carpoint.x, carpoint.y + 216 / 667.f * kScreenH);
        CLLocationCoordinate2D coordinat = [weakSelf.mapView convertPoint:centerpoint toCoordinateFromView:weakSelf.view];
        [weakSelf.mapView setCenterCoordinate:coordinat animated:YES];
        
        /*
         if (car == nil)
         {
         UIAlertView *serviceAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"附近没有车辆" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
         [serviceAlert show];
         return;
         }
         weakSelf.selectCar = car;
         CheckLogin(weakSelf)
         ECarUser *user = self.config.user;
         if (![weakSelf checkUserInfoWithUser:user]) return;
         [weakSelf showHUD:@"正在预定..."];
         // 创建订单
         [weakSelf createOrder:car success:^{
         [weakSelf hideHUD];
         [weakSelf delayHidHUD:@"预定成功"];
         [weakSelf gotoFindCarNavi:car];
         } andFail:^(NSString *msg) {
         [weakSelf delayHidHUD:msg];
         }];
         */
    };
    [self.navigationController pushViewController:carLsitVC animated:YES];
}

- (void)refreshDetailViewWithModel:(ECarCarInfo *)carIngfo
{
    self.detailView.carInfo = carIngfo;
}

- (void)leftClick
{
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    NSString *code = [[NSUserDefaults standardUserDefaults] objectForKey:@"verifyCode"];
    if (phone.length != 0||code.length != 0) {
        self.myCenter = [[ECarMyCenterViewController alloc] init];
        [ECarConfigs shareInstance].TokenID = code;
        self.myCenter.myCenterViewDelegate = self;
        UINavigationController * nv = [[UINavigationController alloc] initWithRootViewController:self.myCenter];
        [self.navigationController presentViewController:nv animated:NO completion:^{
            
        }];
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ECarLogin" bundle:[NSBundle mainBundle]];
        UIViewController *controller = (UIViewController *)[storyboard instantiateInitialViewController];
        [self.navigationController presentViewController:controller animated:NO completion:nil];
    }
}

#pragma mark - 车辆信息
- (void)createCarDetailView
{
    [self.view addSubview:self.detailView];
    [self.view bringSubviewToFront:self.detailView];
    [self detailViewHidde:YES];
    weak_Self(self);
    // 预订车辆
    [self.detailView theBookCarDetailFromModle:^(id model) {
        [self detailViewHidde:YES];
        if (model == nil)
        {
            UIAlertView *serviceAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"车辆不可用" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [serviceAlert show];
            return ;
        }
        
        weakSelf.selectCar = model;
        weakSelf.carInfo = model;
        if (!self.config.loginStatue) {
            UINavigationController *loginVC = StoryBoardViewController(@"ECarLogin", @"LoginNavigationController");
            ECarLoginViewController * login = (ECarLoginViewController *)loginVC.topViewController;
            login.denglutiaozhuan = DengLuTiaoZhuanTiaoZhuan;
            login.model = model;
            login.huidiaoBlock = ^(id model, ECarUser * user){
                if (![weakSelf checkUserInfoWithUser:user]) return;
                weakSelf.selectCar = model;
//                [weakSelf setShiYongButtonHiddenNo];
            };
            [weakSelf.navigationController presentViewController:loginVC animated:NO completion:nil];
            return;
        } else {
            ECarUser *user = self.config.user;
            if (![weakSelf checkUserInfoWithUser:user]) return;
            weakSelf.selectCar = model;
            [weakSelf shiYongButtonClicked:nil];
//            [weakSelf setShiYongButtonHiddenNo];
        }
    }];
}

#pragma mark - 导航调用
- (void)gotoFindCarNavi:(id)model
{
    ECarCarInfo * carin = model;
    weak_Self(self);
    self.warkingNaviewContoller = [[ECarMapNaviViewController alloc]
                                   initWithDelegate:self];
    CLLocationCoordinate2D userCoordinate = self.config.userCoordinate;
    weakSelf.startPoint = [AMapNaviPoint locationWithLatitude:userCoordinate.latitude longitude:userCoordinate.longitude];
    weakSelf.endPoint   = [AMapNaviPoint locationWithLatitude:carin.carLatitude.floatValue longitude:carin.carlongitude.floatValue];
    NSArray *startPoints = @[weakSelf.startPoint];
    NSArray *endPoints   = @[weakSelf.endPoint];
    weakSelf.naviType = NavigationTypeGPS;
//    self.mapView.showsUserLocation = NO;
    self.isWalkingNav = YES;
    self.navManagerTravelType = NavManagerTravelTypeWalk;
    self.warkingNaviewContoller.carInfo = carin;
    // 找车导航需判断是步行还是驾车找车
    BOOL success  = NO;
    [self showHUD:@"正在规划路径"];
    success = [weakSelf.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
    if (success) {
        
    } else {
        self.navManagerTravelType = NavManagerTravelTypeDefault;
    }
}

#pragma mark - 检测用户及车辆状态
- (BOOL)checkUserInfoWithUser:(ECarUser *)user
{
//    BOOL success = NO;
//    if ([user.islock isEqualToString:@"1"]) {
//        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"锁定" message:@"用户状态被锁定，如有疑问，请联系客服：400-6507265。" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
//        [alertV show];
//        return success;
//    }
//    if (user.userStatus == UserInfoStatusNull) {
//        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"未提交驾照信息" message:@"请前往个人中心提交驾照信息，审核通过后方可预定车辆" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
//        alertV.tag = AlertTagFanHuiGeRenZhongXin;
//        [alertV show];
//        return success;
//    }
//    if(user.userStatus == UserInfoStatusRefused){
//        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"审核不通过" message:@"您提交的驾照信息审核不通过，请前往个人中心重新提交" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
//        alertV.tag = AlertTagFanHuiGeRenZhongXin;
//        [alertV show];
//        return success;
//    }
//    if (user.userStatus == UserPhotoInfoStatusReviewing) {
//        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"驾照信息审核中" message:@"您提交的驾照信息正在审核中，还不能预定车辆" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
//        [alertV show];
//        return success;
//    }
//    if ([self.mudiLabel.text isEqualToString:@"输入目的地"])
//    {
//        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入目的地，以便为您匹配合适的车辆" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
//        alertV.tag = AlertTagShuRuMuDiDi;
//        self.carListStatue = YES;
//        [alertV show];
//        return success;
//    }
    return YES;
}

#pragma mark - 地图delegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        if (self.config.loginStatue == YES && self.registerJpushFirst == NO) {
            [self.manager sendUserLocationWithPhone:self.config.user.phone latitude:[NSString stringWithFormat:@"%lf", userLocation.coordinate.latitude] longtitude:[NSString stringWithFormat:@"%lf", userLocation.coordinate.longitude]];
            [self locationSuccessFromUser];
            self.mapView.showsUserLocation = YES;
            self.registerJpushFirst = YES;
        }
        // 取出当前位置的坐标
        if (userLocation.coordinate.latitude == self.userCoordinate.latitude && userLocation.coordinate.longitude == self.userCoordinate.longitude) {
            return;
        }
        self.userCoordinate = userLocation.coordinate;
        self.config.userCoordinate = userLocation.coordinate;
        if (!self.locationUserFirst) {
            [self fetchCarLocationDataisAll:YES andLocationCoordinate:CLLocationCoordinate2DMake(0, 0)];
//            [self locationUser];
//            [self.mapView stopUpdatingLocation];
            self.locationUserFirst = YES;
        }
    }
}

- (void)locationSuccessFromUser
{
    // 定位成功后
    self.locationSuccess = YES;
    CLLocationCoordinate2D userCoordinate = self.config.userCoordinate;
    AMapGeoPoint *startP = [AMapGeoPoint locationWithLatitude:userCoordinate.latitude longitude:userCoordinate.longitude];
    [[AMapSearchManager instance] locationRoadWithLatitude:startP.latitude longitude:startP.longitude success:^(NSString *road) {
        // 当前用户位置的所有信息
        if (road) {
            self.currentRoadInfo = road;
        }
    } faliure:^(NSString *error) {
        
    }];
}

/**
 * 添加大头针方法
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    weak_Self(self);
    if ([annotation isKindOfClass:[CustomAnnotationView class]])
    {
        CustomAnnotationView *p_annotation = (CustomAnnotationView *)annotation;
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = p_annotation.image;
        annotationView.sigleCount = p_annotation.sigleCount;
        annotationView.canShowCallout = NO;
        annotationView.centerOffset = CGPointMake(0, -15);
        if (p_annotation.carDataModel) {
            annotationView.carDataModel = p_annotation.carDataModel;
            annotationView.annotationCount = p_annotation.annotationCount;
        } else {
        }
        annotationView.coordinate = p_annotation.coordinate;
        annotationView.bookCarBlock = ^(id model){
            PDLog(@"预订车辆父类");
            if (weakSelf.bookBlock) {
                weakSelf.bookBlock(model);
            }
        };
        annotationView.hiddenDetailView = ^(){
            [weakSelf detailViewHidde:YES];
        };
        annotationView.salceMapView = ^(CLLocationCoordinate2D coordi) {
            [weakSelf.mapView setZoomLevel:(weakSelf.mapView.zoomLevel + 3) animated:YES];
            [weakSelf.mapView setCenterCoordinate:coordi animated:YES];
        };
        return annotationView;
    }
    return nil;
}

/**
 *  添加遮盖物回调方法
 */
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
//    if (overlay == mapView.userLocationAccuracyCircle){
//        MACircleView *accuracyCircleView = [[MACircleView alloc] initWithCircle:overlay];
//        accuracyCircleView.strokeColor  = [UIColor clearColor];
//        accuracyCircleView.fillColor    = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
//        return accuracyCircleView;
//    }
    // 添加图片遮盖物方法
    if ([overlay isKindOfClass:[MAGroundOverlay class]])
    {
        MAGroundOverlayView *groundOverlayView = [[MAGroundOverlayView alloc]
                                                  initWithGroundOverlay:overlay];
        return groundOverlayView;
    }
     // 添加折线方法
    if ([overlay isKindOfClass:[PDPolygon class]]) {
        PDPolygon * polyGon = (PDPolygon *)overlay;
        MAPolygonView * polyGonView = [[MAPolygonView alloc] initWithPolygon:overlay];
        polyGonView.lineWidth = 1.f;
        if (polyGon.polygonColorType == PolygonColorFanWei) {
            polyGonView.fillColor = [UIColor colorWithRed:243 / 255.f green:201 / 255.f blue:0 / 255.f alpha:0.3];
            polyGonView.lineWidth = 10.f;
            polyGonView.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        } else if (polyGon.polygonColorType == PolygonColorGreen) {
            polyGonView.fillColor = [UIColor colorWithRed:34 / 255.f green:160 / 255.f blue:140.f / 255.f alpha:0.6];
        } else if (polyGon.polygonColorType == PolygonColorYellow) {
            polyGonView.fillColor = [UIColor colorWithRed:252 / 255.f green:0 / 255.f blue:172.f / 255.f alpha:0.4];
        } else if (polyGon.polygonColorType == PolygonColorRed) {
            polyGonView.fillColor = [UIColor colorWithRed:224 / 255.f green:54 / 255.f blue:134 / 255.f alpha:0.4];
        }
        polyGonView.lineJoinType = kMALineJoinRound;
        return polyGonView;
    }
    return nil;
}

/**
 *  大头针选择代理回调方法
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if (![view isKindOfClass:[CustomAnnotationView class]]) {
        [view setSelected:NO animated:NO];
    } else {
        [view setSelected:YES animated:NO];
    }
}

/**
    地图可见区域改变
 */
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.salcus = self.mapView.zoomLevel;
    if (self.annotationAry.count == 0) {
        return;
    }
    [self hebingAnnotations];
}

/**
    地图点击事件
 */
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (_detailView) {
        [self detailViewHidde:YES];
    }
}

#pragma mark - 导航代理方法
/**
 *  导航消失
 */
- (void)naviManager:(AMapNaviManager *)naviManager didDismissNaviViewController:(UIViewController *)naviViewController
{
    self.persentNav = NO;
    // 退出导航界面后恢复地图的状态
    if (self.config.exitTag == ExitNaviTagOpenLockSuccess) {
        [self delayHidHUD:@"正在计算价格"];
        //开锁成之后出现行车导航按钮
        [self ezzyDrivingCar];
    }
}

//#pragma mark 行车导航
//- (void)drivingNavi
//{
//    self.dringNaviViewController = [[ECarDrivingViewController alloc]
//                                    initWithDelegate:self];
//    CLLocationCoordinate2D userCoordinate = self.config.userCoordinate;
//    self.startPoint = [AMapNaviPoint locationWithLatitude:userCoordinate.latitude longitude:userCoordinate.longitude];
//    self.endPoint = [AMapNaviPoint locationWithLatitude:self.userDestitation.location.latitude longitude:self.userDestitation.location.longitude];
//    NSArray *startPoints = @[self.startPoint];
//    NSArray *endPoints   = @[self.endPoint];
//    self.naviType = NavigationTypeGPS;
//    self.navManagerTravelType = NavManagerTravelTypeDring;
//    self.isWalkingNav = NO;
//    BOOL suceess = [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
//    self.mapView.showsUserLocation = NO;
//    [self showHUD:@"正在规划导航路线"];
//    if (suceess) {
//    } else {
//        [self hideHUD];
//        self.navManagerTravelType = NavManagerTravelTypeDefault;
//    }
//}

- (void)ezzyDrivingCar
{
    EZZYDrivingViewController *drivingViewController = [[EZZYDrivingViewController alloc] init];
    drivingViewController.polyArray = self.polyArray;
    drivingViewController.carInfo = self.selectCar;
    drivingViewController.drivingDelegate = self;
    [drivingViewController checkLanYa];
    self.naviType = NavigationTypeGPS;
    self.navManagerTravelType = NavManagerTravelTypeDring;
    self.isWalkingNav = NO;
    [self.navigationController pushViewController:drivingViewController animated:NO];
}

- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
    [self hideHUD];
    if (self.navManagerTravelType == NavManagerTravelTypeWalk) {
        [self delayHidHUD:@"预定成功"];
        self.warkingNaviewContoller.showUIElements = NO;
        [self.warkingNaviewContoller initFindCarButtonView];
        self.warkingNaviewContoller.findType = FindCarTypeNormal;
        self.warkingNaviewContoller.mapNaviDelegate = self;
        [self.warkingNaviewContoller checkLanYa];
        self.warkingNaviewContoller.viewShowMode = AMapNaviViewShowModeCarNorthDirection;
        [self.naviManager presentNaviViewController:self.warkingNaviewContoller animated:NO];
    }
//    else if (self.navManagerTravelType == NavManagerTravelTypeDring) {
//        [self delayHidHUD:@"规划成功"];
//        [self presentDrivingViewWithModel:self.selectCar];
//        
//    }
}

- (void)naviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error
{
    [self hideHUD];
    [self delayHidHUD:@"无网络，请稍后再试"];
    self.navManagerTravelType = NavManagerTravelTypeDefault;
}

/**
 *  导航将要出现
 */
- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
{
    self.naviManager.isRecalculateRouteForYaw = YES;
//    if (self.bottomView.hidden == NO) {
//        [self quxiaoButtonClicked:nil];
//    }
    self.persentNav = YES;
//    [self.mapView removeOverlays:self.ecarsAry];
//    [self.mapView removeAnnotations:self.annotationAry];
    if (self.naviType == NavigationTypeGPS)
    {
        [self.naviManager startGPSNavi];
    }
    else if (self.naviType == NavigationTypeSimulator)
    {
        [self.naviManager startGPSNavi];
    }
}

/**
 *  导航取消按钮点击
 */
- (void)naviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController
{
    if (self.naviType != NavigationTypeNone)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            if (self.iFlySpeechSynthesizer) {
                [self.iFlySpeechSynthesizer stopSpeaking];
            }
        });
        [self.naviManager stopNavi];
    }
    [self.naviManager dismissNaviViewControllerAnimated:NO];
    
//    if ([naviViewController isKindOfClass:[ECarDrivingViewController class]]) {
//        [self addzhifuViewJieshu];
//    }
//    self.mapView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
//    [self configMagView];
//    self.isWalkingNav = NO;
//    self.navManagerTravelType = NavManagerTravelTypeDefault;
//    self.mapView.showsCompass = NO;
//    self.mapView.showsScale = NO;
//    if (!(self.config.exitTag == ExitNaviTagOpenLockSuccess)) {
//        // 开锁成之后出现行车导航按钮
////        self.mudiLabel.text = @"输入目的地";
//        self.mapView.showsUserLocation = YES;
//        self.mapView.showsLabels = YES;
//        [self fetchCarLocationDataisAll:YES andLocationCoordinate:self.userCoordinate];
//    }
    [self fetchCarLocationDataisAll:YES andLocationCoordinate:self.userCoordinate];
    if (_detailView) {
        [self detailViewHidde:YES];
    }
}

- (void)endOrderBackZhiFu
{
    [self hideHUD];
    [self fetchCarLocationDataisAll:YES andLocationCoordinate:CLLocationCoordinate2DMake(self.userCoordinate.latitude, self.userCoordinate.longitude)];
    [self addzhifuViewJieshu];
}

#pragma mark 添加支付界面
- (void)addzhifuViewJieshu
{
    ECarConfigs * config = self.config;
    if (config.currentPrice.floatValue < 0.01) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本次用车没有发生费用，欢迎下次用车" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    ECarZhiFuViewController *zhifu = [[ECarZhiFuViewController alloc] init];
    zhifu.panduan = YES;
    zhifu.priceCar = config.currentPrice;
    zhifu.orderID = config.orignOrderNo;
    zhifu.view.frame = self.view.bounds;
    [self.navigationController pushViewController:zhifu animated:NO];
}

/*!
 @brief 导航界面转向指示View点击时的回调函数
 */
- (void)naviViewControllerTurnIndicatorViewTapped:(AMapNaviViewController *)naviViewController
{
    [self.naviManager readNaviInfoManual];
}

/*!
 @brief 模拟和GPS导航过程中,导航信息有更新后的回调函数
 @param naviInfo 当前的导航信息
 */
- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviInfo:(AMapNaviInfo *)naviInfo
{
    if (self.navManagerTravelType == NavManagerTravelTypeWalk && self.isWalkingNav) {
        ECarConfigs * config = self.config;
        config.carAndPersonDistancs = naviInfo.routeRemainDistance;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAMapNaviInfo" object:naviInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDrivingNaviInfo" object:naviInfo];
}

// 导航位置更新
- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviLocation:(AMapNaviLocation *)naviLocation
{
    self.userCoordinate = CLLocationCoordinate2DMake(naviLocation.coordinate.latitude, naviLocation.coordinate.longitude);
    self.config.userCoordinate = CLLocationCoordinate2DMake(naviLocation.coordinate.latitude, naviLocation.coordinate.longitude);
}


/**
 *  导航到达目的地导航消失回调函数
 */
- (void)naviManagerDidEndEmulatorNavi:(AMapNaviManager *)naviManager
{
    if (self.navManagerTravelType == NavManagerTravelTypeWalk) {
        CustomAnnotationView *pointAnnotation = [[CustomAnnotationView alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.selectCar.carLatitude.floatValue, self.selectCar.carlongitude.floatValue);
        pointAnnotation.image = [UIImage imageNamed:@"cheweizhi33*49"];
        pointAnnotation.carDataModel = self.selectCar;
        [self.annotationAry addObject:pointAnnotation];
        [self.mapView addAnnotations:self.annotationAry];
    }
}

/*!
 @brief 获取当前播报状态的回调函数
 @return 返回当前是否正在播报
 */
- (BOOL)naviManagerGetSoundPlayState:(AMapNaviManager *)naviManager
{
    return YES;
}

/*!
 @brief 导航播报信息回调函数
 @param soundString 播报文字
 @param soundStringType 播报类型，包含导航播报、前方路况播报和整体路况播报，参考AMapNaviSoundType
 */
- (void)naviManager:(AMapNaviManager *)naviManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSNumber * ison = [[NSUserDefaults standardUserDefaults] objectForKey:kSoundEffectIsOnKey];
    if (ison && ison.boolValue) {
        [self.iFlySpeechSynthesizer startSpeaking:soundString];
    }
}

#pragma mark - IFlySpeechSynthesizer语音导航代理
- (void)onCompleted:(IFlySpeechError *)error
{
    
}

#pragma mark - 订单代理方法
- (void)presentDringNavigationWithModel:(OrderModel *)model andCarInfo:(ECarCarInfo *)carInfo
{
    self.selectCar = carInfo;
    [self ezzyDrivingCar];
    
//    self.dringNaviViewController = [[ECarDrivingViewController alloc]
//                                    initWithDelegate:self];
    
//    CLLocationCoordinate2D userCoordinate = self.config.userCoordinate;
//    self.startPoint = [AMapNaviPoint locationWithLatitude:userCoordinate.latitude longitude:userCoordinate.longitude];
//    self.endPoint = [AMapNaviPoint locationWithLatitude:model.endPLatitude.doubleValue longitude:model.endPLongitude.doubleValue];
//    NSArray *startPoints = @[self.startPoint];
//    NSArray *endPoints   = @[self.endPoint];
//    self.naviType = NavigationTypeGPS;
//    self.selectCar = carInfo;
//    self.isWalkingNav = NO;
//    self.navManagerTravelType = NavManagerTravelTypeDring;
//    [self showHUD:@"正在规划路径..."];
//    BOOL success = [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
//    self.mapView.showsUserLocation = NO;
//    if (success) {
//        
//    } else {
//        [self hideHUD];
//        [self delayHidHUD:@"无网络，请稍后再试"];
//        self.navManagerTravelType = NavManagerTravelTypeDefault;
//    }
}

//- (void)presentDrivingViewWithModel:(ECarCarInfo *)carInfo
//{
//    self.dringNaviViewController.showTrafficBar = NO;
//    self.dringNaviViewController.showUIElements = NO;
//    self.dringNaviViewController.carInfo = carInfo;
//    self.dringNaviViewController.drivingDelegate = self;
//    self.dringNaviViewController.viewShowMode = AMapNaviViewShowModeCarNorthDirection;
//    [self.dringNaviViewController checkLanYa];
//    [self.naviManager presentNaviViewController:self.dringNaviViewController animated:NO];
//}

- (void)presentWarkingNavigationWithModel:(OrderModel *)model andCarInfo:(ECarCarInfo *)carInfo
{
    weak_Self(self);
    self.userDestitation = [[AMapPOI alloc] init];
    self.userDestitation.location = [AMapGeoPoint locationWithLatitude:39.90815613 longitude:116.3973999];
    self.warkingNaviewContoller = [[ECarMapNaviViewController alloc]
                                   initWithDelegate:self];
    self.warkingNaviewContoller.isYanShi = [model.isYanShi integerValue];
    self.warkingNaviewContoller.daojimiao = [model.yanShiTime integerValue];
    if ([model.isYanShi integerValue] == 1) {
        self.warkingNaviewContoller.daojimiao = [model.yanShiTime integerValue] - 15 * 60;
    }
    ECarCarInfo * car = [[ECarCarInfo alloc] init];
    car.carLatitude = model.carPLatitude;
    car.carlongitude = model.carPLongtitude;
    car.carno = model.carno;
    car.lanYaName = model.lanYaDic[@"lanYaName"];
    car.lanYaPassWord = model.lanYaDic[@"lanYaPassWord"];
    car.lanYaServiceName = model.lanYaDic[@"lanYaServiceName"];
    car.lanYaWriteCharacteristiceName = model.lanYaDic[@"lanYaWriteCharacteristiceName"];
    car.lanYaNotifyCharacteristiceName = model.lanYaDic[@"lanYaNotifyCharacteristiceName"];
    CLLocationCoordinate2D userCoordinate = self.config.userCoordinate;
    weakSelf.startPoint = [AMapNaviPoint locationWithLatitude:userCoordinate.latitude longitude:userCoordinate.longitude];
    weakSelf.endPoint   = [AMapNaviPoint locationWithLatitude:model.carPLatitude.doubleValue longitude:model.carPLongtitude.doubleValue];
    NSArray *startPoints = @[weakSelf.startPoint];
    NSArray *endPoints   = @[weakSelf.endPoint];
    weakSelf.naviType = NavigationTypeGPS;
    self.mapView.showsUserLocation = NO;
    self.navManagerTravelType = NavManagerTravelTypeWalk;
    self.warkingNaviewContoller.carInfo = car;
    self.selectCar = car;
    self.isWalkingNav = YES;
    // 找车导航需判断是步行还是驾车找车
    [self showHUD:@"正在规划路径..."];
    BOOL success  = NO;
    success = [weakSelf.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
    if (success) {
        
    } else {
        [self hideHUD];
        [self delayHidHUD:@"无网络，请稍后再试"];
        self.navManagerTravelType = NavManagerTravelTypeDefault;
    }
}

#pragma mark - 个人中心代理方法
- (void)clickedCellWithRow:(NSInteger)row
{
    switch (row)
    {
        case 0:
        {
            ECarFanWeiModel * model = [ECarFanWeiModel sharedECarFanWeiModel];
            if (model.fanWeiStatus) {
                [self getFanWeiKongZhi];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - ECarDrivingViewControllerDelegate （可删）
//- (void)zhifuViewPresentWithState:(BOOL)State
//{
//    weak_Self(self);
//    ECarZhiFuViewController * zhifu = [[ECarZhiFuViewController alloc] init];
//    zhifu.panduan = State;
//    zhifu.zhifublock = ^{
//        [weakSelf.naviManager presentNaviViewController:self.dringNaviViewController animated:NO];
//    };
//}

#pragma mark - ECarWorkingViewControllerDelegate
- (void)startSpeekingRoadInfo
{
    [self.naviManager readNaviInfoManual];
}

- (void)stopSpeekingRoadInfo
{
    [self.iFlySpeechSynthesizer stopSpeaking];
}

#pragma mark - UIAlertViewDelegate 弹出框代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == PopoverAlertTypeThree) {
        if (buttonIndex == 0) {
            if (self.popAlertView) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1047071972?mt=8"]];
            }
        } else {
            self.config.gengxinAlert = nil;
        }
    } else if (alertView.tag == AlertTagLianXiKeFu){
        if (buttonIndex == 0) {
            [ToolKit callTelephoneNumber:@"400-6507265" addView:self.view];
        }
    } else if (alertView.tag == AlertTagShuRuMuDiDi)
    {
        if (buttonIndex == 0) {
//            [self sousuoliebiao];
        }
    } else if (alertView.tag == AlertTagWeiWanChengDingDan && buttonIndex == 0) {
        if (self.dingdanDic) {
            OrderModel * model = [[OrderModel alloc] initWithContentsOfDic:self.dingdanDic];
            if (model.isfinish.intValue == 4) {
                [self addzhifuViewJieshuWithModel:model];
            } else if (model.isfinish.intValue == 1) {
                self.config.jinruZhuangTai = 10;
                self.config.orignOrderNo = model.orderID;
                ECarCarInfo * carInfo = [[ECarCarInfo alloc] init];
                carInfo.carLatitude = model.endPLatitude;
                carInfo.carlongitude = model.endPLongitude;
                carInfo.carno = model.carno;
                carInfo.lanYaName = model.lanYaDic[@"lanYaName"];
                carInfo.lanYaPassWord = model.lanYaDic[@"lanYaPassWord"];
                carInfo.lanYaServiceName = model.lanYaDic[@"lanYaServiceName"];
                carInfo.lanYaWriteCharacteristiceName = model.lanYaDic[@"lanYaWriteCharacteristiceName"];
                carInfo.lanYaNotifyCharacteristiceName = model.lanYaDic[@"lanYaNotifyCharacteristiceName"];
                [self presentDringNavigationWithModel:model andCarInfo:carInfo];
            } else if (model.isfinish != nil && model.isfinish.intValue == 0) {
                [self showHUD:@"正在规划路线..."];
                self.config.orignOrderNo = model.orderID;
                [self presentWarkingNavigationWithModel:model andCarInfo:nil];
            }
        }
    } else if (alertView.tag == AlertTagFanHuiGeRenZhongXin)
    {
        if (buttonIndex == 0) {
            [self leftClick];
        }
    }
}

- (void)addzhifuViewJieshuWithModel:(OrderModel *)model
{
    ECarConfigs * config = self.config;
    config.orignOrderNo = model.orderID;
    if (model.rmb.floatValue < 0.001) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本次用车没有发生费用，欢迎下次用车" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    ECarZhiFuViewController *zhifu = [[ECarZhiFuViewController alloc] init];
    zhifu.panduan = YES;
    config.currentPrice = [NSString stringWithFormat:@"%@", model.rmb];
    zhifu.priceCar = [NSString stringWithFormat:@"%@", model.rmb];
    zhifu.orderID = model.orderID;
    [self.navigationController pushViewController:zhifu animated:NO];
}

#pragma mark 搜索列表
//- (void)sousuoliebiao
//{
//    weak_Self(self);
//    LocationCheck(weakSelf)
//    ECarInputViewController * destinationVC = [[ECarInputViewController alloc] init];
//    if (self.carListStatue) {
//        self.carListStatue = NO;
//        destinationVC.bookbackCar = ^(AMapPOI *poi){
//            weakSelf.userDestitation = poi;
//            weakSelf.mudiLabel.text = poi.name;
//            weakSelf.mdLabel.text = poi.name;
//            if ([weakSelf.mudiLabel.text isEqualToString:@"输入目的地"]) {
//                return ;
//            }
//            CheckLogin(weakSelf);
////            [weakSelf setShiYongButtonHiddenNo];
//        };
//    }
//    
//    // 目的地列表点击回调
//    destinationVC.destinationBlock = ^(AMapPOI *poi){
//        weakSelf.userDestitation = poi;
//        weakSelf.mudiLabel.text = poi.name;
//        weakSelf.mdLabel.text = poi.name;
//        // 输入目的地之后显示车辆信息
//        if (weakSelf.locationSuccess) {
//            [weakSelf fetchCarLocationDataisAll:NO andLocationCoordinate:CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude)];
//        }else{
//            // 定位失败
//            LocationCheck(weakSelf)
//        }
//    };
//    destinationVC.currentPOI = weakSelf.userDestitation;
//    [weakSelf.navigationController pushViewController:destinationVC animated:YES];
//}

/**
 - (void)sousuoliebiao
 {
    weak_Self(self);
    LocationCheck(weakSelf)
    ECarInputViewController * destinationVC = [[ECarInputViewController alloc] init];
    //    ECarFanWeiModel * model = [ECarFanWeiModel sharedECarFanWeiModel];
    if (self.carListStatue) {
    self.carListStatue = NO;
    destinationVC.bookbackCar = ^(AMapPOI *poi){
    weakSelf.userDestitation = poi;
    weakSelf.mudiLabel.text = poi.name;
    if ([weakSelf.mudiLabel.text isEqualToString:@"输入目的地"]) {
    return ;
    }
    CheckLogin(weakSelf);
    [weakSelf showHUD:@"正在预定..."];
    // 创建订单
    [weakSelf createOrder:weakSelf.selectCar success:^{
    [weakSelf hideHUD];
    [weakSelf delayHidHUD:@"预定成功"];
    [weakSelf gotoFindCarNavi:weakSelf.selectCar];
    } andFail:^(NSString *msg) {
    [weakSelf delayHidHUD:msg];
    }];
    };
    }
    // 目的地列表点击回调
    destinationVC.destinationBlock = ^(AMapPOI *poi){
    weakSelf.userDestitation = poi;
    weakSelf.mudiLabel.text = poi.name;
    // 输入目的地之后显示车辆信息
    if (weakSelf.locationSuccess) {
    [weakSelf fetchCarLocationDataisAll:NO andLocationCoordinate:CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude)];
    }else{
    // 定位失败
    LocationCheck(weakSelf)
    }
    };
    destinationVC.currentPOI = weakSelf.userDestitation;
    [weakSelf.navigationController pushViewController:destinationVC animated:YES];
 }
 */

#pragma mark - 获取车辆位置信息
- (void)fetchCarLocationDataisAll:(BOOL)isAll andLocationCoordinate:(CLLocationCoordinate2D)destination
{
    CLLocationCoordinate2D userCoordinate = self.config.userCoordinate;
    weak_Self(self);
    
    [[self.manager findNearCarsUserCoordinate:userCoordinate andDestination:destination andAllSelect:isAll] subscribeNext:^(id x) {
        NSMutableArray *carAry = x;
        weakSelf.ecarsAry = carAry;
        [weakSelf.mapView removeAnnotations:weakSelf.annotationAry];
        [weakSelf.annotationAry removeAllObjects];
        [weakSelf.mapView removeAnnotations:weakSelf.sigleAnnotation];
        if (carAry.count == 0) {
            [weakSelf delayHidHUD:@"附近没有车辆"];
        } else {
            for (ECarCarInfo *carInfo in carAry) {
                CustomAnnotationView *pointAnnotation = [[CustomAnnotationView alloc] init];
                pointAnnotation.coordinate = CLLocationCoordinate2DMake(carInfo.carLatitude.floatValue, carInfo.carlongitude.floatValue);
                pointAnnotation.carDataModel = carInfo;
                pointAnnotation.annotationCount = 1;
                [weakSelf.annotationAry addObject:pointAnnotation];
            }
            if (!self.persentNav) {
                [weakSelf hebingAnnotations];
            }
        }
    } error:^(NSError *error) {
        [weakSelf delayHidHUD:@"网络异常，请检查网络后重新操作"];
    } completed:^{
        
    }];
}

- (void)hebingAnnotations
{
    if (self.annotationAry.count == 0) {
        return;
    }
    if (self.salcus == 19.000000) {
        [self.mapView removeAnnotations:self.annotationAry];
        for (CustomAnnotationView * annotation in self.annotationAry) {
            annotation.annotationCount = 1;
        }
        [self.mapView addAnnotations:self.annotationAry];
        return;
    }
    CLLocationDistance a = self.mapView.region.span.latitudeDelta / 50.f;
    CLLocationDistance b = self.mapView.region.span.longitudeDelta / 50.f;
    CLLocationDistance radius = sqrt(a * a + b * b);
    NSMutableArray * annotations = [[NSMutableArray alloc] initWithArray:self.annotationAry];
    NSMutableArray * saveAnnotations = [[NSMutableArray alloc] init];
    int n = 1;
    while (0 < annotations.count) {
        n = 1;
        CustomAnnotationView * customAnnotation = [annotations firstObject];
        customAnnotation.annotationCount = n;
        NSMutableArray * deleAnnotation = [[NSMutableArray alloc] init];
        for (int j = 1; j < annotations.count; j++) {
            CustomAnnotationView * customsecond = annotations[j];
            if ([self.pdDistance isLocationNearToOtherLocation:customAnnotation.coordinate andSecondLocation:customsecond.coordinate andDistance:radius]) {
                n++;
                customAnnotation.annotationCount = n;
                [deleAnnotation addObject:customsecond];
            }
        }
        [saveAnnotations addObject:customAnnotation];
        [annotations removeObjectAtIndex:0];
        if (n > 1) {
            [annotations removeObjectsInArray:deleAnnotation];
        }
    }
    [self.mapView removeAnnotations:self.annotationAry];
    [self.mapView addAnnotations:saveAnnotations];
}

@end
