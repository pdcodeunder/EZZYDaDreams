//
//  EZZYBuyMemberViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/4/14.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "EZZYBuyMemberViewController.h"
#import "ECarZhiFuViewController.h"
#import "EZZYMemberModle.h"
#import "ECarConfigs.h"
#import "ECarUserManager.h"

@interface EZZYBuyMemberViewController ()

@property (nonatomic, strong) EZZYMemberModle *modle;
@property (nonatomic, strong) ECarUserManager *useManager;

@end

@implementation EZZYBuyMemberViewController

- (ECarUserManager *)useManager
{
    if (!_useManager) {
        _useManager = [[ECarUserManager alloc] init];
    }
    return _useManager;
}

- (instancetype)initWithBuyMemberModel:(EZZYMemberModle *)modle
{
    if (self = [super init]) {
        self.modle = modle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.modle.levelName;
    [self createMemberUI];
}

- (void)createMemberUI
{
    // 添加会员文案描述
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(23, 80 / 667.f * kScreenH, kScreenW - 46, kScreenH - 100 / 667.f * kScreenH)];
    textView.font = FontType;
    textView.backgroundColor = [UIColor clearColor];
    textView.selectable = NO;
    textView.editable = NO;
    textView.text = self.modle.note;
    // 添加间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:FontType,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    [self.view addSubview:textView];
    // 购买按钮
    UIButton * buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setTitleColor:[UIColor colorWithRed:224/255.0f green:54/255.0f blue:134/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [buyBtn setTitle:@"购买" forState:UIControlStateNormal];
    buyBtn.titleLabel.font = FontType;
    buyBtn.frame = CGRectMake(0, kScreenH - 49, kScreenW, 49);
    [buyBtn addTarget:self action:@selector(buyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyBtn];
    // 添加下面的线
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH - 49, kScreenW , 1)];
    lineView1.backgroundColor = [UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:1.0];
    [self.view addSubview:lineView1];
}

- (void)buyBtnAction:(UIButton *)sender
{
    [self showHUD:@"请稍等..."];
    weak_Self(self);
    ECarZhiFuViewController * zhifuVC = [[ECarZhiFuViewController alloc] init];
    [[self.useManager creatOrderByRenyuanID:[ECarConfigs shareInstance].user.phone vipType:self.modle.levelCode lastNum:@"10"] subscribeNext:^(id x) {
        [weakSelf hideHUD];
        NSDictionary * dic = x;
        NSString * success = [NSString stringWithFormat:@"%@", dic[@"success"]];
        if (success.boolValue == 0) {
            NSString * msg = [NSString stringWithFormat:@"%@", dic[@"msg"]];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        NSDictionary * dictx = dic[@"obj"];
        ECarConfigs * config = [ECarConfigs shareInstance];
        config.orignOrderNo = [NSString stringWithFormat:@"%@", [dictx objectForKey:@"orderId"]];
        config.currentPrice = [NSString stringWithFormat:@"%.2lf", weakSelf.modle.levelMoney.floatValue];
        
        zhifuVC.priceCar = [NSString stringWithFormat:@"%@", weakSelf.modle.levelMoney];
        zhifuVC.priceUnit = self.modle.levelUnit;
        zhifuVC.orderID = dictx[@"orderId"];
        zhifuVC.canBack = YES;
        zhifuVC.sendType = sendToHouTaiByVip;
        [self.navigationController pushViewController:zhifuVC animated:YES];
    } error:^(NSError *error) {
        [weakSelf delayHidHUD:MESSAGE_NoNetwork];
    }];
}

@end
