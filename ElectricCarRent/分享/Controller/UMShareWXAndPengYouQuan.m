//
//  UMShareWXAndPengYouQuan.m
//  ElectricCarRent
//
//  Created by 程元杰 on 15/12/9.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "UMShareWXAndPengYouQuan.h"
#import "ECarConfigs.h"
#import "UIViewExt.h"
@implementation UMShareWXAndPengYouQuan

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatShareView];
        
    }
    return self;
}
-(void)creatShareView
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
    
    label.backgroundColor = GrayColor;
    
    [self addSubview:label];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame=CGRectMake(130/375.f*kScreenW, 20,kScreenW / 2.f, self.bounds.size.height);
    button.center = CGPointMake(kScreenW / 4.f, self.bounds.size.height / 2.f);
    
    [button setTitle:@"朋友圈" forState:UIControlStateNormal];
    [button setTitleColor:RedColor forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
//    [button setContentEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    [button setTitleColor:RedColor forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"fasongpengyouquan30*30"] forState:UIControlStateNormal];
    button.tag = 100;
    
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame=CGRectMake(210/375.f*kScreenW, 20, kScreenW / 2.f, self.bounds.size.height);
    button1.center = CGPointMake(kScreenW / 4.f * 3.f, self.bounds.size.height / 2.f);
    [button1 setTitleColor:RedColor forState:UIControlStateNormal];
    [button1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
//    [button1 setContentEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    [button1 setTitle:@"好友" forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"fenxianghaoyou30*30"] forState:UIControlStateNormal];
    
    button1.tag = 200;
    
    [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button1];
//    NSArray * array = @[@"朋友圈",@"好友"];
//    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake((120+i*90)/375.f*kScreenW, button.bottom-15, 60, 30)];
//    label1.text = array[i];
//    
//    label1.textColor = RedColor;
//    
//    [self addSubview:label1];
}

-(void)buttonAction:(UIButton*)button
{
    ECarConfigs *cong = [ECarConfigs shareInstance];
    if (button.tag == 200) {
        UIImage  * image  = [UIImage imageNamed:@"fenxiangtubiao"];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [UMSocialSnsService presentSnsIconSheetView:nil
                                             appKey:@"565fc9f367e58ebf8e0014ff"
                                          shareText:@"快快来下载"
                                          shareImage:data
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,nil]
                                           delegate:self];
        [ UMSocialData defaultData].extConfig.wechatSessionData.title = @"大梦科技";
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@car/paramConController/carorder/%@.do", ServerURL, cong.orignOrderNo];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"EZZY就是你的私家车！请放肆的驾驶！" image:data location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                
            } else {
                
            }
        }];
    } else {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = [NSString stringWithFormat:@"EZZY就是你的私家车！请放肆的驾驶！"];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@car/paramConController/carorder/%@.do", ServerURL, cong.orignOrderNo];
        [UMSocialSnsService presentSnsIconSheetView:nil
                                             appKey:@"565fc9f367e58ebf8e0014ff"
                                          shareText:@"sqAsq"
                                         shareImage:nil
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatTimeline,nil]
                                           delegate:self];
        UIImage  * image  = [UIImage imageNamed:@"fenxiangtubiao"];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:data
                                                           location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
                                                               
                                                           }];
    }
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess) {
        //得到分享到的微博平台名
        NSLog(@"分享成功");
    }
}
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    ECarConfigs *cong = [ECarConfigs shareInstance];
        socialData.extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@car/paramConController/carorder/%@.do", ServerURL, cong.orignOrderNo];//        socialData.urlResource.
        socialData.extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@car/paramConController/carorder/%@.do", ServerURL, cong.orignOrderNo];
}

@end
