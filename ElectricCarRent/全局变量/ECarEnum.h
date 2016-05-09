//
//  ECarEnum.h
//  ElectricCarRent
//
//  Created by LIKUN on 15/8/27.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#ifndef ElectricCarRent_ECarEnum_h
#define ElectricCarRent_ECarEnum_h

typedef NS_ENUM(NSInteger, ECarDestinationViewType){
    ECarDestinationViewTypeDefault = 1,   /**<默认样式*/
    ECarDestinationViewTypeHome,           /**<有家地址样式*/
    ECarDestinationViewTypeCompany,     /**<有公司地址样式*/
    ECarDestinationViewTypeComplete,    /**<有公司和家地址样式*/
};

typedef NS_ENUM(NSInteger, TravelTypes)
{
    TravelTypeCar = 0,      // 驾车方式
    TravelTypeWalk,         // 步行方式
};

typedef enum : NSUInteger {
    NavManagerTravelTypeDefault = 0,
    NavManagerTravelTypeDring = 1 << 0,
    NavManagerTravelTypeWalk = 1 << 1,
} NavManagerTravelType;

typedef NS_ENUM(NSInteger, NavigationTypes)
{
    NavigationTypeNone = 0,
    NavigationTypeSimulator, // 模拟导航
    NavigationTypeGPS,       // 实时导航
};

typedef NS_ENUM(NSInteger, UploadPictureTypes)
{
    UploadPictureTypesIDCardUp = 0,   /**<身份证正面*/
    UploadPictureTypesIDCardBack = 1, /**<身份证反面*/
    UploadPictureTypesDriveCardUp = 2,       /**<驾驶证正面*/
    UploadPictureTypesDriveCardBack = 3,       /**<驾驶证反面*/
    UploadPictureTypesSelfieUp = 4,       /**<手持身份证正面*/
    UploadPictureTypesSelfieBack = 5,       /**<手持身份证反面*/
};

typedef NS_ENUM(NSInteger, ExitNaviTag)
{
    ExitNaviTagOpenLockSuccess = 1,
    ExitNaviTagEnd = 2,
    ExitNaviTagOther,
};

typedef NS_ENUM(NSInteger, UserInfoStatus)
{
    UserInfoStatusNull = 0,   /**<未提交审核*/
    UserInfoStatusReviewing = 1,       /**<待审核*/
    UserInfoStatusNormal = 2, /**<审核通过*/
    UserInfoStatusRefused = 3,       /**<审核未通过*/
    UserInfoStatusLocked = 4,       /**<锁定*/
};

typedef NS_ENUM(NSInteger, UserBaseInfoStatus)
{
    UserBaseInfoStatusNull = 0,   /**<信息不完整*/
    UserBaseInfoStatusNormal , /**<审核通过*/
    UserBaseInfoStatusReviewing,       /**<审核中*/
    UserBaseInfoStatusRefused,       /**<审核未通过*/
};

typedef NS_ENUM(NSInteger, UserPhotoInfoStatus)
{
    UserPhotoInfoStatusNull = 0,   /**<信息不完整*/
    UserPhotoInfoStatusReviewing,       /**<审核中*/
    UserPhotoInfoStatusNormal , /**<审核通过*/
    UserPhotoInfoStatusRefused,       /**<审核未通过*/
};

typedef NS_ENUM(NSInteger, UserPayInfoStatus)
{
    UserPayInfoStatusNull = 0,   /**<信息不完整*/
    UserPayInfoStatusNormal , /**<审核通过*/
    UserPayInfoStatusReviewing,       /**<审核中*/
    UserPayInfoStatusRefused,       /**<审核未通过*/
};

typedef NS_ENUM(NSInteger, LinkStep)
{
    LinkStepBeginFindCar = 0,
    LinkStepFindedCar,
    LinkStepUseCar,
    LinkStepUsingChangeCar,
    LinkStepEnd,
};

typedef NS_ENUM(NSInteger, FindCarType)
{
    FindCarTypeNormal = 0,
    FindCarTypeChange,
};

typedef NS_ENUM(NSInteger, OrderLinkType)
{
    OrderLinkTypeFindCar = 0,
    OrderLinkTypeUseCar,
};

typedef NS_ENUM(NSInteger, OrderLinkStatue)
{
    OrderLinkStatueCreate = 0,
    OrderLinkStatueFindCar,
    OrderLinkStatueFindCarChange,
    OrderLinkStatueUseCar,
    OrderLinkStatueUseCarChange,
    OrderLinkStatueFinish,
    OrderLinkStatueCancel,
};

typedef enum : NSUInteger {
    sendToHouTaiByVip = 500,  // 从vip中进入
    sendToHouTaiByDingdan     // 单次优惠码
} sendToHouTaiType;

#endif
