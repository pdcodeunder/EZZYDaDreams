//
//  ECarHomeAndCompViewController.m
//  ElectricCarRent
//
//  Created by 程元杰 on 15/12/8.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarHomeAndCompViewController.h"
#import "UIViewExt.h"
#import "ECarDestinationViewController.h"
@interface ECarHomeAndCompViewController ()

@end

@implementation ECarHomeAndCompViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常用地址";
    [self setUsualAddress];

    self.view.backgroundColor = WhiteColor;
    [self creatCompannySubView];
    [self creatHomeSubView];
}

// 常用地址 家
- (void)creatHomeSubView
{
    _homeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20/375.f*kScreenW, 64, kScreenW-40, 55)];
    _homeImageView.image = [UIImage imageNamed:@"kuang337*55"];
    _homeImageView.userInteractionEnabled = YES;
    [self.view addSubview:_homeImageView];
    _xiaoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 16, 16)];
    
    _xiaoImageView.image = [UIImage imageNamed:@"jia16*16"];
    [_homeImageView addSubview:_xiaoImageView];
    _homesLabel = [[UILabel alloc] initWithFrame:CGRectMake(_xiaoImageView.right+10, 0, 20, 55)];
    _homesLabel.text  = @"家";
    _homesLabel.font = [UIFont systemFontOfSize:14];
    [_homeImageView addSubview:_homesLabel];
    
     _dizhiLabel = [[UILabel alloc] initWithFrame:CGRectMake(64/375.f*kScreenW, -10, 300, 55)];
    AMapPOI *homePOI = [self.usualDic objectForKey:@"home"];
    if ([homePOI.name isEqualToString:@"(null)"] || homePOI.name.length == 0) {
        _dizhiLabel.text = @" ";
    }else {
        _dizhiLabel.text  =[NSString stringWithFormat:@"%@",homePOI.name];
    }
    _dizhiLabel.font = [UIFont systemFontOfSize:14];
    _dizhiLabel.textColor = GrayColor;
    
    [_homeImageView addSubview:_dizhiLabel];
    _homeDetilLabel = [[UILabel alloc] initWithFrame:CGRectMake(64/375.f*kScreenW, 10, 300, 55)];
    if (homePOI.district== nil) {
        _homeDetilLabel.text = @" ";
        
    }else {
        
        _homeDetilLabel.text  =[NSString stringWithFormat:@"%@",homePOI.district];
    }

//    _homeDetilLabel.text  =[NSString stringWithFormat:@"%@",homePOI.district];
    _homeDetilLabel.font = [UIFont systemFontOfSize:14];
    
    [_homeImageView addSubview:_homeDetilLabel];
    UIButton * homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    homeButton.frame = _homeImageView.bounds;
    
    [_homeImageView addSubview:homeButton];

    [homeButton addTarget:self action:@selector(homeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}
//常用地址 公司

-(void)creatCompannySubView
{
    
    _compImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20/375.f*kScreenW, 64+55, kScreenW-40, 55)];
    _compImageView.image = [UIImage imageNamed:@"kuang337*55"];
    _compImageView.userInteractionEnabled = YES;
    [self.view addSubview:_compImageView];
    
    _xiaocompImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 18, 13)];
    _xiaocompImageView.image = [UIImage imageNamed:@"gong18*13"];
    [_compImageView addSubview:_xiaocompImageView];
    
    _compsLabel = [[UILabel alloc] initWithFrame:CGRectMake(_xiaoImageView.right+23, 0, 30, 55)];
    _compsLabel.text  = @"公司";
    _compsLabel.font = [UIFont systemFontOfSize:14];
    [_compImageView addSubview:_compsLabel];
    
    UIButton * homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = _compImageView.bounds;
    [_compImageView addSubview:homeButton];
    [homeButton addTarget:self action:@selector(compButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _copmDetillbel = [[UILabel alloc] initWithFrame:CGRectMake(64/375.f*kScreenW, 10, 300, 55)];
    AMapPOI *homePOI = [self.usualDic objectForKey:@"company"];
    if (homePOI.name == nil) {
        _copmDetillbel.text = @" ";
    }else {
        _copmDetillbel.text  =[NSString stringWithFormat:@"%@",homePOI.district];
    }
    _copmDetillbel.font = [UIFont systemFontOfSize:14];
    _compdizhiLable = [[UILabel alloc] initWithFrame:CGRectMake(64/375.f*kScreenW, -10, 300, 55)];
    if (homePOI.name == nil) {
        _compdizhiLable.text = @" ";
    }else {
        _compdizhiLable.text  =[NSString stringWithFormat:@"%@",homePOI.name];
    }
    _compdizhiLable.textColor = GrayColor;
    _compdizhiLable.font = [UIFont systemFontOfSize:14];
    [_compImageView addSubview:_compdizhiLable];
    [_compImageView addSubview:_copmDetillbel];
}

- (void)homeButtonAction:(UIButton*)sender
{
    ECarDestinationViewController * destinationVC = [[ECarDestinationViewController alloc] init];
    destinationVC.destinationBlock = ^(AMapPOI *poi){
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:poi.name,@"homeName",poi.district,@"homeDistrict",[NSNumber numberWithDouble:poi.location.latitude],@"homeLatitude",[NSNumber numberWithDouble:poi.location.longitude],@"homeLongitude", nil];
        
        _dizhiLabel.text =  [NSString stringWithFormat:@"%@",poi.name];
        _homeDetilLabel.text = [NSString stringWithFormat:@"%@",poi.district];
            [[NSUserDefaults standardUserDefaults]setObject:dic  forKey:@"Home"];
        [[NSUserDefaults standardUserDefaults]synchronize];
           [self setUsualAddress];
    };
    destinationVC.intType = self.intType;
    destinationVC.HCType = 1;
    [self.navigationController pushViewController:destinationVC animated:YES];
}
- (void)compButtonAction:(UIButton *)sender
{
    ECarDestinationViewController * destinationVC = [[ECarDestinationViewController alloc] init];
    destinationVC.destinationBlock = ^(AMapPOI *poi){
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:poi.name,@"companyName",poi.district,@"companyDistrict",[NSNumber numberWithDouble:poi.location.latitude],@"companyLatitude",[NSNumber numberWithDouble:poi.location.longitude],@"companyLongitude", nil];
        _compdizhiLable.text =  [NSString stringWithFormat:@"%@",poi.name];
        _copmDetillbel.text = [NSString stringWithFormat:@"%@",poi.district];
        [[NSUserDefaults standardUserDefaults]setObject:dic2  forKey:@"Company"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self setUsualAddress];
    };
    destinationVC.intType = self.intType;
    destinationVC.HCType = 2;
    [self.navigationController pushViewController:destinationVC animated:YES];
}

- (void)setUsualAddress
{
    NSDictionary *homeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"Home"];
    NSDictionary *companyDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"Company"];
    self.usualDic = [[NSMutableDictionary alloc]initWithCapacity:2];
    if (homeDic) {
        AMapPOI *poi = [AMapPOI new];
        poi.name = homeDic[@"homeName"];
        poi.district = homeDic[@"homeDistrict"];
        poi.location = [AMapGeoPoint locationWithLatitude:[homeDic[@"homeLatitude"]floatValue] longitude:[homeDic[@"homeLongitude"] floatValue]];
        [self.usualDic setObject:poi forKey:@"home"];
    }
    if (companyDic) {
        AMapPOI *poi = [AMapPOI new];
        poi.name = companyDic[@"companyName"];
        poi.district = companyDic[@"companyDistrict"];
        poi.location = [AMapGeoPoint locationWithLatitude:[companyDic[@"companyLatitude"]floatValue] longitude:[companyDic[@"companyLongitude"]floatValue]];
        [self.usualDic setObject:poi forKey:@"company"];
    }
    
}
@end
