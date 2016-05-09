//
//  ECarXingCFPViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/3/30.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarXingCFPViewController.h"
#import "ECarUserManager.h"
#import "SubmitViewController.h"
#import "ECarKaiPiaoSMViewController.h"

@interface ECarXingCFPViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong)NSArray * titleArray;
@property (nonatomic, strong)NSArray * leiXingArray;
@property (nonatomic, strong)UITextField * taiTouFiled; //公司抬头
@property (nonatomic, strong)UILabel * countentLabel; //发票内容；
@property (nonatomic, strong)UILabel * priceLabel; //金额；
@property (nonatomic, strong)UITextField * pepFiled;//收件人
@property (nonatomic, strong)UITextField * phoneLable;//电话
@property (nonatomic, strong)UIPickerView * pickerView;
@property (nonatomic, strong)UITextField * addressFiled; //地址
@property (nonatomic, strong)UILabel * shengLabel;
@property (nonatomic, strong)UILabel * shiLabel;
@property (nonatomic, strong)UILabel * quLabel;
@property (nonatomic, strong)NSArray * shengArray;
@property (nonatomic, strong)NSArray * shiArray;
@property (nonatomic, strong)NSMutableArray * quArray;
@property (nonatomic, strong)UIView * bottomView;
@property (nonatomic, strong)UIButton * cancleButton;
@property (nonatomic, strong)UIButton * certainButton;
@property (nonatomic, strong) NSString * allPrice;
@property (nonatomic, strong) UIControl *control;
@property (nonatomic, strong) UIView *submitView;


@property (nonatomic, strong) UILabel *gsLabel;
@property (nonatomic, strong) UILabel *sjrLabel;
@property (nonatomic, strong) UILabel *sjdzLabel;
@property (nonatomic, strong) UILabel *yjfyLabel;

@property (nonatomic, strong) ECarUserManager * userManager;

@end

@implementation ECarXingCFPViewController

- (ECarUserManager *)userManager
{
    if (!_userManager) {
        _userManager = [[ECarUserManager alloc] init];
    }
    return _userManager;
}

- (UIControl *)control
{
    if (!_control) {
        _control = [[UIControl alloc] initWithFrame:self.view.bounds];
        _control.backgroundColor = [UIColor blackColor];
        _control.alpha = 0;
    }
    return _control;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithPrice:(CGFloat)price;
{
    self = [super init];
    if (self) {
        self.allPrice = [NSString stringWithFormat:@"%.2f", price];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
//    [self createDataSouce];
//    [self createUI];
    [self createData];
    [self setSubViewUI];
    [self createRightButton];
}

- (void)createRightButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 30);
    [btn setTitle:@"开票说明" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = btnItem;
}

- (void)rightBarButtonItemClicked:(id)sender
{
    ECarKaiPiaoSMViewController *kaiPiaoSM = [[ECarKaiPiaoSMViewController alloc] init];
    [self.navigationController pushViewController:kaiPiaoSM animated:YES];
}

- (void)createData
{
    _titleArray = @[@"公司抬头",@"发票内容",@"发票金额",@"收  件  人",@"联系电话",@"所在地区",@"详细地址"];
    self.view.backgroundColor = WhiteColor;
    _leiXingArray = @[@"UITextField",@"UILabel",@"UILabel",@"UITextField",@"UILabel",@"UIPageControl",@"UITextField"];
    [self creatSubViews];
    [self creatTextAndLabel];
    _quArray = [[NSMutableArray alloc] init];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary * dic  = data[@"0"];
    NSArray * array = dic[@"北京市"][@"0"][@"北京市"];
    for (NSString * str in array) {
        [_quArray addObject:str];
    }
    _shengArray = @[@"北京"];
    _shiArray = @[@"北京市"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardWillHidden
{
    [UIView animateWithDuration:.2 animations:^{
        self.view.top = 0;
    }];
}

- (void)setSubViewUI
{
    [self.control addTarget:self action:@selector(controlClicked) forControlEvents:UIControlEventTouchUpInside];
    self.control.hidden = YES;
    [self.view addSubview:self.control];
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 258 / 667.f * kScreenH)];
    _bottomView.backgroundColor = WhiteColor;
    [self.view addSubview:_bottomView];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, _bottomView.height - 134 / 667.f * kScreenH, kScreenW, 134 / 667.f * kScreenH)];
    _pickerView.delegate = self;
    [_bottomView addSubview:_pickerView];
    
    _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleButton.frame = CGRectMake(10 / 375 * kScreenW, 10 / 667.f * kScreenH, 60, 40);
    [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleButton setTitleColor:kColorStr forState:UIControlStateNormal];
    [_cancleButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_cancleButton];
    
    _certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _certainButton.frame = CGRectMake(kScreenW - 70, 10 / 667.f * kScreenH, 60, 40);
    [_certainButton setTitle:@"确定" forState:UIControlStateNormal];
    [_certainButton setTitleColor:RedColor forState:UIControlStateNormal];
    [_certainButton addTarget:self action:@selector(certainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_certainButton];
    
    self.submitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 275, 168)];
    UIImageView * image = [[UIImageView alloc] initWithFrame:self.submitView.bounds];
    image.image = [UIImage imageNamed:@"xingchengfapiao"];
    [self.submitView addSubview:image];
    
    UILabel * comLable = [[UILabel alloc] initWithFrame:CGRectMake(78, 13, 275 - 90, 20)];
    comLable.font = FontType;
    [self.submitView addSubview:comLable];
    self.gsLabel = comLable;
    
    UILabel * reLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 15 + 20, 275 - 90, 20)];
    reLabel.font = FontType;
    [self.submitView addSubview:reLabel];
    self.sjrLabel = reLabel;
    
    UILabel * readdLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 15 + 20 + 20, 275 - 90, 40)];
    readdLabel.font = FontType;
    readdLabel.numberOfLines = 2;
    [self.submitView addSubview:readdLabel];
    self.sjdzLabel = readdLabel;
    
    UILabel * mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 15 + 20 + 20 + 40, 275 - 90, 20)];
    mailLabel.font = FontType;
    [self.submitView addSubview:mailLabel];
    self.yjfyLabel = mailLabel;
    self.submitView.hidden = YES;
    
    UIButton *bakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bakBtn.frame = CGRectMake(0, self.submitView.height - 40, 138, 40);
    [bakBtn addTarget:self action:@selector(controlClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.submitView addSubview:bakBtn];
    
    UIButton *queRenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    queRenBtn.frame = CGRectMake(bakBtn.width, bakBtn.top, bakBtn.width, bakBtn.height);
    [queRenBtn addTarget:self action:@selector(queRenBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.submitView addSubview:queRenBtn];
    [self.view addSubview:self.submitView];
    
    self.submitView.center = self.view.center;
}

- (void)queRenBtnClicked
{
    [self showHUD:@"正在提交..."];
    weak_Self(self);
    NSString * yonghuID = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.taiTouFiled.text, @"disinvtitle", _countentLabel.text, @"disinvcontent", self.allPrice, @"disinvsum", self.pepFiled.text, @"addressee", self.phoneLable.text, @"conphone", [NSString stringWithFormat:@"%@%@%@%@", _shengLabel.text, _shiLabel.text, _quLabel.text, _addressFiled.text], @"placeaddress", self.allIds, @"ids", yonghuID, @"phone", TokenPrams, nil];
    if (self.xingChengType == XingChengFangShiXingCheng) {
        [[self.userManager submitXingChengPaPiaoWithDic:dic] subscribeNext:^(id x) {
            [weakSelf hideHUD];
            NSDictionary * xdic = x;
            NSString * success = [NSString stringWithFormat:@"%@", xdic[@"success"]];
            [weakSelf controlClicked];
            if (success.boolValue == NO) {
                SubmitViewController * submitView = [[SubmitViewController alloc] initWithSuccess:NO andMessage:xdic[@"msg"]];
                [weakSelf.navigationController pushViewController:submitView animated:YES];
                return ;
            }
            SubmitViewController * submitView = [[SubmitViewController alloc] initWithSuccess:YES andMessage:xdic[@"msg"]];
            [weakSelf.navigationController pushViewController:submitView animated:YES];
        } error:^(NSError *error) {
            [weakSelf hideHUD];
            [weakSelf delayHidHUD:MESSAGE_NoNetwork];
        } completed:^{
            
        }];
    } else if (self.xingChengType == XingChengFangShiVIP) {
        [[self.userManager submitVIPPaPiaoWithDic:dic] subscribeNext:^(id x) {
            [weakSelf hideHUD];
            NSDictionary * xdic = x;
            NSString * success = [NSString stringWithFormat:@"%@", xdic[@"success"]];
            [weakSelf controlClicked];
            if (success.boolValue == NO) {
                SubmitViewController * submitView = [[SubmitViewController alloc] initWithSuccess:NO andMessage:xdic[@"msg"]];
                [weakSelf.navigationController pushViewController:submitView animated:YES];
                return ;
            }
            SubmitViewController * submitView = [[SubmitViewController alloc] initWithSuccess:YES andMessage:xdic[@"msg"]];
            [weakSelf.navigationController pushViewController:submitView animated:YES];
        } error:^(NSError *error) {
            [weakSelf hideHUD];
            [weakSelf delayHidHUD:MESSAGE_NoNetwork];
        } completed:^{
            
        }];
    }
}

- (void)controlClicked
{
    [UIView animateWithDuration:.32 animations:^{
        self.control.alpha = 0;
        _bottomView.top = kScreenH;
    } completion:^(BOOL finished) {
        self.control.hidden = YES;
    }];
    self.submitView.hidden = YES;
}

- (void)creatSubViews
{
    for (int i =0; i<_titleArray.count; i++) {
        UILabel * xianLabel = [[UILabel alloc] initWithFrame:CGRectMake(19.5/375*kScreenW,118 + i*54 , kScreenW, 1)];
        xianLabel.backgroundColor = kColorStr;
        [self.view addSubview:xianLabel];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(19.5/375*kScreenW,85+ i*54, 60, 13)];
        label.text = _titleArray[i];
        label.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:label];
        
        if (i == 5) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0,65 + i*54 , kScreenW, 54);
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
        }
    }
}
- (void)creatTextAndLabel
{
    _taiTouFiled = [[UITextField alloc] initWithFrame:CGRectMake(109.5 / 375 * kScreenW, 65, 280, 54)];
    _taiTouFiled.delegate = self;
    _taiTouFiled.placeholder = @"填写公司抬头";
    _taiTouFiled.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_taiTouFiled];
    
    _countentLabel = [[UILabel alloc] initWithFrame:CGRectMake(109.5/375*kScreenW, 85+54, 200, 13)];
    _countentLabel.text = @"出行服务费";
    _countentLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_countentLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(109.5 / 375*kScreenW, 85+2*54, 200, 13)];
    NSString *str = [NSString stringWithFormat:@"%@元", self.allPrice];
    NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc] initWithString:str];
    [attstr addAttribute:NSForegroundColorAttributeName value:RedColor range:NSMakeRange(0, self.allPrice.length)];
    [attstr addAttribute:NSForegroundColorAttributeName value:kColorStr range:NSMakeRange(self.allPrice.length, 1)];
    _priceLabel.attributedText = attstr;
    _priceLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_priceLabel];
    
    
    _pepFiled = [[UITextField alloc] initWithFrame:CGRectMake(109.5/375*kScreenW, 65+3*54, kScreenW - 109.5 / 375.f * kScreenW - 19.5/375*kScreenW, 54)];
    _pepFiled.delegate = self;
    _pepFiled.placeholder = @"填写收件人";
    _pepFiled.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_pepFiled];
    
    _phoneLable = [[UITextField alloc] initWithFrame:CGRectMake(109.5/375*kScreenW, 85 + 4 * 54, kScreenW - 109.5 / 375.f * kScreenW - 19.5/375*kScreenW, 13)];
    _phoneLable.font = [UIFont systemFontOfSize:15];
    _phoneLable.keyboardType = UIKeyboardTypeNumberPad;
    _phoneLable.placeholder = @"联系方式";
    [self.view addSubview:_phoneLable];
    
    _addressFiled = [[UITextField alloc] initWithFrame:CGRectMake(109.5 / 375*kScreenW, 65+6*54, kScreenW - 109.5 / 375.f * kScreenW - 19.5/375*kScreenW, 54)];
    _addressFiled.delegate = self;
    _addressFiled.placeholder = @"填写详细地址";
    _addressFiled.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_addressFiled];
    
    _shengLabel = [[UILabel alloc] initWithFrame:CGRectMake(109.5/375*kScreenW, 85+5*54, 60, 13)];
    _shengLabel.text = @"请选择";
    _shengLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_shengLabel];
    
    _shiLabel = [[UILabel alloc] initWithFrame:CGRectMake((109.5+80)/375*kScreenW, 85+5*54,60, 13)];
    _shiLabel.text = @"请选择";
    _shiLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_shiLabel];
    
    _quLabel = [[UILabel alloc] initWithFrame:CGRectMake((109.5+160)/375*kScreenW, 85+5*54, 100, 13)];
    _quLabel.text = @"请选择";
    _quLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_quLabel];
    
    UILabel *xian = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenH - 50, kScreenW, 1)];
    xian.backgroundColor = kColorStr;
    [self.view addSubview:xian];
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提  交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:RedColor forState:UIControlStateNormal];
    submitBtn.frame = CGRectMake(0, kScreenH - 49, kScreenW, 49);
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
}

- (void)submitBtnClick
{
    if (_taiTouFiled.text.length == 0 || _priceLabel.text.length == 0 || _pepFiled.text.length == 0 || _phoneLable.text.length == 0 || _addressFiled.text.length == 0) {
        [self delayHidHUD:@"请完善发票信息"];
        return;
    }
    if ([_shengLabel.text isEqualToString: @"请选择"] || [_shiLabel.text isEqualToString: @"请选择"] || [_quLabel.text isEqualToString: @"请选择"]) {
        [self delayHidHUD:@"请完善发票信息"];
        return;
    }
    self.submitView.hidden = NO;
    self.control.hidden = NO;
    [UIView animateWithDuration:.32 animations:^{
        self.control.alpha = 0.7;
    }];
    self.gsLabel.text = self.taiTouFiled.text;
    self.sjrLabel.text = [NSString stringWithFormat:@"%@ : %@", _pepFiled.text, _phoneLable.text];
    self.sjdzLabel.text = _addressFiled.text;
    self.yjfyLabel.text = self.allPrice.floatValue >= 200? @"包邮": @"到付";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:.2 animations:^{
        self.view.top = 0;
    }];
    [_taiTouFiled resignFirstResponder];
    [_pepFiled resignFirstResponder];
    [_addressFiled resignFirstResponder];
    [_phoneLable resignFirstResponder];
}



#pragma mark-点击出现pegeVIew
- (void)buttonAction:(UIButton *)sender
{
    [UIView animateWithDuration:.2 animations:^{
        self.view.top = 0;
    }];
    [_taiTouFiled resignFirstResponder];
    [_pepFiled resignFirstResponder];
    [_addressFiled resignFirstResponder];
    [_phoneLable resignFirstResponder];
    self.control.hidden = NO;
    [UIView animateWithDuration:.32 animations:^{
        self.control.alpha = 0.7;
        _bottomView.frame = CGRectMake(0, kScreenH - 258 / 667.f * kScreenH, kScreenW, 258 / 667.f * kScreenH);
    }];
    
    _shengLabel.text = @"北京";
    _shiLabel.text = @"北京市";
    _quLabel.text = @"东城区";
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _addressFiled) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.top -= 120;
        }];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 43 / 667.f * kScreenH;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 1;
    }
    else if (component == 1){
        return 1;
    }else{
        return _quArray.count;
    }
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(component == 0){
        return [_shengArray objectAtIndex:row];
    }else if (component == 1){
        return [_shiArray objectAtIndex:row];
    }else{
        return [_quArray objectAtIndex:row];
    }
}

- (void)cancleButtonAction:(UIButton *)sender
{
    [UIView animateWithDuration:.32 animations:^{
        self.control.alpha = 0;
        _bottomView.top = kScreenH;
    } completion:^(BOOL finished) {
        self.control.hidden = YES;
    }];
    
    _shengLabel.text = @"请选择";
    _shiLabel.text = @"请选择";
    _quLabel.text = @"请选择";
}

- (void)certainButtonAction:(UIButton *)sender
{
    [UIView animateWithDuration:.32 animations:^{
        self.control.alpha = 0;
        _bottomView.top = kScreenH;
    } completion:^(BOOL finished) {
        self.control.hidden = YES;
    }];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        _shengLabel.text = _shengArray[0];
    }else if (component == 1){
        _shiLabel.text = _shiArray[0];
    }else{
        
        _quLabel.text = _quArray[row];
    }
}

@end
