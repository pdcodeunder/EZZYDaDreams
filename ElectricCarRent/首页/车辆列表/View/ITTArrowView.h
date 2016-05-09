//
//  ITTArrowView.h
//  AiXinDemo
//
//  Created by shaofa on 14-2-17.
//  Copyright (c) 2014年 shaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum arrowStates {
    UPStates = 0,
    DOWNStates = 1
}ArrowStates;

typedef void(^StateHadChangedBlock)(ArrowStates state);

@interface ITTArrowView : UIImageView

@property(nonatomic, assign)ArrowStates states;
@property(nonatomic, assign)BOOL isSelected;
@property(nonatomic, copy)StateHadChangedBlock block;

//- (id)initWithFrame:(CGRect)frame stateBlock:(StateHadChangedBlock)block;

@end
