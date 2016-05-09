//
//  ECarFapiaoHistoryTableViewCell.m
//  ElectricCarRent
//
//  Created by 张钊 on 16/3/30.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarFapiaoHistoryTableViewCell.h"
#import "ECarFapiaoHistoryModel.h"

@implementation ECarFapiaoHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.model = [[ECarFapiaoHistoryModel alloc]init];
        self.contentView.backgroundColor = WhiteColor;
        self.backgroundColor = WhiteColor;
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20/375.f*kScreenW, 0, kScreenW-40, 50 / 667.0f * kScreenH)];
    imageView1.image = [UIImage imageNamed:@"kuang337*55"];
    imageView1.userInteractionEnabled = YES;
    
//    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元",self.leftStr]];//替换为self.leftStr
//    [str addAttribute:NSForegroundColorAttributeName value:RedColor range:NSMakeRange(0, str.length - 1)];
    _labelLeft = [[UILabel alloc] initWithFrame:CGRectMake(20/375.f*kScreenW, 0, 200, 50 / 667.0f * kScreenH)];
//    _labelLeft.attributedText = str;
    _labelLeft.font = [UIFont systemFontOfSize:14.0f];
    [imageView1 addSubview:_labelLeft];
    
    CGFloat gap = imageView1.frame.size.width -( 16 + 220) / 375.f * kScreenW - _labelLeft.frame.size.width;
    _labelRight = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_labelLeft.frame) + gap, 0, 220 / 375.f * kScreenW, imageView1.frame.size.height)];
    _labelRight.textColor = [UIColor lightGrayColor];
//    _labelRight.text = [NSString stringWithFormat:@"%@",self.rightStr];
    _labelRight.font = [UIFont systemFontOfSize:14.0f];
    [imageView1 addSubview:_labelRight];
    
    [self.contentView addSubview:imageView1];
}

- (void)refershCellWithModel:(ECarFapiaoHistoryModel *)model{
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f元",[model.costs floatValue]]];
    [str addAttribute:NSForegroundColorAttributeName value:RedColor range:NSMakeRange(0, str.length - 1)];
    _labelLeft.attributedText = str;
    _labelRight.text = [self creatTimeFromDate:[NSNumber numberWithUnsignedInteger:[model.time integerValue]]] ;
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


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
