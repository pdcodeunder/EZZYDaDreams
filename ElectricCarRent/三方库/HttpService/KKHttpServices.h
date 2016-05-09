//
//  KKHttpServices.h
//  BurNing
//
//  Created by LIKUN on 15/8/13.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "KKHttpParse.h"

#define TimeOut 30.0
#define AFNetworkNotReachability ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus <= 0)
#define NoNetworkState -999

typedef NS_ENUM(NSInteger, HttpType) {
    HttpTypeGet = 1,
    HttpTypePost,
};


@interface KKHttpServices : AFHTTPRequestOperationManager

typedef void (^KKSuccessBlock)(AFHTTPRequestOperation *operation,KKHttpParse *parse);
typedef void (^KKFailureBlock)(KKHttpParse *parse);

+ (instancetype)shareInstance;
+ (AFHTTPRequestOperation *)httpNetworkWithUrl:(NSString *)url prams:(NSDictionary *)prams success:(KKSuccessBlock)succsssBlock failure:(KKFailureBlock)failureBlock;
+ (void)httpPostUrl:(NSString *)url prams:(NSDictionary *)dic success:(KKSuccessBlock)succsssBlock failure:(KKFailureBlock)failureBlock;
@end
