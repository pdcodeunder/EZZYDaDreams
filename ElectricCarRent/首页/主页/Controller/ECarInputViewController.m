/*
                           _oo0oo_
                          088888880
                          88" . "88
                          (| -_- |)
                           0\ = /0
                        ___/'---'\___
                      .' \\|     |// '.
                     / \\|||  :  |||// \
                    /_ ||||| -:- |||||- \
                   |   | \\\  -  /// |   |
                   | \_|  ''\---/''  |_/ |
                   \  .-\__  '-'  __/-.  /
                 ___'. .'  /--.--\  '. .'___
              ."" '<  '.___\_<|>_/___.' >'  "".
             | | : '-  \'.;'\ _ /';.'/ - ' : | |
             \  \ '_.   \_ __\ /__ _/   .-' /  /
         ====='-.____'.___ \_____/___.-'____.-'=====
                           '=---='
 
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                    佛祖保佑       永无BUG
 */

#import "ECarInputViewController.h"
#import "ECarMapManager.h"
#import "MBProgressHUD.h"
#import "ECarHomeAndCompViewController.h"
#import "ECarDestinationViewController.h"
#import "UIViewExt.h"
#import "ECarFanWeiModel.h"
#import "NSString+Category.h"

@interface ECarInputViewController ()<UITextFieldDelegate, UISearchBarDelegate, AMapSearchDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) ECarMapManager *mapManager;
@property (strong, nonatomic) NSMutableArray *usualAddressAry;
@property (strong, nonatomic) UITextField *text;
@property (strong, nonatomic) NSMutableDictionary *homeCompanyDic;
@property (strong, nonatomic) AMapSearchAPI * search;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (assign, nonatomic) BOOL chaoshi;
@property (assign, nonatomic) NSInteger biaoshi;
@property (strong, nonatomic) NSString * resameText;

@end

@implementation ECarInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.resameText = @"";
    self.biaoshi = 0;
    [ECarConfigs shareInstance].biaoshi = 0;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initData];
    [self setNavBar];
    [self setNavigationSearchBar];
    [self creatSubButton];
    [self creatTableView];
}

- (void)dealloc
{
    [ECarConfigs shareInstance].biaoshi = 0;
}

- (void)initData {
    [self fetchPlaceWithKeyword:@"中坤大厦"]; // 国家图书馆
}

- (void)setNavBar {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.font = [UIFont boldSystemFontOfSize:17.f];
    label.text = @"目的地查询";
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 顶部搜索框
- (void)setNavigationSearchBar
{
    _text = [[UITextField alloc] init];
    _text.frame = CGRectMake(0, 64, kScreenW, 54);
    _text.backgroundColor = WhiteColor;
    _text.returnKeyType = UIReturnKeySearch;
    _text.placeholder = @"输入目的地";
    _text.delegate = self;
    [_text addTarget:self action:@selector(textChangeClicked:) forControlEvents:UIControlEventEditingChanged];
    _text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _text.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIImageView *view = [[UIImageView alloc] init];
    view.image = [UIImage imageNamed:@"sousuo21*21"];
    view.frame = CGRectMake(15, 64, 44, 44);
    view.contentMode = UIViewContentModeCenter;
    _text.leftView = view;
    _text.leftViewMode = UITextFieldViewModeAlways;
    _text.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_text];
}

- (void)textChangeClicked:(UITextField *)textField
{
    if ([textField.text isEqualToString:self.resameText]) {
        return;
    }
    self.resameText = textField.text;
    [self fetchPlaceWithKeyword:textField.text]; // 国家图书馆
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length == 0) {
        [self delayHidHUD:@"请输入正确的地址"];
        return NO;
    }
    [self showHUD:@"请稍等..."];
    self.chaoshi = NO;
    [self.text resignFirstResponder];
    weak_Self(self);
    [self performSelector:@selector(chaoshiPanduan) withObject:nil afterDelay:8.f];
    NSString *key = self.text.text;
    key.biaoShiTag = [NSNumber numberWithInteger:50000];
    [[AMapSearchManager instance] searchPlaceWithKeywords:key city:@"beijing" success:^(NSArray *ary) {
        [weakSelf hideHUD];
        if (weakSelf.chaoshi) {
            return ;
        }
        weakSelf.chaoshi = YES;
        weakSelf.usualAddressAry = [NSMutableArray arrayWithArray:ary];
        AMapPOI *poiObj =[_usualAddressAry firstObject];
        [weakSelf yunYingFanWeiPanDuanWithPOI:poiObj];
    } failure:^(NSString *error) {
        [weakSelf hideHUD];
        [weakSelf delayHidHUD:@"请输入正确的地址"];
    }];
    return YES;
}

- (void)chaoshiPanduan
{
    if (self.chaoshi == YES) {
        return;
    }
    [self hideHUD];
    [self delayHidHUD:@"请输入正确的地址"];
    self.chaoshi = YES;
}

//创建三个地点 button
- (void)creatSubButton
{
    //家 button
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, _text.bottom, kScreenW, 92)];
    _bgView.backgroundColor = WhiteColor;
    [self.view addSubview:_bgView];
    _homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_homeButton setImage:[UIImage imageNamed:@"jia120*97"] forState:UIControlStateNormal];
        _homeButton.backgroundColor = WhiteColor;
    _homeButton.frame =CGRectMake(0, 0, kScreenW/2.0, 92);
    [_homeButton addTarget:self action:@selector(homeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_homeButton];
    //工作 button
    _workButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _workButton.frame =CGRectMake(_homeButton.right, 0,kScreenW/2.0, 92);
    [_workButton setImage:[UIImage imageNamed:@"gongsi120*97"] forState:UIControlStateNormal];
    [_workButton addTarget:self action:@selector(workAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_workButton];
   //永利国际 button
//    _yongLiButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _yongLiButton.frame =CGRectMake(_workButton.right, 0, kScreenW/3.0, 92);
//     [_yongLiButton setImage:[UIImage imageNamed:@"yongliguoji120*97"] forState:UIControlStateNormal];
//    [_yongLiButton addTarget:self action:@selector(yongLiAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_bgView addSubview:_yongLiButton];
   //视图线
    UILabel * bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _text.bottom, kScreenW, 1)];
    bottomLabel.backgroundColor = GrayColor;
    [self.view addSubview:bottomLabel];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, _bgView.bottom, kScreenW, 1)];
    label.backgroundColor = GrayColor;
    [self.view addSubview:label];
     UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(_homeButton.right, 0, 1, 92)];
    label1.backgroundColor = GrayColor;
    [_homeButton addSubview:label1];
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(_workButton.right,118, 1, 92)];
    label2.backgroundColor = GrayColor;
    [self.view addSubview:label2];
}

// 家点击事件
- (void)homeAction:(UIButton *)button
{
    CheckLogin(self);
    [self queryUsualAddress];
    AMapPOI *poiObj = [self.homeCompanyDic objectForKey:@"home"];
    if (poiObj.name == nil || poiObj.name.length == 0) {
        ECarHomeAndCompViewController * destinVC = [[ECarHomeAndCompViewController alloc] init];
        destinVC.intType = 1;
        [self.navigationController pushViewController:destinVC animated:YES];
    } else{
        [self yunYingFanWeiPanDuanWithPOI:poiObj];
    }
}

// 工作点击事件
- (void)workAction:(UIButton *)button
{
    CheckLogin(self);
    [self queryUsualAddress];
    AMapPOI *poi = [self.homeCompanyDic objectForKey:@"company"];
    if (poi.name == nil || poi.name.length == 0) {
        ECarHomeAndCompViewController * destinVC = [[ECarHomeAndCompViewController alloc] init];
        destinVC.intType = 2;
        [self.navigationController pushViewController:destinVC animated:YES];
    } else {
        [self yunYingFanWeiPanDuanWithPOI:poi];
    }
}

//永利国际点击事件
- (void)yongLiAction:(UIButton *)button
{
    AMapPOI *poi  = [[AMapPOI alloc] init];
    poi.name = @"永利国际停车场";
    CGFloat la = 39.935188;
    CGFloat lo = 116.443811;
    poi.location = [AMapGeoPoint locationWithLatitude:la longitude:lo];
//     CheckLogin(self);
    if (self.bookbackCar) {
        self.bookbackCar(poi);
    } else if (self.destinationBlock) {
        self.destinationBlock(poi);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)yunYingFanWeiPanDuanWithPOI:(AMapPOI *)poiObj
{
    ECarFanWeiModel * model = [ECarFanWeiModel sharedECarFanWeiModel];
    if (model.fanWeiStatus) {
        CGFloat poiLati = poiObj.location.latitude;
        CGFloat poiLong = poiObj.location.longitude;
        if ([self panduanFanWeiKongZhiWithCoordinate:CLLocationCoordinate2DMake(poiLati, poiLong)]) {
            if (self.bookbackCar) {
                self.bookbackCar(poiObj);
                [self.navigationController popViewControllerAnimated:YES];
            } else if (self.destinationBlock) {
                self.destinationBlock(poiObj);
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"车辆只能在运营区域内行驶，您的目的地超出运营区域" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            alertV.tag = 234;
            [alertV show];
        }
    } else {
        if (self.bookbackCar) {
            self.bookbackCar(poiObj);
            [self.navigationController popViewControllerAnimated:YES];
        } else if (self.destinationBlock) {
            self.destinationBlock(poiObj);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//创建列表视图
- (void)creatTableView
{
    _fuzzySearchTable = [[UITableView alloc]initWithFrame:CGRectMake(0, _bgView.bottom+1, kScreenW, kScreenH - 54 - 60 - 64) style:UITableViewStylePlain];
    _fuzzySearchTable.dataSource = self;
    _fuzzySearchTable.delegate = self;
    _fuzzySearchTable.backgroundColor = WhiteColor;
    _fuzzySearchTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_fuzzySearchTable];
}

- (void)fetchPlaceWithKeyword:(NSString *)key
{
    weak_Self(self);
    NSString *city =[ECarConfigs shareInstance].userCity;
    if (city.length == 0||city == nil) {
        city = @"beijing";
    }
    if (!self.usualAddressAry) {
        self.usualAddressAry = [[NSMutableArray alloc] init];
    }
    self.biaoshi ++;
    key.biaoShiTag = [NSNumber numberWithInteger:self.biaoshi];
    [[AMapSearchManager instance] searchPlaceWithKeywords:key city:city success:^(NSArray *ary) {
        [weakSelf.usualAddressAry removeAllObjects];
        [weakSelf.usualAddressAry addObjectsFromArray:ary];
        [weakSelf.fuzzySearchTable reloadData];
    } failure:^(NSString *error) {
        
    }];
}

#pragma mark ---- 获取常用地址
- (void)queryUsualAddress
{
    self.homeCompanyDic = [[NSMutableDictionary alloc]initWithCapacity:2];
    NSDictionary *homeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"Home"];
    NSDictionary *companyDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"Company"];
    if (homeDic) {
        AMapPOI *poi = [AMapPOI new];
        poi.name = homeDic[@"homeName"];
        poi.district = homeDic[@"homeDistrict"];
        poi.location = [AMapGeoPoint locationWithLatitude:((NSString *)homeDic[@"homeLatitude"]).floatValue longitude:((NSString *)homeDic[@"homeLongitude"]).floatValue];
        [self.homeCompanyDic setObject:poi forKey:@"home"];
    }
    if (companyDic) {
        AMapPOI *poi = [AMapPOI new];
        poi.name = companyDic[@"companyName"];
        poi.district = companyDic[@"companyDistrict"];
        poi.location = [AMapGeoPoint locationWithLatitude:((NSString *)companyDic[@"companyLatitude"]).floatValue longitude:((NSString *)companyDic[@"companyLongitude"]).floatValue];
        [self.homeCompanyDic setObject:poi forKey:@"company"];
    }
}

#pragma mark - tableview代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _usualAddressAry.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"SearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = WhiteColor;
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    AMapPOI * cellPOI = _usualAddressAry[indexPath.row];
    cell.textLabel.text = cellPOI.name;
    cell.detailTextLabel.text = cellPOI.businessArea;
    //     [cell setAddressData:_usualAddressAry[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    AMapPOI *poiObj =_usualAddressAry[indexPath.row];
    [self.text resignFirstResponder];
    [self yunYingFanWeiPanDuanWithPOI:poiObj];
}

// 判断点是否在运营范围内
- (BOOL)panduanFanWeiKongZhiWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    // 判断方形运营范围
    /**
    ECarFanWeiModel * model = [ECarFanWeiModel sharedECarFanWeiModel];
    CGFloat latitude = coordinate.latitude;
    CGFloat longitude = coordinate.longitude;
    CGFloat maxLati = model.topLeftPoint.latitude;
    CGFloat maxLong = model.bottomRightPoint.longitude;
    CGFloat minLati = model.bottomRightPoint.latitude;
    CGFloat minLong = model.topLeftPoint.longitude;
    if ((latitude >= minLati && latitude <= maxLati) && (longitude >= minLong && longitude <= maxLong)) {
        return YES;
    } else {
        return NO;
    }
     */
    
    // 判断折线运营范围
    ECarFanWeiModel * model = [ECarFanWeiModel sharedECarFanWeiModel];
    NSInteger nCross = 0;
    double x = coordinate.longitude;
    double y = coordinate.latitude;
    NSInteger verticesCount = [model.pointArr count];
    for (int i = 0; i < verticesCount; i++) {
        NSString * p1 = [model.pointArr objectAtIndex:i];
        NSString * p2 = [model.pointArr objectAtIndex:((i + 1) % verticesCount)];
        NSArray * pStr1 = [p1 componentsSeparatedByString:@","];
        NSArray * pStr2 = [p2 componentsSeparatedByString:@","];
        double p1x = [pStr1[0] doubleValue];
        double p1y = [pStr1[1] doubleValue];
        double p2x = [pStr2[0] doubleValue];
        double p2y = [pStr2[1] doubleValue];
        if (p1y == p2y) {
            continue;
        }
        // 交点在p1p2延长线上
        if (y < MIN(p1y, p2y)) {
            continue;
        }
        // 交点在p1p2延长线上
        if (y >= MAX(p1y, p2y)) {
            continue;
        }
        // 交点的x坐标
        double xx = ((y - p1y) * (p2x - p1x)) / (p2y - p1y) + p1x;
        // 统计单边交点
        if (xx > x) {
            nCross ++;
        }
    }
    // 单边交点为奇数，点在多边形之内
    if (nCross % 2 == 1) {
        return YES;
    } else {
        return NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.text resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.text resignFirstResponder];
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
