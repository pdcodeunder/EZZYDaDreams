//
//  ECarUserManager.m
//  ElectricCarRent
//
//  Created by LIKUN on 15/10/5.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarUserManager.h"

@implementation ECarUserManager
- (DSASubject *)savePicture:(NSString *)userid fileName:(NSString *)file type:(UploadPictureTypes)cardType
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userid,@"userId",file,@"fileName",[NSString stringWithFormat:@"%ld",(long)cardType],@"cardType",TokenPrams, nil];
    NSString *loginurl=[NSString stringWithFormat:@"%@car/pictureController.do?save", ServerURL];
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

- (DSASubject *)updatePicture:(NSString *)userid file:(NSString *)file
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userid, @"phone",file, @"file",TokenPrams, nil];
//    NSLog(@"JHHHHFDF  %@", userid);
    NSString *loginurl=[NSString stringWithFormat:@"%@car/tCMemberController.do?uploadPicCarno", ServerURL];
    [KKHttpServices httpPostUrl:loginurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

- (DSASubject *)getPicture:(NSString *)userid
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userid,@"userId",TokenPrams, nil];
    NSString *loginurl=[NSString stringWithFormat:@"%@car/pictureController.do?getPicture", ServerURL];
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

- (DSASubject *)refreshUserInfo
{
    DSASubject *subject = [DSASubject subject];
    ECarUser *user = [ECarConfigs shareInstance].user;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:user.phone,@"phone",TokenPrams, nil];
    NSString *doVerifyurl = [NSString stringWithFormat:@"%@car/tCMemberController.do?getMember2", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse)
    {
        NSMutableDictionary *dic = parse.responseJsonOB;
        NSDictionary *objDic = dic[@"obj"];
        [user updateUserInfoWithResponse:objDic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
    {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

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
                       homeAddress:(NSString *)homeAddress
{
    DSASubject *subject=[DSASubject subject];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userid,@"id",realname,@"realname",birth,@"birth",sex,@"sex",
                         idcard,@"idcard",
                         drivingLicense,@"drivingLicense",
                         dept,@"dept",
                         career,@"career",
                         email,@"email",
                         postalAddress,@"postalAddress",
                         postalcode,@"postalcode",
                         homeAddress,@"address",
                         TokenPrams,
                         nil];
    
    NSString *loginurl=[NSString stringWithFormat:@"%@car/tCMemberController.do?doUpdateInfo", ServerURL];
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

- (DSASubject *)updateUserPayInfo:(NSString *)userid bankCard:(NSString *)cardNo
                     validityYear:(NSString *)year
                    validityMonth:(NSString *)month
                       verifyCode:(NSString *)verifyCode
                            phone:(NSString *)phone
                              pwd:(NSString *)pwd
{
    DSASubject *subject=[DSASubject subject];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userid,@"id",cardNo,@"bankcark",month,@"expirationdatemonth",year,@"expirationdateyear",
                         verifyCode,@"verifycode",
                         pwd,@"pwd",
                         phone,@"pmobile",
                         TokenPrams,
                         nil];
    NSString *loginurl=[NSString stringWithFormat:@"%@car/tCMemberController.do?doUpdateInfo", ServerURL];
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

- (DSASubject *)userAudit:(NSString *)userid
{
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userid,@"id",TokenPrams, nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCMemberController.do?changeAudit", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        NSDictionary *objDic = dic[@"obj"];
        [subject sendNext:objDic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
}
- (DSASubject *)userPhoneDataList:(NSString *)userid
                             Data:(NSString *)dataArr
{
    
    
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userid,@"id", dataArr, @"data", TokenPrams,nil ];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCAddressBookController.do?addressList", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
       NSDictionary *dic = [ToolKit JSONDecodeFromString:operation.responseString];
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         
         [subject sendError:nil];
         [subject sendCompleted];
         
         
     }];
    return subject;
    
    
    
}

// 会员邀请码接口
- (DSASubject* )sendBuyMemberInfoRenyuanID:(NSString *)renyuanID
                               vipFreeCode:(NSString *)vipFreeCode
{
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:renyuanID,@"phone", vipFreeCode, @"vipFreeCode", TokenPrams,nil ];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCemberVipController.do?changeVipByFree", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;

        NSDictionary *objDic = dic;
        [subject sendNext:objDic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
}

// 单次优惠码接口
- (DSASubject* )sendBuyMemberInfodingdanID:(NSString *)dingdanID
                                  freeCode:(NSString *)freeCode
{
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:dingdanID,@"id", freeCode, @"freeCode", TokenPrams,nil ];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCOrderController.do?userUseOnceFreeCode", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        NSDictionary *objDic = dic;
        [subject sendNext:objDic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
}
//首次导入通讯录
- (DSASubject *)firstDaoRuTongXunLu:(NSString *)phoneNumber
{
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"phone",TokenPrams,nil ];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCAddressBookController.do?checkIsFirstImport", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary *dic = [ToolKit JSONDecodeFromString:operation.responseString];
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
}

// 获取所有会员信息
- (DSASubject *)getMemberAllInfoPhone:(NSString *)phone{
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone", TokenPrams,nil ];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCemberVipController.do?checkUserVipState", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
}

//前台给后台传的参数String tokenid,String id（人员ID）,String vipType（vip类型）   返回金额和订单号（levelMoney、orderId）
- (DSASubject* )sendBuyMemberInfoRenyuanID:(NSString *)renyuanID
                                   vipType:(NSString *)vipType
{
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:renyuanID,@"phone", vipType, @"vipType", TokenPrams,nil ];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCemberVipController.do?doBuyVipOrAdd", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
}

// 观看视屏
- (DSASubject *)getMoviesListDataFromNetWorkWithPage:(NSInteger)page
{
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%zd", page],@"page", nil ];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/paramConController.do?getVideoList", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
    return nil;
}

// 新的获取所有会员信息
- (DSASubject *)getAllMemberInfoByPhone:(NSString *)phone{
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone", TokenPrams,nil ];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tVipAppController.do?getUerVipInformation", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
}

// 新的点击购买生成订单
- (DSASubject* )creatOrderByRenyuanID:(NSString *)renyuanID
                              vipType:(NSString *)vipType
                              lastNum:(NSString *)lastNum
{
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:renyuanID, @"phone", vipType, @"vipType", lastNum, @"lastnum",TokenPrams,nil ];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tVipAppController.do?BuyVipOrder", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
}

// 关于我们
- (DSASubject* )aboutUs
{
    DSASubject *subject = [DSASubject subject];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/paramConController.do?getGywm", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:nil success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
}

// 联系客服
- (DSASubject* )connectUs
{
    DSASubject *subject = [DSASubject subject];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/paramConController.do?getLxwm", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:nil success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
}

//会员到期提醒
- (DSASubject* )memberTranslationRemaind:(NSString *)phone
{
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",TokenPrams,nil ];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCemberVipController.do?vipCountDown",ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
    
}

/**
 *  行程发票列表
 */
- (DSASubject* )xingchengFapiaoListWithPhone:(NSString *)phone andPage:(NSString *)page
{
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone, @"phone", page, @"page", TokenPrams, nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/appReceiptController.do?getOrderReceipt",ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
    
}

/**
 *  行程发票列表
 */
- (DSASubject* )goumaiHuiYuanFaPiaoWithPhone:(NSString *)phone andPage:(NSString *)page
{
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone, @"phone", page, @"page", TokenPrams, nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/appReceiptController.do?getVIPOrderReceipt",ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
    
}

/**
 *  行程发票提交
 */
- (DSASubject* )submitXingChengPaPiaoWithDic:(NSDictionary *)dic
{
    DSASubject *subject = [DSASubject subject];

    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/appReceiptController.do?getOrderReceiptOrder",ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
}

/**
 *  会员发票提交
 */
- (DSASubject* )submitVIPPaPiaoWithDic:(NSDictionary *)dic
{
    DSASubject *subject = [DSASubject subject];
    
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/appReceiptController.do?getVipOrderReceiptOrder",ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
}

// 开票历史 VIP
- (DSASubject* )fapiaoHistoryVIP:(NSString *)phone
                            type:(NSString *)type
                            page:(NSString *)page
{
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",type,@"type",page,@"page",TokenPrams,nil ];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/appReceiptController.do?getVipOrderReceiptList",ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
    
}

// 开票历史 行程
- (DSASubject* )fapiaoHistoryXingcheng:(NSString *)phone
                                  type:(NSString *)type
                                  page:(NSString *)page
{
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",type,@"type",page,@"page",TokenPrams,nil ];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/appReceiptController.do?getOrderReceiptList",ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
    
}

// 违章处理
- (DSASubject* )weiZhangKouKuanWithPhone:(NSString *)phone
                                  page:(NSString *)page
                             andSeverURL:(NSString *)severUrl
{
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone, @"phone", page, @"page", TokenPrams,nil ];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@%@", ServerURL, severUrl];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
}

// 违章自行处理
- (DSASubject* )weiZhangZiXingChuLiWithPID:(NSString *)pid
{
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pid, @"pid", TokenPrams,nil ];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tcpeccancyController.do?toProcessed", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
}

// 违章说明
- (DSASubject* )weizhangshuoming
{
    DSASubject *subject = [DSASubject subject];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tcpeccancyController.do?getProcessedExplain",ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:nil success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
    
}

// 行程说明
- (DSASubject* )xingchengShuoMing
{
    DSASubject *subject = [DSASubject subject];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/appReceiptController.do?getinvoiveexplain",ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:nil success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse)
     {
         [subject sendError:nil];
         [subject sendCompleted];
     }];
    return subject;
    
}

@end
