//
//  KKHttpServices.m
//  BurNing
//
//  Created by LIKUN on 15/8/13.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "KKHttpServices.h"

static KKHttpServices *httpServices = nil;

@implementation KKHttpServices
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpServices = [[KKHttpServices alloc]init];
    });
    return httpServices;
}

+(NSMutableURLRequest *)getMutableURLRequest:(HttpType)type url:(NSString*) url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:TimeOut];
    if (type == HttpTypeGet) {
        [request setHTTPMethod:@"GET"];
    }else{
        [request setHTTPMethod:@"POST"];
    }
    return request;
}
/**
 *  解析Http返回
 *
 *  @param operation http返回对象
 *
 *  @return 解析的KKHttpParse对象
 */
+ (KKHttpParse *)parseResponse:(AFHTTPRequestOperation *)operation
{
    NSString* responseStr = operation.responseString;
    NSMutableDictionary* jsonDic = nil;
    if (responseStr.length > 0) {
        jsonDic = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    }else
        return nil;
    
    KKHttpParse *parse = [[KKHttpParse alloc]init];
    parse.responseCode = operation.response.statusCode;
    parse.responseMsg = operation.response.description;
    parse.responseJsonOB = jsonDic;
    return parse;
}
/**
 *  http请求
 *
 *  @param url          url
 *  @param succsssBlock 成功的回调
 *  @param failureBlock 失败的回调
 *
 *  @return http请求对象
 */
+ (AFHTTPRequestOperation *)httpNetworkWithUrl:(NSString *)url prams:(NSDictionary *)prams success:(KKSuccessBlock)succsssBlock failure:(KKFailureBlock)failureBlock
{
    [ToolKit checkNetwork];
    if (AFNetworkNotReachability) {
        KKHttpParse* a = [[KKHttpParse alloc] init];
        a.responseCode = NoNetworkState;
        a.responseMsg = MESSAGE_NoNetwork;
        failureBlock(a);
        return nil;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"operation.str == %@",operation.responseString);
        KKHttpParse *parse = [KKHttpServices parseResponse:operation];
        if (parse) {
            succsssBlock(operation,parse);
        }else{
            failureBlock(parse);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        KKHttpParse* a = [[KKHttpParse alloc] init];
        a.responseCode = operation.response.statusCode;
        a.responseMsg = MESSAGE_NoNetwork;
        failureBlock(a);
    }];
    [[[KKHttpServices shareInstance]operationQueue]addOperation:operation];
    return operation;
}

+ (void)httpPostUrl:(NSString *)url prams:(NSDictionary *)dic success:(KKSuccessBlock)succsssBlock failure:(KKFailureBlock)failureBlock
{
    [ToolKit checkNetwork];
    if (AFNetworkNotReachability) {
        KKHttpParse* a = [[KKHttpParse alloc] init];
        a.responseCode = NoNetworkState;
        a.responseMsg = MESSAGE_NoNetwork;
        failureBlock(a);
    }

    [[AFHTTPRequestOperationManager manager] POST:url parameters:dic success:^(AFHTTPRequestOperation * operation, id responseObject) {
        KKHttpParse *parse = [KKHttpServices parseResponse:operation];
        if (parse) {
            succsssBlock(operation,parse);
        }else{
            failureBlock(parse);
        }

    } failure:^(AFHTTPRequestOperation * operation,  NSError *error) {
        KKHttpParse* a = [[KKHttpParse alloc] init];
        a.responseCode = operation.response.statusCode;
        a.responseMsg = MESSAGE_NoNetwork;
        failureBlock(a);
    }];
}

@end
