//
//  ECarWzwtViewController.m
//  ElectricCarRent
//
//  Created by 张钊 on 16/4/13.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarWzwtViewController.h"
#import "ECarWeiZhangModel.h"
#import "ECarWeiZhangZhiFuViewController.h"

@interface ECarWzwtViewController ()

@property (nonatomic, strong) ECarWeiZhangModel *model;

@end

@implementation ECarWzwtViewController

- (instancetype)initWithWeiTuoModel:(ECarWeiZhangModel *)model
{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = WhiteColor;
    self.title = @"委托EZZY处理";
    
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
    CGFloat gap = 39 / 375.f * kScreenW;
    CGFloat labelHeight = 25 / 667.f * kScreenH;
    CGFloat labelWidth = kScreenW - gap * 2;
    CGFloat tiaojian = 15.f / 667.f * kScreenH;
    
    // 背景view
    UIView * viewTop = [[UIView alloc]initWithFrame:CGRectMake(gap, CGRectGetMaxY(label.frame) + 14 / 667.f * kScreenH, labelWidth, 399 / 667.f * kScreenH)];
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
    NSString * moneyStr = self.model.wzPrice;
    UILabel * moneyLabel = [self creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(timeLabel.frame) + labelHeight * 3, labelWidth, labelHeight) andText:[NSString stringWithFormat:@"罚单金额：%@元",moneyStr]];
    [viewTop addSubview:moneyLabel];
    
    // 违章扣分
    NSString * koufenStr = self.model.wzKouFen;
    UILabel * koufenLabel = [self creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(moneyLabel.frame), labelWidth, labelHeight) andText:[NSString stringWithFormat:@"违章扣分：%@分",koufenStr]];
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
        //        paragraphStyle.lineSpacing = 9 / 667.f * kScreenH;// 字体的行间距
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
    
    [viewTop addSubview:detailYuanyin];
    
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
    UILabel * dingdanLabel = [self creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(carNumColorLabel.frame), labelWidth, labelHeight) andText:[NSString stringWithFormat: @"关联订单号：%@",dingdanStr]];
    [dingdanLabel sizeToFit];
    [viewTop addSubview: dingdanLabel ];
    
    // 录入时间
    NSString * luruStr = [self creatTimeFromDate:self.model.enteringTime];
    UILabel * luruTimeLabel = [self creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(dingdanLabel.frame), labelWidth, labelHeight) andText:[NSString stringWithFormat: @"录入时间：%@",luruStr]];
    [viewTop addSubview:luruTimeLabel];
    
    [self.view addSubview:viewTop];
    
    // label
    UILabel * labelLine = [[UILabel alloc]initWithFrame:CGRectMake(24 / 375.f * kScreenW, CGRectGetMaxY(viewTop.frame) , kScreenW - 24 / 375.f * kScreenW, 1)];
    labelLine.backgroundColor = GrayColor;
    [self.view addSubview:labelLine];
    
    //价格
    NSString * jineStr = [NSString stringWithFormat:@"%.2f",[self.model.wzPrice floatValue]];
    UILabel * jineLabel = [self creatLabelWithFrame:CGRectMake(179 / 375.f * kScreenW, CGRectGetMaxY(labelLine.frame) + 15 / 667.f * kScreenH, kScreenW - 179 / 375.f * kScreenW, labelHeight) andText:[NSString stringWithFormat:@"罚  单 金 额：¥%@",jineStr]];
    [self.view addSubview:jineLabel];
    
    NSString * fuwufeiStr = [NSString stringWithFormat:@"%.2lf", self.model.wzFuWuFei.floatValue];
    UILabel * fuwufeiLabel = [self creatLabelWithFrame:CGRectMake(179 / 375.f * kScreenW, CGRectGetMaxY(jineLabel.frame), kScreenW - 179 / 375.f * kScreenW, labelHeight) andText:[NSString stringWithFormat:@"委托服务费：¥%@",fuwufeiStr]];
    [self.view addSubview:fuwufeiLabel];
    NSString * hejiStr = [NSString stringWithFormat:@"%.2lf", [self.model.wzPrice floatValue] + [self.model.wzFuWuFei floatValue]];
    UILabel * hejiLabel = [self creatLabelWithFrame:CGRectMake(179 / 375.f * kScreenW, CGRectGetMaxY(fuwufeiLabel.frame), kScreenW - 179 / 375.f * kScreenW, labelHeight) andText:[NSString stringWithFormat:@"合            计：¥%@",hejiStr]];
    [self.view addSubview:hejiLabel];
    
    // 文案
    CGFloat newGap = 18 / 375.f * kScreenW;
    UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(newGap, CGRectGetMaxY(hejiLabel.frame), kScreenW - newGap * 2, kScreenH - 50 / 667.f * kScreenH - CGRectGetMaxY(hejiLabel.frame))];
    textView.text = @"您好，您的违章将要委托EZZY公司处理。支付成功后可以在“处理中违章”查看动态。";
    textView.font = FontMinSize;
    textView.textColor = RedColor;
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.textAlignment = NSTextAlignmentLeft;
    textView.backgroundColor = WhiteColor;
    [self.view addSubview:textView];
    
    // 按钮
    UIButton * btnLeft = [self creatBtnWithFrame:CGRectMake(0, kScreenH - 50 / 667.f * kScreenH, kScreenW , 50 / 667.f * kScreenH) andTitle:@"立即支付" andTag:110];
    [self.view addSubview:btnLeft];
    
    UILabel * labelLine1 = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenH - 50 / 667.f * kScreenH, kScreenW, 1)];
    labelLine1.backgroundColor = RedColor;
    [self.view addSubview:labelLine1];
}

#pragma mark btnAction
- (void)btnAction:(UIButton *)btn{
    if (btn.tag == 110) {
        [ECarConfigs shareInstance].orignOrderNo = self.model.weizhangID;
        [ECarConfigs shareInstance].currentPrice = [NSString stringWithFormat:@"%.2lf", [self.model.wzPrice floatValue] + [self.model.wzFuWuFei floatValue]];
        ECarWeiZhangZhiFuViewController *zhifuWeiZhang = [[ECarWeiZhangZhiFuViewController alloc] init];
        [self.navigationController pushViewController:zhifuWeiZhang animated:YES];
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
    //    [btn setBackgroundImage:[UIImage imageNamed:@"u13"] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = FontType;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self  action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
