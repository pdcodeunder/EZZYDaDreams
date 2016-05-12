//
//  EZZYNetworkingService.h
//  ElectricCarRent
//
//  Created by 彭懂 on 16/5/12.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#ifndef EZZYNetworkingService_h
#define EZZYNetworkingService_h

/**
 *  网络接口名称
 */

/**
 *  用户接口 userManager
 */
// 保存图片
#define kServePickter       @"car/pictureController.do?save"

// 获取图片信息
#define kGetPickterInfo     @"car/pictureController.do?getPicture"

// 更新用户基本信息
#define kUpdateUserInfo     @"car/tCMemberController.do?doUpdateInfo"

// 刷新用户信息
#define kRefreshUserInfo    @"car/tCMemberController.do?getMember2"

// 上传图片
#define kUpdatePickterInfo  @"car/tCMemberController.do?uploadPicCarno"

// 更新支付信息
#define kUpdateZhiFuInfo    @"car/tCMemberController.do?doUpdateInfo"

// 提交审核
#define kSubmitCheckInfo    @"car/tCMemberController.do?changeAudit"

// 首次导入通讯录
#define kFirstSubmitPNumber @"car/tCAddressBookController.do?checkIsFirstImport"

// 导入通讯录
#define kSubmitPhoneNumber  @"car/tCAddressBookController.do?addressList"

// 会员邀请码
#define kMumberMianFeiCode  @"car/tCemberVipController.do?changeVipByFree"

// 单次优惠码
#define kOnceYouHuiCode     @"car/tCOrderController.do?userUseOnceFreeCode"

// 获取会员信息
#define kMumberInfo         @"car/tCemberVipController.do?checkUserVipState"    // 以前的
#define kGetMumberInfo      @"car/tVipAppController.do?getUerVipInformation"    // 现用的

// 点击购买会员接口
#define kBuyMember          @"car/tCemberVipController.do?doBuyVipOrAdd"        // 以前的
#define kGetBuyMemberOrder  @"car/tVipAppController.do?BuyVipOrder"             // 现用的

// 视频列表
#define kMoveList           @"car/paramConController.do?getVideoList"

// 关于我们
#define kAboutUs            @"car/paramConController.do?getGywm"

// 联系我们
#define kConnectionUs       @"car/paramConController.do?getLxwm"

// 会员到期提醒
#define kMemberDaoQi        @"car/tCemberVipController.do?vipCountDown"

// 行程发票列表
#define kXingChengFaPList   @"car/appReceiptController.do?getOrderReceipt"

// 购买会员发票列表
#define kBuyMemberFaPiao    @"car/appReceiptController.do?getVIPOrderReceipt"

// 提交行程发票
#define kSubmitXCFP         @"car/appReceiptController.do?getOrderReceiptOrder"

// 提交会员发票
#define kSubmitVIPFA        @"car/appReceiptController.do?getVipOrderReceiptOrder"

// 行程开票历史
#define kXingChengKPStory   @"car/appReceiptController.do?getOrderReceiptList"

// 购买会员开票历史
#define kBuyMemberKPHistory @"car/appReceiptController.do?getVipOrderReceiptList"

// 违章自行处理
#define kWeiZhangZiChuLi    @"car/tcpeccancyController.do?toProcessed"

// 违章处理说明
#define kWeiZhangShuoMing   @"car/tcpeccancyController.do?getProcessedExplain"

// 行程说明
#define kXingChengShuoMing  @"car/appReceiptController.do?getinvoiveexplain"



#pragma mark - 用车流程接口
/**
 *  用车流程接口  mapManager
 */



#endif /* EZZYNetworkingService_h */
