//
//  ECarFaPiaoTableViewCell.h
//  ElectricCarRent
//
//  Created by 彭懂 on 16/3/30.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FaPiaoModel;
@interface ECarFaPiaoTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL selectStatus;

- (void)refreshViewWithModel:(FaPiaoModel *)model;

+ (instancetype)createTableViewCellWithTableView:(UITableView *)tableView;

@end
