//
//  ECarFapiaoHistoryModel.m
//  ElectricCarRent
//
//  Created by 张钊 on 16/3/30.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarFapiaoHistoryModel.h"

@implementation ECarFapiaoHistoryModel

/*
 addressee = 22;
 applytime = 1459334684000;
 conphone = 22;
 disinvcontent = 22;
 disinvsum = 22;
 disinvtitle = 22;
 expresscompany = 2;
 expressnumber = 2;
 freeship = 22;
 id = 1121212121;
 invNo = 40280d8150b27fa90150b2925535000a;
 invnote = 2;
 mailcost = 22;
 mailstatu = 0;
 mailtime = 1459334680000;
 orderIDs = 40280d8150b27fa90150b2925535000a;
 placeaddress = 22;
 userId = 8ab3c0cd5171c0b2015171f08aba00a3;
 */

// 重写构造方法解析数据
-(instancetype)initWithJSONDic:(NSDictionary *)dic
{
    if(self = [super init]){
        // 以为字段的名字是关键字所以不能直接映射，我们手动写入
        self.name = [NSString stringWithFormat:@"%@",dic[@"addressee"]];
        self.phoneNum = [NSString stringWithFormat:@"%@",dic[@"conphone"]];
        self.address = [NSString stringWithFormat:@"%@",dic[@"placeaddress"]];
        self.companyHeader = [NSString stringWithFormat:@"%@",dic[@"disinvtitle"] ];
        self.connets = [NSString stringWithFormat:@"%@",dic[@"disinvcontent"]];
        self.costs = [NSString stringWithFormat:@"%@",dic[@"disinvsum"]];
        self.time = [NSString stringWithFormat:@"%@",dic[@"applytime"]];
        self.state = [NSString stringWithFormat:@"%@",dic[@"mailstatu"]];
        
        self.fanhuiID = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.userID = [NSString stringWithFormat:@"%@",dic[@"userId"]];
        self.invNo = [NSString stringWithFormat:@"%@",dic[@"invNo"]];
        self.orderID = [NSString stringWithFormat:@"%@",dic[@"userId"]];
        self.freeship = [NSString stringWithFormat:@"%@",dic[@"freeship"]];
        self.mailCost = [NSString stringWithFormat:@"%@",dic[@"mailcost"]];
        self.mailTime = [NSString stringWithFormat:@"%@",dic[@"mailtime"]];
        self.expressCompany = [NSString stringWithFormat:@"%@",dic[@"expresscompany"]];
        self.expressNumber = [NSString stringWithFormat:@"%@",dic[@"expressnumber"]];
        self.invote = [NSString stringWithFormat:@"%@",dic[@"invnote"]];
    }
    return self;
}

// 共有方法，外部直接调用解析
+(ECarFapiaoHistoryModel *)parseWithJSONDic:(NSDictionary *)dic
{
    ECarFapiaoHistoryModel * model = [[ECarFapiaoHistoryModel alloc] initWithJSONDic:dic];
    return model;
}

@end
