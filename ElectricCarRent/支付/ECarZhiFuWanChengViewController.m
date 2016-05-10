//
//  ECarZhiFuWanChengViewController.m
//  ElectricCarRent
//
//  Created by 程元杰 on 15/12/9.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarZhiFuWanChengViewController.h"
#import "UIViewExt.h"
#import "WXApi.h"
#import "ECarConfigs.h"
@interface ECarZhiFuWanChengViewController ()

@end

@implementation ECarZhiFuWanChengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = @"支付完成";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = WhiteColor;
    [self creatSubViews];
    [self setLeftBarItem];
}

-(void)creatSubViews
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20/375.f*kScreenW, 64, kScreenW-40, 55)];
    _imageView.image = [UIImage imageNamed:@"xian337*55"];
    _imageView.userInteractionEnabled = YES;
    
    [self.view addSubview:_imageView];
    
    _thanksLabel = [[UILabel alloc] initWithFrame:_imageView.bounds];
    _thanksLabel.textAlignment = NSTextAlignmentCenter;
    _thanksLabel.text = @"感谢您的使用";
    _thanksLabel.font=[UIFont systemFontOfSize:14.f];
    _thanksLabel.textColor = RedColor;
    [_imageView addSubview:_thanksLabel];
    
    _costImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW/2.f - 40,210, 44, 44)];
    _costImageView.image = [UIImage imageNamed:@"zhifuchenggong44*44"];
                      
    [self.view addSubview:_costImageView];
    
    _costLabel = [[UILabel alloc] initWithFrame:CGRectMake(_costImageView.right-10 , 210, 100, 44)];
    _costLabel.font = FontType;
    NSString * string = [NSString stringWithFormat:@"￥%@", [ECarConfigs shareInstance].currentPrice];
    _costLabel.text = string;
    
    [self.view addSubview:_costLabel];
    if (![WXApi isWXAppInstalled]) {
        return;
    }
    _UMShareImageView = [[UMShareWXAndPengYouQuan alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 100)];
    [self.view addSubview: _UMShareImageView];
    
}
//重写基类方法
- (void)setLeftBarItem
{
    //lianxikefu24*8
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, -10, 30, 30);
    [button setImage:[UIImage imageNamed:@"fanhui9*14"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    
    //    [self.navigationController.navigationBar addSubview:button];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    if (![WXApi isWXAppInstalled]) {
        return;
    }
    UIButton * right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 30, 30);
    [right setImage:[UIImage imageNamed:@"fenxiang15*13"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(fenxiangAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbu = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightbu;
}

- (void)fenxiangAction:(UIButton *)sender
{
    [UIView animateWithDuration:.32 animations:^{
        if (_UMShareImageView.top == kScreenH) {
            _UMShareImageView.top = kScreenH - 100;
        } else {
            _UMShareImageView.top = kScreenH;
        }
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [UIView animateWithDuration:.32 animations:^{
        if (_UMShareImageView.top == kScreenH-100){
            
            _UMShareImageView.top =kScreenH;
        }
    }];
}

@end
