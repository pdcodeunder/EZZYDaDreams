//
//  ECarLoginViewController.m
//  ElectricCarRent
//
//  Created by LIKUN on 15/8/28.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarLoginViewController.h"
#import "ECarLoginRegisterManager.h"
#import "ECarProViewController.h"
#import "ECarUser.h"
#import "PDUUID.h"

@interface ECarLoginViewController ()
{
    BOOL phoneValid;
    BOOL verifyCodeValid;
}
@property (strong, nonatomic) ECarLoginRegisterManager *manager;
@end

@implementation ECarLoginViewController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneNumber resignFirstResponder];
    [self.checkCodeNumber resignFirstResponder];
}

- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(4 / 375.f * kScreenW, 8 / 667.f * kScreenH, 50, 50);
    [backButton setImage:[UIImage imageNamed:@"shanchu18*18"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    self.phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.manager = [ECarLoginRegisterManager new];
    if (ScreenInchSmall) {
        self.infoLabel.font = [UIFont systemFontOfSize:13.0];
        self.protocalBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    }
    
    self.protocalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.protocalBtn setTitle:@"《用户协议与法律条款》" forState:UIControlStateNormal];
    [self.protocalBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    [self.protocalBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.protocalBtn addTarget:self action:@selector(protocalBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self reSetViewFrame];
}

- (void)awakeFromNib
{
    
}

- (void)reSetViewFrame
{
    self.backImage.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    NSString * string = @"点击登录，即表示您同意";
    CGSize size = [string boundingRectWithSize:CGSizeMake(0, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.f]} context:nil].size;
    NSString * proStr = @"《用户协议与法律条款》";
    CGSize prosize = [proStr boundingRectWithSize:CGSizeMake(0, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.f]} context:nil].size;
    
    self.infoLabel.frame = CGRectMake((kScreenW - size.width - prosize.width) / 2.f, kScreenH - 55, size.width, 30);
    self.infoLabel.textAlignment = NSTextAlignmentRight;
    
    self.protocalBtn.frame = CGRectMake(CGRectGetMaxX(self.infoLabel.frame), self.infoLabel.frame.origin.y, prosize.width, 30);
    [self.view addSubview:self.protocalBtn];
    
    self.phoneView.frame = CGRectMake(60 / 375.f * kScreenW, 280 / 667.f * kScreenH, kScreenW - 120 / 375.f * kScreenW, 49);
    self.phoneNumber.frame = CGRectMake(0, 0, self.phoneView.bounds.size.width, 49);
    UIImageView * imagev = [[UIImageView alloc] initWithFrame:CGRectMake(self.phoneView.frame.origin.x, CGRectGetMaxY(self.phoneView.frame) - 3, self.phoneView.bounds.size.width, 1)];
    imagev.image = [UIImage imageNamed:@"dengluxian255*1"];
    [self.view addSubview:imagev];
    
    self.codeView.frame = CGRectMake(self.phoneView.frame.origin.x, CGRectGetMaxY(self.phoneView.frame) + 1, kScreenW - 120 / 375.f * kScreenW, 49);
    self.checkCodeNumber.frame = CGRectMake(0, 0, self.codeView.bounds.size.width - 100, 49);
    UIImageView * imagevee = [[UIImageView alloc] initWithFrame:CGRectMake(self.codeView.frame.origin.x, CGRectGetMaxY(self.codeView.frame) - 3, self.codeView.bounds.size.width, 1)];
    imagevee.image = [UIImage imageNamed:@"dengluxian255*1"];
    [self.view addSubview:imagevee];
    self.checkNumber.frame = CGRectMake(self.codeView.bounds.size.width - 80, 0, 80, 49);
    self.checkNumber.backgroundColor = [UIColor clearColor];
    self.codeView.alpha = 0.8;
    self.loginButton.frame = CGRectMake(self.phoneView.frame.origin.x, CGRectGetMaxY(self.codeView.frame) + 30, 103, 40);
    self.loginButton.center = CGPointMake(kScreenW / 2.f, CGRectGetMaxY(self.codeView.frame) + 70);
}

// 检验手机号合法性
- (BOOL)invalidPhone:(NSString *)phone
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)loginButtonEnable
{
    if (phoneValid&&verifyCodeValid) {
        self.loginButton.enabled = YES;
    }else{
        self.loginButton.enabled = NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

// 登录
-(IBAction)login:(id)sender
{
    NSString *phoneNumber = self.phoneNumber.text;
    NSString *code = self.checkCodeNumber.text;
    if (phoneNumber == nil || phoneNumber.length == 0) {
        [self delayHidHUD:@"请输入手机号"];
        return;
    }
    NSString *identifierForDevice = [PDUUID getUUID];
    PDLog(@"identifierForDevice:;  %@", identifierForDevice);
    // 访问后台接口，传递参数，解析后台返回的JESON
    [self showHUD:@"登录中..."];
    weak_Self(self);
    [[self.manager apploginWithPhone:phoneNumber pwd:code andUUID:identifierForDevice] subscribeNext:^(id x) {
        NSMutableDictionary *responseJsonOB=x;
        NSNumber *value = [responseJsonOB objectForKey:@"success"];
        // 去主页面
        if(value.boolValue == true){
            [ECarConfigs shareInstance].TokenID = code;
            [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"phone"];
            [[NSUserDefaults standardUserDefaults] setObject:code forKey:@"verifyCode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginFinished" object:nil];
            NSDictionary *objDic = responseJsonOB[@"obj"];
            ECarUser *user = [[ECarUser alloc] initWithResponse:objDic];
            [ECarConfigs shareInstance].user = user;
            NSNumber * phoneMsg = responseJsonOB[@"phoneMsg"];
            if (phoneMsg != nil && phoneMsg.boolValue == 0) {
                NSDictionary * objNo2 = responseJsonOB[@"objNo2"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"YouWeiWanChengDingDan" object:nil userInfo:objNo2];
            }
            [ECarConfigs shareInstance].loginStatue = YES;
            if (weakSelf.denglutiaozhuan == DengLuTiaoZhuanTiaoZhuan) {
                if (weakSelf.huidiaoBlock) {
                    weakSelf.huidiaoBlock(self.model, [ECarConfigs shareInstance].user);
                }
            }
            if ([ECarConfigs shareInstance].loginStatue == YES) {
                [[weakSelf.manager registerJpushid:[ECarConfigs shareInstance].user.phone jpushid:[ECarConfigs shareInstance].registerID] subscribeNext:^(id x) {
                    
                } error:^(NSError *error) {
                    
                } completed:^{
                    [weakSelf hideHUD];
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                }];
            }
        } else {
            [weakSelf hideHUD];
            NSString *message = responseJsonOB[@"msg"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phone"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"verifyCode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (message.length == 0 || !message) {
                message = @"用户名或验证码输入错误，请重新输入";
            }
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alertV show];
        }
    } error:^(NSError *error) {
        [weakSelf hideHUD];
        [weakSelf delayHidHUD:MESSAGE_NoNetwork];
    } completed:^{
        
    }];
}

- (void)protocalBtnClicked:(UIButton *)sender
{
    ECarProViewController * pro = [[ECarProViewController alloc] init];
    [self.navigationController pushViewController:pro animated:YES];
}

// 获取验证码方法
- (IBAction)getCheckCode:(id)sender{
    if (self.phoneNumber.text == nil || self.phoneNumber.text.length == 0) {
        [self delayHidHUD:@"请输入手机号"];
        return;
    }
    [self.phoneNumber resignFirstResponder];
    JJRGetCodeButton *btn = (JJRGetCodeButton *)sender;
    [btn fireCodeTimer];
    [btn getCodeBtnFinished:^{
        [btn setTitleColor:[UIColor colorWithRed:234/255.0 green:80/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
    }];
    weak_Self(self);
    // 将手机号传至后台，发起获取验证码请求,访问后台接口，传递参数，解析后台返回的JESON
    [[self.manager getCode:self.phoneNumber.text] subscribeNext:^(id x) {
        [weakSelf hideHUD];
        // x是数据模型的数组
        NSDictionary *dic = x;
        NSNumber *value = [dic objectForKey:@"success"];
        // 去主页面
        if(value.boolValue == true){
        } else {
            NSString * mgs = [NSString stringWithFormat:@"%@", dic[@"msg"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:mgs delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alert show];
        }
    } error:^(NSError *error) {
        [weakSelf hideHUD];
        [weakSelf delayHidHUD:MESSAGE_NoNetwork];
    } completed:^{
    }];
}

- (void)getUserInfo
{
    weak_Self(self);
    [[self.manager userInfo:self.phoneNumber.text] subscribeNext:^(id x) {
        ECarUser *user = x;
        [ECarConfigs shareInstance].user = user;
    } error:^(NSError *error) {
        
    } completed:^{
        [ECarConfigs shareInstance].loginStatue = YES;
        if (weakSelf.denglutiaozhuan == DengLuTiaoZhuanTiaoZhuan) {
            if (weakSelf.huidiaoBlock) {
                weakSelf.huidiaoBlock(self.model, [ECarConfigs shareInstance].user);
            }
        }
        if ([ECarConfigs shareInstance].loginStatue == YES) {
            [[weakSelf.manager registerJpushid:[ECarConfigs shareInstance].user.phone jpushid:[ECarConfigs shareInstance].registerID] subscribeCompleted:^{
                
            }];
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
