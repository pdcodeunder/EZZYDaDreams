//
//  ECarTableController.h
//  ElectricCarRent
//
//  Created by 程元杰 on 15/11/10.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "carListModel.h"
#import "ECarMapManager.h"
#import "ECarCarInfo.h"

@class ECarMapManager;
@interface ECarTableController : ECarBaseViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (nonatomic,strong) ECarMapManager * CYJmanager;
@property(nonatomic,strong)UIButton * rightButton;
@property(nonatomic,strong)UIView * buttonView;
@property(nonatomic,strong)NSArray * titleArray;
@property(nonatomic,strong)UIImageView * imageView;
@property(nonatomic,strong)UIView * bgView;
@property (nonatomic,assign) BOOL isChecked;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray*dataList;
@property(nonatomic,strong)ECarCarInfo * model;
@property(nonatomic,strong)NSString*oderNum;

typedef void (^carInfoBackBlock)(ECarCarInfo *car);
@property (nonatomic, copy) carInfoBackBlock backBlock;

typedef void (^refrashMapAnnotation)();
@property (nonatomic, copy) refrashMapAnnotation refrashBlock;

@end
