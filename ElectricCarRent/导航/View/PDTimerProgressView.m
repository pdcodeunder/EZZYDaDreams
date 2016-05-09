//
//  PDTimerProgressView.m
//  TimerProgressView
//
//  Created by 彭懂 on 15/12/11.
//  Copyright (c) 2015年 彭懂. All rights reserved.
//

#import "PDTimerProgressView.h"

@interface PDTimerProgressView ()

@property (nonatomic, strong) UILabel * fenLabel;
@property (nonatomic, strong) UILabel * miaoLanel;
@property (nonatomic, assign) NSInteger miao;

@end

@implementation PDTimerProgressView

- (UILabel *)fenLabel
{
    if (!_fenLabel) {
        NSString * str = @"请在00:";
        CGSize size = [str boundingRectWithSize:CGSizeMake(0, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.f]} context:nil].size;
        _fenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 30)];
        _fenLabel.textColor = [UIColor colorWithRed:224 / 255.f green:54 / 255.f blue:134 / 255.f alpha:1];
        _fenLabel.textAlignment = NSTextAlignmentRight;
        _fenLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _fenLabel;
}

- (UILabel *)miaoLanel
{
    if (!_miaoLanel) {
        NSString * str = @"00分钟内找车(京N3283222)";
        CGSize size = [str boundingRectWithSize:CGSizeMake(0, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.f]} context:nil].size;
        _miaoLanel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.fenLabel.frame), 0, size.width, 30)];
        _miaoLanel.font = [UIFont systemFontOfSize:15.f];
        _miaoLanel.textColor = [UIColor colorWithRed:224 / 255.f green:54 / 255.f blue:134 / 255.f alpha:1];
        _miaoLanel.textAlignment = NSTextAlignmentLeft;
    }
    return _miaoLanel;
}

- (instancetype)initWithFrame:(CGRect)frame andCountMiao:(NSInteger)fen andCarNo:(NSString *)carNo
{
    self = [super initWithFrame:frame];
    if (self) {
        self.miao = fen * 60;
        self.carno = carNo;
        [self addSubview:self.fenLabel];
        [self addSubview:self.miaoLanel];
    }
    return self;
}

- (void)setProgressTimer:(NSInteger)progressTimer
{
    if (progressTimer > self.miao) {
        return;
    }
    self.fenLabel.text = [NSString stringWithFormat:@"请在%02zd:", (self.miao - progressTimer) / 60];
    self.miaoLanel.text = [NSString stringWithFormat:@"%02zd分钟内找车(%@)", (self.miao - progressTimer) % 60, self.carno];
}

@end
