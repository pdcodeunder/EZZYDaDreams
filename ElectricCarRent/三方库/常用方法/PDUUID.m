//
//  PDUUID.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/5/16.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "PDUUID.h"
#import "PDKeyChainStore.h"

@implementation PDUUID

+(NSString *)getUUID
{
    NSString * strUUID = (NSString *)[PDKeyChainStore load:@"com.company.app.usernamepassword"];
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        //将该uuid保存到keychain
        [PDKeyChainStore save:KEY_USERNAME_PASSWORD data:strUUID];
    }
    return strUUID;
}

@end
