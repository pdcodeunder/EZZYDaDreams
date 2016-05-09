//
//  ECarFapiaoViewController.m
//  ElectricCarRent
//
//  Created by 张钊 on 16/3/29.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarDDFapiaoViewController.h"
#import "ECarFaPiaoViewController.h"
#import "ECarMumberFaPiaoViewController.h"

@interface ECarDDFapiaoViewController ()

@end

@implementation ECarDDFapiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发票";
    self.view.backgroundColor = WhiteColor;
    [self creatUI];
}

- (void)creatUI{
    UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20/375.f*kScreenW, 64, kScreenW-40, 55)];
    imageView1.image = [UIImage imageNamed:@"kuang337*55"];
    imageView1.userInteractionEnabled = YES;
    
    UILabel *  label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 55)];
    label1.text  = @"行程开票";
    label1.font = [UIFont systemFontOfSize:14];
    [imageView1 addSubview:label1];
    
    UIButton * pushButton =[ UIButton buttonWithType:UIButtonTypeCustom];
    pushButton.frame =  CGRectMake(0, 0, kScreenW - 40, 55) ;
    pushButton.tag = 111;
    [pushButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageView1 addSubview:pushButton];
    [self.view addSubview:imageView1];
    
    UIImageView * imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(20/375.f*kScreenW, CGRectGetMaxY(imageView1.frame), kScreenW-40, 55)];
    imageView2.image = [UIImage imageNamed:@"kuang337*55"];
    imageView2.userInteractionEnabled = YES;
    
    UILabel *  label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 55)];
    label2.text  = @"购买会员开票";
    label2.font = [UIFont systemFontOfSize:14];
    [imageView2 addSubview:label2];
    
    UIButton * pushButton2 =[UIButton buttonWithType:UIButtonTypeCustom];
    pushButton2.frame =  CGRectMake(0, 0, kScreenW - 40, 55) ;
    pushButton2.tag = 222;
    [pushButton2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageView2 addSubview:pushButton2];
    [self.view addSubview:imageView2];
}

- (void)buttonAction:(UIButton *)btn{
    if (btn.tag == 111) {
        ECarFaPiaoViewController * xingcheng = [[ECarFaPiaoViewController alloc] init];
        [self.navigationController pushViewController:xingcheng animated:YES];
    } else if (btn.tag == 222) {
        ECarMumberFaPiaoViewController *vip = [[ECarMumberFaPiaoViewController alloc] init];
        [self.navigationController pushViewController:vip animated:YES];
    }
}

@end
