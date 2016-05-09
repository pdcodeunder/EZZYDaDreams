//
//  ECarBaseViewController.m
//  ECarDreams
//
//  Created by 彭懂 on 15/12/28.
//  Copyright © 2015年 彭懂. All rights reserved.
//

#import "ECarBaseViewController.h"
#import "MBProgressHUD.h"

@interface ECarBaseViewController ()

@property (strong, nonatomic)MBProgressHUD *hud;

@end

@implementation ECarBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = WhiteColor;
    [self setLeftBarItem];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

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
    
    UIButton * right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 30, 30);
    [right setImage:[UIImage imageNamed:@"lianxikefu16*17"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(callSaver:) forControlEvents:UIControlEventTouchUpInside];
    
    right.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    UIBarButtonItem *rightbu = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightbu;
}

- (void)callSaver:(UIButton *)sender
{
    UIAlertView *serviceAlert = [[UIAlertView alloc] initWithTitle:@"联系客服" message:@"400-6507265" delegate:self cancelButtonTitle:@"呼叫" otherButtonTitles:@"取消", nil];
    serviceAlert.tag = 400;
    [serviceAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 400) {
        if (buttonIndex == 0) {
            [ToolKit callTelephoneNumber:@"400-6507265" addView:self.view];
        }
    }
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

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
    [_hud hide:YES afterDelay:3];
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
