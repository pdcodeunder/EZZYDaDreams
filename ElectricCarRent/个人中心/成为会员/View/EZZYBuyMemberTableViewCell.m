//
//  EZZYBuyMemberTableViewCell.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/5/13.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "EZZYBuyMemberTableViewCell.h"
#import "EZZYOnSaleMemberModel.h"

@interface EZZYBuyMemberTableViewCell ()

@property (nonatomic, strong) UIImageView *selecteButton;
@property (nonatomic, strong) UILabel *monthlyLabel;
@property (nonatomic, strong) UILabel *yuanJiaLabel;
@property (nonatomic, strong) UILabel *daZheLabel;
@property (nonatomic, strong) UILabel *xianJiaLabel;

@end

@implementation EZZYBuyMemberTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
        self.selectStatus = NO;
    }
    return self;
}

- (void)createUI
{
    _selecteButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _selecteButton.center = CGPointMake(30 / 375.f * kScreenW, 27.5 / 667.f * kScreenH);
    [self.contentView addSubview:_selecteButton];
    
    CGFloat cellHeight = 55 / 667.0 * kScreenH;
    
    UILabel *yueLabel = [[UILabel alloc] initWithFrame:CGRectMake(_selecteButton.right + 20 / 375.f * kScreenW, 0, 150 / 375.f * kScreenW, cellHeight)];
    yueLabel.font = FontType;
    yueLabel.textColor = RedColor;
    [self.contentView addSubview:yueLabel];
    self.monthlyLabel = yueLabel;
    
    UILabel *yuanjiaLa = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100 / 375.f * kScreenW, cellHeight)];
    yuanjiaLa.right = 245.f / 375.f * kScreenW;
    yuanjiaLa.textAlignment = NSTextAlignmentRight;
    yuanjiaLa.textColor = GrayColor;
    yuanjiaLa.font = FontMinSize;
    [self.contentView addSubview:yuanjiaLa];
    self.yuanJiaLabel = yuanjiaLa;
    
    UILabel *dazheLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80 / 375.0 * kScreenW, cellHeight)];
    dazheLabel.right = 285.0 / 375.0 * kScreenW;
    dazheLabel.font = FontMinSize;
    dazheLabel.textColor = GrayColor;
    dazheLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:dazheLabel];
    self.daZheLabel = dazheLabel;
    
    UILabel *xianjiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150 / 375.f * kScreenW, cellHeight)];
    xianjiaLabel.right = kScreenW - 20 / 375.0 * kScreenW;
    xianjiaLabel.font = FontType;
    xianjiaLabel.textAlignment = NSTextAlignmentRight;
    xianjiaLabel.textColor = RedColor;
    [self.contentView addSubview:xianjiaLabel];
    self.xianJiaLabel = xianjiaLabel;
}

- (void)refreshCellViewWithModel:(EZZYOnSaleMemberModel *)model
{
    self.monthlyLabel.text = [NSString stringWithFormat:@"%@个月", model.mothly];
    self.xianJiaLabel.text = [NSString stringWithFormat:@"%@元", model.xianjia];
    
    if ([[NSString stringWithFormat:@"%@", model.mothly] isEqualToString:@"1"]) {
        return;
    }
    NSString *yuanj = [NSString stringWithFormat:@"%@元", model.yuanjia];
    NSInteger length = yuanj.length;
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:yuanj];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:GrayColor range:NSMakeRange(0, length)];
    [self.yuanJiaLabel setAttributedText:attri];
    self.daZheLabel.text = [NSString stringWithFormat:@"%@折", model.dazhe];
}

+ (instancetype)createTableViewCellWithTableView:(UITableView *)tableView
{
    EZZYBuyMemberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"efddsadfdsaf"];
    if (!cell) {
        cell = [[EZZYBuyMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"efddsadfdsaf"];
        cell.contentView.backgroundColor = WhiteColor;
        cell.backgroundColor = WhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setSelectStatus:(BOOL)selectStatus
{
    _selectStatus = selectStatus;
    if (selectStatus) {
        _selecteButton.image = [UIImage imageNamed:@"选中圈"];
    } else {
        _selecteButton.image = [UIImage imageNamed:@"danxuan"];
    }
}

@end
