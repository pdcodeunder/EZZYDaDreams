//
//  ECarPlayMovieTableViewCell.h
//  ElectricCarRent
//
//  Created by 彭懂 on 16/2/19.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECarMovieModel;
@interface ECarPlayMovieTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *pImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel * timeLabel;
@property (strong, nonatomic) UILabel * ciShuLabel;
@property (strong, nonatomic) UIImageView * litleImageView;
@property (strong, nonatomic) UILabel * jianJieLable;

- (void)refrashSubViewsWithModel:(ECarMovieModel *)model;

@end
