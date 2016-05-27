//
//  EZZYBuyMemberViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/4/14.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "EZZYBuyMemberViewController.h"
#import "EZZYMemberZhiFuViewController.h"
#import "EZZYMemberModle.h"
#import "ECarConfigs.h"
#import "ECarUserManager.h"
#import "EZZYOnSaleMemberModel.h"
#import "EZZYBuyMemberTableViewCell.h"
#import "YLLabel.h"

@interface EZZYBuyMemberViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) EZZYMemberModle *modle;
@property (nonatomic, strong) ECarUserManager *useManager;
@property (nonatomic, strong) EZZYOnSaleMemberModel *selectedModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *textViewd;

@end

@implementation EZZYBuyMemberViewController

- (ECarUserManager *)useManager
{
    if (!_useManager) {
        _useManager = [[ECarUserManager alloc] init];
    }
    return _useManager;
}

- (instancetype)initWithBuyMemberModel:(EZZYMemberModle *)modle
{
    if (self = [super init]) {
        self.modle = modle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.selectedModel = [self.modle.subModels objectAtIndex:0];
    self.title = self.modle.levelName;
    [self createMemberUI];
}

- (void)createMemberUI
{
    // 添加会员文案描述
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 100 / 667.f * kScreenH)];
    textView.font = FontType;
    textView.backgroundColor = [UIColor clearColor];
    CGSize size = [ToolKit getSizeByFont:FontType labelWidth:kScreenW - 45 message:self.modle.note];
    textView.height = size.height + 10 * (size.height / (15 / 667.0 * kScreenH)) + 110;
    textView.selectable = NO;
    textView.editable = NO;
    textView.text = self.modle.note;
    // 添加间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:FontType,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    textView.textContainerInset = UIEdgeInsetsMake(55, 20, 0, 20);
    self.textViewd = textView;
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64 - 49) style:UITableViewStylePlain];
    table.backgroundView.backgroundColor = WhiteColor;
    table.backgroundColor = WhiteColor;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 2)];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    self.tableView = table;
    
    // 购买按钮
    UIButton * buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setTitleColor:[UIColor colorWithRed:224/255.0f green:54/255.0f blue:134/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [buyBtn setTitle:@"购买" forState:UIControlStateNormal];
    buyBtn.titleLabel.font = FontType;
    buyBtn.frame = CGRectMake(0, kScreenH - 49, kScreenW, 49);
    [buyBtn addTarget:self action:@selector(buyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyBtn];
    
    // 添加下面的线
    UIView * lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - 49, kScreenW , 1)];
    lineView1.backgroundColor = [UIColor colorWithRed:197 / 255.0 green:197/255.0 blue:197/255.0 alpha:1.0];
    [self.view addSubview:lineView1];
}

- (void)buyBtnAction:(UIButton *)sender
{
    [self showHUD:@"请稍等..."];
    weak_Self(self);
    EZZYMemberZhiFuViewController * zhifuVC = [[EZZYMemberZhiFuViewController alloc] init];
    [[self.useManager creatOrderByRenyuanID:[ECarConfigs shareInstance].user.phone vipType:self.selectedModel.levelCode lastNum:@"10"] subscribeNext:^(id x) {
        [weakSelf hideHUD];
        NSDictionary * dic = x;
        NSString * success = [NSString stringWithFormat:@"%@", dic[@"success"]];
        if (success.boolValue == 0) {
            NSString * msg = [NSString stringWithFormat:@"%@", dic[@"msg"]];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        NSDictionary * dictx = dic[@"obj"];
        ECarConfigs * config = [ECarConfigs shareInstance];
        config.orignOrderNo = [NSString stringWithFormat:@"%@", [dictx objectForKey:@"orderId"]];
        config.currentPrice = [NSString stringWithFormat:@"%.2lf", weakSelf.selectedModel.xianjia.floatValue];
        zhifuVC.priceUnit = @"元";
        [self.navigationController pushViewController:zhifuVC animated:YES];
    } error:^(NSError *error) {
        [weakSelf delayHidHUD:MESSAGE_NoNetwork];
    }];
}

// tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modle.subModels.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.modle.subModels.count) {
        return 55 / 667.0 * kScreenH;
    }
    return self.textViewd.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.modle.subModels.count) {
        EZZYBuyMemberTableViewCell *cell = [EZZYBuyMemberTableViewCell createTableViewCellWithTableView:tableView];
        EZZYOnSaleMemberModel *onSaleModel = [self.modle.subModels objectAtIndex:indexPath.row];
        [cell refreshCellViewWithModel:onSaleModel];
        if (onSaleModel == self.selectedModel) {
            cell.selectStatus = YES;
        } else {
            cell.selectStatus = NO;
        }
        return cell;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"efddsadsdaffdsaf"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"efddsadsdaffdsaf"];
        cell.contentView.backgroundColor = WhiteColor;
        cell.backgroundColor = WhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.contentView addSubview:self.textViewd];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row < self.modle.subModels.count) {
        EZZYOnSaleMemberModel *onSaleModel = [self.modle.subModels objectAtIndex:indexPath.row];
        self.selectedModel = onSaleModel;
        [tableView reloadData];
    }
}

@end
