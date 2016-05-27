//
//  YLLabel.h
//  YLLabelDemo
//
//  Created by Eric Yuan on 12-11-8.
//  Copyright (c) 2012年 YuanLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLLabel : UIView

@property (nonatomic, strong) NSMutableAttributedString* string;
@property (nonatomic, strong) UIFont* font;
@property (nonatomic, strong) UIColor* textColor;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) CGFloat firstLineHeadIndent;

- (void)setText:(NSString*)text;

@end
