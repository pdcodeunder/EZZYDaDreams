//
//  ITTSegement.m
//  AiXinDemo
//
//  Created by shaofa on 14-2-17.
//  Copyright (c) 2014年 shaofa. All rights reserved.
//

#import "ITTSegement.h"

@implementation ITTSegement
{
    NSMutableArray *allItems;
    
}

-(id)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        [self _initViews:items];
    }
    
    return self;
}

-(void)_initViews:(NSArray *)items
{
    
    allItems = [[NSMutableArray alloc] initWithCapacity:items.count];
    self.items = items;
    for (int i = 0; i < items.count; i++) {
        NSString *itemName = items[i];
        
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake((i * (50 + 10))/320.f*kScreenW, 0, 50, 35)];
        if (i==2) {
            itemView.frame=CGRectMake((i*(50+5))/320.f*kScreenW, 0, 50+30, 35);
        }
        UILabel *titleLabel =[[UILabel alloc] initWithFrame:itemView.bounds];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = itemName;
        titleLabel.tag = 2013;
        [itemView addSubview:titleLabel];
        
        ITTArrowView *arrowView = [[ITTArrowView alloc] initWithFrame:CGRectMake(40, 10, 16, 16)];
        
        if (i==2) {
            arrowView.frame=CGRectMake(50+20, 10, 16, 16);
        }
        
        __weak ITTSegement *this = self;
        arrowView.block = ^(ArrowStates state){
            ITTSegement *strong = this;
            strong.currentState = state;
        };
        
        arrowView.tag = 2014;
        if (i == 0) {
            arrowView.isSelected = YES;
        }
        [itemView addSubview:arrowView];
        
        UIImageView *indexView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [itemView addSubview:indexView];
        indexView.tag = 2015;
        
        [self addSubview:itemView];
        [allItems addObject:itemView];
    }
}

-(void)setSelectedIndex:(int)selectedIndex
{
    _selectedIndex = selectedIndex;
    for (int i = 0; i < allItems.count; i++) {
        UIView *itemView = allItems[i];
        UILabel *titleLabel = (UILabel *)[itemView viewWithTag:2013];
        ITTArrowView *arrowView = (ITTArrowView *)[itemView viewWithTag:2014];
        if (i == selectedIndex) {
            
            titleLabel.textColor = [UIColor colorWithRed:224 / 255.f green:54 / 255.f blue:134 / 255.f alpha:1];
            arrowView.isSelected = YES;
        } else {
            titleLabel.textColor = [UIColor blackColor];
            arrowView.isSelected = NO;
            
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    float width=70;
    int index = point.x/width;
    if (index > 2) {
        return;
    }
    self.selectedIndex = index;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}



@end

