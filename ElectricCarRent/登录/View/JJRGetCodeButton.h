//
//  GetCodeButton.h
//  MaiChe
//
//  Created by xiejc on 14-7-11.
//  Copyright (c) 2014年 BitEP. All rights reserved.
//

@interface JJRGetCodeButton : UIButton

@property (nonatomic, assign) BOOL isGettingCode;

typedef void (^FinishedCodeTimeBlock)();
@property (nonatomic,strong)FinishedCodeTimeBlock finishBlock;
- (void)getCodeBtnFinished:(void(^)())block;

- (void)closeCodeTimer;

- (void)fireCodeTimer;

- (void)invalid;

- (void)showListenCodeAlert;

- (void)showSendCodeSuccessAlert:(NSString *)phone;

@end
