//
//  ECarLoginRegisterManager.m
//  ElectricCarRent
//
//  Created by LIKUN on 15/8/28.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarLoginRegisterManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ECarUser.h"

@implementation ECarLoginRegisterManager

- (DSASubject *)registerAccount:(NSString *)phone
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone", nil];
    NSString *loginurl=[NSString stringWithFormat:@"%@car/tCMemberController.do?doAdd", ServerURL];
    [KKHttpServices httpPostUrl:loginurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary *dic = [ToolKit JSONDecodeFromString:operation.responseString];
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

- (DSASubject *)registerJpushid:(NSString *)phone jpushid:(NSString *)jpushid
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone", jpushid, @"reid", TokenPrams, nil];
    NSString *loginurl=[NSString stringWithFormat:@"%@car/tCMemberController.do?getRegId", ServerURL];
    [KKHttpServices httpPostUrl:loginurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        [subject sendNext:nil];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

//login
- (DSASubject *)login:(NSString *)phone pwd:(NSString *)pwd;
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",pwd,@"verify", nil];
    NSString *loginurl=[NSString stringWithFormat:@"%@car/loginController.do?checkuser2", ServerURL];

    [KKHttpServices httpPostUrl:loginurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary *dic = [ToolKit JSONDecodeFromString:operation.responseString];
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}
//getcode
- (DSASubject *)getCode:(NSString *)userPhone
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userPhone,@"phoneNumber", nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCMemberController.do?doVerify", ServerURL];
    
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary *dic = [ToolKit JSONDecodeFromString:operation.responseString];
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    
    return subject;
}

//个人信息
- (DSASubject *)userInfo:(NSString *)phone
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",TokenPrams, nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCMemberController.do?getMember2", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        NSDictionary *objDic = dic[@"obj"];
        ECarUser *user = [[ECarUser alloc] initWithResponse:objDic];
        [subject sendNext:user];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

//退出登录
- (DSASubject *)loginOut:(NSString *)phone
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone", TokenPrams, nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/loginController.do?logout2", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

- (DSASubject *)apploginWithPhone:(NSString *)phone pwd:(NSString *)pwd andUUID:(NSString *)uuiddd
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone, @"phone", pwd, @"verify", uuiddd, @"iphoneid", TokenPrams, nil];
    NSString *loginurl=[NSString stringWithFormat:@"%@car/tCMemberController.do?AppLogin", ServerURL];
    [KKHttpServices httpPostUrl:loginurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary *dic = [ToolKit JSONDecodeFromString:operation.responseString];
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

@end
