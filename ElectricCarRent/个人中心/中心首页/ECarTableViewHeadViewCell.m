//
//  ECarTableViewHeadViewCell.m
//  ElectricCarRent
//
//  Created by 彭懂 on 15/11/4.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarTableViewHeadViewCell.h"

@implementation ECarTableViewHeadViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor grayColor];
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    
}


@end
