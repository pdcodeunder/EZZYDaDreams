//
//  ECarWeiZhangTableViewCell.h
//  ElectricCarRent
//
//  Created by 彭懂 on 16/4/12.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECarWeiZhangModel;
@interface ECarWeiZhangTableViewCell : UITableViewCell

- (void)refreshUIWithModel:(ECarWeiZhangModel *)model;
+ (instancetype)createTableViewCellWithTableView:(UITableView *)tableView;

@end
