//
//  SubmitViewController.h
//  提交成功
//
//  Created by 程元杰 on 16/3/30.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SubmitViewController : ECarBaseViewController

@property (nonatomic, strong)UIImageView * imageView;
@property (nonatomic, strong)UILabel * statusLabel;
@property (nonatomic, strong)UILabel * promptLabel;
@property (nonatomic, strong)UILabel * xianLabel;
@property (nonatomic, strong)UIButton * button;

- (instancetype)initWithSuccess:(BOOL)success andMessage:(NSString *)msg;

@end
