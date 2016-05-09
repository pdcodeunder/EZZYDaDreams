//
//  MumberFaPiaoTableViewCell.h
//  ElectricCarRent
//
//  Created by 彭懂 on 16/3/30.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MumberFaPiaoModel;
@interface MumberFaPiaoTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL selectStatus;

- (void)refreshViewWithModel:(MumberFaPiaoModel *)model;
+ (instancetype)createTableViewCellWithTableView:(UITableView *)tableView;

@end
