//
//  ECarDestinationViewController.h
//  ElectricCarRent
//
//  Created by LIKUN on 15/9/11.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMapSearchManager.h"

@interface ECarDestinationViewController : ECarBaseViewController<UITableViewDataSource,UITableViewDelegate>

//@property (weak, nonatomic) IBOutlet UITableView *fuzzySearchTable;
@property (strong, nonatomic) UITableView *fuzzySearchTable;
typedef void (^DestinationBlock)(AMapPOI *poi);
@property (copy, nonatomic) DestinationBlock destinationBlock;
@property (strong ,nonatomic) AMapPOI *currentPOI;
@property (assign, nonatomic) int intType;
@property (assign, nonatomic) int HCType;
@end
