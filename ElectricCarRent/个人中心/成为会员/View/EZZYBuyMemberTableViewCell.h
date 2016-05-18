//
//  EZZYBuyMemberTableViewCell.h
//  ElectricCarRent
//
//  Created by 彭懂 on 16/5/13.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EZZYOnSaleMemberModel;

@interface EZZYBuyMemberTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL selectStatus;

+ (instancetype)createTableViewCellWithTableView:(UITableView *)tableView;

- (void)refreshCellViewWithModel:(EZZYOnSaleMemberModel *)model;

@end
