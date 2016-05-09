//
//  ECarAboutUsController.m
//  ElectricCarRent
//
//  Created by cuibaoyin on 15/9/16.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarAboutUsController.h"
#import "ECarUser.h"
#import "ECarUserManager.h"

@interface ECarAboutUsController () <UIAlertViewDelegate>
//@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic , strong)ECarUser * zz;
@property (nonatomic , strong)ECarUserManager * manage;
@property (nonatomic , strong)UITextView * textView;
@end

@implementation ECarAboutUsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitle:@"EZZY"];
    self.view.backgroundColor = WhiteColor;
    ECarConfigs * user=[ECarConfigs shareInstance];
    _zz = user.user;
    _manage = [ECarUserManager new];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    NSString *urlStr = @"http://www.dadreams.com";
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//    [self.webView setScalesPageToFit:YES];
//    self.webView.backgroundColor = WhiteColor;
//    [self.webView loadRequest:request];
    
    [self creatUI];
    [self loadData];
}

- (void)loadData{
    [self showHUD:@"请稍等..."];
    weak_Self(self);
    [[_manage aboutUs] subscribeNext:^(id x) {
        NSDictionary * dic = x;
        [weakSelf hideHUD];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;// 字体的行间距
        NSDictionary *attributes = @{
                                     NSFontAttributeName:FontType,
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        _textView.attributedText = [[NSAttributedString alloc] initWithString:[dic objectForKey:@"phoneMsg"] attributes:attributes];
    } error:^(NSError *error) {
        [weakSelf hideHUD];
    } completed:^{
        
    }];
}

- (void)creatUI{
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(50 / 375.0 * kScreenW, 64 + 50 / 667.0 * kScreenH, kScreenW - 100 / 375.0 * kScreenW, kScreenH - 64 - 50 / 667.0 * kScreenH - 100 / 667.0 * kScreenH)];
    _textView.backgroundColor = WhiteColor;
    _textView.editable = NO;
    _textView.scrollEnabled = NO;
    
    [self.view addSubview:_textView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
