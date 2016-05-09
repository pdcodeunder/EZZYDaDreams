//
//  ECarUser.h
//  ElectricCarRent
//
//  Created by LIKUN on 15/8/28.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECarEnum.h"

@interface ECarUser : NSObject

//用户登陆信息
@property (strong, nonatomic) NSString *user_id;/**<用户id*/
@property (strong, nonatomic) NSString *password;/**<用户密码*/
@property (strong, nonatomic) NSString *phone;/**<用户手机号*/

//用户首页信息
@property (strong, nonatomic) NSString *username;/**<用户用户名*/
@property (readwrite, nonatomic) UserInfoStatus userStatus;/**<用户全部信息状态，0-未提交审核、1-待审核、2-审核通过、3-审核未通过、4-锁定*/
@property (readwrite, nonatomic) UserBaseInfoStatus userBaseInfoStatus;/**<用户基本信息状态*/
@property (readwrite, nonatomic) UserPhotoInfoStatus userPhotoInfoStatus;/**<用户照片信息状态*/
@property (readwrite, nonatomic) UserPayInfoStatus userPayInfoStatus;/**<用户支付信息状态*/

//@property (strong, nonatomic) NSString *userAvater;/**<用户头像*/
//@property (strong, nonatomic) NSString *orderStatus;/**<用户订单状态*/
//@property (strong, nonatomic) NSString *msgNuber;/**<用户未读消息条数*/

//用户基本资料
@property (strong, nonatomic) NSString *realname;/**<用户真实姓名*/
@property (strong, nonatomic) NSString *sex;/**<用户性别，0男1女*/
@property (strong, nonatomic) NSString *idcard;/**<用户身份证号*/
@property (strong, nonatomic) NSString *drivingNo;/**<用户驾驶证号*/
@property (strong, nonatomic) NSString *company;/**<用户单位*/
@property (strong, nonatomic) NSString *career;/**<用户职业*/
@property (strong, nonatomic) NSString *email;/**<用户邮箱*/
@property (strong, nonatomic) NSString *homeAddress;/**<用户家庭地址*/
@property (strong, nonatomic) NSString *postalAddress;/**<通讯地址*/
@property (strong, nonatomic) NSString *postalcode;/**<邮政编码*/

//用户照片资料
@property (strong, nonatomic) NSString *idcardfront;/**<身份证正面*/
@property (strong, nonatomic) NSString *idcardback;/**<身份证反面*/
@property (strong, nonatomic) NSString *drivingLiensef;/**<驾驶证照片正面照*/
@property (strong, nonatomic) NSString *drivingLienses;/**<驾驶证照片反面照*/
@property (strong, nonatomic) NSString *facecardfront;/**<用户正面*/
@property (strong, nonatomic) NSString *facecardback;/**<用户反面*/

//用户支付信息
@property (strong, nonatomic) NSString *creditNo;/**<信用卡号*/
@property (strong, nonatomic) NSString *expirationdateyear;/**<有效年*/
@property (strong, nonatomic) NSString *expirationdatemonth;/**<有效月*/
@property (strong, nonatomic) NSString *verifycode;/**<验证码*/
@property (strong, nonatomic) NSString *pmobile;/**<卡预留手机*/
@property (strong, nonatomic) NSString *checkpwd;/**<交易密码*/

////用户常用地址信息
//@property (strong, nonatomic) NSString *commomHomeAddress;/**<用户家庭地址*/
//@property (strong, nonatomic) NSString *commomCompanyAddress;/**<用户公司地址*/

//其他
@property (strong, nonatomic) NSString *age;/**<用户年龄*/
@property (strong, nonatomic) NSString *birth;/**<用户生日*/
@property (strong, nonatomic) NSString *islock;
@property (strong, nonatomic) NSString *paymsg;/**<用户id*/

- (instancetype)initWithResponse:(NSDictionary *)dic;

- (NSString *)userInfoNowStatusString;
- (NSString *)userBaseInfoNowStatusString;
- (NSString *)userPayInfoNowStatusString;
- (NSString *)userPhotoInfoNowStatusString;

- (BOOL)isUserInfoComplete;
- (BOOL)isUserBaseInfoComplete;
- (BOOL)isUserPhotoInfoComplete;
- (BOOL)isUserPayInfoComplete;

/**
 *  更新已登陆用户的信息
 *
 *  @param dic 服务器数据
 */
- (void)updateUserInfoWithResponse:(NSDictionary *)dic;

@end
