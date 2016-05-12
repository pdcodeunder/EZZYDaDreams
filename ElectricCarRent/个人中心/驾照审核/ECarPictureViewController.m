//
//  ECarPictureViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 15/11/10.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarPictureViewController.h"
#import "ECarPictureTestViewController.h"
#import "ECarMyCenterViewController.h"
#import "ECarLoginRegisterManager.h"
#import "UIViewExt.h"
@interface ECarPictureViewController ()
@property (strong, nonatomic) ECarLoginRegisterManager *loginManager;
@end

@implementation ECarPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    _loginManager = [ECarLoginRegisterManager new];
    self.title = @"驾照审核";
    [self createTableView];
}

- (void)createTableView
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20/375.f*kScreenW, 64, kScreenW-40, 55)];
    _imageView.image = [UIImage imageNamed:@"xian337*55"];
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];

    _label = [[UILabel alloc] initWithFrame:CGRectMake(_imageView.right-117, 8, 70, 40)];
    _label.textAlignment = NSTextAlignmentRight;
    _label.font=[UIFont systemFontOfSize:14.f];
    _label.text=[[ECarConfigs shareInstance].user userInfoNowStatusString];
    _label.textColor = RedColor;
    [_imageView addSubview:_label];
    
    _shenheLabel = [[UILabel alloc] initWithFrame:CGRectMake(26/375.f*kScreenW, 8, 100, 40)];
    _shenheLabel.text = @"驾照审核";
    _shenheLabel.font = [UIFont systemFontOfSize:14];
    [_imageView addSubview:_shenheLabel];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = _imageView.bounds;
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_imageView addSubview:_button];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (void)buttonAction:(UIButton *)button
{
    if ([ECarConfigs shareInstance].user.islock.integerValue == 1) {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"用户已锁定" message:@"用户状态被锁定，如有疑问，请联系客服：400-6507265。" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertV show];
        return;
    }
    
    ECarPictureTestViewController * picture = [[ECarPictureTestViewController alloc] init];
    [picture returnText:^(NSString *blckStr) {
        NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
        NSString *code = [[NSUserDefaults standardUserDefaults] objectForKey:@"verifyCode"];
        if (phone.length == 0||code.length == 0) {
            return;
        }
        [[_loginManager userInfo:phone]subscribeNext:^(id x) {
            ECarUser *user = x;
            [ECarConfigs shareInstance].user = user;
        } error:^(NSError *error) {
            
        } completed:^{
            _label.text =[[ECarConfigs shareInstance].user userInfoNowStatusString];
        }];
    }];
    [self.navigationController pushViewController:picture animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
    NSString *code = [[NSUserDefaults standardUserDefaults]objectForKey:@"verifyCode"];
    if (phone.length == 0||code.length == 0) {
        return;
    }
    [[_loginManager userInfo:phone]subscribeNext:^(id x) {
        ECarUser *user = x;
        [ECarConfigs shareInstance].user = user;
        
//        PDLog(@"%@",[[ECarConfigs shareInstance].user userInfoNowStatusString]);
        _label.text = [[ECarConfigs shareInstance].user userInfoNowStatusString];
        //        [self createTableView];
        
    } error:^(NSError *error) {
        
    } completed:^{
        
        _label.text =[[ECarConfigs shareInstance].user userInfoNowStatusString];
        
//        PDLog(@"回调状态为 %@",_label.text);
        
    }];
    

}

@end
