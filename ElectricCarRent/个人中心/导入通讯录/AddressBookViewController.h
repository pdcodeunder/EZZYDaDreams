//
//  AddressBookViewController.h
//  ElectricCarRent
//
//  Created by 程元杰 on 15/12/2.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarBaseViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "ECarConfigs.h"
#import "KKHttpServices.h"
#import "ECarMapManager.h"
#import "ECarUserManager.h"

@interface AddressBookViewController : ECarBaseViewController
{
    
    NSInteger _sectionNumber;
    NSInteger _recordID;
    NSString *_name;
    NSString *_email;
    NSString *_tel;
    NSMutableArray *_addressBookTemp;
    
}
@property (nonatomic, copy) NSMutableArray *personArray;
@property (nonatomic, copy)NSMutableArray * phoneList;
@property (nonatomic, copy)NSMutableArray * nameList;
@property (nonatomic, strong) ECarUserManager * manager;
@end
