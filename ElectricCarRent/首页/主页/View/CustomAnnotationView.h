//
//  CustomAnnotationView.h
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <AMapNaviKit/MAMapKit.h>
#import "ECarCarInfo.h"
#import "ECarMapManager.h"

typedef void(^HiddenDetailView)();
typedef void(^SalceMapView)(CLLocationCoordinate2D coordinate);
@interface CustomAnnotationView : MAPinAnnotationView<UIAlertViewDelegate>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIImage *portrait;
@property (nonatomic, strong) UIView *calloutView;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic,strong) id carDataModel;     /**<车信息的数据模型*/
@property (nonatomic, strong) ECarMapManager *manager;
typedef void (^BookCarBtnBlock)(id model);
@property (copy, nonatomic) BookCarBtnBlock bookCarBlock;
@property (nonatomic, copy) HiddenDetailView hiddenDetailView;
@property (nonatomic, assign) NSInteger annotationCount;
@property (nonatomic, assign) NSInteger sigleCount;
@property (nonatomic, copy) SalceMapView salceMapView;

@end
