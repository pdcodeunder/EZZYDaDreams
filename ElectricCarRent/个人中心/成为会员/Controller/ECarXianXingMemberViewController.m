//
//  ECarXianXingMemberViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/4/14.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarXianXingMemberViewController.h"
#import "EZZYMemberModle.h"
#import "ECarZhiFuViewController.h"
#import "ECarUserManager.h"

@interface ECarXianXingMemberViewController () <UITextFieldDelegate>

@property (nonatomic , strong)UITextField * textField;
@property (nonatomic , strong)UILabel * labelLine;
@property (nonatomic , strong)UIButton * selectBtn;

@property (nonatomic, strong) ECarUserManager *userManager;
@property (nonatomic, strong) EZZYMemberModle *modle;

@end

@implementation ECarXianXingMemberViewController

- (ECarUserManager *)userManager {
    if (!_userManager) {
        _userManager = [[ECarUserManager alloc] init];
    }
    return _userManager;
}

- (instancetype)initWithXianXingModel:(EZZYMemberModle *)modle
{
    if (self = [super init]) {
        self.modle = modle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.modle.levelName;
    [self createXianXingMember];
}

- (void)createXianXingMember
{
    // 限行会员 XX元/月
//    UILabel * labelLeft = [[UILabel alloc] init];
//    labelLeft.text = [NSString stringWithFormat:@"%@:", self.modle.levelName];
//    CGSize sizeLeft = [labelLeft.text boundingRectWithSize:CGSizeMake(0, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FontType} context:nil].size;
//    labelLeft.frame =CGRectMake(0, 0, sizeLeft.width, 35);
//    labelLeft.font = FontType;
//    
//    UILabel * labelRight = [[UILabel alloc]init];
//    labelRight.text = [NSString stringWithFormat:@"%@%@", self.modle.levelMoney, self.modle.levelUnit];
//    CGSize sizeRight = [labelRight.text boundingRectWithSize:CGSizeMake(0, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FontType} context:nil].size;
//    labelRight.textColor = RedColor;
//    labelRight.font = FontType;
//    labelRight.frame = CGRectMake(sizeLeft.width + 10,0 , sizeRight.width, 35);
//    
//    UIView * firstView = [[UIView alloc]initWithFrame:CGRectMake((kScreenW - sizeLeft.width - sizeRight.width - 10) / 2, 0, sizeLeft.width + sizeRight.width + 10, 35)];
//    [firstView addSubview:labelLeft];
//    [firstView addSubview:labelRight];
//    
//    UIView * topBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 20, kScreenW, 35)];
//    [topBgView addSubview:firstView];
//    [self.view addSubview:topBgView];
    
    // 限行会员和输入框
    UILabel * labelHaoma = [[UILabel alloc]init];
    labelHaoma.text = @"     请输入限行尾号";
    CGSize sizeHaoma = [labelHaoma.text boundingRectWithSize:CGSizeMake(0, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FontType} context:nil].size;
    labelHaoma.frame = CGRectMake(0, 0, sizeHaoma.width, 40);
    labelHaoma.textColor = RedColor;
    labelHaoma.font = FontType;
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(sizeHaoma.width + 10, 1, 38, 38)];
    _textField.delegate = self;
    _textField.font = FontType;
    _textField.textColor = RedColor;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.background = [UIImage imageNamed:@"xianxingweihaokuang38*38"];
    
    UIView * haomaView = [[UIView alloc]initWithFrame:CGRectMake((kScreenW - (sizeHaoma.width + 40 + 10)) / 2, 0, sizeHaoma.width + 40 + 10, 40)];
    [haomaView addSubview:labelHaoma];
    [haomaView addSubview:_textField];
    
    UIView * haomaBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 20, kScreenW, 40)];
    [haomaBgView addSubview:haomaView];
    [self.view addSubview:haomaBgView];
    
    _labelLine = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(haomaBgView.frame) + 20, kScreenW - 20, 1)];
    _labelLine.backgroundColor = GrayColor;
    [self.view addSubview:_labelLine];
    
    // 添加会员文案描述
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(23, CGRectGetMaxY(_labelLine.frame) + 20, kScreenW - 46, kScreenH - (CGRectGetMaxY(_labelLine.frame) + 20) - 30 - 49)];
    textView.font = FontType;
    textView.backgroundColor = [UIColor clearColor];
    textView.selectable = NO;
    textView.editable = NO;
    textView.text = self.modle.note;
    // 添加间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName: FontType,
                                 NSParagraphStyleAttributeName: paragraphStyle
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
    
    // 添加点击事件
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)buyBtnAction:(UIButton *)sender
{
    if (_textField.text.length != 1) {
        UIAlertView * noTextAlert = [[UIAlertView alloc] initWithTitle:@"限行号" message:@"请输入您的机动车尾号。" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [noTextAlert show];
        return;
    }
    [self showHUD:@"请稍等..."];
    weak_Self(self);
    ECarZhiFuViewController * zhifuVC = [[ECarZhiFuViewController alloc]init];
    [[self.userManager creatOrderByRenyuanID:[ECarConfigs shareInstance].user.phone vipType:self.modle.levelCode lastNum:_textField.text] subscribeNext:^(id x) {
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

- (void)tapGesture
{
    [_textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length > 0) {
        unichar uc = [string characterAtIndex:0];
        if (uc > 57 || uc < 48) {
            return NO;
        }
    }
    self.textField.text = string;
    return NO;
}

@end
