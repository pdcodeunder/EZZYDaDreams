//
//  MumberFaPiaoTableViewCell.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/3/30.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "MumberFaPiaoTableViewCell.h"
#import "MumberFaPiaoModel.h"

@interface MumberFaPiaoTableViewCell ()

@property (nonatomic, strong) UILabel * NYLabel;            //年月日
@property (nonatomic, strong) UILabel * VIPLabel;         //开始位置
@property (nonatomic, strong) UILabel * orderLabel;         //订单
@property (nonatomic, strong) UILabel * priceLabel;         //价格
@property (nonatomic, strong) UIImageView * selecteButton;     //选中ImageView

@end

@implementation MumberFaPiaoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubViews];
        self.selectStatus = NO;
    }
    return self;
}

- (void)creatSubViews
{
    //button
    _selecteButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _selecteButton.center = CGPointMake(20 / 375.f * kScreenW, 52 / 667.f * kScreenH);
    [self.contentView addSubview:_selecteButton];
    
    _NYLabel = [[UILabel alloc] initWithFrame:CGRectMake(_selecteButton.right + 15 / 375.f * kScreenW, 15 / 667.f *kScreenH, 200 / 375.f * kScreenW, 15 / 667.f * kScreenH)];
    _NYLabel.font = [UIFont systemFontOfSize:12];
    _NYLabel.textColor = [UIColor grayColor];
    [self.contentView  addSubview:_NYLabel];
    
    _orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 100 / 375.f * kScreenW, 15 / 667.f * kScreenH, 150 / 375.f * kScreenW, 15 / 667.f * kScreenH)];
    _orderLabel.right = kScreenW - 10 / 375.f * kScreenW;
    _orderLabel.font = [UIFont systemFontOfSize:12];
    _orderLabel.textAlignment = NSTextAlignmentRight;
    _orderLabel.textColor = [UIColor grayColor];
    [self.contentView  addSubview:_orderLabel];
    
    _VIPLabel = [[UILabel alloc] initWithFrame:CGRectMake(_NYLabel.left, _selecteButton.top, 200 / 375.f * kScreenW, 20)];
    _VIPLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_VIPLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_orderLabel.left, _VIPLabel.top, _orderLabel.width, _VIPLabel.height)];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView  addSubview:_priceLabel];
    
}

- (void)refreshViewWithModel:(MumberFaPiaoModel *)model
{
    _NYLabel.text = [self creatTimeFromDate:model.mfpTime];
    _orderLabel.text = [NSString stringWithFormat:@"订单号%@", model.mfpNumber];
    _VIPLabel.text = model.mfpType;
    NSString * str = [NSString stringWithFormat:@"%@元", model.mfpPrice];
    NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc] initWithString:str];
    [attstr addAttribute:NSForegroundColorAttributeName value:RedColor range:NSMakeRange(0, str.length - 1)];
    [attstr addAttribute:NSFontAttributeName value:FontType range:NSMakeRange(0, str.length - 1)];
    _priceLabel.attributedText = attstr;
}

// 时间戳转化为时间
-(NSString *)creatTimeFromDate:(NSNumber *)date
{
    double d=[date doubleValue];
    NSString * string=[NSString stringWithFormat:@"%f",d/1000];
    long long int date1 = (long long int)[string intValue];
    
    NSDate * date2=[NSDate dateWithTimeIntervalSince1970:date1];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date2];
    return dateString;
}

+ (instancetype)createTableViewCellWithTableView:(UITableView *)tableView
{
    MumberFaPiaoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"dfff"];
    if (!cell) {
        cell = [[MumberFaPiaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dfff"];
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
