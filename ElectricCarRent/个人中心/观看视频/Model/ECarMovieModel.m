//
//  ECarMovieModel.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/2/19.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarMovieModel.h"

@implementation ECarMovieModel

- (instancetype)initWithDictinary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.pictuerUrl = [NSString stringWithFormat:@"%@", dic[@"videopic"]];
        self.movieTitle = [NSString stringWithFormat:@"%@", dic[@"title"]];
        self.information = [NSString stringWithFormat:@"%@", dic[@"note"]];
        self.movieUrl = [NSString stringWithFormat:@"%@", dic[@"vediourl"]];
    }
    return self;
}

@end
