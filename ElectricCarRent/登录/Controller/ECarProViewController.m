//
//  ECarProViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/1/15.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarProViewController.h"

@interface ECarProViewController ()

@end

@implementation ECarProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"用户协议及法律条款";
    [self creatWeb];
}

- (void)creatWeb {
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH)];
    webView.scalesPageToFit = YES;
    webView.backgroundColor = WhiteColor;
    [self.view addSubview:webView];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@car/AppWeb/loginfltl.html", ServerURL]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

@end
