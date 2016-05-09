//
//  ECarOrderTableViewCell.m
//  ElectricCarRent
//
//  Created by 程元杰 on 15/11/6.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarOrderTableViewCell.h"
#import <CommonCrypto/CommonDigest.h>
@implementation ECarOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initSubViews];
        [self _initDataSubViews];
        //订单状态
        _button=[UIButton buttonWithType:UIButtonTypeCustom];
//        _button.frame = CGRectMake(100, self.size.height-80, 200, 50);
        _button.frame = CGRectZero;
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
    }
    return self;
}

-(void)_initDataSubViews
{
    _prototypeLabels = [[UILabel alloc] initWithFrame:CGRectZero];
    _prototypeLabels.font = [UIFont systemFontOfSize:14 ];
    [self.contentView addSubview:_prototypeLabels];
    
    _numbelLabels = [[UILabel alloc] initWithFrame:CGRectZero];
    _numbelLabels.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_numbelLabels];
    
    _stateLbales = [[UILabel alloc] initWithFrame:CGRectZero];
    _stateLbales.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_stateLbales];
    
    _currentStateLabels = [[UILabel alloc] initWithFrame:CGRectZero];
    _currentStateLabels.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_currentStateLabels];
    
    _movePlaceLabels = [[UILabel alloc] initWithFrame:CGRectZero];
    _movePlaceLabels.font = [UIFont systemFontOfSize:14];
    _movePlaceLabels.numberOfLines = 0;
    [self.contentView addSubview:_movePlaceLabels];
    
    _carTypeLables = [[UILabel alloc ] initWithFrame:CGRectZero];
    _carTypeLables.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_carTypeLables];
    
    //起止点图片
    _beginImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_beginImageView];
    
    _endImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_endImageView];
    
    _prototypeLabel.frame=CGRectMake(30, 50, 40, 15);
    NSString * proString=[NSString stringWithFormat:@"订单:"];
    _prototypeLabel.text=proString;
    
    _numbelLabel.frame=CGRectMake(30, _prototypeLabel.bottom+5, 200 / 375.0 * kScreenW, 15);
    NSString * numStr=[NSString stringWithFormat:@"日期:"];
    _numbelLabel.text=numStr;
    
    NSString * stateStr=[NSString stringWithFormat:@"里程:"];
    _stateLbale.frame=CGRectMake(30, _numbelLabel.bottom+5, 50,15 );
    _stateLbale.text=stateStr;
    
    NSString * currentStr=[NSString stringWithFormat:@"价格:"];
    _currentStateLabel.frame=CGRectMake(30, _stateLbale.bottom+5, 50, 15);
    _currentStateLabel.text=currentStr;
    
    //数据label
    _prototypeLabels.frame=CGRectMake(_prototypeLabel.right, 50, 200 / 375.0 * kScreenW, 15);
    _numbelLabels.frame=CGRectMake(_prototypeLabel.right, _prototypeLabel.bottom+5, kScreenW - _prototypeLabel.right - 30, 15);
    _stateLbales.frame=CGRectMake(_prototypeLabel.right, _numbelLabels.bottom+5, kScreenW - _prototypeLabel.right - 30, 15);
    _currentStateLabels.frame=CGRectMake(_prototypeLabel.right, _stateLbales.bottom+5, kScreenW - _prototypeLabel.right  - 30, 15);
}

-(void)_initSubViews
{
    _proLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_proLabel];

    _prototypeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _prototypeLabel.font = [UIFont systemFontOfSize:14 ];
    [self.contentView addSubview:_prototypeLabel];
    
    _numbelLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _numbelLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_numbelLabel];
    
    _stateLbale = [[UILabel alloc] initWithFrame:CGRectZero];
    _stateLbale.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_stateLbale];
    
    _currentStateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _currentStateLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_currentStateLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _prototypeLabels.text = _model.user_id;
   NSString *dateStr = [self creatTimeFromDate:_model.createdate];
    _numbelLabels.text = dateStr;
    
//    double dis=[_model.distance doubleValue];
    
    _stateLbales.text= [NSString stringWithFormat:@"%.2f公里",_model.distance.doubleValue/1000.0];
    NSString * str = [NSString stringWithFormat:@"%.2f", _model.rmb.floatValue];
    _currentStateLabels.text = str;
    _movePlaceLabels.frame=CGRectMake(_prototypeLabel.right, _currentStateLabels.bottom + 5, kScreenW - _prototypeLabel.right - 30, 40);
    _movePlaceLabels.text=_model.begin;
    _movePlaceLabels.numberOfLines = 0;
    _carTypeLables.frame=CGRectMake(_prototypeLabel.right, _movePlaceLabels.bottom-8, kScreenW - _prototypeLabel.right - 30, 40);
    _carTypeLables.text=_model.end;
    _carTypeLables.numberOfLines = 0;
    
    UIColor * color=[UIColor colorWithRed:224 / 255.f green:54 / 255.f blue:134 / 255.f alpha:1];
    UIColor * color1=[UIColor colorWithRed:28 / 255.f green:26 / 255.f blue:36 / 255.f alpha:1];
    NSArray * titleArray=@[@"未支付", @"进行中", @"已取消", @"已完成", @"已预定"];
    NSArray * colorArray=@[color,color1];
    //
    
    _button.frame=CGRectMake(30 / 320.f * kScreenW, 20, 50, 20);
    _button.layer.cornerRadius=5;
    
    _button.titleLabel.font=[UIFont boldSystemFontOfSize:13];
    if (_model.isfinish.intValue == 4) {
        [_button setTitle:titleArray[0] forState:UIControlStateNormal];
        _button.backgroundColor=colorArray[1];
    }else if (_model.isfinish.intValue==1 ){
        [_button setTitle:titleArray[1] forState:UIControlStateNormal];
         _button.backgroundColor=colorArray[1];
    }else if (_model.isfinish.intValue==0) {
        [_button setTitle:titleArray[4] forState:UIControlStateNormal];
        _button.backgroundColor=colorArray[1];
    } else if (_model.isfinish.intValue==5){
        [_button setTitle:titleArray[3] forState:UIControlStateNormal];
         _button.backgroundColor=colorArray[0];
    } else {
        [_button setTitle:titleArray[2] forState:UIControlStateNormal];
        _button.backgroundColor=colorArray[0];
    }
    //起止图片
    _beginImageView.frame=CGRectMake(35, _currentStateLabel.bottom+10, 19, 28);
    _beginImageView.image=[UIImage imageNamed:@"qidain39*57.png"];
    _endImageView.frame=CGRectMake(35, _beginImageView.bottom+5, 19, 28);
    _endImageView.image=[UIImage imageNamed:@"zhongdian39*57.png"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 时间戳转化为时间
-(NSString *)creatTimeFromDate:(NSNumber *)date
{
    double d=[date doubleValue];
    
    NSString * string=[NSString stringWithFormat:@"%f",d/1000];
    
    long long int date1 = (long long int)[string intValue];
    
    NSDate * date2=[NSDate dateWithTimeIntervalSince1970:date1];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date2];
    return dateString;
}

#pragma mark-buttton点击事件

-(void)buttonAction:(UIButton *)sender
{

}

@end
