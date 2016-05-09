//
//  ECarMyCenterViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 15/10/30.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarMyCenterViewController.h"
#import "ECarMyCenterNormalTableViewCell.h"
#import "ECarTableViewHeadViewCell.h"
#import "ECarLoginRegisterManager.h"

// 个人中心子级目录
#import "ECarSettingViewController.h"
#import "ECarOrderViewController.h"
#import "ECarPictureViewController.h"
#import "ECarAboutUsController.h"
#import "ECarHelpSelfViewController.h"
#import "EZZYMemberViewController.h"
#import "ECarQuYuJiaGeViewController.h"
#import "ECarWeiZhangViewController.h"

#import "ECarAboutEZZYController.h"

#import "MBProgressHUD.h"
#import "ECarUserManager.h"

@interface ECarMyCenterViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITableView               * tableView;
@property (nonatomic, strong) ECarLoginRegisterManager  * loginManager;
@property (strong, nonatomic) MBProgressHUD             * hud;

@end

@implementation ECarMyCenterViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 19 / 667.f * kScreenH, kScreenW, 41.8 * 9 / 667.f * kScreenH)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = nil;
        _tableView.scrollEnabled = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.loginManager = [[ECarLoginRegisterManager alloc] init];
    self.view.backgroundColor = GrayColor;
//    self.view.backgroundColor = [UIColor whiteColor];
//    UIImageView * backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
//    backImage.image = [UIImage imageNamed:@"ditu375*667"];
//    [self.view addSubview:backImage];
    
    [self creatTopView];
    
    [self createTableView];
}

- (void)creatTopView{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 164 / 677.0f  * kScreenH)];
    topView.backgroundColor = RedColor;
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenW - 92) / 2, 57.f / 677.0f * kScreenH , 92, 48)];
    [imageView setImage:[UIImage imageNamed:@"ezzyicon115*60"]];
    [topView addSubview:imageView];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), kScreenW, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    NSString * yonghuID = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
    label.text = [NSString stringWithFormat:@"用户ID:%@",yonghuID] ;
    label.font = FontType;
    label.textColor = WhiteColor;
    [topView addSubview:label];
    [self.view addSubview:topView];
}

- (void)createTableView
{
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(4 / 375.f * kScreenW, 12 / 667.f * kScreenH, 50, 50);
    [backButton setImage:[UIImage imageNamed:@"shanchu18*18"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    [self.tableView registerClass:[ECarMyCenterNormalTableViewCell class] forCellReuseIdentifier:@"dddd"];
    
    UIView * tableBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 161 / 667.f * kScreenH, kScreenW, kScreenH - 161 / 667.f * kScreenH - 50)];
    tableBackView.backgroundColor = WhiteColor;
//    tableBackView.alpha = 0.7;
    [self.view addSubview:tableBackView];
    self.tableView.frame = CGRectMake(0, 19 / 667.f * kScreenH, kScreenW, tableBackView.bounds.size.height - 38 / 667.f * kScreenH);
    self.tableView.center = CGPointMake(kScreenW / 2.f, tableBackView.bounds.size.height / 2.f);
    [tableBackView addSubview:self.tableView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, kScreenH - 49, kScreenW, 49);
    [button addTarget:self action:@selector(tuituButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = WhiteColor;
//    button.alpha = 0.7;
    [self.view addSubview:button];
    
    UILabel * tuichu = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 49)];
    tuichu.text = @"退出登录";
//    tuichu.textColor = [UIColor whiteColor];
    tuichu.textAlignment = NSTextAlignmentCenter;
    tuichu.font = FontType;
    [button addSubview:tuichu];
}

- (void)backButtonClicked:(UIButton *)button
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)tuituButtonClicked:(UIButton *)sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，确认离开吗？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alert.tag = 324;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 324) {
        
        if (buttonIndex == 0) {
            weak_Self(self);
            ECarUser *user = [ECarConfigs shareInstance].user;
            [[self.loginManager loginOut:user.phone]subscribeNext:^(id x) {
                [ECarConfigs shareInstance].user = nil;
                [ECarConfigs shareInstance].loginStatue = NO;
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phone"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"verifyCode"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            } error:^(NSError *error) {
                [weakSelf delayHidHUD:@"网络异常,请检查网络是否连接"];
            } completed:^{
                //        [self.myCenterViewDelegate clickedCellWithRow:indexPath.row];
            }];
        }
    }
    if (alertView.tag == 400) {
        if (buttonIndex == 0) {
            [ToolKit callTelephoneNumber:@"400-6507265" addView:self.view];
        }
    }
}

- (void)resetCell:(ECarMyCenterNormalTableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            cell.tagImageView.image = [UIImage imageNamed:@"wodexingcheng20*20"];
            cell.titleLabel.text = @"我的行程";
            break;
        }
        case 1:
        {
            cell.tagImageView.image = [UIImage imageNamed:@"jiazhaoshenhe20*20"];
            cell.titleLabel.text = @"驾照审核";
            break;
        }
            
        case 2:
        {
            cell.tagImageView.image = [UIImage imageNamed:@"chengweihuiyuan20*20"];
            cell.titleLabel.text = @"成为会员";
            break;
        }
        case 3:
        {
            cell.tagImageView.image = [UIImage imageNamed:@"yunyingshijianjiquyu20*20"];
            cell.titleLabel.text = @"运营时间及区域";
            break;
        }
        case 4:{
            cell.tagImageView.image = [UIImage imageNamed:@"weizhangjilu20*20"];
            cell.titleLabel.text = @"违章记录";
            break;
        }
        case 5:
        {
            cell.tagImageView.image = [UIImage imageNamed:@"yonghuzhinan20*20"];
            cell.titleLabel.text = @"用户指南";
//            cell.tagImageView.image = [UIImage imageNamed:@"guankanshiping20*20"];
//            cell.titleLabel.text = @"观看视频";
            break;
        }
        case 6:
        {
            cell.tagImageView.image = [UIImage imageNamed:@"guanyuwomen20*20"];
            cell.titleLabel.text = @"关于我们";
//            cell.tagImageView.image = [UIImage imageNamed:@"daorutongxunlu20*20"];
//            cell.titleLabel.text = @"导入通讯录";
            break;
        }
        case 7:
        {
            cell.tagImageView.image = [UIImage imageNamed:@"gerenshezhi20*20"];
            cell.titleLabel.text = @"个人设置";
            break;
        }
//        case 7:
//        {
//            
//            break;
//        }
//        case 8:
//        {
//            cell.tagImageView.image = [UIImage imageNamed:@"lianxikefu20*20"];
//            cell.titleLabel.text = @"联系我们";
//            //            cell.callBtn.hidden = NO;
//            break;
//        }
//        case 9:
//        {
//            
//        }
        default:
            break;
    }
}

- (void)clickedmyCenterCellWithRow:(NSInteger)row
{
    //    [self coverControlClicked:nil];
    
    switch (row)
    {
        case 0:// 我的行程
        {
            ECarOrderViewController * orderVC = [[ECarOrderViewController alloc] init];
            orderVC.orderDelegate = self.myCenterViewDelegate;
            [self.navigationController pushViewController:orderVC animated:YES];
            break;
        }
        case 1:// 驾照审核
        {
            ECarPictureViewController * pickture = [[ECarPictureViewController alloc] init];
            [self.navigationController pushViewController:pickture animated:YES];
            
            break;
        }
        case 2:// 成为会员
        {
            EZZYMemberViewController *member = [[EZZYMemberViewController alloc] init];
            [self.navigationController pushViewController:member animated:YES];
            
            break;
        }
        case 3:// 区域限制
        {
            ECarQuYuJiaGeViewController * quyu = [[ECarQuYuJiaGeViewController alloc] init];
            [self.navigationController pushViewController:quyu animated:YES];
            break;
        }
        case 4:{
            ECarWeiZhangViewController *weizhang = [[ECarWeiZhangViewController alloc] init];
            [self.navigationController pushViewController:weizhang animated:YES];
            break;
        }
        case 5:// 用户指南
        {
            ECarHelpSelfViewController *controller = [[ECarHelpSelfViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 6: // 关于我们
        {
            ECarAboutEZZYController * aboutEzzy = [[ECarAboutEZZYController alloc] init];
            [self.navigationController pushViewController:aboutEzzy animated:YES];
            break;
        }
        case 7:// 个人设置
        {
            ECarSettingViewController * controller = [[ECarSettingViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECarMyCenterNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dddd" forIndexPath:indexPath];
    cell.backgroundColor = WhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self resetCell:cell withIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self clickedmyCenterCellWithRow:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.bounds.size.height / 8.0;
}

#pragma mark ---HUD
- (void)showHUD:(NSString *)text
{
    if (!self.hud) {
        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
        _hud.mode = MBProgressHUDAnimationFade;
        [self.view addSubview:_hud];
    }
    [_hud setLabelText:text];
    [_hud show:YES];
}
- (void)hideHUD
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.hud = nil;
}
- (void)delayHidHUD:(NSString *)text
{
    if (!self.hud) {
        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
        _hud.mode = MBProgressHUDModeText;
        [self.view addSubview:_hud];
    }
    [_hud setLabelText:text];
    [_hud show:YES];
    [_hud hide:YES afterDelay:2];
}

@end
