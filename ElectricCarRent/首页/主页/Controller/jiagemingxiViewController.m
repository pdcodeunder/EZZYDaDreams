//
//  jiagemingxiViewController.m
//  ElectricCarRent
//
//  Created by 张钊 on 16/1/15.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "jiagemingxiViewController.h"
#import "AMBlurView.h"


#define LABEL_HEIGHT 25 / 667.0f * kScreenH
#define LABEL_WIDTH1 kScreenW / 3
#define LABEL_WIDTH2 kScreenW - 130 - LABEL_WIDTH1

@interface jiagemingxiViewController ()

@property (nonatomic, strong) UIVisualEffectView *visualEfView;

@end

@implementation jiagemingxiViewController
- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.dataDic = [[NSDictionary alloc] initWithDictionary:dic];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    AMBlurView * amb = [[AMBlurView alloc]initWithFrame:self.view.bounds];
    [amb setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
//    amb.alpha = 0.99;
    [self.view addSubview:amb];
//    [self loadData];
//    [self creatBackGround];
    [self creatUI];
}

// 加载数据
- (void)loadData{
    self.dataDic = [[NSDictionary alloc]init];
    self.dataDic = @{@"zongjia":@"1000.00元",
                     @"qibujia":@"40元",
                     @"zonglicheng":@"总里程(5.00km)",
                     @"lichengfei":@"123.23元",
                     @"disufei":@"123.23元",};
}
// 毛玻璃
- (void)creatBackGround{
    
    UIImageView * imageView = [[UIImageView alloc]initWithImage:self.maoImage];
    imageView.frame = self.view.bounds;
    
    self.visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    _visualEfView.frame = self.view.frame;
//    [_visualEfView addSubview:imageView];
    [self.view addSubview:_visualEfView];
    [self.view addSubview:imageView];
}

// 搭建UI
- (void)creatUI{
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = WhiteColor;
    
    // 最上面的label
    UILabel * topLabel = [self creatLabelWithFrame:CGRectMake(0, 0, 267,30 / 667.0f * kScreenH) andTitle:@"" andNstextAliagent:NSTextAlignmentCenter];
    topLabel.center = CGPointMake(kScreenW / 2, kScreenH / 4);
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hejiyugu267*20"]];
    [topLabel addSubview:imageView];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:topLabel];
    
    // 总价label
    UILabel * totleLabel = [self creatLabelWithFrame:CGRectMake(kScreenW / 4, CGRectGetMaxY(topLabel.frame) + 25 / 667.0f * kScreenH, kScreenW / 2, 60) andTitle:@"" andNstextAliagent:NSTextAlignmentCenter];
    totleLabel.font = [UIFont systemFontOfSize:35.0f];
    NSString * zongjia = [NSString stringWithFormat:@"%@元",[self.dataDic objectForKey:@"zongjia"]];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:zongjia];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(str.length - 1, 1)];
    totleLabel.attributedText = str;
    totleLabel.textColor = RedColor;
    [self.view addSubview:totleLabel];
    
    // 起步价
    UILabel * qibujiaLabel = [self creatLabelWithFrame:CGRectMake(65 / 375.0f * kScreenW, CGRectGetMaxY(totleLabel.frame) + 35 / 667.0f * kScreenH, LABEL_WIDTH1, LABEL_HEIGHT) andTitle:@"起步价" andNstextAliagent:NSTextAlignmentLeft];
    [self.view addSubview:qibujiaLabel];
    
    UILabel * qibujiageLabel = [self creatLabelWithFrame:CGRectMake(65 / 375.0f * kScreenW + LABEL_WIDTH1, CGRectGetMaxY(totleLabel.frame) + 35, LABEL_WIDTH2, LABEL_HEIGHT) andTitle:[NSString stringWithFormat:@"%@元",[self.dataDic objectForKey:@"qibujia"]] andNstextAliagent:NSTextAlignmentRight];
    [self.view addSubview:qibujiageLabel];
    
    if ([[NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"qibujia"]] floatValue] < 0.01) {
        qibujiaLabel.hidden = YES;
        qibujiageLabel.hidden = YES;
    }
    
    //里程费
    UILabel * lichengLabel = [self creatLabelWithFrame:CGRectMake(65 / 375.0f * kScreenW, CGRectGetMaxY(qibujiaLabel.frame) + LABEL_HEIGHT / 4, LABEL_WIDTH1, LABEL_HEIGHT) andTitle:[NSString stringWithFormat:@"总里程(%@km)",[self.dataDic objectForKey:@"zonglicheng"]] andNstextAliagent:NSTextAlignmentLeft];
    [self.view addSubview:lichengLabel];
    UILabel * lichengjiageLabel = [self creatLabelWithFrame:CGRectMake(65 / 375.0f * kScreenW + LABEL_WIDTH1, CGRectGetMaxY(qibujiaLabel.frame) + LABEL_HEIGHT / 4, LABEL_WIDTH2, LABEL_HEIGHT) andTitle:[NSString stringWithFormat:@"%@元",[self.dataDic objectForKey:@"lichengfei"]] andNstextAliagent:NSTextAlignmentRight];
    [self.view addSubview:lichengjiageLabel];
    
    if ([[NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"lichengfei"]] floatValue] < 0.01) {
        lichengLabel.hidden = YES;
        lichengjiageLabel.hidden = YES;
    }
    
    //低速费
    UILabel * disuLabel = [self creatLabelWithFrame:CGRectMake(65 / 375.0f * kScreenW, CGRectGetMaxY(lichengLabel.frame) + LABEL_HEIGHT / 4, LABEL_WIDTH1, LABEL_HEIGHT) andTitle:@"低速费" andNstextAliagent:NSTextAlignmentLeft];
    [self.view addSubview:disuLabel];
    UILabel * disujiageLabel = [self creatLabelWithFrame:CGRectMake(65 / 375.0f * kScreenW + LABEL_WIDTH1, CGRectGetMaxY(lichengLabel.frame) + LABEL_HEIGHT / 4, LABEL_WIDTH2, LABEL_HEIGHT) andTitle:[NSString stringWithFormat:@"%@元",[self.dataDic objectForKey:@"disufei"]] andNstextAliagent:NSTextAlignmentRight];
    [self.view addSubview:disujiageLabel];
    
    if ([[NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"disufei"]] floatValue] < 0.01) {
        disuLabel.hidden = YES;
        disujiageLabel.hidden = YES;
    }
    
    // 退出按钮
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"shanchu40*40"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(kScreenW / 2 - 20 , kScreenH - 30 / 375.0f * kScreenH, 40, 40);
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

// label创建方法
- (UILabel *)creatLabelWithFrame:(CGRect )frame andTitle:(NSString *)title andNstextAliagent:(NSTextAlignment )alignment{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = alignment;
    
    return label;
}

// 点击事件
- (void)btnAction{
    [self.view removeFromSuperview];
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
