//
//  SubmitViewController.m
//  提交成功
//
//  Created by 程元杰 on 16/3/30.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "SubmitViewController.h"
@interface SubmitViewController ()

@property (nonatomic, assign) BOOL sucessed;
@property (nonatomic, strong) NSString *msg;

@end

@implementation SubmitViewController

- (instancetype)initWithSuccess:(BOOL)success andMessage:(NSString *)msg
{
    self = [super init];
    if (self) {
        self.sucessed = success;
        self.msg = msg;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.title = @"行程开票";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self creatSubViews];
}

- (void)creatSubViews
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _imageView.image = self.sucessed ? [UIImage imageNamed:@"成功提示"] : [UIImage imageNamed:@"失败提示"];
    _imageView.center = CGPointMake(kScreenW / 2.0, 200 / 667.f * kScreenH);
    [self.view addSubview:_imageView];
    
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.text = self.sucessed ? @"提交成功" : @"提交失败";
    _statusLabel.font = [UIFont systemFontOfSize:18];
    _statusLabel.center = CGPointMake(kScreenW/2.0, 260/667.f*kScreenH);
    [self.view addSubview:_statusLabel];
    
    _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    _promptLabel.text = self.sucessed ? @"我们会尽快将发票寄到你的手上" : self.msg;
    _promptLabel.font = [UIFont systemFontOfSize:12];
    _promptLabel.textColor = [UIColor grayColor];
    _promptLabel.center = CGPointMake(kScreenW/2.0, 290/667.f*kScreenH);
    [self.view addSubview:_promptLabel];
    
    _xianLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenH - 50, kScreenW, 1)];
    _xianLabel.backgroundColor = kColorStr;
    [self.view addSubview:_xianLabel];
    
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.frame = CGRectMake(0, kScreenH - 50, kScreenW, 50);
    if (self.sucessed == YES) {
        [_button setTitle:@"关闭" forState:UIControlStateNormal];
    } else {
        [_button setTitle:@"重新提交" forState:UIControlStateNormal];
    }
    [_button setTitleColor:RedColor forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}

- (void)buttonAction:(UIButton *)sender
{
    if (self.sucessed == YES) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
