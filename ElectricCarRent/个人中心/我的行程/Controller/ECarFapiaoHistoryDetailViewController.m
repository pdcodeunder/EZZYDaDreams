//
//  ECarFapiaoHistoryDetailViewController.m
//  ElectricCarRent
//
//  Created by 张钊 on 16/3/30.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarFapiaoHistoryDetailViewController.h"
#import "ECarFapiaoHistoryModel.h"

@interface ECarFapiaoHistoryDetailViewController ()

@end

@implementation ECarFapiaoHistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"开票历史";
    self.view.backgroundColor = WhiteColor;
    [self creatUI];
}

- (void)creatUI{
    
    CGFloat gap = 20 / 375.0f * kScreenW;
    CGFloat height = 54 / 667.0f * kScreenH;
    
    //灰线
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, kScreenW, 1)];
    label1.backgroundColor = kColorStr;
    [self.view addSubview:label1];
    
    //状态
    UILabel * labelState = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame) + 1, kScreenW, height)];
    if ([self.fapiaoModel.state integerValue] == 0) {
        labelState.text = @"待邮寄";
    }else if ([self.fapiaoModel.state integerValue] == 1){
        labelState.text = @"已寄出";
    }
    labelState.font = [UIFont systemFontOfSize:15.0f];
    labelState.textColor = RedColor;
    labelState.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelState];
    
    //灰线
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(gap, CGRectGetMaxY(labelState.frame), kScreenW, 1)];
    label2.backgroundColor = kColorStr;
    [self.view addSubview:label2];
    
    //姓名
    NSString * name = [NSString stringWithFormat:@"%@",self.fapiaoModel.name];
    CGSize size = [name boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]} context:nil].size;
    UILabel * labelName = [[UILabel alloc]initWithFrame:CGRectMake(gap , CGRectGetMaxY(label2.frame), size.width, height)];
    labelName.text = name;
    labelName.font = [UIFont systemFontOfSize:14.0f];
    labelName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelName];
    
    //电话
    UILabel * labelNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(labelName.frame) + 30 / 375.f * kScreenW, CGRectGetMaxY(label2.frame), 150, height)];
    labelNum.text = [NSString stringWithFormat:@"%@",self.fapiaoModel.phoneNum];
    labelNum.font = [UIFont systemFontOfSize:14.0f];
    labelNum.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:labelNum];
    
    //灰线
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(gap, CGRectGetMaxY(labelName.frame), kScreenW, 1)];
    label3.backgroundColor = kColorStr;
    [self.view addSubview:label3];
    
    //地址
    UILabel * labelAddress = [[UILabel alloc]initWithFrame:CGRectMake(gap, CGRectGetMaxY(label3.frame), kScreenW - gap * 2, height)];
    labelAddress.text = [NSString stringWithFormat:@"%@",self.fapiaoModel.address];
    labelAddress.font = [UIFont systemFontOfSize:14.0f];
    labelAddress.numberOfLines = 2;
    [self.view addSubview:labelAddress];
    
    //灰线
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(gap, CGRectGetMaxY(labelAddress.frame), kScreenW, 1)];
    label4.backgroundColor = kColorStr;
    [self.view addSubview:label4];
    
    //发票抬头
    UILabel * labelTaitou = [[UILabel alloc]initWithFrame:CGRectMake(gap, CGRectGetMaxY(label4.frame), kScreenW - gap * 2, height)];
    labelTaitou.text = [NSString stringWithFormat:@"发票抬头：%@",self.fapiaoModel.companyHeader];
    labelTaitou.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:labelTaitou];
    
    //灰线
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(gap, CGRectGetMaxY(labelTaitou.frame), kScreenW, 1)];
    label5.backgroundColor = kColorStr;
    [self.view addSubview:label5];
    
    //发票内容
    UILabel * labelNeirong = [[UILabel alloc]initWithFrame:CGRectMake(gap, CGRectGetMaxY(label5.frame), kScreenW - gap * 2, height)];
    labelNeirong.text = [NSString stringWithFormat:@"发票内容：%@",self.fapiaoModel.connets];
    labelNeirong.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:labelNeirong];
    
    //灰线
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(gap, CGRectGetMaxY(labelNeirong.frame), kScreenW, 1)];
    label6.backgroundColor = kColorStr;
    [self.view addSubview:label6];
    
    //发票金额
    NSString *pr = [NSString stringWithFormat:@"%.2f",[self.fapiaoModel.costs floatValue]];
    NSString * price = [NSString stringWithFormat:@"发票金额：%@元", pr];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:price];
    [str addAttribute:NSForegroundColorAttributeName value:RedColor range:NSMakeRange(5, pr.length)];
    UILabel * labelCost = [[UILabel alloc]initWithFrame:CGRectMake(gap, CGRectGetMaxY(label6.frame), kScreenW - gap * 2, height)];
    labelCost.attributedText = str;
    labelCost.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:labelCost];
    
    //灰线
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(gap, CGRectGetMaxY(labelCost.frame), kScreenW, 1)];
    label7.backgroundColor = kColorStr;
    [self.view addSubview:label7];
    
    //时间
    UILabel * labelTime = [[UILabel alloc]initWithFrame:CGRectMake(gap, CGRectGetMaxY(label7.frame), kScreenW - gap * 2, height)];
    labelTime.text = [NSString stringWithFormat:@"申请时间：%@",[self creatTimeFromDate:[NSNumber numberWithUnsignedInteger:[self.fapiaoModel.time integerValue]]]];
    labelTime.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:labelTime];
    
    //灰线
    UILabel * label8 = [[UILabel alloc]initWithFrame:CGRectMake(gap, CGRectGetMaxY(labelTime.frame), kScreenW, 1)];
    label8.backgroundColor = kColorStr;
    [self.view addSubview:label8];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
