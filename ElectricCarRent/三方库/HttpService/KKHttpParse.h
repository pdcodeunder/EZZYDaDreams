//
//  KKHttpParse.h
//  BurNing
//
//  Created by LIKUN on 15/8/13.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKHttpParse : NSObject
@property (assign ,nonatomic) NSInteger responseCode;/**<HttpCode*/
@property (copy ,nonatomic) NSString *responseMsg;/**<HttpDescription*/
@property (strong ,nonatomic) NSMutableDictionary* responseJsonOB;/**<Json字典*/
@end
