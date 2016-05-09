//
//  ECarSettingViewController.m
//  ElectricCarRent
//
//  Created by 程元杰 on 15/12/8.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarSettingViewController.h"
@interface ECarSettingViewController ()

@end

@implementation ECarSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个性化设置";
    _titleList = @[@"常用地址",@"消息音效"];
    
    self.view.backgroundColor = WhiteColor;
    
    [self creatSubViews];
}

- (void)creatSubViews
{
    _listView = [[UIImageView alloc] initWithFrame:CGRectMake(20/375.f*kScreenW, 64, kScreenW-40, 55)];
    _listView.image = [UIImage imageNamed:@"kuang337*55"];
    _listView.userInteractionEnabled = YES;
    
    UILabel *  label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 55)];
    label.text  = @"常用地址";
    label.font = [UIFont systemFontOfSize:14];
    [_listView addSubview:label];
    
    UIButton * pushButton =[ UIButton buttonWithType:UIButtonTypeCustom];
    pushButton.frame =  CGRectMake(0, 0, kScreenW - 40, 55) ;
    [pushButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_listView addSubview:pushButton];
    [self.view addSubview:_listView];
    
    _listView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20/375.f*kScreenW, 64+55, kScreenW-40, 55)];
    _listView1.image = [UIImage imageNamed:@"xian337*55"];
    _meslabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 55)];
    _meslabel.text  = @"消息音效";
    _meslabel.font = [UIFont systemFontOfSize:14];
    _listView1.userInteractionEnabled = YES;
    _switchBar = [[UISwitch alloc] initWithFrame:CGRectMake(285/375.f*kScreenW, 10, 40, 55)];
    
    [_switchBar addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    NSNumber * ison =  [[NSUserDefaults standardUserDefaults] objectForKey:kSoundEffectIsOnKey];
    if (ison) {
        [_switchBar setOn:ison.boolValue];
    } else {
        [_switchBar setOn:NO];
    }
    
    [_listView1 addSubview:_switchBar];
    [_listView1 addSubview:_meslabel];
    [self.view addSubview:_listView1];
    
}

- (void)buttonAction:(UIButton * )sender
{
    ECarHomeAndCompViewController * ecarVC  = [[ECarHomeAndCompViewController alloc] init];
    
    [self.navigationController pushViewController:ecarVC animated:YES];
}

- (void)switchAction:(UISwitch *)sender
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@(sender.on) forKey:kSoundEffectIsOnKey];
    [userDefaults synchronize];
}
@end
