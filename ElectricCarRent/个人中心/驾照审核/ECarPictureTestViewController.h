//
//  ECarPictureTestViewController.h
//  ElectricCarRent
//
//  Created by 彭懂 on 15/11/12.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnTextBlock)(NSString * blckStr);
@interface ECarPictureTestViewController : ECarBaseViewController
@property(nonatomic, strong)UIImageView * imageView;
@property(nonatomic, strong)UILabel     * shenheLabel;      //驾照审核
@property(nonatomic, strong)UILabel     * label;            //审核状态
@property(nonatomic, strong)UILabel     * lineLabel;        //button线
@property (nonatomic, copy)ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;



@end
