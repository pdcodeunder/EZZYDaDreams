//
//  ECarTableViewCell.h
//  ElectricCarRent
//
//  Created by 张钊 on 15/12/4.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ECarCarInfo.h"


@interface ECarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *carLichengLabel;
@property (weak, nonatomic) IBOutlet UILabel *carDistanceLabel;

@property (weak, nonatomic) IBOutlet UIView *carPowerImageView;

//- (void)refershCellWithModel:(ECarCarInfo * )model;

@end
