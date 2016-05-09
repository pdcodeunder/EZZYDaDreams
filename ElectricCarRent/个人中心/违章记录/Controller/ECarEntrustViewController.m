//
//  ECarEntrustViewController.m
//  ElectricCarRent
//
//  Created by 程元杰 on 16/4/13.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarEntrustViewController.h"
#import "ECarWeiZhangModel.h"

@interface ECarEntrustViewController ()

@property (nonatomic, strong)UILabel * handleType;
@property (nonatomic, strong)UILabel * timeLabel;
@property (nonatomic, strong)UILabel * addressLabel;
@property (nonatomic, strong)UILabel * priceLabel;
@property (nonatomic, strong)UILabel * countLabel;
@property (nonatomic, strong)UILabel * carType;
@property (nonatomic, strong)UILabel * carNumber;
@property (nonatomic, strong)UILabel * carColor;
@property (nonatomic, strong)UILabel * numberColor;
@property (nonatomic, strong)UILabel * orderNumber;
@property (nonatomic, strong)UILabel * beginTime;
@property (nonatomic, strong)UILabel * handleTime;
@property (nonatomic, strong)UILabel * xianLabel;
@property (nonatomic, strong)UITextView * diDianTextView;
@property (nonatomic, strong)UILabel * yuanYinLabel;
@property (nonatomic, strong)UITextView * reasonTextView;
@property (nonatomic, strong)UILabel * fnishLabel;

@property (nonatomic, strong) ECarWeiZhangModel *model;

@end

@implementation ECarEntrustViewController

- (instancetype)initWithModel:(ECarWeiZhangModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    [self creatSubViews];
}

- (UILabel *)createLabelFrame:(CGRect)frame
{
    UILabel *lbl = [[UILabel alloc]initWithFrame:frame];
    lbl.backgroundColor = ClearColor;
    //    lbl.textAlignment = 1;
    lbl.font = FontType;
    lbl.textColor = [UIColor blackColor];
    return lbl;
}
#pragma mark - creatUI
/**
 *@  传进来一个model，然后拼接到Label里面
 */
- (void)creatSubViews
{
    _xianLabel = [self createLabelFrame:CGRectMake(20/375.f*kScreenW, 64+55/667.f*kScreenH, kScreenW -20 / 375.f * kScreenW , 1)];
    _xianLabel.backgroundColor = GrayColor;
    [self.view addSubview:_xianLabel];
    
    _handleType = [self createLabelFrame:CGRectMake(0,64 +13/667.f*kScreenH, kScreenW, 30 / 667.f * kScreenH)];
    _handleType.textAlignment = NSTextAlignmentCenter;
    if ([self.model.processingType isEqualToString:@"0"]) {
        _handleType.text = @"自行处理";
    } else if ([self.model.processingType isEqualToString:@"1"]) {
        _handleType.text = @"委托EZZY处理";
    }
    _handleType.font = FontType;
    _handleType.textColor = RedColor;
    [self.view addSubview:_handleType];
    
    _timeLabel = [self createLabelFrame:CGRectMake(56/375.f*kScreenW, _xianLabel.bottom+30/667.f*kScreenH, kScreenW - 40/375.f*kScreenW, 15 / 667.f * kScreenH)];
    NSString * str = [NSString stringWithFormat:@"违章时间: %@", [self creatTimeFromDate:self.model.wzTime]];
    _timeLabel.text = str;
    [self.view addSubview:_timeLabel];
    
    _addressLabel = [self createLabelFrame:CGRectMake(56/375.f*kScreenW, _timeLabel.bottom +13/667.f*kScreenH, 80/375.f*kScreenW, 15 / 667.f * kScreenH)];
    _addressLabel.text = @"违章地点:";
    [self.view addSubview:_addressLabel];
    
    NSString * detailDidian = self.model.wzAddress;
    _diDianTextView = [[UITextView alloc]initWithFrame:CGRectMake(130/375.f*kScreenW,_timeLabel.bottom + 4/667.f*kScreenH,200/375.f*kScreenW,90/667.f * kScreenH)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:FontType,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    _diDianTextView.attributedText = [[NSAttributedString alloc] initWithString:detailDidian attributes:attributes];
    _diDianTextView.editable = NO;
    _diDianTextView.scrollEnabled = NO;
    _diDianTextView.backgroundColor = WhiteColor;
    _diDianTextView.font = FontType;
    _diDianTextView.contentOffset = CGPointMake(5, 0);
    [self.view addSubview:_diDianTextView];
    
    _priceLabel = [self createLabelFrame:CGRectMake(56/375.f*kScreenW, 250/667.f*kScreenH, kScreenW - 40/375.f*kScreenW, 15 / 667.f * kScreenH)];
    NSString * str2 = [NSString stringWithFormat:@"罚单金额: %@元", self.model.wzPrice];
    _priceLabel.text = str2;
    [self.view addSubview:_priceLabel];
    
    _countLabel = [self createLabelFrame:CGRectMake(56/375.f*kScreenW, _priceLabel.bottom+13/667.f*kScreenH, kScreenW - 40/375.f*kScreenW, 15 / 667.f * kScreenH)];
    NSString * str3 = [NSString stringWithFormat:@"违章扣分: %@分", self.model.wzKouFen];
    _countLabel.text = str3;
    [self.view addSubview:_countLabel];
    
    _yuanYinLabel = [self createLabelFrame:CGRectMake(56/375.f*kScreenW, _countLabel.bottom+13/667.f*kScreenH,80/375.f*kScreenW, 15 / 667.f * kScreenH)];
    NSString * str13 = [NSString stringWithFormat:@"违章原因:"];
    _yuanYinLabel.text = str13;
    [self.view addSubview:_yuanYinLabel];
    
    NSString * detailDidian1 = self.model.peccancycause;
    _reasonTextView = [[UITextView alloc] initWithFrame:CGRectMake(130/375.f*kScreenW,_countLabel.bottom + 4/667.f*kScreenH,200/375.f*kScreenW,90/667.f * kScreenH)];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle1.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes1 = @{
                                  NSFontAttributeName:FontType,
                                  NSParagraphStyleAttributeName:paragraphStyle1
                                  };
    _reasonTextView.attributedText = [[NSAttributedString alloc] initWithString:detailDidian1 attributes:attributes1];
    _reasonTextView.editable = NO;
    _reasonTextView.scrollEnabled = NO;
    _reasonTextView.backgroundColor = WhiteColor;
    _reasonTextView.font = FontType;
    _reasonTextView.contentOffset = CGPointMake(5, 0);
    [self.view addSubview:_reasonTextView];
    
    
    _carType = [self createLabelFrame:CGRectMake(56/375.f*kScreenW, 372/667.f*kScreenH, kScreenW - 40/375.f*kScreenW, 15 / 667.f * kScreenH)];
    NSString * str4 = [NSString stringWithFormat:@"车辆类型: %@", self.model.carType];
    _carType.text = str4;
    [self.view addSubview:_carType];
    
    _carNumber = [self createLabelFrame:CGRectMake(56/375.f*kScreenW, _carType.bottom+13/667.f*kScreenH, kScreenW - 40/375.f*kScreenW, 15 / 667.f * kScreenH)];
    NSString * str5 = [NSString stringWithFormat:@"车  牌  号: %@", self.model.carNo];
    _carNumber.text = str5;
    [self.view addSubview:_carNumber];
    
    _carColor = [self createLabelFrame:CGRectMake(56/375.f*kScreenW, _carNumber.bottom+13/667.f*kScreenH, kScreenW - 40/375.f*kScreenW, 15 / 667.f * kScreenH)];
    NSString * str6 = [NSString stringWithFormat:@"车身颜色: %@", self.model.carColor];
    _carColor.text = str6;
    [self.view addSubview:_carColor];
    
    _numberColor = [self createLabelFrame:CGRectMake(56/375.f*kScreenW, _carColor.bottom+13/667.f*kScreenH, kScreenW - 40/375.f*kScreenW, 15 / 667.f * kScreenH)];
    NSString * str7 = [NSString stringWithFormat:@"号牌颜色: %@", self.model.carNoColor];
    _numberColor.text = str7 ;
    [self.view addSubview:_numberColor];
    
    _orderNumber = [self createLabelFrame:CGRectMake(56 / 375.f*kScreenW, _numberColor.bottom+13/667.f*kScreenH, kScreenW - 20/375.f*kScreenW, 15 / 667.f * kScreenH)];
    NSString * str8 = [NSString stringWithFormat:@"关联订单号: %@", self.model.orderId];
    _orderNumber.text = str8;
    [self.view addSubview:_orderNumber];
    
    _beginTime = [self createLabelFrame:CGRectMake(56/375.f*kScreenW, _orderNumber.bottom+13/667.f*kScreenH, kScreenW - 40/375.f*kScreenW, 15 / 667.f * kScreenH)];
    NSString * str9 = [NSString stringWithFormat:@"录入时间: %@", [self creatTimeFromDate:self.model.enteringTime]];
    _beginTime.text = str9;
    [self.view addSubview:_beginTime];
    
    _handleTime = [self createLabelFrame:CGRectMake(56/375.f*kScreenW, _beginTime.bottom+13/667.f*kScreenH, kScreenW - 60/375.f*kScreenW, 15 / 667.f * kScreenH)];
    NSString * str10 = [NSString stringWithFormat:@"开始处理时间: %@", [self creatTimeFromDate:self.model.processingTime]];
    _handleTime.text = str10;
    [self.view addSubview:_handleTime];
    
    if ([self.model.processingStatus isEqualToString:@"2"]) {
        _fnishLabel = [self createLabelFrame:CGRectMake(56/375.f*kScreenW, _handleTime.bottom+13/667.f*kScreenH, kScreenW - 40/375.f*kScreenW, 15)];
        NSString * str11 = [NSString stringWithFormat:@"完成时间: %@", [self creatTimeFromDate:self.model.endTime]];
        _fnishLabel.text = str11;
        [self.view addSubview:_fnishLabel];
    }
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

@end
