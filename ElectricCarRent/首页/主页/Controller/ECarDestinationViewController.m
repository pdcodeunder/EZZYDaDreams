//
//  ECarDestinationViewController.m
//  ElectricCarRent
//
//  Created by LIKUN on 15/9/11.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarDestinationViewController.h"
#import "ECarMapManager.h"
#import "MBProgressHUD.h"
#import "NSString+Category.h"

#define WHITE_COLOR [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]
#define GRAY_COLOR [UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:1.0]

@interface ECarDestinationViewController () <UITextFieldDelegate,UISearchBarDelegate>

@property (strong, nonatomic) ECarMapManager *mapManager;
@property (strong, nonatomic) NSMutableArray *usualAddressAry;
@property (strong, nonatomic) UITextField *text;
@property (strong, nonatomic) NSMutableDictionary *homeCompanyDic;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (assign, nonatomic) BOOL chaoshi;
@property (assign, nonatomic) NSInteger biaoshi;
@property (strong, nonatomic) NSString * resameText;

@end

@implementation ECarDestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapManager = [ECarMapManager new];
    self.resameText = @"";
    self.biaoshi = 10000;
    [ECarConfigs shareInstance].biaoshi = 0;
    [self initData];
    [self setNavBar];
    [self setNavigationSearchBar];
    [self creatTableView];
    [self queryUsualAddress];
}

- (void)dealloc
{
    [ECarConfigs shareInstance].biaoshi = 0;
}

- (void)initData{
    [self fetchPlaceWithKeyword:@"中坤大厦"]; // 国家图书馆
}

- (void)setNavBar{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.font = [UIFont boldSystemFontOfSize:17.f];
    if (_intType == 1 && _HCType == 1) {
        label.text = @"家";
    } else if (_intType == 1 && _HCType ==2){
        label.text = @"工作";
    }else if(_intType == 2 && _HCType == 1) {
        
        label.text = @"家";
        
    }else if(_intType == 2 && _HCType == 2) {
        
        label.text = @"工作";
        
    }else{
        label.text = @"常用地址设置";
    }
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark --- 顶部搜索框
- (void)setNavigationSearchBar
{
    _text = [[UITextField alloc] init];
    _text.frame = CGRectMake(0, 64, kScreenW, 54);
    _text.backgroundColor = WHITE_COLOR;
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

#pragma mark - 搜索框代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [self delayHidHUD:@"请输入正确的地址"];
        return NO;
    }
    [self showHUD:@"请稍等..."];
    self.chaoshi = NO;
    [self.text resignFirstResponder];
    weak_Self(self);
    [self performSelector:@selector(chaoshiPanduan) withObject:nil afterDelay:4.f];
    NSString *key = self.text.text;
    key.biaoShiTag = [NSNumber numberWithInteger:50000];
    [[AMapSearchManager instance] searchPlaceWithKeywords:key city:@"beijing" success:^(NSArray *ary) {
        [weakSelf hideHUD];
        if (weakSelf.chaoshi) {
            return ;
        }
        weakSelf.chaoshi = YES;
        weakSelf.usualAddressAry = [NSMutableArray arrayWithArray:ary];
        AMapPOI * poiObj =[_usualAddressAry firstObject];
        [self.text resignFirstResponder];
        if (self.destinationBlock) {
            self.destinationBlock(poiObj);
        }
        [self.navigationController popViewControllerAnimated:YES];
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

- (void)fetchAroundWithKeys:(NSString *)key
{
    weak_Self(self);
    NSString *city =[ECarConfigs shareInstance].userCity;
    if (city.length == 0||city == nil) {
        city = @"beijing";
    }
    CLLocationCoordinate2D location = [ECarConfigs shareInstance].userCoordinate;
    AMapGeoPoint * point = [AMapGeoPoint locationWithLatitude:location.latitude longitude:location.longitude];
    [[AMapSearchManager instance] searchAroundPlaceWithUserLocation:point keywords:key city:city success:^(NSArray *ary) {
        weakSelf.usualAddressAry = [NSMutableArray arrayWithArray:ary];
        [weakSelf.fuzzySearchTable reloadData];
        [self hideHUD];
    } failure:^(NSString *error) {
        
    }];
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

#pragma mark - 创建TableView
- (void)creatTableView{
    _fuzzySearchTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
     self.fuzzySearchTable.frame = CGRectMake(0, CGRectGetMaxY(self.text.frame), kScreenW, kScreenH - CGRectGetMaxY(self.text.frame));
    _fuzzySearchTable.dataSource = self;
    _fuzzySearchTable.delegate = self;
    _fuzzySearchTable.backgroundColor = WHITE_COLOR;
    _fuzzySearchTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_fuzzySearchTable];
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

    cell.backgroundColor = WHITE_COLOR;
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
    AMapPOI *poiObj =_usualAddressAry[indexPath.row];
    
    [self.text resignFirstResponder];
    if (self.destinationBlock) {
        self.destinationBlock(poiObj);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
        _hud.mode = MBProgressHUDModeText;
        [self.view addSubview:_hud];
    }
    [_hud setLabelText:text];
    [_hud show:YES];
    [_hud hide:YES afterDelay:3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
