//
//  AddressBookViewController.m
//  ElectricCarRent
//
//  Created by 程元杰 on 15/12/2.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "AddressBookViewController.h"

@interface AddressBookViewController ()

@end

@implementation AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_personArray == nil) {
        _personArray = [NSMutableArray array];
    }
    //新建一个通讯录类
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
        //获取个人名字
//        CFStringRef firstNameLabel = ABPersonCopyLocalizedPropertyName(kABPersonFirstNameProperty);
//        CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
//        CFStringRef lastNameLabel = ABPersonCopyLocalizedPropertyName(kABPersonLastNameProperty);
        // 姓
        CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        // 取记录数量
//        NSInteger phoneCount = ABMultiValueGetCount(phones);
        // 遍历所有的电话号码
        CFStringRef phoneNumber = ABMultiValueCopyValueAtIndex(phones, 0);
        NSString * name = [NSString stringWithFormat:@"%@", lastName];
        NSString * phone = [NSString stringWithFormat:@"%@", phoneNumber];
        if (name !=nil && phone !=nil) {
            NSDictionary * dic = @{@"name":name, @"phone":phone};
            [array addObject:dic];
        }
    }

    ECarConfigs * user=[ECarConfigs shareInstance];
    ECarUser * yj = user.user;
    _manager = [ECarUserManager  new];
    NSDictionary * addressDic = [[NSDictionary alloc] initWithObjectsAndKeys:array, @"address", nil];
    NSData * data = [NSJSONSerialization dataWithJSONObject:addressDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[self.manager userPhoneDataList:yj.user_id Data:str] subscribeCompleted:^{
        
    }];
    
}

@end
