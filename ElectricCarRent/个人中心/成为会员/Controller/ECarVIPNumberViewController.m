//
//  ECarVIPNumberViewController.m
//  ElectricCarRent
//
//  Created by 张钊 on 15/12/6.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarVIPNumberViewController.h"
#import "ECarUser.h"
#import "ECarUserManager.h"

@interface ECarVIPNumberViewController ()<UITextFieldDelegate>
{
    UITextField * _textField;
    ECarUser * zz;
    ECarUserManager  * manage;
}
@end

@implementation ECarVIPNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ECarConfigs * user = [ECarConfigs shareInstance];
    zz = user.user;
    manage = [ECarUserManager new];

    self.view.backgroundColor = [UIColor colorWithRed:249/255.0f green:249/255.0f blue:249/255.0f alpha:1.0f];
//    self.title = @"会员邀请码";
//    [self creatNavBar];
    [self creatUI];
}

- (void)creatNavBar{
    UILabel * dd = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    dd.text = @"会员邀请码";
    dd.textAlignment = NSTextAlignmentCenter;
    dd.font = [UIFont systemFontOfSize:14.0f];
    self.navigationItem.titleView = dd;
}

- (void)creatUI{
    
    UIButton * putongMem = [UIButton buttonWithType:UIButtonTypeCustom];
    putongMem.frame = CGRectMake(0, 64, kScreenW, 55);
    [putongMem setTitle:@"请输入会员邀请码" forState:UIControlStateNormal];
    [putongMem setTitleColor:[UIColor colorWithRed:224/255.0f green:54/255.0f blue:134/255.0f alpha:1.0f] forState:UIControlStateNormal];
    putongMem.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [putongMem setBackgroundImage:[UIImage imageNamed:@"beijingkuang374*55"] forState:UIControlStateNormal];
    putongMem.enabled = NO;
    [self.view addSubview:putongMem];
    
    _textField  = [[UITextField alloc]initWithFrame:CGRectMake((kScreenW - 7 * 44)/2.f, 0, 2, 3)];
    _textField.delegate = self;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_textField];
    
    for (NSInteger i = 0; i < 7; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake((kScreenW - 7 * 44)/2+(i * 44), CGRectGetMaxY(putongMem.frame) + 60, 44, 37)];
        label.tag = 110 + i;
        label.textColor = RedColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderWidth = 1.0f;
        label.layer.borderColor = [GrayColor CGColor];
        [self.view addSubview:label];
    }
    
    UIButton * textButton = [UIButton buttonWithType:UIButtonTypeCustom];
    textButton.frame = CGRectMake((kScreenW - 7 * 44)/2, CGRectGetMaxY(putongMem.frame) + 60, 7 * 44, 37);
    [textButton addTarget:self action:@selector(textButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:textButton];
    
    // 添加确定按钮
    UIButton * buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setTitleColor:[UIColor colorWithRed:224/255.0f green:54/255.0f blue:134/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [buyBtn setTitle:@"确认" forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    buyBtn.frame = CGRectMake(0, kScreenH - 49, kScreenW, 49);
    [buyBtn addTarget:self action:@selector(buyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyBtn];
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH - 49, kScreenW , 1)];
    lineView1.backgroundColor = [UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:1.0];
    [self.view addSubview:lineView1];
    
    [_textField becomeFirstResponder];
}

- (void)textButtonAction
{
    for (NSInteger i = 0; i < 7; i ++) {
        UILabel * label = (UILabel *)[self.view viewWithTag:110 + i];
        label.text = @" ";
        _textField.text = nil;
    }
    [_textField becomeFirstResponder];
}

// textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    switch (range.location) {
        case 0:
        {
            UILabel * label = (UILabel *)[self.view viewWithTag:110];
            if (range.length == 0) {
                label.text = string;
            } else {
                label.text = @" ";
            }
            break;
        }
        case 1:
        {
            UILabel * label = (UILabel *)[self.view viewWithTag:111];
            if (range.length == 0) {
                label.text = string;
            } else {
                label.text = @" ";
            }
            break;
        }
        case 2:
        {
            UILabel * label = (UILabel *)[self.view viewWithTag:112];
            if (range.length == 0) {
                label.text = string;
            } else {
                label.text = @" ";
            }
            break;
        }
        case 3:
        {
            UILabel * label = (UILabel *)[self.view viewWithTag:113];
            if (range.length == 0) {
                label.text = string;
            } else {
                label.text = @" ";
            }
            break;
        }
        case 4:
        {
            UILabel * label = (UILabel *)[self.view viewWithTag:114];
            if (range.length == 0) {
                label.text = string;
            } else {
                label.text = @" ";
            }
            break;
        }
        case 5:
        {
            UILabel * label = (UILabel *)[self.view viewWithTag:115];
            if (range.length == 0) {
                label.text = string;
            } else {
                label.text = @" ";
            }
            break;
        }
        case 6:
        {
            UILabel * label = (UILabel *)[self.view viewWithTag:116];
            if (range.length == 0) {
                label.text = string;
                [_textField resignFirstResponder];
            } else {
                label.text = @" ";
            }
            break;
        }
        default:
        {
            [_textField resignFirstResponder];
            return NO;
            break;
        }
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
}

// 输入完成之后的点击事件
- (void)buyBtnAction:(UIButton *)btn{
    NSString * str = @"";
    for (NSInteger i = 0; i < 7; i++) {
        UILabel * label = (UILabel *)[self.view viewWithTag:(110 + i)];
        str = [NSString stringWithFormat:@"%@%@",str,label.text];
    }
    [self showHUD:@"请稍等..."];
    weak_Self(self);
//    PDLog(@"asdfa     %@",str);
    [[manage sendBuyMemberInfoRenyuanID:zz.phone vipFreeCode:str]subscribeNext:^(id x) {
        NSDictionary * dicx = x;
        [weakSelf hideHUD];
        PDLog(@"%@",dicx);
        // true false 判断
        NSString * succes = [NSString stringWithFormat:@"%@", [dicx objectForKey:@"success"]];
        if (succes.boolValue == 0) {
            UIAlertView * falseAlert = [[UIAlertView alloc]initWithTitle:@"错误" message:[NSString stringWithFormat:@"%@", [dicx objectForKey:@"msg"]] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [falseAlert show];
        }else{
            UIAlertView * tishi = [[UIAlertView alloc] initWithTitle:@"恭喜您!" message:[NSString stringWithFormat:@"%@", [dicx objectForKey:@"msg"]] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [tishi show];
        }
    } error:^(NSError *error) {
        [weakSelf hideHUD];
        [weakSelf delayHidHUD:@"网络连接失败!"];
    } completed:^{
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
