//
//  ECarFapiaoHistoryTableViewCell.h
//  ElectricCarRent
//
//  Created by 张钊 on 16/3/30.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ECarFapiaoHistoryModel;
@interface ECarFapiaoHistoryTableViewCell : UITableViewCell



@property (nonatomic, copy)NSString * leftStr;
@property (nonatomic, copy)NSString * rightStr;

@property (nonatomic, strong)UILabel * labelLeft;
@property (nonatomic, strong)UILabel * labelRight;

@property (nonatomic, strong)ECarFapiaoHistoryModel * model;

- (void)refershCellWithModel:(ECarFapiaoHistoryModel *)model;


@end
