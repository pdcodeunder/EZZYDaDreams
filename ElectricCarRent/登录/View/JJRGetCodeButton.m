//
//  GetCodeButton.m
//  MaiChe
//
//  Created by xiejc on 14-7-11.
//  Copyright (c) 2014年 BitEP. All rights reserved.
//

#import "JJRGetCodeButton.h"


#define CODE_REGET_TIME 60

@interface JJRGetCodeButton ()

@property (nonatomic, assign) int codeTime;
@property (nonatomic, strong) NSTimer *codeTimer;
@property (nonatomic, strong) UILabel *getCodeBtnLabel;
@property (nonatomic, strong) UILabel *getCodeTimeLabel;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIWebView *phoneCallWebView;
@property (nonatomic, assign) BOOL isShowingAlert;

@end

@implementation JJRGetCodeButton

- (id)init {
    self = [super init];
    if (self) {
        [self loadView];
    }
    return self;
}

- (void)awakeFromNib {
    [self loadView];
}

- (void)dealloc {
    [self invalid];
}

- (void)loadView {
    self.isGettingCode = NO;
    self.isShowingAlert = NO;
    self.title = [self titleForState:UIControlStateNormal];

    CGRect getCodeLabelFrame = CGRectMake(0, 0, self.frame.size.width * 0.6, self.frame.size.height);
    self.getCodeBtnLabel = [[UILabel alloc] initWithFrame:getCodeLabelFrame];
    self.getCodeBtnLabel.backgroundColor = [UIColor clearColor];
//    [self addSubview:self.getCodeBtnLabel];
    self.getCodeBtnLabel.text = @"";
    self.getCodeBtnLabel.textAlignment = NSTextAlignmentRight;
    self.getCodeBtnLabel.hidden = YES;
    self.getCodeBtnLabel.textColor = [UIColor colorWithRed:234/255.0 green:80/255.0 blue:153/255.0 alpha:1.0];
    self.getCodeBtnLabel.font = [UIFont systemFontOfSize:15.0];

    CGRect codeTimeLabelFrame = CGRectMake(0, 0,
                                           self.frame.size.width,
                                           self.frame.size.height);
    self.getCodeTimeLabel = [[UILabel alloc] initWithFrame:codeTimeLabelFrame];
    [self addSubview:self.getCodeTimeLabel];
    self.getCodeTimeLabel.text = @"";
    self.getCodeTimeLabel.textColor = [UIColor grayColor];
    self.getCodeTimeLabel.font = [UIFont systemFontOfSize:18.0];
    self.getCodeTimeLabel.backgroundColor = [UIColor clearColor];
    self.getCodeTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.getCodeBtnLabel.hidden = YES;
}

- (void)invalid {
    if ([self.codeTimer isValid]) {
        [self.codeTimer invalidate];
    }
    self.codeTimer = nil;
}

/**
 *  启动获取确认码timer
 */
- (void)fireCodeTimer {
    if ([self.codeTimer isValid]) {
        return;
    }
    [self setEnabled:NO];
    [self setTitle:@"" forState:UIControlStateNormal];

    self.codeTime = CODE_REGET_TIME;
    self.getCodeBtnLabel.hidden = NO;
    self.getCodeTimeLabel.hidden = NO;
    self.getCodeBtnLabel.text = [NSString stringWithFormat:@"重新发送"];
    self.getCodeTimeLabel.text = [NSString stringWithFormat:@"%d 秒", self.codeTime];
    self.codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshCodeBtn) userInfo:nil repeats:YES];
}

/*
 * timer结束的返回
 */
- (void)getCodeBtnFinished:(void(^)())block
{
    self.finishBlock = block;
}

/**
 *  关闭获取确认码timer
 */
- (void)closeCodeTimer {
    [self invalid];
    [self setEnabled:YES];
    [self setTitle:self.title forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.getCodeBtnLabel.hidden = YES;
    self.getCodeTimeLabel.hidden = YES;
    
    if (self.finishBlock) {
        self.finishBlock();
    }
}

/**
 *  更新再次获取确认码时间
 */
- (void)refreshCodeBtn {
    self.codeTime -= 1;
    if (self.codeTime <= 0) {
        [self closeCodeTimer];
        self.isGettingCode = NO;
        return;
    }
    self.isGettingCode = YES;
//    self.getCodeTimeLabel.text = [NSString stringWithFormat:@"(%d)", self.codeTime];
    self.getCodeTimeLabel.text = [NSString stringWithFormat:@"%d 秒", self.codeTime];
}

/**
 *  提示收听确认码
 */
- (void)showListenCodeAlert {
    if (self.isShowingAlert) {
        return;
    }
    self.isShowingAlert = YES;
}

/**
 *  发送验证码成功后弹出
 */
- (void)showSendCodeSuccessAlert:(NSString *)phone {
    if (self.isShowingAlert) {
        return;
    }
    self.isShowingAlert = YES;
}

/**
 *  显示收听确认码电话
 */
- (void)callToListenCode
{
    if (self.phoneCallWebView == nil) {
        self.phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", @"18612452302"]];
    [self.phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

@end
