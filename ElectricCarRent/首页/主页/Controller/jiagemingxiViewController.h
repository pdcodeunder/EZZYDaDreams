//
//  jiagemingxiViewController.h
//  ElectricCarRent
//
//  Created by 张钊 on 16/1/15.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface jiagemingxiViewController : UIViewController

@property (nonatomic, strong)NSDictionary * dataDic;
@property (nonatomic, strong) UIImage * maoImage;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
