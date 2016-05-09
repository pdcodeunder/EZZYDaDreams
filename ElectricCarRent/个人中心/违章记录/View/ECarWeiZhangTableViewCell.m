//
//  ECarWeiZhangTableViewCell.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/4/12.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarWeiZhangTableViewCell.h"
#import "ECarWeiZhangModel.h"

@interface ECarWeiZhangTableViewCell ()

@property (nonatomic, strong) UILabel *wzTimeLabel;
@property (nonatomic, strong) UILabel *wzAddLabel;
@property (nonatomic, strong) UILabel *wzPriceLabel;
@property (nonatomic, strong) UILabel *wzKouFenLabel;

@end

@implementation ECarWeiZhangTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 6, 9)];
    imageView.image = [UIImage imageNamed:@"inturn"];
    [self.contentView addSubview:imageView];
    imageView.center = CGPointMake(kScreenW - 25 / 375.f * kScreenW, 72.5 / 667.f * kScreenH);
    
    CGFloat leftSpe = 20 / 375.0 * kScreenW;
    UILabel *time = [self createLabelWithFrame:CGRectMake(leftSpe, 10 / 667.f * kScreenH, 68 / 375.f * kScreenW, 25 / 667.f * kScreenH) andTitle:@"违章时间:"];
    [self.contentView addSubview:time];
    
    UILabel *address = [self createLabelWithFrame:CGRectMake(leftSpe, CGRectGetMaxY(time.frame), time.width, time.height) andTitle:@"违章地点:"];
    [self.contentView addSubview:address];
    
    UILabel *price = [self createLabelWithFrame:CGRectMake(leftSpe, CGRectGetMaxY(address.frame) + address.height, address.width, address.height) andTitle:@"罚单金额:"];
    [self.contentView addSubview:price];
    
    UILabel *koufen = [self createLabelWithFrame:CGRectMake(leftSpe, CGRectGetMaxY(price.frame), price.width, price.height) andTitle:@"违章扣分:"];
    [self.contentView addSubview:koufen];
    
    self.wzTimeLabel = [self createLabelWithFrame:CGRectMake(time.right, time.top, 190 / 375.f * kScreenW, time.height) andTitle:nil];
    [self.contentView addSubview:self.wzTimeLabel];
    
    self.wzAddLabel = [self createLabelWithFrame:CGRectMake(address.right, address.top + 2, self.wzTimeLabel.width, address.height) andTitle:nil];
    self.wzAddLabel.numberOfLines = 2;
    [self.contentView addSubview:self.wzAddLabel];
    
    self.wzPriceLabel = [self createLabelWithFrame:CGRectMake(price.right, price.top, self.wzAddLabel.width, price.height) andTitle:nil];
    [self.contentView addSubview:self.wzPriceLabel];
    
    self.wzKouFenLabel = [self createLabelWithFrame:CGRectMake(koufen.right, koufen.top, self.wzAddLabel.width, koufen.height) andTitle:nil];
    [self.contentView addSubview:self.wzKouFenLabel];
}

- (UILabel *)createLabelWithFrame:(CGRect)rect andTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.font = FontType;
    label.text = title;
    return label;
}

- (void)refreshUIWithModel:(ECarWeiZhangModel *)model
{
    self.wzTimeLabel.text = [self creatTimeFromDate:model.wzTime];
    CGSize size = [model.wzAddress boundingRectWithSize:CGSizeMake(self.wzAddLabel.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: FontType} context:nil].size;
    if (size.height > 20) {
        self.wzAddLabel.height = 2 * self.wzTimeLabel.height;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 9 / 667.f * kScreenH;// 字体的行间距
        NSDictionary *attributes = @{
                                     NSFontAttributeName:FontType,
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        self.wzAddLabel.attributedText = [[NSAttributedString alloc] initWithString:model.wzAddress attributes:attributes];
    } else {
        self.wzAddLabel.height = self.wzTimeLabel.height;
        self.wzAddLabel.text = model.wzAddress;
    }
    
    NSString *pri = [NSString stringWithFormat:@"%@元", model.wzPrice];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:pri];
    [attStr addAttribute:NSForegroundColorAttributeName value:RedColor range:NSMakeRange(0, model.wzPrice.length)];
    self.wzPriceLabel.attributedText = attStr;
    
    NSString *kouf = [NSString stringWithFormat:@"%@分", model.wzKouFen];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:kouf];
    [attr addAttribute:NSForegroundColorAttributeName value:RedColor range:NSMakeRange(0, model.wzKouFen.length)];
    self.wzKouFenLabel.attributedText = attr;
}

// 时间戳转化为时间
-(NSString *)creatTimeFromDate:(NSNumber *)date
{
    double d=[date doubleValue];
    NSString * string=[NSString stringWithFormat:@"%f",d / 1000];
    long long int date1 = (long long int)[string intValue];
    
    NSDate * date2=[NSDate dateWithTimeIntervalSince1970:date1];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date2];
    return dateString;
}

+ (instancetype)createTableViewCellWithTableView:(UITableView *)tableView
{
    ECarWeiZhangTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"pddd"];
    if (!cell) {
        cell = [[ECarWeiZhangTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pddd"];
        cell.contentView.backgroundColor = WhiteColor;
        cell.backgroundColor = WhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
