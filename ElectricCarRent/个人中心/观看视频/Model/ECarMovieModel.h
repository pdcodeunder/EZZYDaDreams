//
//  ECarMovieModel.h
//  ElectricCarRent
//
//  Created by 彭懂 on 16/2/19.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECarMovieModel : NSObject

@property (nonatomic, copy) NSString * pictuerUrl;
@property (nonatomic, copy) NSString * movieTitle;
@property (nonatomic, copy) NSString * information;
@property (nonatomic, copy) NSString * movieUrl;

- (instancetype)initWithDictinary:(NSDictionary *)dic;

@end
