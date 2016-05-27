//
//  ECarMapManager.m
//  ElectricCarRent
//
//  Created by LIKUN on 15/9/14.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarMapManager.h"
@implementation ECarMapManager

- (DSASubject *)createOrder:(NSString *)carid userID:(NSString *)user_id begin:(NSString *)begin area:(NSString *)area userLatitude:(NSString *)userSPLatitude userLongitude:(NSString *)userSPLongitude
{
    DSASubject *subject=[DSASubject subject];
//    PDLog(@"1%@   2 %@    3%@    4%@     5%@    6%@    7%@    8%@    9%@    10%@, 1%@   2%@", carid, user_id, begin, destination,area,power, endPLatitude, endPLongitude, userSPLatitude, userSPLongitude,theCarLatitude, theCarLongitude);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%@", userSPLatitude],@"userSPLatitude",
                         [NSString stringWithFormat:@"%@", userSPLongitude],@"userSPLongitude",
                         [NSString stringWithFormat:@"%@", carid],@"car.id",
                         [NSString stringWithFormat:@"%@", user_id],@"member.id",
                         [NSString stringWithFormat:@"%@", begin],@"begin",
                         [NSString stringWithFormat:@"%@", area],@"territoryId", TokenPrams, nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCOrderController.do?doAdd", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary *dic = parse.responseJsonOB;
        if (dic) {
            [subject sendNext:dic];
            [subject sendCompleted];
        }
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

//获取订单列表
- (DSASubject *)orderList:(NSString *)user_id page:(NSInteger)page
{
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:user_id,@"memberId", [NSString stringWithFormat:@"%zd", page], @"page",TokenPrams, nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCOrderController.do?getMemberOrder2", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

// 车辆列表
-(DSASubject *)carTableListUserCoordinate:(CLLocationCoordinate2D)userCoordinate
                                    order:(NSString *)orderStr
                                     type:(NSString *)typeStr
                                   states:(NSString *)states
                                  andPage:(NSString *)page;
{
    DSASubject *subject = [DSASubject subject];
    NSDictionary *dic = nil;
    NSString *doVerifyurl = nil;
    NSString * yonghuID = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
    doVerifyurl = [NSString stringWithFormat:@"%@car/tCCarStatusController.do?%@", ServerURL,states];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lf", userCoordinate.longitude], @"longitude", [NSString stringWithFormat:@"%lf", userCoordinate.latitude], @"latitude", orderStr, @"order", typeStr, @"type", page, @"page", yonghuID, @"phone", @"2", @"buildId", nil];
    
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableArray *carAry = [[NSMutableArray alloc] init];
        NSMutableDictionary *dic = parse.responseJsonOB;
        NSArray *objAry = dic[@"obj"];
        for (NSDictionary *objDic in objAry) {
            ECarCarInfo *carInfo = [[ECarCarInfo alloc] initWithResponse:objDic];
            [carAry addObject:carInfo];
        }
        [subject sendNext:carAry];
        [subject sendCompleted];
        
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

/**
 *  得到价格明细
 */
- (DSASubject *)getJiaGeMingXiWithOrder:(NSString *)orderID
{
    DSASubject *subject=[DSASubject subject];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCOrderController.do?getPicDetail", ServerURL];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderID,@"id", TokenPrams, nil];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary * dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

/**
 *  支付宝支付完成回调
 */
- (DSASubject *)zhifubaofinishOrderWithID:(NSString *)orderNo andCanshu:(NSString *)canshu
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderNo,@"id", canshu, @"mes",TokenPrams, nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/TCOrderPayController.do?aliPayCall", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
//        NSDictionary * dic = parse.responseJsonOB;
        [subject sendNext:nil];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

/**
 *  点击微信支付掉用
 */
- (DSASubject *)sendHouTaiWithOrderID:(NSString *)orderID
{
    DSASubject *subject=[DSASubject subject];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCOrderController.do?findWxPAYisok", ServerURL];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderID,@"id", TokenPrams, nil];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary * dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

// 异步调用_通过Vip接口
- (DSASubject *)sendHouTaiVipWithOrderID:(NSString *)orderID
{
    DSASubject *subject=[DSASubject subject];
    
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCOrderController.do?findWxPayVipisok", ServerURL];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderID,@"id", TokenPrams, nil];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary * dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

/**
 *  微信支付
 */
- (DSASubject *)weixinzhifuOrderWithID:(NSString *)orderNo andTimestamp:(NSString *)timestamp
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderNo, @"id", timestamp, @"time_stamp", TokenPrams, nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/TCOrderPayController.do?getWxPay", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary * dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

/**
    范围控制 (图片和四点折线)
 */
- (DSASubject *)getFanWeiKongZhi
{
    DSASubject *subject=[DSASubject subject];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCSysconfigController.do?getRectangle", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:nil success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary * dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

/**
 范围控制 (自定义不规则范围控制)
 */
- (DSASubject *)getZiDingYiFanWeiKongZhiWithVersion:(NSString *)version
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:version, @"version", nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCSysconfigController.do?getRectangleNew", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary * dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

/**
    找车延时
 */
- (DSASubject *)zhaocheYanshiWithOrder:(NSString *)orderID
{
    DSASubject *subject=[DSASubject subject];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCOrderController.do?continuedTime", ServerURL];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderID,@"id", TokenPrams, nil];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary * dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

/**
    双闪
 */
- (DSASubject *)lookingCar:(NSString *)carid
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:carid,@"id",TokenPrams, nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCCarStatusController.do?remoteLookingCar", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        [subject sendNext:nil];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

// 取消订单时的接口。
- (DSASubject *)cancelOrder:(NSString *)orderID carid:(NSString *)carid userid:(NSString *)userid andStatus:(NSInteger)status
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderID, @"id", [NSString stringWithFormat:@"%zd", status], @"status",TokenPrams, nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCOrderController.do?cancelOrder", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

// 开中控锁
- (DSASubject *)openLock:(NSString *)orderID
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderID, @"id",TokenPrams, nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCOrderController.do?orderUnlock", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary * dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

// 得到价格
- (DSASubject *)getMoneyPrice:(NSString *)orderID
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderID, @"id", TokenPrams, nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCOrderController.do?retPrice", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

/**
 *  用车导航开锁
 */
- (DSASubject *)useCarOpenDoorWith:(NSString *)orderID
{
    DSASubject *subject=[DSASubject subject];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCOrderController.do?openCarDoor", ServerURL];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderID,@"id", TokenPrams, nil];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary * dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

/**
 *  用车导航关锁
 */
- (DSASubject *)useCarCloseDoorWith:(NSString *)orderID
{
    DSASubject *subject=[DSASubject subject];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCOrderController.do?closeCarDoor", ServerURL];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderID,@"id", TokenPrams, nil];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary * dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

/**
 *  判断车门是否开过
 */
- (DSASubject *)panduanDoorIsOpen:(NSString *)orderNo
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderNo,@"id",TokenPrams, nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCOrderController.do?CarDoorIsOpen", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary * dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

- (DSASubject *)endOrderNo:(NSString *)orderID
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderID, @"id", TokenPrams, nil];
    NSString *doVerifyurl = [NSString stringWithFormat:@"%@car/tCOrderController.do?finishUsingCar", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary *dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

// 支付完成回调
- (DSASubject *)finishOrderWithID:(NSString *)orderNo
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderNo,@"orderNo" ,TokenPrams, nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCOrderController.do?PaymentCompletion", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        //        NSDictionary * dic = parse.responseJsonOB;
        [subject sendNext:nil];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

// 查找附近车辆
- (DSASubject *)findNearCarsUserCoordinate:(CLLocationCoordinate2D)userCoordinate andDestination:(CLLocationCoordinate2D)destination andAllSelect:(BOOL)isAll
{
    DSASubject *subject = [DSASubject subject];
    
    NSDictionary *dic = nil;
    NSString *doVerifyurl = nil;
    NSString * yonghuID = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    doVerifyurl = [NSString stringWithFormat:@"%@car/tCCarStatusController.do?findAllBeiJingCar", ServerURL];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lf", userCoordinate.longitude], @"longitude", [NSString stringWithFormat:@"%lf", userCoordinate.latitude], @"latitude", yonghuID, @"phone", nil];
//    } else {
//        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", userCoordinate.longitude], @"longitude", [NSString stringWithFormat:@"%f", userCoordinate.latitude], @"latitude", [NSString stringWithFormat:@"%f", destination.longitude], @"Terminilongitude", [NSString stringWithFormat:@"%f", destination.latitude], @"Terminilatitude", yonghuID, @"phone", nil];
//        doVerifyurl = [NSString stringWithFormat:@"%@car/tCCarStatusController.do?findAreaCar", ServerURL];
//    }
    
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSMutableArray *carAry = [[NSMutableArray alloc] init];
        NSMutableDictionary *dic = parse.responseJsonOB;
        NSArray *objAry = dic[@"obj"];
        for (NSDictionary *objDic in objAry) {
            ECarCarInfo *carInfo = [[ECarCarInfo alloc] initWithResponse:objDic];
            [carAry addObject:carInfo];
        }
        [subject sendNext:carAry];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

// 获得估计价格
- (DSASubject *)getGuJiFeiYongWithStartCoordinate:(CLLocationCoordinate2D)beginCoordinate andDestination:(CLLocationCoordinate2D)destination andUserID:(NSString *)userid
{
    DSASubject *subject = [DSASubject subject];
    if (!userid) {
        userid = @"dashabi";
    }
    NSString *doVerifyurl = [NSString stringWithFormat:@"%@car/tCOrderController.do?getCarPicYuji", ServerURL];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%lf", beginCoordinate.longitude], @"slo",
                         [NSString stringWithFormat:@"%lf", beginCoordinate.latitude], @"sla",
                         [NSString stringWithFormat:@"%lf", destination.longitude], @"elo",
                         [NSString stringWithFormat:@"%lf", destination.latitude], @"ela",
                         userid, @"mid",
                         TokenPrams, nil];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary * dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

// 上报位置
- (DSASubject *)sendUserLocationWithPhone:(NSString *)phone latitude:(NSString *)latitude longtitude:(NSString *)lontitude
{
    DSASubject *subject=[DSASubject subject];
    
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCMemberController.do?getmemberLoLa", ServerURL];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone", latitude, @"latitude", lontitude, @"longitude",TokenPrams, nil];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary * dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

// 获取人和车开锁的距离
- (DSASubject *)getOpenCarDistanceBetweenPersonAndCar {
    DSASubject *subject = [DSASubject subject];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCCarStatusController.do?getUserToCarDistance", ServerURL];
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

- (DSASubject *)openLockbyLanYaWithOrderID:(NSString *)orderID
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderID, @"id",TokenPrams, nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCOrderController.do?orderUnlockBluetooth", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary * dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

// 违章扣款支付完成回调
- (DSASubject *)weiZhangKouKuanFinishOrderWithID:(NSString *)orderNo Type:(NSString *)type andPayMethod:(NSString *)payMethod
{
    DSASubject *subject=[DSASubject subject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderNo, @"pid", type, @"type", payMethod, @"payMethod", TokenPrams, nil];
    NSString *doVerifyurl=[NSString stringWithFormat:@"%@car/tCOrderController.do?PaymentCompletion", ServerURL];
    [KKHttpServices httpPostUrl:doVerifyurl prams:dic success:^(AFHTTPRequestOperation *operation, KKHttpParse *parse) {
        NSDictionary * dic = parse.responseJsonOB;
        [subject sendNext:dic];
        [subject sendCompleted];
    } failure:^(KKHttpParse *parse) {
        [subject sendError:nil];
        [subject sendCompleted];
    }];
    return subject;
}

@end
