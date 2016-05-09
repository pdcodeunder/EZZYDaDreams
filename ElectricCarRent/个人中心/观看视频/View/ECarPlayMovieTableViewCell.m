//
//  ECarPlayMovieTableViewCell.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/2/19.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarPlayMovieTableViewCell.h"
#import "ECarMovieModel.h"
#import "UIKit+AFNetworking.h"
#import "UIViewExt.h"

#define imgTitleWeith 10

@implementation ECarPlayMovieTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = WhiteColor;
        self.backgroundColor = WhiteColor;
        [self creatSubViews];
    }
    return self;
}

//创建子视图
- (void)creatSubViews
{
    _pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(23 / 375.f * kScreenW, 20 / 667.f * kScreenH, 139 / 375.f * kScreenW, 89 / 667.f * kScreenH)];
    [self.contentView addSubview:_pImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_pImageView.frame) + imgTitleWeith, _pImageView.frame.origin.y, kScreenW - CGRectGetMaxX(_pImageView.frame) - 23 / 375.f * kScreenW - 10, 35)];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_titleLabel];
    
    _jianJieLable = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_titleLabel.frame) + 5, _titleLabel.width, _pImageView.height - _titleLabel.height - 5)];
    _jianJieLable.textColor = RedColor;
    _jianJieLable.font = [UIFont systemFontOfSize:13];
    _jianJieLable.numberOfLines = 0;
    [self.contentView addSubview:_jianJieLable];
}

- (void)refrashSubViewsWithModel:(ECarMovieModel *)model
{
    [_pImageView setImageWithURL:[NSURL URLWithString:model.pictuerUrl] placeholderImage:[UIImage imageNamed:@"meiyoushipin139*89"]];
    _titleLabel.text = model.movieTitle;
    _jianJieLable.text = model.information;
}

@end
