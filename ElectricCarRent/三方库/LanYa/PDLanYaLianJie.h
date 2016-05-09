//
//  PDLanYaLianJie.h
//  ddddd
//
//  Created by 彭懂 on 16/2/23.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PDLanYaLianJieDelegate <NSObject>

// 蓝牙是否打开
- (void)LanYaIsOpen:(BOOL)isOpen;
// 是否发现指定蓝牙设备
- (void)LanYaFindDiverceNameIsSuccess:(BOOL)isSuccess;
// 指定蓝牙设备是否连接成功
- (void)LanYaLianJieIsSuccess:(BOOL)isSuccess;
// 接收到数据
- (void)LanYaReceiveMessegeData:(NSData *)data;

@optional
// 信号强度
- (void)LanYaXinHaoQiangDu:(NSNumber *)xinC;

@end

@interface PDLanYaLianJie : NSObject

@property (nonatomic, assign) id <PDLanYaLianJieDelegate> pdDelegate;
@property (nonatomic, strong) NSString * deviceName;
@property (nonatomic, assign) BOOL lanYaStatus;

+ (instancetype)shareInstance;

// 开始蓝牙
- (void)beginBlueToothWithDiverceName:(NSString *)diverceName;

// 设置蓝牙连接服务名称和特性名称
- (void)linkLanYaDiverceBeginWithServiceName:(NSString *)serviceName writeCharacteristice:(NSString *)characterName andNotifyCharacteristice:(NSString *)notifyCharacteristice;

// 发送数据
- (void)sendMessegeWithData:(NSData *)data;

// 重新扫描
- (void)resameCanse;

- (void)deallocSharedLanYa;

// 开始测试蓝牙信号强度
- (void)cansaoXinHaoQiangduBegin;

@end
