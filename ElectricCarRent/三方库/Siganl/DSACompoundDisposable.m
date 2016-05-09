//
//  DSACompoundDisposable.m
//  MVVMDemo
//
//  Created by 汪亚强 on 15-1-28.
//  Copyright (c) 2015年 bitcar. All rights reserved.
//

#import "DSACompoundDisposable.h"
@interface DSACompoundDisposable()
@end
@implementation DSACompoundDisposable
+ (instancetype)compoundDisposable {
    return[[self alloc] initWithDisposables:nil];
}
- (id)initWithDisposables:(NSArray *)otherDisposables {
    self = [self init];
    if (self == nil) return nil;
    self.disposablesArray=[NSMutableArray arrayWithCapacity:0];

    
    return self;
}

- (void)dispose {
    while (self.disposablesArray.count>0) {
        DSADisposable *dispose=[self.disposablesArray firstObject];
        if ([dispose isKindOfClass:[DSADisposable class]]) {
          [dispose dispose];  
        }
        
        [self.disposablesArray removeObject:dispose];
    }
}
-(void)dealloc
{
}
@end
