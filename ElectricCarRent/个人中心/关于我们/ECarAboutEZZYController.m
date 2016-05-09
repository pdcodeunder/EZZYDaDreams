//
//  ECarAboutEZZYController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/3/29.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarAboutEZZYController.h"
#import "ECarLianxiwomenViewController.h"
#import "ECarMoviesPlayViewController.h"
#import "AddressBookViewController.h"
#import "ECarAboutUsController.h"

@interface ECarAboutEZZYController () <UIAlertViewDelegate>
@property(nonatomic, strong)NSArray * titleList;
@property(nonatomic, strong)UIImageView * listView;

@end

/**
 *  @"关于EZZY",
 @"观看视频",
 @"导入通讯录",
 @"联系我们"
 */
@implementation ECarAboutEZZYController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self setTitle:@"关于我们"];
    _titleList=@[@"EZZY",
                 @"观看视频",
                 @"导入通讯录",
                 @"联系我们"];
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
        label.font = FontType;
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
    switch (sender.tag) {
        case 0:
        {
            ECarAboutUsController *about = [[ECarAboutUsController alloc] init];
            [self.navigationController pushViewController:about animated:YES];
            break;
        }
        case 1:
        {
            ECarMoviesPlayViewController * movie = [[ECarMoviesPlayViewController alloc] init];
            [self.navigationController pushViewController:movie animated:YES];
            break;
        }
        case 2:
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否导入通讯录？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
            alert.tag = 456;
            [alert show];
            break;
        }
        case 3:
        {
            ECarLianxiwomenViewController * lianXi = [[ECarLianxiwomenViewController alloc] init];
            [self.navigationController pushViewController:lianXi animated:YES];
            break;
        }
            
        default:
            break;
    }
    
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 456) {
        if (buttonIndex == 0) {
            [self daoruTongXunLu];
        }
    }
    if (alertView.tag == 400) {
        if (buttonIndex == 0) {
            [ToolKit callTelephoneNumber:@"400-6507265" addView:self.view];
        }
    }
}

- (void)daoruTongXunLu
{
    ABAddressBookRef addressBooks = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        
    {
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        
        //获取通讯录权限
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    } else
        
    {
        addressBooks = ABAddressBookCreate();
    }
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    NSMutableArray * array = [NSMutableArray new];
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFTypeRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        // 取记录数量
        //        NSInteger phoneCount = ABMultiValueGetCount(phones);
        // 遍历所有的电话号码
        CFStringRef phoneNumber = ABMultiValueCopyValueAtIndex(phones, 0);
        NSString * name = [NSString stringWithFormat:@"%@", lastName];
        NSString * firstname = [NSString stringWithFormat:@"%@", firstName];
        NSString * phone = [NSString stringWithFormat:@"%@", phoneNumber];
        if (name !=nil && phone !=nil) {
            NSDictionary * dic = @{@"xing":name,@"name":firstname, @"phone":phone};
            [array addObject:dic];
        }
    }
    ECarConfigs * user=[ECarConfigs shareInstance];
    ECarUser * yj = user.user;
    ECarUserManager * usmanager = [ECarUserManager  new];
    NSDictionary * addressDic = [[NSDictionary alloc] initWithObjectsAndKeys:array, @"address", nil];
    NSData * data = [NSJSONSerialization dataWithJSONObject:addressDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[usmanager  userPhoneDataList:yj.user_id Data:str] subscribeNext:^(id x) {
        NSDictionary * dic = x;
        UIAlertView *serviceAlert = [[UIAlertView alloc] initWithTitle:@"恭喜您" message:dic[@"msg"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [serviceAlert show];
        
    }];
}

@end
