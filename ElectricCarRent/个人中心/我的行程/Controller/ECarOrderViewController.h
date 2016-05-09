//
//  ECarOrderViewController.h
//  ElectricCarRent
//
//  Created by 程元杰 on 15/11/5.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarBaseViewController.h"
#import "OrderModel.h"

//@class OrderModel;
//@class ECarCarInfo;
@protocol ECarOrderViewControllerDelegate <NSObject>

- (void)presentDringNavigationWithModel:(OrderModel *)model andCarInfo:(ECarCarInfo *)carInfo;

- (void)presentWarkingNavigationWithModel:(OrderModel *)model andCarInfo:(ECarCarInfo *)carInfo;

@end

@interface ECarOrderViewController : ECarBaseViewController
{
    UITableView * _tableView;
    
    NSMutableDictionary *_showCellStatus;
    
    UIView * _bgView;
    
    UIImageView * _imageView;
    
    BOOL _isShow;
}

@property (nonatomic, assign) NSInteger mainViewOrder;

@property (nonatomic,retain) NSMutableArray *dataList;
@property(nonatomic, strong) OrderModel*model;
@property (nonatomic, assign) id <ECarOrderViewControllerDelegate> orderDelegate;

@end

