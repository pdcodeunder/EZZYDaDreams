//
//  KKFileManager.h
//  ElectricCarRent
//
//  Created by LIKUN on 15/9/23.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKFileManager : NSObject
+ (instancetype)shareInstance;
/**
 *  documents
 *
 *  @return 路径
 */
-(NSString *)dirDoc;
-(NSString *)createDirWithPath:(NSString *)path;
-(NSString *)createFileWithPath:(NSString *)path;
-(BOOL)writeFilePath:(NSString *)path data:(NSData *)data;
@end
