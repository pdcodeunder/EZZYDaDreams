//
//  ECarCarDetailView.m
//  ElectricCarRent
//
//  Created by 彭懂 on 15/11/2.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarCarDetailView.h"
#import "ECarCarInfo.h"
#import <AMapNaviKit/MAMapKit.h>
#import "AMapSearchManager.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import "UIViewExt.h"

@implementation ECarCarDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WhiteColor;
         _imageArray = @[@"car32*12",@"dianchi21*9",@"weizhi16*19",@"buxingshijian14*24"];
         _titleArry = @[@"状况",@"续航里程",@"距您",@"步行时间",@"   "];
         [self creatSubViews];
         [self  datafromService];
         
    }
    return self;
}

- (void)addOtherView
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.locationLabel];
    
    [self addSubview:[self createGryLineWithFrame:CGRectMake(74 / 375.f * kScreenW, CGRectGetMaxY(self.locationLabel.frame) + 10, kScreenW - 74 / 375.f * kScreenW, 1) ]];
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 70 / 667.f * kScreenH, kScreenW, 53 / 667.f * kScreenH)];
    UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 12)];
    imageView1.center = CGPointMake(52 / 375.f * kScreenW, view1.bounds.size.height / 2.f);
    imageView1.image = [UIImage imageNamed:@"car32*12"];
    [view1 addSubview:imageView1];
    [self addSubview:view1];
}

/*
 // 1.2版本
- (UILabel *)enduranceLabel
{
    if (!_enduranceLabel) {
        _enduranceLabel = [[UILabel alloc] initWithFrame:CGRectMake(41, CGRectGetMaxY(self.titleLabel.frame) + 6, 120 / 320.f * kScreenW, 15)];
        _enduranceLabel.font = [UIFont systemFontOfSize:14];
        _enduranceLabel.textColor = [UIColor whiteColor];
        _enduranceLabel.text = @"";
        _enduranceLabel.numberOfLines = 0;
        //        _distanceLabel.backgroundColor = [UIColor purpleColor];
    }
    return _enduranceLabel;
}

- (UILabel *)distanceLabel
{
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(41, CGRectGetMaxY(self.enduranceLabel.frame) + 6, 120 / 320.f * kScreenW, 15)];
        _distanceLabel.font = [UIFont systemFontOfSize:14];
        _distanceLabel.textColor = [UIColor whiteColor];
        _distanceLabel.text = @"";
        _distanceLabel.numberOfLines = 0;
//        _distanceLabel.backgroundColor = [UIColor purpleColor];
    }
    return _distanceLabel;
}
*/

- (UIButton *)bookButton
{
    if (!_bookButton) {
        _bookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bookButton.frame = CGRectMake(0, self.bounds.size.height - 49, kScreenW, 49);
        _bookButton.titleLabel.font = [UIFont systemFontOfSize:23.f];
        [_bookButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bookButton setTitle:@"开始使用" forState:UIControlStateNormal];
        [_bookButton addTarget:self action:@selector(bookButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bookButton;
}

- (void)bookButtonClicked:(UIButton *)sender
{
    __block ECarCarInfo * blockInfo = self.carInfo;
    if (self.bookCarFromDetail) {
        self.bookCarFromDetail(blockInfo);
    }
}

- (void)afterDeleAction
{
    _bookButton.enabled = YES;
}

- (UIImageView *)detailImage
{
    if (!_detailImage) {
        _detailImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 / 320.f * kScreenW, 38, 100, 44)];
    }
    return _detailImage;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18 / 375.f * kScreenW, 10, kScreenW - 30, 25)];
        _titleLabel.font = FontSizeMax;
    }
    return _titleLabel;
}

- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) , 180 / 320.f * kScreenW, 25)];
        _locationLabel.font = FontSizeMiddle;
    }
    return _locationLabel;
}

- (void)theBookCarDetailFromModle:(BookCarFromDetail)bookCar
{
    self.bookCarFromDetail = bookCar;
}

- (UIView *)createGryLineWithFrame:(CGRect)rect
{
    UIView * view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = BlackColor;
    return view;
}

#pragma mark- 创建UI
- (void)creatSubViews
{
     _EcarNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(18/375.f*kScreenW, 20/667.f*kScreenH, 200, 19)];
     _EcarNumberLabel.text = @"京A888888";
     _EcarNumberLabel.font = [UIFont systemFontOfSize:14];
     [self addSubview: _EcarNumberLabel];
     
     //地址
     _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(20/375.f*kScreenW, 45/667.f*kScreenH, kScreenW - 20/375.f*kScreenW, 18)];
     _locationLabel.text = @"三里屯太古里南区";
     _locationLabel.textColor = GrayColor;
     _locationLabel.font = [UIFont systemFontOfSize:12];
     [self addSubview: _locationLabel];
     
     for (int i =0; i <5 ; i ++) {
         _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(90/375.f*kScreenW, (75+i*53)/667.f*kScreenH, kScreenW-80/320.f*kScreenW, 1)];
         _lineLabel.backgroundColor = GrayColor;
         [self addSubview: _lineLabel];
         
         _statuLabel = [[UILabel alloc] initWithFrame:CGRectMake(90/375.f*kScreenW, (101+i*53)/667.f*kScreenH, 100, 20)];
         _statuLabel.font = [UIFont systemFontOfSize:12];
         _statuLabel.textColor = GrayColor;
         _statuLabel.text = _titleArry[i];
         [self addSubview:_statuLabel];
     }
 
     _imageView = [[UIImageView alloc ] initWithFrame:CGRectMake(0,0,32,12)];
     _imageView.image = [UIImage imageNamed:_imageArray[0]];
     _imageView.center = CGPointMake(52/375.f*kScreenW,105/667.f*kScreenH);
     [self addSubview:_imageView];
     
     _xuhangImageView = [[UIImageView alloc ] initWithFrame:CGRectMake(0,0,21,9)];
     _xuhangImageView.image = [UIImage imageNamed:_imageArray[1]];
     _xuhangImageView.center = CGPointMake(52/375.f*kScreenW,158/667.f*kScreenH);
     
     [self addSubview:_xuhangImageView];
     
     _weiZhiimageView = [[UIImageView alloc ] initWithFrame:CGRectMake(0,0,16,19)];
     _weiZhiimageView.image = [UIImage imageNamed:_imageArray[2]];
     _weiZhiimageView.center = CGPointMake(52/375.f*kScreenW,208/667.f*kScreenH);
     [self addSubview:_weiZhiimageView];
     
     _peimageView = [[UIImageView alloc ] initWithFrame:CGRectMake(0,0,16,24)];
     _peimageView.image = [UIImage imageNamed:_imageArray[3]];
     _peimageView.center = CGPointMake(52/375.f*kScreenW,258/667.f*kScreenH);
     [self addSubview:_peimageView];
     
     _changLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 50, kScreenW, 1)];
     _changLineLabel.backgroundColor = GrayColor;
     [self addSubview: _changLineLabel];
    
     _starButton = [UIButton buttonWithType:UIButtonTypeCustom];
     _starButton.frame = CGRectMake(0, self.bounds.size.height - 49, kScreenW, 49);
     //    _starButton.backgroundColor = [UIColor orangeColor];
     [_starButton setTitle:@"开始使用" forState:UIControlStateNormal];
     _starButton.titleLabel.font = [UIFont systemFontOfSize:14];
     [_starButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
     [_starButton setTitleColor:[UIColor blackColor ] forState:UIControlStateNormal];
     [self addSubview:_starButton];
 }
 
 //服务获得的数据Label
 
 - (void)datafromService
 {
 _waiLable = [[UILabel alloc ] initWithFrame:CGRectMake(90/375.f*kScreenW,83/667.f*kScreenH , 40, 20)];
     _waiLable.text = [NSString stringWithFormat:@"内部"];
 _waiLable.font = [UIFont systemFontOfSize:14];
 
     for (int i = 0; i<2; i++) {
         _duihaoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((123+i*72)/375.f*kScreenW,88/667.f*kScreenH, 16, 10)];
         
         _duihaoImageView.image = [UIImage imageNamed:@"duigou16*10"];
         
         [self addSubview:_duihaoImageView];
     }
     
     [self addSubview:_waiLable];
     
     _neiBulabel = [[UILabel alloc ] initWithFrame:CGRectMake(163/375.f*kScreenW,83/667.f*kScreenH , 40, 20)];
     _neiBulabel.text = [NSString stringWithFormat:@"外部"];
     _neiBulabel.font = [UIFont systemFontOfSize:14];
     
     [self addSubview:_neiBulabel];
     
     _xuhangLabel = [[UILabel alloc ] initWithFrame:CGRectMake(90/375.f*kScreenW,135/667.f*kScreenH , 100, 20)];
     _xuhangLabel.text = [NSString stringWithFormat:@"108公里"];
     _xuhangLabel.font = [UIFont systemFontOfSize:14];
     
     [self addSubview:_xuhangLabel];
     
     _distanceLabel = [[UILabel alloc ] initWithFrame:CGRectMake(90/375.f*kScreenW,188/667.f*kScreenH , 100, 20)];
     _distanceLabel.text = [NSString stringWithFormat:@"73公里"];
     _distanceLabel.font = [UIFont systemFontOfSize:14];
     
     [self addSubview:_distanceLabel];
     
     _timeLable = [[UILabel alloc ] initWithFrame:CGRectMake(90/375.f*kScreenW,241/667.f*kScreenH , 100, 20)];
     _timeLable.text = [NSString stringWithFormat:@"50分钟"];
     _timeLable.font = [UIFont systemFontOfSize:14];
     
     [self addSubview:_timeLable];
 }
 
 #pragma mark - button点击事件
 
 - (void)buttonAction:(UIButton*)sender
 {
     __block ECarCarInfo * blockInfo = self.carInfo;
     if (self.bookCarFromDetail) {
         self.bookCarFromDetail(blockInfo);
     }
 }

- (void)setCarInfo:(ECarCarInfo *)carInfo
{
    _carInfo = carInfo;
    _EcarNumberLabel.text = [NSString stringWithFormat:@"%@", carInfo.carno];
    self.locationLabel.text = @"";
    [[AMapSearchManager instance] locationRoadWithLatitude:carInfo.carLatitude.floatValue longitude:carInfo.carlongitude.floatValue success:^(NSString *road) {
        self.locationLabel.text = road;
    } faliure:^(NSString *error) {
    }];
    self.xuhangLabel.text = [NSString stringWithFormat:@"%@公里", carInfo.Mileage];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2lf公里", carInfo.distance.doubleValue / 1000.f];
    self.timeLable.text = [NSString stringWithFormat:@"%@分钟", carInfo.duration];
}

@end
