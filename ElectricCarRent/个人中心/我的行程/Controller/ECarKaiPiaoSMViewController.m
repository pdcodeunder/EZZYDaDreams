//
//  ECarKaiPiaoSMViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/4/14.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarKaiPiaoSMViewController.h"
#import "ECarUserManager.h"

@interface ECarKaiPiaoSMViewController ()

@property (nonatomic, strong)UITextView * textView;
@property (nonatomic, strong) ECarUserManager * zzManager;

@end

@implementation ECarKaiPiaoSMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = WhiteColor;
    self.title = @"开票说明";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _zzManager = [ECarUserManager new];
    [self creatUI];
    [self loadData];
}

- (void) creatUI {
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(27 / 375.f * kScreenW, 64 + 32 / 667.f * kScreenH, kScreenW - (2 * 27 / 375.f * kScreenW), kScreenH - 64)];
    _textView.backgroundColor = WhiteColor;
    _textView.editable = NO;
    _textView.scrollEnabled = NO;
    [self.view addSubview:_textView];
}

- (void)loadData{
    [[_zzManager xingchengShuoMing] subscribeNext:^(id x) {
        NSDictionary * dic = x;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;// 字体的行间距
        NSDictionary *attributes = @{
                                     NSFontAttributeName:FontType,
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        _textView.attributedText = [[NSAttributedString alloc] initWithString:[dic objectForKey:@"msg"] attributes:attributes];
    } completed:^{
        
    }];
}

@end
