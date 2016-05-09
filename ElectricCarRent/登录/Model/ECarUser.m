//
//  ECarUser.m
//  ElectricCarRent
//
//  Created by LIKUN on 15/8/28.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarUser.h"
static ECarUser *sharedInstance = nil;

@implementation ECarUser

- (instancetype)initWithResponse:(NSDictionary *)dic;
{
    if (self = [super init])
    {
        [self setUserWithResponse:dic];
    }
    return self;
}

- (void)updateUserInfoWithResponse:(NSDictionary *)dic
{
    [self setUserWithResponse:dic];
}

- (void)setUserWithResponse:(NSDictionary *)dic;
{
    self.user_id = [ToolKit nullString:dic[@"id"]];
    self.age = [ToolKit nullString:dic[@"age"]];
    
    self.birth = [ToolKit nullString:dic[@"birth"]];
//    NSNumber *birthNm = dic[@"birth"];
//    self.birth = birthNm.stringValue;
    
    self.password = [ToolKit nullString:dic[@"password"]];
    self.paymsg = [ToolKit nullString:dic[@"paymsg"]];
    self.realname = [ToolKit nullString:dic[@"realname"]];
    self.username = [ToolKit nullString:dic[@"username"]];
    
    self.email = [ToolKit nullString:dic[@"email"]];
    self.idcard = [ToolKit nullString:dic[@"idcard"]];
    self.phone = [ToolKit nullString:dic[@"phone"]];
    
    NSNumber *sexNm = dic[@"sex"];
    self.sex = sexNm.stringValue;
//    self.sex = [ToolKit nullString:dic[@"sex"]];
    
    self.userStatus = [dic[@"status"] integerValue];
    
    if ([ToolKit nullString:dic[@"islock"]].integerValue == 1)
    {
        self.userStatus = UserInfoStatusLocked;
    }
    self.islock = [ToolKit nullString:dic[@"islock"]];
    
    self.drivingNo = [ToolKit nullString:dic[@"drivingLicense"]];
    self.company = [ToolKit nullString:dic[@"dept"]];
    self.career = [ToolKit nullString:dic[@"career"]];
    self.postalAddress = [ToolKit nullString:dic[@"postalAddress"]];
    self.postalcode = [ToolKit nullString:dic[@"postalcode"]];
    self.homeAddress = [ToolKit nullString:dic[@"address"]];
    
    self.idcardfront = [ToolKit nullString:dic[@"idcardfront"]];
    self.idcardback = [ToolKit nullString:dic[@"idcardback"]];
    self.drivingLiensef = [ToolKit nullString:dic[@"drivingLiensef"]];
    self.drivingLienses = [ToolKit nullString:dic[@"drivingLienses"]];
    self.facecardfront = [ToolKit nullString:dic[@"facecardfront"]];
    self.facecardback = [ToolKit nullString:dic[@"facecardback"]];
    
    self.creditNo = [ToolKit nullString:dic[@"bankcark"]];
    self.expirationdateyear = [ToolKit nullString:dic[@"expirationdateyear"]];
    self.expirationdatemonth = [ToolKit nullString:dic[@"expirationdatemonth"]];
    self.verifycode = [ToolKit nullString:dic[@"verifycode"]];
    self.pmobile = [ToolKit nullString:dic[@"pmobile"]];
    self.checkpwd = [ToolKit nullString:dic[@"pwd"]];
    
//    [self refreshUserBaseInfoStatus];
//    [self refreshUserPhotoInfoStatus];
//    [self refreshUserPayInfoStatus];
}

- (NSString *)phone
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
}

//- (void)setUserStatusWith:(int)serverString
//{
//    if([ToolKit nullString:serverString].length == 0)
//    {
//        _userStatus = UserInfoStatusNull;
//    }
//    else
//    {
//        _userStatus = [serverString integerValue];
//    }
//}

- (NSString *)userInfoNowStatusString
{
    if (self.islock.integerValue == 1)
    {
        return @"锁定";
    }
//    NSLog(@"%zd", self.userStatus);
    switch (self.userStatus)
    {
        case 0:
        {
            return @"未提交审核";
        }
        case 1:
        {
            return @"待审核";
        }
        case 2:
        {
            return @"审核通过";
        }
        case 3:
        {
            return @"审核未通过";
        }
        default:
            return nil;
    }
}

- (NSString *)userBaseInfoNowStatusString
{
    switch (self.userBaseInfoStatus)
    {
        case UserBaseInfoStatusNull:
        {
            return @"信息不完整";
        }
        case UserBaseInfoStatusNormal:
        {
            return @"审核通过";
        }
        case UserBaseInfoStatusRefused:
        {
            return @"审核未通过";
        }
        case UserBaseInfoStatusReviewing:
        {
            return @"审核中";
        }
        default:
            return nil;
    }
}

- (NSString *)userPayInfoNowStatusString
{
    switch (self.userPayInfoStatus)
    {
        case UserPayInfoStatusNull:
        {
            return @"信息不完整";
        }
        case UserPayInfoStatusNormal:
        {
            return @"审核通过";
        }
        case UserPayInfoStatusRefused:
        {
            return @"审核未通过";
        }
        case UserPayInfoStatusReviewing:
        {
            return @"审核中";
        }
        default:
            return nil;
    }
}

- (NSString *)userPhotoInfoNowStatusString
{
    switch (self.userPhotoInfoStatus)
    {
        case UserPhotoInfoStatusNull:
        {
            return @"信息不完整";
        }
        case UserPhotoInfoStatusNormal:
        {
            return @"审核通过";
        }
        case UserPhotoInfoStatusRefused:
        {
            return @"审核未通过";
        }
        case UserPhotoInfoStatusReviewing:
        {
            return @"审核中";
        }
        default:
            return nil;
    }
}

- (void)refreshUserBaseInfoStatus
{
    if (self.userStatus == UserInfoStatusNormal)
    {
        self.userBaseInfoStatus = UserBaseInfoStatusNormal;
    }
    
    if (self.userStatus == UserInfoStatusNull)
    {
        self.userBaseInfoStatus = UserBaseInfoStatusNull;
    }
    
    if (self.userStatus == UserInfoStatusReviewing)
    {
        self.userBaseInfoStatus = UserBaseInfoStatusReviewing;
    }

    if (self.userStatus == UserInfoStatusRefused)
    {
        if (self.realname.length <= 0 || self.sex.length <= 0 || self.idcard.length <= 0 || self.drivingNo.length <= 0 || self.company.length <= 0 ||
            self.career.length <= 0 || self.email.length <= 0 || self.homeAddress.length <= 0 || self.postalAddress.length <= 0 || self.postalcode.length <= 0)
        {
            self.userBaseInfoStatus = UserBaseInfoStatusRefused;
        }
        else
        {
            self.userBaseInfoStatus = UserBaseInfoStatusNormal;
        }
    }
}

- (void)refreshUserPhotoInfoStatus
{
    if (self.userStatus == UserInfoStatusNormal)
    {
        self.userPhotoInfoStatus = UserPhotoInfoStatusNormal;
    }
    
    if (self.userStatus == UserInfoStatusNull)
    {
        self.userPhotoInfoStatus = UserPhotoInfoStatusNull;
    }
    
    if (self.userStatus == UserInfoStatusReviewing)
    {
        self.userPhotoInfoStatus = UserPhotoInfoStatusReviewing;
    }
    
    if (self.userStatus == UserInfoStatusRefused)
    {
        if (self.idcardfront.length <= 0 || self.idcardback.length <= 0 || self.drivingLiensef.length <= 0 || self.drivingLienses.length <= 0 ||
            self.facecardfront.length <= 0 || self.facecardback.length <= 0)
        {
            self.userPhotoInfoStatus = UserPhotoInfoStatusRefused;
        }
        else
        {
            self.userPhotoInfoStatus = UserPhotoInfoStatusNormal;
        }
    }
}

- (void)refreshUserPayInfoStatus
{
    if (self.userStatus == UserInfoStatusNormal)
    {
        self.userPayInfoStatus = UserPayInfoStatusNormal;
    }
    
    if (self.userStatus == UserInfoStatusNull)
    {
        self.userPayInfoStatus = UserPayInfoStatusNull;
    }
    
    if (self.userStatus == UserInfoStatusReviewing)
    {
        self.userPayInfoStatus = UserPayInfoStatusReviewing;
    }

    if (self.userStatus == UserInfoStatusRefused)
    {
        if (self.creditNo.length <= 0 || self.expirationdateyear.length <= 0 || self.expirationdatemonth.length <= 0 || self.pmobile.length <= 0 ||
            self.verifycode.length <= 0 || self.checkpwd.length <= 0)
        {
            self.userPayInfoStatus = UserPayInfoStatusRefused;
        }
        else
        {
            self.userPayInfoStatus = UserPayInfoStatusNormal;
        }
    }
}

- (BOOL)isUserInfoComplete
{
    return [self isUserPhotoInfoComplete] && [self isUserBaseInfoComplete] && [self isUserPayInfoComplete];
}

- (BOOL)isUserBaseInfoComplete
{
    if (self.realname.length <= 0 || self.sex.length <= 0 || self.idcard.length <= 0 || self.drivingNo.length <= 0 || self.company.length <= 0 || self.career.length <= 0 || self.email.length <= 0 || self.homeAddress.length <= 0 || self.postalAddress.length <= 0 || self.postalcode.length <= 0)
    {
        return NO;
    }
    return YES;
}

- (BOOL)isUserPayInfoComplete
{
    if (self.creditNo.length <= 0 || self.expirationdateyear.length <= 0 || self.expirationdatemonth.length <= 0 || self.verifycode.length <= 0 || self.pmobile.length <= 0 || self.checkpwd.length <= 0)
    {
        return NO;
    }
    return YES;
}

- (BOOL)isUserPhotoInfoComplete
{
    if (self.idcardfront.length <= 0 || self.idcardback.length <= 0 || self.drivingLiensef.length <= 0 || self.drivingLienses.length <= 0 || self.facecardfront.length <= 0 || self.facecardback.length <= 0)
    {
        return NO;
    }
    return YES;
}

@end
