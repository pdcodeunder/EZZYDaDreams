//
//  ECarLoginRegisterManager.h
//  ElectricCarRent
//
//  Created by LIKUN on 15/8/28.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKHttpServices.h"
#import "DSASubject.h"

@interface ECarLoginRegisterManager : NSObject
- (DSASubject *)registerAccount:(NSString *)phone;
- (DSASubject *)getCode:(NSString *)userPhone;
- (DSASubject *)login:(NSString *)phone pwd:(NSString *)pwd;
- (DSASubject *)userInfo:(NSString *)phone;
- (DSASubject *)loginOut:(NSString *)phone;

- (DSASubject *)registerJpushid:(NSString *)phone jpushid:(NSString *)jpushid;

- (DSASubject *)apploginWithPhone:(NSString *)phone pwd:(NSString *)pwd andUUID:(NSString *)uuid;

@end
