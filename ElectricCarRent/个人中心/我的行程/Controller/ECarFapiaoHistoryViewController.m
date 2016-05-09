//
//  ECarFapiaoHistoryViewController.m
//  ElectricCarRent
//
//  Created by 张钊 on 16/3/30.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarFapiaoHistoryViewController.h"
#import "ECarFapiaoHistoryTableViewCell.h"
#import "ECarFapiaoHistoryDetailViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "ECarConfigs.h"
#import "ECarUserManager.h"
#import "ECarFapiaoHistoryModel.h"


@interface ECarFapiaoHistoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) UIButton * btnLeft;
@property (nonatomic, strong) UIButton * btnRight;
@property (nonatomic, strong) UILabel * labelLeft;
@property (nonatomic, strong) UILabel * labelRight;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) ECarUserManager * zzManager;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, strong) MBProgressHUD * hud;

@end

@implementation ECarFapiaoHistoryViewController

#pragma mark lazyLoad

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
    }
    return _label;
}

- (UILabel *)labelLeft{
    if (!_labelLeft) {
        _labelLeft = [[UILabel alloc]init];
    }
    return _labelLeft;
}

- (UILabel *)labelRight{
    if (!_labelRight) {
        _labelRight = [[UILabel alloc]init];
    }
    return _labelRight;
}

- (UIButton *)btnLeft{
    if (!_btnLeft) {
        _btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _btnLeft;
}

- (UIButton *)btnRight{
    if (!_btnRight) {
        _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _btnRight;
}

- (instancetype)initWithTyep:(ECarHistoryType)type
{
    self = [super init];
    if (self) {
        self.historyType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"开票历史";
    self.view.backgroundColor = WhiteColor;
    _page = 0;
    _type = @"0";
    _zzManager = [ECarUserManager new];
    
    [self creatUI];
}

#pragma mark UI
- (void)creatUI{
    self.btnLeft.frame = CGRectMake(0, 64, kScreenW / 2, 58 / 667.0f * kScreenH);
    self.btnLeft.tag = 200;
    [self.btnLeft addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.labelLeft.frame = CGRectMake(0, 0, kScreenW / 2, 58 / 667.0f * kScreenH);
    self.labelLeft.text = @"待邮寄";
    self.labelLeft.font = [UIFont systemFontOfSize:14.0f];
    self.labelLeft.textColor = RedColor;
    self.labelLeft.textAlignment = NSTextAlignmentCenter;
    [self.btnLeft addSubview:self.labelLeft];
    [self.view addSubview:self.btnLeft];
    
    self.btnRight.frame = CGRectMake(kScreenW / 2, 64, kScreenW / 2, 58 / 667.0f * kScreenH);
    self.btnRight.tag = 201;
    [self.btnRight addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.labelRight.frame = CGRectMake(0, 0, kScreenW / 2, 58 / 667.0f * kScreenH);
    self.labelRight.text = @"已寄出";
    self.labelRight.font = [UIFont systemFontOfSize:14.0f];
    self.labelRight.textAlignment = NSTextAlignmentCenter;
    [self.btnRight addSubview:self.labelRight];
    [self.view addSubview:self.btnRight];
    
    self.label.frame = CGRectMake(kScreenW / 4 - 25 / 375.f * kScreenW, CGRectGetMaxY(_btnRight.frame), 50 / 375.f * kScreenW, 2);
    self.label.backgroundColor = RedColor;
    [self.view addSubview:self.label];
    
    [self creatTableView];
}

- (void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_btnRight.frame) + 2, kScreenW, kScreenH - CGRectGetMaxY(_btnRight.frame) - 1) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = WhiteColor;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self setupRefresh];
    [self.view addSubview:_tableView];
}

#pragma mark btnAction

- (void)btnAction:(UIButton *)btn{
    if (btn.tag == 200) {
        [UIView animateWithDuration:0.5 animations:^{
            self.label.frame = CGRectMake(kScreenW / 4 - 25 / 375.f * kScreenW, CGRectGetMaxY(_btnRight.frame), 50 / 375.f * kScreenW, 2);
        }];
        self.labelLeft.textColor = RedColor;
        self.labelRight.textColor = [UIColor blackColor];
        _type = @"0";
        _page = 0;
        [self getData];
    }else if(btn.tag == 201){
        [UIView animateWithDuration:0.5 animations:^{
            self.label.frame = CGRectMake(kScreenW / 4 * 3 - 25 / 375.f * kScreenW, CGRectGetMaxY(_btnRight.frame), 50 / 375.f * kScreenW, 2);
        }];
        _type = @"1";
        _page = 0;
        self.labelLeft.textColor = [UIColor blackColor];
        self.labelRight.textColor = RedColor;
        [self getData];
    }
}

#pragma mark downloadData

- (void)setupRefresh
{
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_tableView headerBeginRefreshing];
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

- (void)headerRereshing
{
    _page = 0;
    [self getData];
}

- (void)footerRereshing
{
    _page ++;
    [self getData];
}

- (void)getData
{
    weak_Self(self);
    if (!self.dataSource) {
        self.dataSource = [[NSMutableArray alloc] init];
    }
    ECarConfigs * user=[ECarConfigs shareInstance];
    [self showHUD:@"正在加载"];
    if (self.historyType == ECarHistoryTypeXingcheng) {
        [[_zzManager fapiaoHistoryXingcheng:user.user.phone type:_type page:[NSString stringWithFormat:@"%zd",_page]] subscribeNext:^(id x) {
            [self hideHUD];
            NSDictionary * dic = x;
            NSArray * arr = [dic objectForKey:@"obj"];
            if (_page == 0) {
                [_dataSource removeAllObjects];
            }
            for (NSDictionary * dic1 in arr) {
                ECarFapiaoHistoryModel * model = [ECarFapiaoHistoryModel parseWithJSONDic:dic1];
                [_dataSource addObject:model];
            }
            [_tableView reloadData];
        } completed:^{
            [weakSelf.tableView headerEndRefreshing];
            [weakSelf.tableView footerEndRefreshing];
            [self hideHUD];
        }];
    }else if (self.historyType == ECarHistoryTypeVIP){
        [[_zzManager fapiaoHistoryVIP:user.user.phone type:_type page:[NSString stringWithFormat:@"%zd",_page]] subscribeNext:^(id x) {
            [self hideHUD];
            NSDictionary * dic = x;
            NSArray * arr = [dic objectForKey:@"obj"];
            if (_page == 0) {
                [_dataSource removeAllObjects];
            }
            for (NSDictionary * dic1 in arr) {
                ECarFapiaoHistoryModel * model = [ECarFapiaoHistoryModel parseWithJSONDic:dic1];
                [_dataSource addObject:model];
            }
            [_tableView reloadData];
        } completed:^{
            [weakSelf.tableView headerEndRefreshing];
            [weakSelf.tableView footerEndRefreshing];
            [self hideHUD];
        }];
    }
}

#pragma  mark tableViewDelegate

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 / 375.f * kScreenW;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * reuseStr = @"fapiaoHistoryCell";
    ECarFapiaoHistoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseStr];
    if (!cell) {
        cell = [[ECarFapiaoHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseStr];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ECarFapiaoHistoryModel * model = [_dataSource objectAtIndex:indexPath.row];
    [cell refershCellWithModel:model];
    return cell;
}

#pragma mark ---HUD
- (void)showHUD:(NSString *)text
{
    if (!self.hud) {
        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
        _hud.mode = MBProgressHUDAnimationFade;
        [self.view addSubview:_hud];
    }
    [_hud setLabelText:text];
    [_hud show:YES];
}
- (void)hideHUD
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.hud = nil;
}
- (void)delayHidHUD:(NSString *)text
{
    if (!self.hud) {
        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
        _hud.mode = MBProgressHUDModeText;
        [self.view addSubview:_hud];
    }
    [_hud setLabelText:text];
    [_hud show:YES];
    [_hud hide:YES afterDelay:3];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ECarFapiaoHistoryDetailViewController * vc = [[ECarFapiaoHistoryDetailViewController alloc]init];
    vc.fapiaoModel = _dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
