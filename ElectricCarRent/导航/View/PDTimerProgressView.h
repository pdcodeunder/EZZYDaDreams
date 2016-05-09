//
//  PDTimerProgressView.h
//  TimerProgressView
//
//  Created by 彭懂 on 15/12/11.
//  Copyright (c) 2015年 彭懂. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDTimerProgressView : UIView

@property (nonatomic, assign) NSInteger progressTimer;
@property (nonatomic, copy) NSString * carno;

- (instancetype)initWithFrame:(CGRect)frame andCountMiao:(NSInteger)fen andCarNo:(NSString *)carNo;

@end
