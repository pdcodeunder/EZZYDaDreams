//
//  DaichuliViewController.m
//  ElectricCarRent
//
//  Created by 张钊 on 16/4/13.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "DaichuliViewController.h"
#import "ECarWzwtViewController.h"
#import "ECarWeiZhangModel.h"
#import "ECarUserManager.h"

@interface DaichuliViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) ECarWeiZhangModel *model;
@property (nonatomic, strong) ECarUserManager *userManager;

@end

@implementation DaichuliViewController

- (ECarUserManager *)userManager
{
    if (!_userManager) {
        _userManager = [[ECarUserManager alloc] init];
    }
    return _userManager;
}

- (instancetype)initWithWeiZhangModel:(ECarWeiZhangModel *)model
{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"违章待处理";
    self.view.backgroundColor = WhiteColor;
    [self creatUI];
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

#pragma  mark creatUI
- (void)creatUI{
    // 顶部灰线
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, kScreenW, 1)];
    label.backgroundColor = GrayColor;
    
    // 基本数据
    CGFloat gap = 56 / 375.f * kScreenW;
    CGFloat labelHeight = 25 / 667.f * kScreenH;
    CGFloat labelWidth = kScreenW - gap * 2;
    CGFloat tiaojian = 15.f / 667.f * kScreenH;
    
    // 背景view
    UIView * viewTop = [[UIView alloc] initWithFrame:CGRectMake(gap, CGRectGetMaxY(label.frame) + 25 / 667.f * kScreenH, labelWidth, 430 / 667.f * kScreenH)];
    viewTop.backgroundColor = WhiteColor;
    
    // 违章时间
    NSString * time = [self creatTimeFromDate:self.model.wzTime];
    UILabel * timeLabel = [self creatLabelWithFrame:CGRectMake(0, 0, labelWidth, labelHeight) andText:[NSString stringWithFormat:@"违章时间：%@",time]];
    [viewTop addSubview:timeLabel];
    
    // 违章地点
    NSString * didianStr = @"违章地点：";
    CGSize didianSize = [didianStr boundingRectWithSize:CGSizeMake(0, labelHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FontType} context:nil].size;
    UILabel * locationLabel = [self creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(timeLabel.frame), didianSize.width, labelHeight) andText:didianStr];
    [viewTop addSubview:locationLabel];
    
    UILabel * detailDidian = [self creatLabelWithFrame:CGRectMake(CGRectGetMaxX(locationLabel.frame), CGRectGetMaxY(timeLabel.frame), labelWidth - didianSize.width, labelHeight * 3) andText:nil];
    detailDidian.numberOfLines = 3;
    [viewTop addSubview:detailDidian];
    
    CGSize size = [self.model.wzAddress boundingRectWithSize:CGSizeMake(labelWidth - didianSize.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: FontType} context:nil].size;
    if (size.height < tiaojian * 2) {
        detailDidian.height = labelHeight;
        //        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //        paragraphStyle.lineSpacing = 9 / 667.f * kScreenH;// 字体的行间距
        //        NSDictionary *attributes = @{
        //                                     NSFontAttributeName:FontType,
        //                                     NSParagraphStyleAttributeName:paragraphStyle
        //                                     };
        //        detailDidian.attributedText = [[NSAttributedString alloc] initWithString:self.model.wzAddress attributes:attributes];
        detailDidian.text = self.model.wzAddress;
    }else if (size.height < tiaojian * 3){
        detailDidian.height = labelHeight * 2;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 7 / 667.f * kScreenH;// 字体的行间距
        NSDictionary *attributes = @{
                                     NSFontAttributeName:FontType,
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        detailDidian.attributedText = [[NSAttributedString alloc] initWithString:self.model.wzAddress attributes:attributes];
    }else{
        detailDidian.height = labelHeight * 3;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 7 / 667.f * kScreenH;// 字体的行间距
        NSDictionary *attributes = @{
                                     NSFontAttributeName:FontType,
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        detailDidian.attributedText = [[NSAttributedString alloc] initWithString:self.model.wzAddress attributes:attributes];
        
    }
    
    // 罚单金额
    NSString * moneyStr = [NSString stringWithFormat:@"%@元", self.model.wzPrice];
    UILabel * moneyLabel = [self creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(timeLabel.frame) + labelHeight * 3, labelWidth, labelHeight) andText:[NSString stringWithFormat:@"罚单金额：%@",moneyStr]];
    [viewTop addSubview:moneyLabel];
    
    // 违章扣分
    NSString * koufenStr = [NSString stringWithFormat:@"%@分", self.model.wzKouFen];
    UILabel * koufenLabel = [self creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(moneyLabel.frame), labelWidth, labelHeight) andText:[NSString stringWithFormat:@"违章扣分：%@",koufenStr]];
    [viewTop addSubview:koufenLabel];
    
    // 违章原因
    UILabel * yuanyinLabel = [self creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(koufenLabel.frame), didianSize.width, labelHeight) andText:@"违章原因："];
    [viewTop addSubview:yuanyinLabel];
    
    UILabel * detailYuanyin = [self creatLabelWithFrame:CGRectMake(CGRectGetMaxX(yuanyinLabel.frame), CGRectGetMaxY(koufenLabel.frame), labelWidth - didianSize.width, labelHeight * 3) andText:nil];
    detailYuanyin.numberOfLines = 3;
    [viewTop addSubview:detailYuanyin];
    
    CGSize size1 = [self.model.peccancycause boundingRectWithSize:CGSizeMake(labelWidth - didianSize.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: FontType} context:nil].size;
    
    if (size1.height < tiaojian * 2) {
        detailYuanyin.height = labelHeight;
        //        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //        paragraphStyle.lineSpacing = 10 / 667.f * kScreenH;// 字体的行间距
        //        NSDictionary *attributes = @{
        //                                     NSFontAttributeName:FontType,
        //                                     NSParagraphStyleAttributeName:paragraphStyle
        //                                     };
        //        detailYuanyin.attributedText = [[NSAttributedString alloc] initWithString:self.model.peccancycause attributes:attributes];
        detailYuanyin.text = self.model.peccancycause;
    }else if (size1.height < tiaojian * 3){
        detailYuanyin.height = labelHeight * 2;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 7 / 667.f * kScreenH;// 字体的行间距
        NSDictionary *attributes = @{
                                     NSFontAttributeName:FontType,
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        detailYuanyin.attributedText = [[NSAttributedString alloc] initWithString:self.model.peccancycause attributes:attributes];
    }else{
        detailYuanyin.height = labelHeight * 3;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 7 / 667.f * kScreenH;// 字体的行间距
        NSDictionary *attributes = @{
                                     NSFontAttributeName:FontType,
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        detailYuanyin.attributedText = [[NSAttributedString alloc] initWithString:self.model.peccancycause attributes:attributes];
        
    }
    
    // 车辆类型
    NSString * carTypeStr = self.model.carType;
    UILabel * carTypeLabel = [self creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(koufenLabel.frame) + labelHeight * 3, labelWidth, labelHeight) andText:[NSString stringWithFormat: @"车辆类型：%@",carTypeStr]];
    [viewTop addSubview:carTypeLabel];
    
    // 车牌号
    NSString * carNum = self.model.carNo;
    UILabel * carNumLabel = [self creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(carTypeLabel.frame), labelWidth, labelHeight) andText:[NSString stringWithFormat: @"车  牌  号：%@",carNum]];
    [viewTop addSubview:carNumLabel];
    
    // 车身颜色
    NSString * carColor = self.model.carColor;
    UILabel * carColorLabel = [self creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(carNumLabel.frame), labelWidth, labelHeight) andText:[NSString stringWithFormat: @"车身颜色：%@",carColor]];
    [viewTop addSubview:carColorLabel];
    
    // 号牌颜色
    NSString * carNumColor = self.model.carNoColor;
    UILabel * carNumColorLabel = [self creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(carColorLabel.frame), labelWidth, labelHeight) andText:[NSString stringWithFormat: @"号牌颜色：%@",carNumColor]];
    [viewTop addSubview:carNumColorLabel];
    
    // 关联订单号
    NSString * dingdanStr = self.model.orderId;
    UILabel * dingdanLabel = [self creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(carNumColorLabel.frame), labelWidth + 20, labelHeight) andText:[NSString stringWithFormat: @"关联订单号：%@",dingdanStr]];
    [dingdanLabel sizeToFit];
    [viewTop addSubview: dingdanLabel ];
    
    // 录入时间
    NSString * luruStr = [self creatTimeFromDate:self.model.enteringTime];
    UILabel * luruTimeLabel = [self creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(dingdanLabel.frame), labelWidth, labelHeight) andText:[NSString stringWithFormat: @"录入时间：%@",luruStr]];
    [viewTop addSubview:luruTimeLabel];
    
    [self.view addSubview:viewTop];
    
    // 文案
    CGFloat newGap = 23 / 375.f * kScreenW;
    UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(newGap, CGRectGetMaxY(viewTop.frame), kScreenW - newGap * 2, 110 / 667.f * kScreenH)];
    textView.text = @"自违章录入时间开始算起，请您7日内选择自行处理违章或者委托EZZY代为处理，否则您的EZZY账号将被锁定，暂时不能用车。";
    textView.font = FontMinSize;
    textView.textColor = RedColor;
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.textAlignment = NSTextAlignmentLeft;
    textView.backgroundColor = WhiteColor;
    [self.view addSubview:textView];
    
    // 按钮
    UIButton * btnLeft = [self creatBtnWithFrame:CGRectMake(0, kScreenH - 50 / 667.f * kScreenH, kScreenW / 2, 50 / 667.f * kScreenH) andTitle:@"委托EZZY处理" andTag:110];
    [self.view addSubview:btnLeft];
    
    UIButton * btnRight = [self creatBtnWithFrame:CGRectMake(kScreenW / 2, kScreenH - 50 / 667.f * kScreenH, kScreenW / 2, 50 / 667.f * kScreenH) andTitle:@"自行处理" andTag:120];
    [self.view addSubview:btnRight];
    
    UILabel * labelLine = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenH - 50 / 667.f * kScreenH, kScreenW, 1)];
    labelLine.backgroundColor = RedColor;
    [self.view addSubview:labelLine];
    
    UILabel * labelLine1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, 50 / 667.f * kScreenH)];
    labelLine1.center = CGPointMake(kScreenW / 2, kScreenH - 25 / 667.f * kScreenH);
    labelLine1.backgroundColor = RedColor;
    [self.view addSubview:labelLine1];
}

#pragma mark btnAction
- (void)btnAction:(UIButton *)btn{
    if (btn.tag == 110) {
        if (self.model.wzKouFen.integerValue >= 6)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"6分以上请自行处理" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        ECarWzwtViewController * vc = [[ECarWzwtViewController alloc] initWithWeiTuoModel:self.model];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag == 120){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"你好，确认完毕后，请到相关部门办理违章事宜。有疑问请咨询客服人员。请在“违章管理”里查看处理动态。" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        alert.tag = 267;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 267) {
        if (buttonIndex == 0) {
            [self showHUD:@"请稍等..."];
            weak_Self(self);
            [[self.userManager weiZhangZiXingChuLiWithPID:self.model.weizhangID] subscribeNext:^(id x) {
                [weakSelf hideHUD];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } error:^(NSError *error) {
                [weakSelf hideHUD];
                [weakSelf delayHidHUD:MESSAGE_NoNetwork];
            }];
        }
    }
}

#pragma mark creatLabel
- (UILabel *)creatLabelWithFrame:(CGRect)rect andText:(NSString *)title{
    UILabel * label = [[UILabel alloc]initWithFrame:rect];
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = WhiteColor;
    label.font = FontType;
    label.text = title;
    return  label;
}

#pragma mark creatBtn
- (UIButton *)creatBtnWithFrame:(CGRect)frame andTitle:(NSString *)title andTag:(NSInteger)tag{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = FontType;
    [btn setTitleColor:RedColor forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self  action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
