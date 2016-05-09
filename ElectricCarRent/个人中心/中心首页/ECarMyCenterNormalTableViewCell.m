//
//  ECarMyCenterNormalTableViewCell.m
//  ElectricCarRent
//
//  Created by 彭懂 on 15/10/30.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarMyCenterNormalTableViewCell.h"

@implementation ECarMyCenterNormalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.tagImageView];
        [self.contentView addSubview:self.detailImageView];
        [self.contentView addSubview:self.titleLabel];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImageView *)tagImageView
{
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50 / 375.f * kScreenW, self.contentView.bounds.size.height / 2.f - 10, 20, 20)];
        _tagImageView.center = CGPointMake(50 / 375.f * kScreenW + 10, self.contentView.bounds.size.height / 2.f);
//        _tagImageView.image = [UIImage imageNamed:@"pc_setting"];
    }
    return _tagImageView;
}

- (UIImageView *)detailImageView
{
    if (!_detailImageView) {
        _detailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - 62 / 375.f * kScreenW , self.contentView.bounds.size.height / 2.f, 20, 20)];
        _detailImageView.center = CGPointMake(kScreenW - 62 / 375.f * kScreenW, self.contentView.bounds.size.height / 2.f);
        _detailImageView.image = [UIImage imageNamed:@"jiantou20*20"];
    }
    return _detailImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tagImageView.frame) + 8,  0, 150, self.contentView.bounds.size.height)];
        _titleLabel.font = FontType;
//        _titleLabel.textColor = GrayColor;
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)callService:(id)sender
{
    
}

@end
