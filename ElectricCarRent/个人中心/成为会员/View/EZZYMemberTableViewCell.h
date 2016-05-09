//
//  EZZYMemberTableViewCell.h
//  ElectricCarRent
//
//  Created by 彭懂 on 16/4/11.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EZZYMemberModle;
@interface EZZYMemberTableViewCell : UITableViewCell

- (void)refreshViewWithModel:(EZZYMemberModle *)model;

+ (instancetype)createTableViewCellWithTableView:(UITableView *)tableView;

@end
