//
//  ECarBaseViewController.h
//  ECarDreams
//
//  Created by 彭懂 on 15/12/28.
//  Copyright © 2015年 彭懂. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECarBaseViewController : UIViewController

- (void)goBack;
- (void)showHUD:(NSString *)text;
- (void)hideHUD;
- (void)delayHidHUD:(NSString *)text;

@end
