//
//  ECarPictureTestViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 15/11/12.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarPictureTestViewController.h"
#import "MBProgressHUD.h"
#import "ECarUserManager.h"
#import "ECarLoginRegisterManager.h"
#import "ECarConfigs.h"
#import "UIViewExt.h"
#define NowStatus @"[[ECarConfigs shareInstance].user userInfoNowStatusString]"
@interface ECarPictureTestViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController   * imagePikerViewController;
@property (nonatomic, strong) UILabel                   * titleLabel;
@property (nonatomic, strong) UIButton                  * photoButton;
@property (nonatomic, strong) UIButton                  * sureButton;
@property (strong, nonatomic) MBProgressHUD             * hud;
@property (strong, nonatomic) ECarUserManager           * manager;
@property (strong, nonatomic) UIImage                   * currentImage;
@property (strong, nonatomic) ECarLoginRegisterManager  * loginManager;
@property(strong, nonatomic)NSMutableDictionary         * imageUrlDic;
@property(strong, nonatomic)UIImage                     * image;
@property(strong, nonatomic)UIImageView                 * staImageView;
@property(strong, nonatomic)UILabel                     * staLabel;

@end
@implementation ECarPictureTestViewController

- (void)viewDidLoad {
    _shenheLabel.hidden = YES;
    _shenheLabel.hidden = YES;
     _loginManager=[ECarLoginRegisterManager new];
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.manager = [ECarUserManager new];
    self.title = @"驾照审核";
    _staImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100/320.f*kScreenW, 70, 37, 37)];
    [self.view addSubview:_staImageView];
    [self.view addSubview:_staImageView];
    [self _creatNewSubViews];
    [self _creatPhotoButton];
    [self _creatSureButton];
}

//新版视图排版
- (void)_creatNewSubViews
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20/375.f*kScreenW, 64, kScreenW-40, 55)];
    _imageView.image = [UIImage imageNamed:@"xian337*55"];
    _imageView.userInteractionEnabled = YES;
    
    [self.view addSubview:_imageView];
    if ([NowStatus isEqualToString:@"未提交审核"]) {
        _staLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW-40, 55)];
        _staLabel.textAlignment = NSTextAlignmentCenter;
        _staLabel.font=[UIFont systemFontOfSize:14.f];
        _staLabel.text=@"请上传您的驾驶证";
        _staLabel.textColor = RedColor;
        [_imageView addSubview:_staLabel];
    }else{
        _shenheLabel.hidden = NO;
        _label.hidden = NO;
        _shenheLabel = [[UILabel alloc] initWithFrame:CGRectMake(26/375.f*kScreenW, 8, 100, 40)];
        _shenheLabel.text = @"驾照审核";
        _shenheLabel.font = [UIFont systemFontOfSize:14];
        [_imageView addSubview:_shenheLabel];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(_imageView.right-117, 8, 70, 40)];
        _label.textAlignment = NSTextAlignmentRight;
        _label.font=[UIFont systemFontOfSize:14.f];
        _label.text=[[ECarConfigs shareInstance].user userInfoNowStatusString];
        _label.textColor = RedColor;
        [_imageView addSubview:_label];
    }
    [self.view addSubview:_imageView];
}

//拍照按钮

- (void)_creatPhotoButton
{
    if (!_photoButton) {
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoButton.frame = CGRectMake((kScreenW-233)/2/375.f*kScreenW, 130, kScreenW - 60 / 375.f * kScreenW, 161/375.f * kScreenW);
        _photoButton.center = CGPointMake(kScreenW / 2.f, (kScreenH - 64) / 2.f);
        _photoButton.center = self.view.center;
        
        NSString * str = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/pic.plist"];
        NSDictionary * dicv = [NSDictionary dictionaryWithContentsOfFile:str];
        NSData * imageData = dicv[[ECarConfigs shareInstance].user.phone];
        UIImage * image1 = [UIImage imageWithData:imageData];
//        UIImage * image2=[self OriginImage:image1 scaleToSize:CGSizeMake(260, 320)];
        
        if ([[[ECarConfigs shareInstance].user userInfoNowStatusString] isEqualToString:@"未提交审核"]) {
            UIImage * imag = [UIImage imageNamed:@"jiashizheng236*161"];
            CGFloat f = kScreenW - 60 / 375.f * kScreenW;
            self.photoButton.bounds = CGRectMake(0, 0, f, f / imag.size.width * imag.size.height);
            [_photoButton setBackgroundImage:imag forState:UIControlStateNormal];
            
        }
        else if(imageData==nil && ![[[ECarConfigs shareInstance].user userInfoNowStatusString] isEqualToString:@"未提交审核"])
        {
            ECarConfigs * user=[ECarConfigs shareInstance];
            ECarUser * yj = user.user;
            
            [[self.manager  getPicture:yj.user_id]  subscribeNext:^(id x) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSURL * url = [NSURL URLWithString:x[@"obj"]];
                    NSData * data = [NSData dataWithContentsOfURL:url];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (data) {
                            UIImage * image3 =[ UIImage imageWithData:data];
                            CGFloat f = kScreenW - 60 / 375.f * kScreenW;
                            self.photoButton.bounds = CGRectMake(0, 0, f, f / image3.size.width * image3.size.height);
                            [_photoButton setBackgroundImage:image3 forState:UIControlStateNormal];
                        }
                    });
                });
            } completed:^{
                
            }];
        }else {
            CGFloat f = kScreenW - 60 / 375.f * kScreenW;
            self.photoButton.bounds = CGRectMake(0, 0, f, f / image1.size.width * image1.size.height);
            [_photoButton setBackgroundImage:image1 forState:UIControlStateNormal];
            [_photoButton setBackgroundImage:image1 forState:UIControlStateNormal];
        }    }
    [self.view addSubview:self.titleLabel];
    [self.photoButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.photoButton];

}
//提交照片按钮
- (void)_creatSureButton
{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenH-50, kScreenW, 1)];
    _label.backgroundColor =GrayColor;
    [self.view addSubview:_label];
    
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(0, kScreenH - 49, kScreenW, 49);
        if ([[[ECarConfigs shareInstance].user userInfoNowStatusString]  isEqualToString:@"未提交审核"]) {
            [_sureButton setTitle:@"提交" forState:UIControlStateNormal];
            _sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [_sureButton setTitleColor:RedColor forState:UIControlStateNormal];
        }else if ([[[ECarConfigs shareInstance].user userInfoNowStatusString] isEqualToString:@"审核通过"]){
            [_sureButton setTitle:@"已提交" forState:UIControlStateNormal];
            [_sureButton setTitleColor:RedColor forState:UIControlStateNormal];
               _sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
                        _sureButton.enabled=NO;
            _photoButton.enabled = NO;
        }else {
            [_sureButton setTitle:@"重新提交" forState:UIControlStateNormal];
               _sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [_sureButton setTitleColor:RedColor forState:UIControlStateNormal];
            
        }
        [self.sureButton addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.sureButton];
    }
}
- (void)sureButtonClicked:(UIButton *)sender
{
    weak_Self(self);
    //    ECarUser * user = [ECarConfigs shareInstance].user;
    NSData *_data = UIImageJPEGRepresentation(self.currentImage, 0.6f);
    if (_data != nil) {
        [self showHUD:@"正在上传"];
        NSString *_encodedImageStr = [_data base64EncodedStringWithOptions:0];
        NSString * phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
        [[self.manager updatePicture:phoneNumber file:_encodedImageStr] subscribeNext:^(id x) {
            NSDictionary * dic = x;
            NSString * str = [NSString stringWithFormat:@"%@", dic[@"success"]];
            if (str.intValue == 1) {
                NSDictionary *objDic = dic[@"obj"];
                ECarUser *user = [[ECarUser alloc] initWithResponse:objDic];
                [ECarConfigs shareInstance].user = user;
            }
            [self hideHUD];
            [self delayHidHUD:@"上传成功"];
            [_sureButton setTitle:@"重新提交" forState:UIControlStateNormal];
            NSString * str1 = @"待审核";
            self.returnTextBlock(str1);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } error:^(NSError *error) {
            [self hideHUD];
            [self delayHidHUD:@"上传失败"];
        } completed:^{
            
        }];
        
        NSString *path_sandox = NSHomeDirectory();
        NSString * filePath= [path_sandox stringByAppendingPathComponent:@"/Documents/pic.plist"];
        NSMutableDictionary * dic=[NSMutableDictionary dictionary];
        [dic  setValue:_data forKey:[ECarConfigs shareInstance].user.phone];
        //写入plist文件
        if ([dic writeToFile:filePath atomically:YES]) {
        };
    }
    [self  refreshDataFromEcar];
}

- (void)returnText:(ReturnTextBlock)block
{
    self.returnTextBlock = block;
}

- (void)buttonClicked:(UIButton *)sender
{
    [self createPhontoCammor];
}

#pragma mark - 照相
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage * image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    self.currentImage = image;
//    UIImage * image1 = [self imageCompressForSize:image targetSize:CGSizeMake(260, 300)];
    CGFloat f = kScreenW - 60 / 375.f * kScreenW;
    self.photoButton.bounds = CGRectMake(0, 0, f, f / image.size.width * image.size.height);
    [self.photoButton setBackgroundImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)createPhontoCammor
{
    self.imagePikerViewController = [[UIImagePickerController alloc] init];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.0, (kScreenH-250)/2.0, 315/ 320.f * kScreenW, 231 / 320.f * kScreenW)];
    imageView.image = [UIImage imageNamed:@"xiangkuang333*231"];
        imageView.center = CGPointMake(kScreenW / 2.f, kScreenH / 2.f - 30);
    [self.imagePikerViewController.view addSubview:imageView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.f];
    label.textColor = [UIColor whiteColor];
    label.center = CGPointMake(kScreenW / 2.f, 25);
    label.text = @"请拍摄你的驾驶证";
    //    [self.imagePikerViewController.view addSubview:label];
    
    self.imagePikerViewController.delegate = self;
    self.imagePikerViewController.allowsEditing = YES;
    //    PDLog(@"ddd d  ddd  %@", self.imagePikerViewController.view.subviews);
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.imagePikerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePikerViewController animated:NO completion:NULL];
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机摄像头没有哦～" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    //    self.imageview.contentMode = UIViewContentModeScaleAspectFit;
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
    if(!self.hud) {
        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
        _hud.mode = MBProgressHUDModeText;
        [self.view addSubview:_hud];
    }
    [_hud setLabelText:text];
    [_hud show:YES];
    [_hud hide:YES afterDelay:3];
}
- (void)refreshDataFromEcar
{
    
    NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
    NSString *code = [[NSUserDefaults standardUserDefaults]objectForKey:@"verifyCode"];
    if (phone.length == 0||code.length == 0) {
        return;
    }
        [ECarConfigs shareInstance].TokenID = code;
        [ECarConfigs shareInstance].loginStatue = YES;
        [[_loginManager userInfo:phone]subscribeNext:^(id x) {
            ECarUser *user = x;
            [ECarConfigs shareInstance].user = user;
        } error:^(NSError *error) {
            
        } completed:^{
            
            _staLabel.text=[[ECarConfigs shareInstance].user userInfoNowStatusString];
            
        }];
    
}

@end
