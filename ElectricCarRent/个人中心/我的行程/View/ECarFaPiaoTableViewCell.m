//
//  ECarFaPiaoTableViewCell.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/3/30.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarFaPiaoTableViewCell.h"
#import "FaPiaoModel.h"

@interface ECarFaPiaoTableViewCell ()

@property (nonatomic, strong)UILabel * NYLabel;            //年月日
//@property (nonatomic, strong)UILabel * yuanLabel;          //时间
@property (nonatomic, strong)UILabel * beginLabel;         //开始位置
@property (nonatomic, strong)UILabel * orderLabel;         //订单
@property (nonatomic, strong)UILabel * endLabel;           //结束位置
@property (nonatomic, strong)UILabel * priceLabel;         //价格
@property (nonatomic, strong)UIImageView * beginImage;     //开始图片
@property (nonatomic, strong)UIImageView * endImage;       //结束图片
@property (nonatomic, strong)UIImageView * selecteButton;     //选中button

@end

@implementation ECarFaPiaoTableViewCell

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
    //button
    _selecteButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _selecteButton.center = CGPointMake(20 / 375.f * kScreenW, 45 / 667.f * kScreenH);
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
    
    _beginImage = [[UIImageView alloc] initWithFrame:CGRectMake(_NYLabel.left , _NYLabel.bottom + 10 / 667.f * kScreenH, 7.5 / 375.f * kScreenW, 7.5 / 375.f * kScreenW)];
    _beginImage.image = [UIImage imageNamed:@"起点"];
    [self.contentView addSubview:_beginImage];
    
    _beginLabel = [[UILabel alloc] initWithFrame:CGRectMake(_beginImage.right + 10 / 375.f * kScreenW, _beginImage.top - 5 / 667.f * kScreenH, 220 / 375.f * kScreenW, 20 / 667.f * kScreenH)];
    _beginLabel.font = FontType;
    _beginLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    [self.contentView addSubview:_beginLabel];
    
    _endImage = [[UIImageView alloc] initWithFrame:CGRectMake(_NYLabel.left, _beginImage.bottom + 15 / 667.f * kScreenH, 7.5 / 375.f * kScreenW, 7.5 / 375.f * kScreenW)];
    _endImage.image = [UIImage imageNamed:@"终点"];
    [self.contentView addSubview:_endImage];
    
    _endLabel = [[UILabel alloc] initWithFrame:CGRectMake(_beginImage.right + 10 / 375.f * kScreenW, _beginLabel.bottom + 3 / 667.f * kScreenH, 220 / 375.f * kScreenW, 20 / 667.f * kScreenH)];
    _endLabel.font = FontType;
    _endLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    [self.contentView  addSubview:_endLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView  addSubview:_priceLabel];
    
//    UIImageView * imaview = [[UIImageView alloc] initWithFrame:CGRectMake(20 / 375.f * kScreenW, 89 / 667.f * kScreenH, kScreenW - 20 / 375.f * kScreenW, 1)];
//    imaview.image = [UIImage imageNamed:@"kuang337*55"];
//    [self.contentView addSubview:imaview];
}

- (void)refreshViewWithModel:(FaPiaoModel *)model
{
    _NYLabel.text = [self creatTimeFromDate:model.fpTime];
    _orderLabel.text = [NSString stringWithFormat:@"订单号%@", model.fpNumber];
    _beginLabel.text = model.fpBeginAdd;
    _endLabel.text = model.fpEndAdd;
    NSString * str = [NSString stringWithFormat:@"%@元", model.fpPrice];
    NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc] initWithString:str];
    [attstr addAttribute:NSForegroundColorAttributeName value:RedColor range:NSMakeRange(0, str.length - 1)];
    [attstr addAttribute:NSFontAttributeName value:FontType range:NSMakeRange(0, str.length - 1)];
    _priceLabel.attributedText = attstr;
    CGSize size = [_priceLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_priceLabel.font,NSFontAttributeName, nil]];
    _priceLabel.frame = CGRectMake(kScreenW - size.width - 10, _selecteButton.top, size.width + 3, 20);
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
    ECarFaPiaoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"dfff"];
    if (!cell) {
        cell = [[ECarFaPiaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dfff"];
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
