//
//  ECarLianxiwomenViewController.m
//  ElectricCarRent
//
//  Created by 张钊 on 16/2/29.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarLianxiwomenViewController.h"
#import "UIKit+AFNetworking.h"

#import "ECarUser.h"
#import "ECarUserManager.h"

@interface ECarLianxiwomenViewController ()

@property (nonatomic , strong)ECarUser * zz;
@property (nonatomic , strong)ECarUserManager * manage;
@property (nonatomic , strong)UITextView * textViewTop;
@property (nonatomic , strong)UITextView * textViewDown;
@property (nonatomic, strong) UIImageView * image1;
@property (nonatomic, strong) UIImageView * image2;


@end

@implementation ECarLianxiwomenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ECarConfigs * user=[ECarConfigs shareInstance];
    _zz = user.user;
    _manage = [ECarUserManager new];
    
    self.title = @"联系我们";
    self.view.backgroundColor = WhiteColor;
    
    [self creatUI];
    
    [self loadData];
}

- (void)loadData{
    weak_Self(self);
    [self showHUD:@"请稍等..."];
    [[_manage connectUs]subscribeNext:^(id x) {
        [weakSelf hideHUD];
        NSDictionary * dic = [x objectForKey:@"attributes"];
        _textViewTop.text = [dic objectForKey:@"kefu"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;// 字体的行间距
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:14.0],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        _textViewDown.attributedText = [[NSAttributedString alloc] initWithString:[dic objectForKey:@"dameng"] attributes:attributes];
        [weakSelf.image1 setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"erweima1"]]];
        [weakSelf.image2 setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"erweima2"]]];
    } error:^(NSError *error) {
        [weakSelf hideHUD];
    } completed:^{
        
    }];
}

- (void)creatUI{
    
    // EZZY 客服:  400-6507265
    UIView * viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 64 / 667.0 * kScreenH, kScreenW, 120 / 667.0 * kScreenH)];
    
    UILabel * labelTop = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 30 / 667.0 * kScreenH)];
    labelTop.text = @"EZZY";
    labelTop.textColor = RedColor;
    labelTop.backgroundColor = WhiteColor;
    labelTop.center = CGPointMake(kScreenW / 2, 45 / 667.0 * kScreenH);
    labelTop.textAlignment = NSTextAlignmentCenter;
    labelTop.font = [UIFont systemFontOfSize:14.0f];
    [viewTop addSubview:labelTop];
    
    UITextView * textViewTop = [[UITextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(labelTop.frame), kScreenW, 30 / 667.0 * kScreenH)];
    textViewTop.backgroundColor = WhiteColor;
//    textViewTop.text = @"客服:  400-6507265";
    textViewTop.textAlignment = NSTextAlignmentCenter;
    textViewTop.editable = NO;
    textViewTop.scrollEnabled = NO;
    textViewTop.font = [UIFont systemFontOfSize:14.0f];
    [viewTop addSubview:textViewTop];
    _textViewTop = textViewTop;
    
    UILabel * labelLine = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(viewTop.frame), kScreenW - 20, 1 / 667.0 * kScreenH)];
    labelLine.backgroundColor = GrayColor;
    [self.view addSubview:labelLine];
    
    [self.view addSubview:viewTop];
    
    // 大梦科技
    UIView * viewDown = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewTop.frame) + 1 , kScreenW, kScreenH - (64 + 120 + 1) / 667.0 * kScreenH)];
    viewDown.backgroundColor = WhiteColor;
    
    UILabel * labelDown = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 15 / 667.0 * kScreenH)];
    labelDown.text = @"大梦科技";
    labelDown.textColor = RedColor;
    labelDown.center = CGPointMake(kScreenW / 2, 45 / 667.0 * kScreenH);
    labelDown.textAlignment = NSTextAlignmentCenter;
    labelDown.font = [UIFont systemFontOfSize:14.0f];
    [viewDown addSubview:labelDown];
    
    UITextView * textViewDown = [[UITextView alloc]init];
//    textViewDown.text = @"客服:  400-6507265\n客服:  400-6507265\n客服:  400-89nvm39091\n客服:  400-89nbnvhhvnvnv39091\n客服:  400-6507265\n客服:  400-6507265\n客服:  400-6507265";
    textViewDown.frame = CGRectMake(70 / 375.0 * kScreenW , CGRectGetMaxY(labelDown.frame) + 15 / 375.0 * kScreenW, kScreenW - 70 / 375.0 * kScreenW, 200 / 667.0 * kScreenH);
    textViewDown.backgroundColor = WhiteColor;
    textViewDown.editable = NO;
    textViewDown.scrollEnabled = NO;
    textViewDown.textAlignment = NSTextAlignmentLeft;
    _textViewDown = textViewDown;
    
    UIView * erweimaView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textViewDown.frame) + 15 / 375.0 * kScreenW, kScreenW, viewDown.frame.size.height - textViewDown.frame.size.width - labelDown.frame.size.height)];
    NSInteger gap = (kScreenW - 113 / 375.0 * kScreenW) / 2;
    
    UIImageView * erweimaImageView = [[UIImageView alloc]initWithFrame:CGRectMake(gap, 0, 113 / 375.0 * kScreenW, 137.5 / 667.0 * kScreenH)];
    [erweimaView addSubview:erweimaImageView];
    self.image1 = erweimaImageView;
    
//    UIImageView * imageViewLeft = [[UIImageView alloc]initWithFrame:CGRectMake(gap - 10, 0, 110 / 375.0 * kScreenW, 111 / 667.0 * kScreenH)];
    
//    UIImageView * imageViewRight = [[UIImageView alloc]initWithFrame:CGRectMake(gap + 110 / 375.0 * kScreenW + 20, 0, 110 / 375.0 * kScreenW, 111 / 667.0 * kScreenH)];
//    [erweimaView addSubview:imageViewLeft];
//    [erweimaView addSubview:imageViewRight];
//    self.image1 = imageViewLeft;
//    self.image2 = imageViewRight;
    
    [viewDown addSubview:textViewDown];
    [viewDown addSubview:erweimaView];
    [self.view addSubview:viewDown];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
