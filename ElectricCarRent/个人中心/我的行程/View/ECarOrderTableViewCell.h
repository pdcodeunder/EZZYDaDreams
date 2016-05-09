//
//  ECarOrderTableViewCell.h
//  ElectricCarRent
//
//  Created by 程元杰 on 15/11/6.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "UIViewExt.h"
@interface ECarOrderTableViewCell : UITableViewCell
{
    UILabel * _prototypeLabel;//订单表.
    
    UILabel *  _numbelLabel;//日期.
    
    UILabel * _stateLbale;//里程
    
    UILabel * _currentStateLabel;//价格
    
    UILabel * _movePlaceLabel;//上车地点
    
    UILabel * _carTypeLable;//下车地点
    
    UILabel * _prototypeLabels;//订单表
    
    UILabel *  _numbelLabels;//订单号
    
    UILabel * _stateLbales;//订单状态
    
    UILabel * _currentStateLabels;//当前环节
    
    UILabel * _movePlaceLabels;//上车地点
    
    UILabel * _carTypeLables;//车型
    
    UIImageView * _carImageViews;//车图片
    
    UILabel * _proLabel;
    
    UIImageView * _beginImageView;
    
    UIImageView * _endImageView;
}
@property(nonatomic,strong)OrderModel*model;
@property(nonatomic,strong)UIButton * button;

@end
