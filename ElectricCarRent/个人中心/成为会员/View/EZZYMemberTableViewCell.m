//
//  EZZYMemberTableViewCell.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/4/11.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "EZZYMemberTableViewCell.h"
#import "EZZYMemberModle.h"

@interface EZZYMemberTableViewCell ()

@property (nonatomic, strong) UILabel *memberType;
@property (nonatomic, strong) UILabel *memberPrice;

@end

@implementation EZZYMemberTableViewCell

- (UILabel *)memberType
{
    if (!_memberType) {
        _memberType = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , kScreenW, 25 / 667.f * kScreenH )];
        _memberType.textAlignment = NSTextAlignmentCenter;
        _memberType.font = FontType;
        _memberType.center = CGPointMake(kScreenW / 2.0, 40 / 667.f * kScreenH);
    }
    return _memberType;
}

- (UILabel *)memberPrice
{
    if (!_memberPrice) {
        _memberPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, 45 / 667.f * kScreenH , kScreenW, 25 / 667.f * kScreenH )];
        _memberPrice.textAlignment = NSTextAlignmentCenter;
        _memberPrice.font = FontType;
        _memberPrice.textColor = RedColor;
    }
    return _memberPrice;
}

+ (instancetype)createTableViewCellWithTableView:(UITableView *)tableView
{
    EZZYMemberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"dfff"];
    if (!cell) {
        cell = [[EZZYMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dfff"];
        cell.contentView.backgroundColor = WhiteColor;
        cell.backgroundColor = WhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self.contentView addSubview:self.memberType];
//    [self.contentView addSubview:self.memberPrice];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(10 / 375.f * kScreenW, 78 / 667.f * kScreenH, kScreenW - 20 / 375.f * kScreenW, 1)];
    bottomView.backgroundColor = GrayColor;
    [self.contentView addSubview:bottomView];
}

- (void)refreshViewWithModel:(EZZYMemberModle *)model
{
    self.memberType.text = model.levelName;
}

@end
