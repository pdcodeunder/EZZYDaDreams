//
//  ECarCarDetailView.h
//  ElectricCarRent
//
//  Created by 彭懂 on 15/11/2.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECarCarInfo;
typedef void(^BookCarFromDetail)(id model);
//typedef void(^CarDetailFromView)(id model);
@interface ECarCarDetailView : UIView

/*
     // 1.2版本车辆信息详情
    @property (nonatomic, copy) CarDetailFromView carDetail;
    @property (nonatomic, strong) UIImageView * detailImage;
    @property (nonatomic, strong) UILabel * titleLabel;
    @property (nonatomic, strong) UILabel * locationLabel;
    @property (nonatomic, strong) UIButton * bookButton;
    @property (nonatomic, strong) UILabel * distanceLabel;
    @property (nonatomic, strong) UILabel * enduranceLabel;
 
    //- (void)theCarDetailFromViewModel:(CarDetailFromView)carDetail;
*/

@property (nonatomic, copy) BookCarFromDetail bookCarFromDetail;
@property (nonatomic, strong) ECarCarInfo * carInfo;
 
@property (nonatomic, strong) UIImageView * detailImage;    // 详细图片
@property (nonatomic, strong) UILabel * titleLabel;         // 标题
@property (nonatomic, strong) UILabel * locationLabel;      // 地址
@property (nonatomic, strong) UIButton * bookButton;        // 使用按钮
@property (nonatomic, strong) UILabel * distanceLabel;      // 距离
@property (nonatomic, strong) UILabel * xuhangLabel;     // 续航
@property (nonatomic, strong) UILabel *EcarNumberLabel;    //车牌号
@property (nonatomic, strong) UIImageView * imageView;  //汽车视图
@property (nonatomic, strong) UIImageView * xuhangImageView; // 续航图
@property (nonatomic, strong) UILabel * lineLabel;   //分割线
@property (nonatomic, strong) NSArray * imageArray;
@property (nonatomic, strong) UIImageView * distanceImageView;  //汽车视图
@property (nonatomic, strong) UIImageView * peimageView;  //ren视图
@property (nonatomic, strong) UIImageView * weiZhiimageView;  //ren视图
@property (nonatomic, strong) UILabel * statuLabel ;
@property (nonatomic, strong) NSArray * titleArry;
@property (nonatomic, strong) UILabel * neiBulabel;
@property (nonatomic, strong) UILabel * waiLable;
@property (nonatomic, strong) UILabel * timeLable;
@property (nonatomic, strong) UILabel * changLineLabel;
@property (nonatomic, strong) UIButton * starButton;
@property (nonatomic, strong) UIImageView * duihaoImageView;

- (void)theBookCarDetailFromModle:(BookCarFromDetail)bookCar;

@end
