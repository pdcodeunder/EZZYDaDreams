//
//  WZSMViewController.m
//  ElectricCarRent
//
//  Created by 张钊 on 16/4/14.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "WZSMViewController.h"
#import "ECarUserManager.h"

@interface WZSMViewController ()

@property (nonatomic, strong)UITextView * textView;

@property (nonatomic, strong)ECarUserManager * zzManager;

@end

@implementation WZSMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = WhiteColor;
    self.title = @"违章说明";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _zzManager = [ECarUserManager new];
    
    [self creatUI];
    [self loadData];
}

- (void)creatUI{
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(27 / 375.f * kScreenW, 64 + 32 / 667.f * kScreenH, kScreenW - (2 * 27 / 375.f * kScreenW), kScreenH - 64)];
    _textView.backgroundColor = WhiteColor;
    _textView.editable = NO;
    _textView.scrollEnabled = NO;
    [self.view addSubview:_textView];
}

- (void)loadData{
    [[_zzManager weizhangshuoming] subscribeNext:^(id x) {
        NSDictionary * dic = x;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;// 字体的行间距
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        _textView.attributedText = [[NSAttributedString alloc] initWithString:[dic objectForKey:@"msg"] attributes:attributes];
    } completed:^{
        
    }];
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
