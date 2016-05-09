//
//  ECarLoginViewController.h
//  ElectricCarRent
//
//  Created by LIKUN on 15/8/28.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarBaseViewController.h"
#import "JJRGetCodeButton.h"
#import "ECarOrderViewController.h"

//@class ECarCarInfo;
typedef NS_ENUM(NSUInteger, DengLuTiaoZhuan) {
    DengLuTiaoZhuanDefault = 1 << 1,
    DengLuTiaoZhuanTiaoZhuan = 1 << 2
};

typedef void(^HuiDiaoBlock)(id model, ECarUser * user);
@interface ECarLoginViewController : ECarBaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak,nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak,nonatomic) IBOutlet UITextField *checkCodeNumber;
@property (weak,nonatomic) IBOutlet JJRGetCodeButton *checkNumber;
@property (weak,nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) UIButton *protocalBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) ECarCarInfo * model;
@property (copy, nonatomic) HuiDiaoBlock huidiaoBlock;
@property (assign, nonatomic) DengLuTiaoZhuan denglutiaozhuan;

-(IBAction)getCheckCode:(id)sender;
-(IBAction)login:(id)sender;

@end
