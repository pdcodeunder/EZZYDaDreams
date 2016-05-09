//
//  ECarUserManager.h
//  ElectricCarRent
//
//  Created by LIKUN on 15/10/5.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKHttpServices.h"
#import "DSASubject.h"
@interface ECarUserManager : NSObject
/**
 *  保存图片
 *
 *  @param userid   用户id
 *  @param file     图片名称
 *  @param cardType 图片类型   0：会员身份证正面；1：身份证反面；2：驾驶证正面；3：驾驶证返面；4：颜照正面；5：颜照反面
 *
 *  @return subject
 */
- (DSASubject *)savePicture:(NSString *)userid fileName:(NSString *)file type:(UploadPictureTypes)cardType;
/**
 *  获取图片信息
 *
 *  @param userid 用户id
 *
 *  @return subject
 */
- (DSASubject *)getPicture:(NSString *)userid;

- (DSASubject *)refreshUserInfo;

/**
 *  更新个人基本信息
 *
 *  @param userid         用户id
 *  @param realname       姓名
 *  @param birth          生日 1990-05-02
 *  @param sex            性别  0，1
 *  @param idcard         身份证
 *  @param drivingLicense 驾驶证
 *  @param dept           单位
 *  @param career         职业
 *  @param email          邮箱
 *  @param postalAddress  通信地址
 *  @param postalcode     邮政编码
 *  @param homeAddress    家庭地址
 *
 *  @return subject
 */
- (DSASubject *)updateUserBaseInfo:(NSString *)userid name:(NSString *)realname
                             birth:(NSString *)birth
                               sex:(NSString *)sex
                            idcard:(NSString *)idcard
                    drivingLicense:(NSString *)drivingLicense
                              dept:(NSString *)dept
                            career:(NSString *)career
                             email:(NSString *)email
                     postalAddress:(NSString *)postalAddress
                        postalcode:(NSString *)postalcode
                       homeAddress:(NSString *)homeAddress;

/*
     上传图片接口
 */

- (DSASubject *)updatePicture:(NSString *)userid file:(NSString *)file;

/**
 *  更新支付信息的接口
 *
 *  @param userid     用户id
 *  @param cardNo     卡号
 *  @param validDate  有效期
 *  @param verifyCode 验证码
 *  @param phone      预留手机号
 *  @param pwd        密码
 *
 *  @return subject
 */
- (DSASubject *)updateUserPayInfo:(NSString *)userid bankCard:(NSString *)cardNo
                     validityYear:(NSString *)year
                    validityMonth:(NSString *)month
                       verifyCode:(NSString *)verifyCode
                            phone:(NSString *)phone
                              pwd:(NSString *)pwd;
/**
 *  提交审核接口
 *
 *  @param userid userid
 *
 *  @return subject
 */
- (DSASubject *)userAudit:(NSString *)userid;
// 导入通讯录接口
- (DSASubject *)userPhoneDataList:(NSString *)userid
                             Data:(NSString *)dataArr;

// 会员邀请码接口
- (DSASubject* )sendBuyMemberInfoRenyuanID:(NSString *)renyuanID
                               vipFreeCode:(NSString *)vipFreeCode;

- (DSASubject* )sendBuyMemberInfodingdanID:(NSString *)dingdanID
                                  freeCode:(NSString *)freeCode;
// 首次导入通讯录
- (DSASubject *)firstDaoRuTongXunLu:(NSString *)phoneNumber;

//获取会员信息接口
- (DSASubject *)getMemberAllInfoPhone:(NSString *)phone;

//点击购买生成订单接口
- (DSASubject *)sendBuyMemberInfoRenyuanID:(NSString *)renyuanID
                                   vipType:(NSString *)vipType;

// 视频播放
- (DSASubject *)getMoviesListDataFromNetWorkWithPage:(NSInteger)page;

// 新的获取会员信息的接口
- (DSASubject *)getAllMemberInfoByPhone:(NSString *)phone;


// 新的点击购买生成订单接口
- (DSASubject* )creatOrderByRenyuanID:(NSString *)renyuanID
                              vipType:(NSString *)vipType
                              lastNum:(NSString *)lastNum;

- (DSASubject* )aboutUs;

- (DSASubject* )connectUs;

- (DSASubject* )memberTranslationRemaind:(NSString *)phone;

/**
 *  行程发票列表
 */
- (DSASubject* )xingchengFapiaoListWithPhone:(NSString *)phone andPage:(NSString *)page;

/**
 *  购买会员发票列表
 */
- (DSASubject* )goumaiHuiYuanFaPiaoWithPhone:(NSString *)phone andPage:(NSString *)page;

- (DSASubject* )submitXingChengPaPiaoWithDic:(NSDictionary *)dic;

- (DSASubject* )submitVIPPaPiaoWithDic:(NSDictionary *)dic;

// 开票历史 行程
- (DSASubject* )fapiaoHistoryXingcheng:(NSString *)phone
                                  type:(NSString *)type
                                  page:(NSString *)page;
// 开票历史 VIP
- (DSASubject* )fapiaoHistoryVIP:(NSString *)phone
                            type:(NSString *)type
                            page:(NSString *)page;

// 违章处理
- (DSASubject* )weiZhangKouKuanWithPhone:(NSString *)phone
                                    page:(NSString *)page
                             andSeverURL:(NSString *)severUrl;

// 自行处理
- (DSASubject* )weiZhangZiXingChuLiWithPID:(NSString *)pid;

// 违章说明
- (DSASubject* )weizhangshuoming;

// 行程说明
- (DSASubject* )xingchengShuoMing;

@end
