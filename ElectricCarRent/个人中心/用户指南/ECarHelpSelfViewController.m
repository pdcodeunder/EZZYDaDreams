//
//  ECarHelpSelfViewController.m
//  ElectricCarRent
//
//  Created by 程元杰 on 15/12/7.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarHelpSelfViewController.h"
#import "CarSeniorityViewController.h"


@interface ECarHelpSelfViewController () <UIAlertViewDelegate>

@property (nonatomic ,strong)NSArray * webArr;

@end

@implementation ECarHelpSelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    乘车技巧  http://www.dreamers-makers.com:9888/car/AppWeb/cejq.html
//    常见问题 http://www.dreamers-makers.com:9888/car/AppWeb/cjwt.html
//    法律声明 http://www.dreamers-makers.com:9888/car/AppWeb/fltl.html
//    计费规则 http://www.dreamers-makers.com:9888/car/AppWeb/jfgz.html
//    违章扣款 http://www.dreamers-makers.com:9888/car/AppWeb/wzkk.html
//    用车资质 http://www.dreamers-makers.com:9888/car/AppWeb/yczz.html
    self.view.backgroundColor = WhiteColor;
    [self setTitle:@"用户指南"];
    _titleList=@[@"用车资质",
                 @"乘车技巧",
                 @"计费规则",
                 @"违章扣款",
                 @"用户协议及法律条款",
                 @"常见问题"];
    _webArr = @[[NSString stringWithFormat:@"%@car/AppWeb/yczz.html", ServerURL],
                [NSString stringWithFormat:@"%@car/AppWeb/cejq.html", ServerURL],
                [NSString stringWithFormat:@"%@car/AppWeb/jfgz.html", ServerURL],
                [NSString stringWithFormat:@"%@car/AppWeb/wzkk.html", ServerURL],
                [NSString stringWithFormat:@"%@car/AppWeb/fltl.html", ServerURL],
                [NSString stringWithFormat:@"%@car/AppWeb/cjwt.html", ServerURL]
                ];
    [self creatListCell];
}
-(void)creatListCell
{
    int i;
    for (i = 0; i < _titleList.count; i++) {
        
        _listView = [[UIImageView alloc] initWithFrame:CGRectMake(20/375.f*kScreenW, 64+i*55, kScreenW-40, 55)];
        _listView.image = [UIImage imageNamed:@"kuang337*55"];
        _listView.userInteractionEnabled = YES;
        
        UILabel *  label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 55)];
        label.text  = _titleList[i];
        label.font = [UIFont systemFontOfSize:14];
        [_listView addSubview:label];
        
        UIButton * pushButton =[ UIButton buttonWithType:UIButtonTypeCustom];
        pushButton.frame =  CGRectMake(0, 0, kScreenW - 40, 55) ;
        [pushButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        pushButton.tag = i;
        [_listView addSubview:pushButton];
        
        [self.view addSubview:_listView];
    }
}
-(void)buttonAction:(UIButton * )sender
{
    CarSeniorityViewController * vc = [[CarSeniorityViewController alloc]init];
    
    vc.webUrl = _webArr[(int)sender.tag];
    vc.title = _titleList[(int)sender.tag];
    
    [self.navigationController pushViewController:vc animated: YES];
    
//    if (sender.tag == 4) {
//        
//        ECarRuleViewController *vc = StoryBoardViewController(@"ECarLogin", @"ECarRuleViewController");
//        [self.navigationController pushViewController:vc animated:YES];
//    } else {
//        
//        CarSeniorityViewController * senniVC = [[CarSeniorityViewController alloc] init];
//        
//        senniVC.index = (int)sender.tag;
//        
//        [self.navigationController pushViewController:senniVC animated: YES];
//    }
}

@end
