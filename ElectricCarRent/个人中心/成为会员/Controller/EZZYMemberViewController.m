//
//  EZZYMemberViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/4/11.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "EZZYMemberViewController.h"
#import "ECarConfigs.h"
#import "ECarUserManager.h"
#import "EZZYMemberModle.h"
#import "EZZYMemberTableViewCell.h"
#import "EZZYBuyMemberViewController.h"
#import "ECarXianXingMemberViewController.h"

@interface EZZYMemberViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourse;
@property (nonatomic, strong) UITextView *ztLabel;
@property (nonatomic, strong) ECarUserManager * manage;
@property (nonatomic, strong) ECarConfigs *configs;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation EZZYMemberViewController

- (UITextView *)ztLabel
{
    if (!_ztLabel) {
        _ztLabel = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 15, 90 / 667.f * kScreenH)];
        _ztLabel.backgroundColor = WhiteColor;
        _ztLabel.editable = NO;
        _ztLabel.scrollEnabled = NO;
        _ztLabel.font = FontType;
        _ztLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _ztLabel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = WhiteColor;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (NSMutableArray *)dataSourse
{
    if (!_dataSourse) {
        _dataSourse = [[NSMutableArray alloc] init];
    }
    return _dataSourse;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_tableView) {
        [self createSourseData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isFirst = YES;
    _manage = [[ECarUserManager alloc] init];
    self.title = @"成为会员";
    [self createTableView];
    [self createSourseData];
}

- (void)createTableView
{
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(5 / 375.f * kScreenW, 0, kScreenW - 20 / 375.f * kScreenW, 1)];
//    bottomView.backgroundColor = GrayColor;
//    [self.ztLabel addSubview:bottomView];
    
    self.tableView.tableFooterView = self.ztLabel;
    [self.view addSubview:self.tableView];
}

- (void)createSourseData
{
    weak_Self(self);
    [weakSelf showHUD:@"加载中..."];
    _configs = [[ECarConfigs alloc] init];
    [[_manage getAllMemberInfoByPhone:_configs.user.phone] subscribeNext:^(id x) {
        [weakSelf hideHUD];
        NSDictionary * dic = x;
        
        NSString * success = [NSString stringWithFormat:@"%@", dic[@"success"]];
        if (success.boolValue == 0) {
            NSString * msg = [NSString stringWithFormat:@"%@", dic[@"msg"]];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        NSArray *obj = dic[@"obj"];
        [weakSelf.dataSourse removeAllObjects];
        if (obj.count != 0) {
            for (NSDictionary *level in obj) {
                if ([[NSString stringWithFormat:@"%@", level[@"levelCode"]] isEqualToString:@"20160218004"]) {
                    continue;
                }
                EZZYMemberModle *model = [[EZZYMemberModle alloc] initWithDictionary:level];
                [weakSelf.dataSourse addObject:model];
            }
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 10 / 667.0 *kScreenH;// 字体的行间距
            NSDictionary *attributes = @{
                                         NSFontAttributeName: FontType,
                                         NSParagraphStyleAttributeName: paragraphStyle
                                         };
            NSString * ztText = [NSString stringWithFormat:@"%@", dic[@"phoneMsg"]];
            _ztLabel.attributedText = [[NSAttributedString alloc] initWithString:ztText attributes:attributes];
            CGSize size = [ztText boundingRectWithSize:CGSizeMake(kScreenW - 30, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: FontType} context:nil].size;
            if (_isFirst == YES) {
                weakSelf.ztLabel.bounds = CGRectMake(0, 0, kScreenW - 15, kScreenH - 64 - obj.count * 90.0 / 667.0 * kScreenH);
                _ztLabel.textContainerInset = UIEdgeInsetsMake((weakSelf.ztLabel.height - size.height) / 2.0 - 10, 0, 0, 15);
                _isFirst = NO;
            }
            _ztLabel.textColor = RedColor;
        }
        [weakSelf.tableView reloadData];
    } error:^(NSError *error) {
        [weakSelf hideHUD];
        [weakSelf delayHidHUD:MESSAGE_NoNetwork];
    } completed:^{
        
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourse.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80 / 667.f * kScreenH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZZYMemberTableViewCell *cell = [EZZYMemberTableViewCell createTableViewCellWithTableView:tableView];
    EZZYMemberModle *modle = [self.dataSourse objectAtIndex:indexPath.row];
    [cell refreshViewWithModel:modle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZZYMemberModle *modle = [self.dataSourse objectAtIndex:indexPath.row];
    if ([modle.levelCode isEqualToString:@"20160218003"]) {
        ECarXianXingMemberViewController *xianXing = [[ECarXianXingMemberViewController alloc] initWithXianXingModel:modle];
        [self.navigationController pushViewController:xianXing animated:YES];
    } else {
        EZZYBuyMemberViewController *buyMem = [[EZZYBuyMemberViewController alloc] initWithBuyMemberModel:modle];
        [self.navigationController pushViewController:buyMem animated:YES];
    }
}

@end
