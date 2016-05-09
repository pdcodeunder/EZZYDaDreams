
//  CarSeniorityViewController.m
//  ElectricCarRent
//
//  Created by 程元杰 on 15/11/26.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "CarSeniorityViewController.h"

@interface CarSeniorityViewController ()

@end

@implementation CarSeniorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    
    [self creatWeb];
   
//    _titleList = @[@"用车资质",@"乘车技巧",@"计费规则",@"违章扣款",@"",@"常见问题"];
//     _textFile = [[UITextView alloc] initWithFrame: CGRectMake(0, 64, kScreenW, kScreenH-64)];
//    self.title=_titleList[_index];
//    _arrayList = @[@"使用EZZY的汽车，需要具备以下条件:\n1.	用户需要登录并填写完整认证信息之后方能正常预定和使用EZZY的车辆，认证信息包括一张信用卡和本人有效的驾驶证。\n2.	用户的驾驶证需要在有效期内并且能够准驾自动挡车型，没有被吊销、没收、失效或以其他方式作废，如果驾驶证在任何时间被吊销、没收，失效或其状态发生变化，用户必须立即通知客服，用户将不被批准使用或者预定任何EZZY车辆。",
//                   @"1.	 登录/填写完整的认证信息\n用户需要登录并填写完整的认证信息之后方能正常预定和使用EZZY的车辆，没有填写完整认证信息，只能浏览APP首页，不能预定使用车辆。\n2.	 搜索/预定车辆\n用户可以在APP首页查看附近车辆，输入目的地之后，系统会根据目的地信息为用户匹配满足续航能力的车辆；用户查看车辆之后，可以从中选出满意的车辆进行预定。\n3.	 找车/开锁\n成功预定车辆之后，用户有30分钟的时间根据地图导航去找目标车辆。找车过程中，用户可以查看目标车辆周围的全景视图；近车范围内，用户可以通过APP上的“闪/鸣”按钮来控制车辆的双闪和鸣笛，以更便捷地找到车辆；用户确认找到目标车辆，可以通过APP上的“开锁”按钮，打开车辆的中控锁。\n4.	 开车到达目的地\n开锁之后，用户就可以打开车门上车，关上车门之后就可以启动引擎了，接下来，您就可以开着我们“EZZY”的车辆去往您想去的地方了。\n5.	 结束用车\n到达目的地之后，用户需要关闭车辆引擎，点击APP上的“结束用车”按钮，进入结算页面，按照金额进行结算就可以完成订单了。",
//                   @"用户开锁之后开始计时，到启动引擎之前有5分钟的免费调整时间，如果5分钟之内启动引擎，从启动引擎开始计费，若开锁之后5分钟还没有启动引擎，从5分钟开始计费，计费规则如下：\n\n支付费用=起步价+里程费+低速费\n\n起步价：30元\n里程费：1.5元/公里，每0.1公里结算\n低速费：车速低于12公里/小时， 1元/分钟（高峰时间段，早7点~10点，晚5点~8点）， 0.6元/分钟（其他非高峰时间段）",
//                   @"北京大梦科技有限公司在收到交警或城管对车辆的违章通知后，会马上进行用户确认。在确认该违章在用户的用车时间段内的情况下，大梦科技将立即通过电话通知用户，用户在接到大梦科技的通知后，可以选择以下三种方式进行处理（若用户在接到电话通知7天之内没有选择①或者②，将视为选择③自动委托大梦科技处理违章事宜）\n①客户在接到电话通知7天内到交管部门自行处理，处理后告知我们并将有关单据寄大梦科技。\n②客户在接到电话通知7天内将驾驶执照寄送至大梦科技，由大梦科技代为处理，在此情况下，客户需支付：违章罚款相应的金额、违章代办服务费每单150元、驾驶执照寄往大梦科技的费用（驾照寄还的费用由大梦科技承担）。\n③客户也可委托大梦科技全权处理违章，客户需支付违章罚款、违章代办服务费（每个罚单150元代办费用，如有扣分情况另加每分300元费用），对于吊销驾照或单次违章扣分6分及以上的严重交通违法行为，大梦科技不接受委托处理。",
//                   @"",
//                   @"在找车导航页面，导航路线不更新了，怎么办？\n\n如果根据找车导航，您走到地下车库入口或者其他GPS信号不是很好的地方，导航路线不更新了，若此时APP上的“鸣笛”按钮可用，您可以通过鸣笛和双闪快速找到目标车辆；若此时APP上的“鸣笛”按钮还不可用，您可以尝试继续朝更接近目标车辆的方向走，直至APP上的“鸣笛”按钮可以用。\n\n开锁后，为什么打不开车门？\n\n开锁后，如果打不开车门，可能有以下几种原因：\n1.	点击APP上的“开锁”按钮后，系统需要大概3~5s的时间才能打开车锁，并且会伴随车辆的一声鸣笛声，所以用户点击APP上的“开锁”按钮后，需要稍等片刻才能打开车门。\n2.	为了保证车辆的安全，用户点击APP上的“开锁”按钮后，需要在30s内打开车门，如果30s内车门没有被打开，会重新落锁，请尝试重新点击APP上的“开锁”按钮，打开车门。\n3.	如果您遇到的情况不属于以上所列情况，请拨打APP上的“联系客服”按钮。\n\n结束用车后，我还能继续使用这辆车吗？\n\n点击APP上的“结束用车”按钮后，您对这辆车的使用权限将被收回，如果您想继续使用“EZZY”的车辆，请您重新预定车辆。\n\n为什么我不能结束用车？\n\n结束用车的流程：关闭引擎→关门→结束用车。\n结束用车前请确认引擎已经关闭\n如果引擎已经关闭，仍不能结束用车，请联系我们的客服。\n\n离开车辆后，突然发现有物品遗漏在车辆上，怎么办？\n\n我们会为每位使用“EZZY”的用户，预留15分钟的车辆“等待”时间，在这15分钟内，您使用的车辆不会被其他用户预定和使用，如果您发现有物品遗漏在车辆上，请拔打我们的客服电话，我们的客服将会为您远程打开车锁，以便您取回遗漏的物品。\n\n用完车后忘记关门关锁了，怎么办？\n\n万一您忘记关门关锁了，没关系，我们赋予用户忘记的权利。您忘记的，我们远程都可以帮您做到：远程关门，远程关中控锁。\n\n我预定的车辆可以借给其他人开吗？\n\n不可以，用户使用APP预定车辆，车辆的开锁，结束用车也需要通过APP操作，如果您把车借给其他人开，发生额外的费用或者发生车辆被盗，车辆事故等，保险公司将不予理赔，一切额外的费用和损失将由您个人承当。\n\n用车期间发生车辆故障了怎么办？\n\n用车期间发生事故了怎么办？\n用车期间如果发生事故，在保障人身安全的情况下，请您务必第一时间保留现场证据，并通知“大梦科技”客服，进行报备；发生车辆事故，大梦科技提供道路救援，用车期间的额外保险，以保障用户在租车期间的事故现场处理和理赔。\n\n道路救援产生的费用由谁承担？\n\n对于车辆本身故障引起的救援，费用由“大梦科技”承担；非车辆本身故障导致车辆无法正常行驶时（包含且不限于认为操作失误、保险事故等），费用由用户自行承担。"];
//    
//    _textFile.font = [UIFont systemFontOfSize:14];
//    [self.view addSubview:_textFile];
//    [self creatText];
//    
//    _textFile.editable=NO;
//    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle};
//    paragraphStyle.lineSpacing=3.5;
//    _textFile.attributedText = [[NSAttributedString alloc]initWithString:_textFile.text attributes:attributes];
}

//- (void)creatText
//{
// 
//    _textFile.text = _arrayList[_index];
//    
//}

- (void)creatWeb{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    webView.scalesPageToFit = YES;
    webView.backgroundColor = WhiteColor;
    [self.view addSubview:webView];
    NSURL * url = [NSURL URLWithString:self.webUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

@end
