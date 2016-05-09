//
//  ECarWeiZhangViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/4/12.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarWeiZhangViewController.h"
#import "ECarWeiZhangTableViewCell.h"
#import "ECarEntrustViewController.h"
#import "WZSMViewController.h"
#import "DaichuliViewController.h"
#import "ECarWeiZhangModel.h"
#import "ECarUserManager.h"
#import "ECarConfigs.h"
#import "MJRefresh.h"

@interface ECarWeiZhangViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ECarUserManager *manager;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UIButton *btnTopBtn1;
@property (nonatomic, strong) UIButton *btnTopBtn2;
@property (nonatomic, strong) UIButton *btnTopBtn3;
@property (nonatomic, strong) UIView *topViews;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSString *severURL;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) WeiZhangChuLiType weizhangChuLiType;

@end

@implementation ECarWeiZhangViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = WhiteColor;
        _tableView.backgroundView = nil;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (ECarUserManager *)manager
{
    if (!_manager) {
        _manager = [[ECarUserManager alloc] init];
    }
    return _manager;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.weizhangChuLiType == WeiZhangChuLiTypeDaiChuLi) {
        self.severURL = @"car/tcpeccancyController.do?getpendingPeccancy";
        [_tableView headerBeginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"违章记录";
    self.page = 1;
    self.weizhangChuLiType = WeiZhangChuLiTypeDaiChuLi;
    self.severURL = @"car/tcpeccancyController.do?getpendingPeccancy";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createUI];
    [self createRightButton];
}

- (void)createRightButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 30);
    [btn setTitle:@"违章说明" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = btnItem;
}

- (void)rightBarButtonItemClicked:(UIButton *)sender
{
    WZSMViewController *wzsm = [[WZSMViewController alloc] init];
    [self.navigationController pushViewController:wzsm animated:YES];
}

- (void)createUI {
    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(40 / 375.f * kScreenW, 64, kScreenW - 60 / 375.f * kScreenW, 20 / 667.f * kScreenH)];
    tView.backgroundColor = WhiteColor;
    tView.clipsToBounds = YES;
    [self.view addSubview:tView];
    
    UIImageView *labaImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 11)];
    labaImage.image = [UIImage imageNamed:@"laba12*11"];
    labaImage.center = CGPointMake(28 / 375.f * kScreenW, tView.center.y);
    [self.view addSubview:labaImage];
    
    NSString * str = @"自违章录入时间开始算起，请您7日内选择自行处理违章或者委托EZZY代为处理，否则您的EZZY账号将被锁定，暂时不能用车。";
    CGSize size = [str boundingRectWithSize:CGSizeMake(0, 20 / 667.f * kScreenH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: FontMinSize} context:nil].size;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 20 / 667.f * kScreenH)];
    label.textColor = RedColor;
    label.font = FontMinSize;
    label.text = str;
    [tView addSubview:label];
    self.topLabel = label;
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(paomadengClick) userInfo:nil repeats:YES];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tView.frame), kScreenW, 60 / 667.f * kScreenH)];
    topView.backgroundColor = WhiteColor;
    [self.view addSubview:topView];
    self.topViews = topView;
    
    UIButton *daichuli = [UIButton buttonWithType:UIButtonTypeCustom];
    daichuli.frame = CGRectMake(22.5 / 375.f * kScreenW, 0, 110 / 375.0 * kScreenW, topView.height);
    [daichuli setTitle:@"待处理" forState:UIControlStateNormal];
    [daichuli setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [daichuli setTitleColor:RedColor forState:UIControlStateSelected];
    daichuli.selected = YES;
    daichuli.titleLabel.font = FontType;
    [daichuli addTarget:self action:@selector(daichuliClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:daichuli];
    self.btnTopBtn1 = daichuli;
    
    UIButton *chulizhong = [UIButton buttonWithType:UIButtonTypeCustom];
    chulizhong.frame = CGRectMake(CGRectGetMaxX(daichuli.frame), 0, 110 / 375.0 * kScreenW, topView.height);
    [chulizhong setTitle:@"处理中" forState:UIControlStateNormal];
    [chulizhong setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [chulizhong setTitleColor:RedColor forState:UIControlStateSelected];
    chulizhong.titleLabel.font = FontType;
    [chulizhong addTarget:self action:@selector(chulizhongClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:chulizhong];
    self.btnTopBtn2 = chulizhong;
    
    UIButton *yichuli = [UIButton buttonWithType:UIButtonTypeCustom];
    yichuli.frame = CGRectMake(CGRectGetMaxX(chulizhong.frame), 0, 110 / 375.0 * kScreenW, topView.height);
    [yichuli setTitle:@"已处理" forState:UIControlStateNormal];
    [yichuli setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [yichuli setTitleColor:RedColor forState:UIControlStateSelected];
    yichuli.titleLabel.font = FontType;
    [yichuli addTarget:self action:@selector(yichuliClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:yichuli];
    self.btnTopBtn3 = yichuli;
    
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(50 / 375.f * kScreenW, topView.height - 2, 50, 2)];
    vi.center = CGPointMake(daichuli.center.x, topView.height - 1);
    vi.backgroundColor = RedColor;
    [topView addSubview:vi];
    self.lineView = vi;
    
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.topViews.frame), kScreenW, kScreenH - CGRectGetMaxY(self.topViews.frame));
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView addHeaderWithTarget:self action:@selector(headDataSource)];
    [self.tableView addFooterWithTarget:self action:@selector(footerDataSource)];
    [self.tableView headerBeginRefreshing];
    [self.view addSubview:self.tableView];
}

- (void)paomadengClick
{
    if (self.topLabel.right < 0) {
        self.topLabel.left = kScreenW - 60 / 375.f * kScreenW;
    }
    self.topLabel.left = self.topLabel.left - 3;
}

- (void)daichuliClicked:(UIButton *)sender
{
    if (self.weizhangChuLiType == WeiZhangChuLiTypeDaiChuLi) {
        return;
    }
    sender.selected = !sender.isSelected;
    self.btnTopBtn3.selected = NO;
    self.btnTopBtn2.selected = NO;
    [UIView animateWithDuration:0.15 animations:^{
        self.topViews.top = 20 / 667.f * kScreenH + 64;
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.topViews.frame), kScreenW, kScreenH - CGRectGetMaxY(self.topViews.frame));
        self.lineView.center = CGPointMake(sender.center.x, self.lineView.center.y);
    }];
    self.weizhangChuLiType = WeiZhangChuLiTypeDaiChuLi;
    self.severURL = @"car/tcpeccancyController.do?getpendingPeccancy";
    self.page = 1;
    [self getDataSourceFormNetwork];
}

- (void)chulizhongClicked:(UIButton *)sender
{
    if (self.weizhangChuLiType == WeiZhangChuLiTypeChuLiZhong) {
        return;
    }
    sender.selected = !sender.isSelected;
    self.btnTopBtn1.selected = NO;
    self.btnTopBtn3.selected = NO;
    [UIView animateWithDuration:0.15 animations:^{
        self.topViews.top = 64;
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.topViews.frame), kScreenW, kScreenH - CGRectGetMaxY(self.topViews.frame));
        self.lineView.center = CGPointMake(sender.center.x, self.lineView.center.y);
    }];
    self.weizhangChuLiType = WeiZhangChuLiTypeChuLiZhong;
    self.severURL = @"car/tcpeccancyController.do?getProcessingPeccancy";
    self.page = 1;
    [self getDataSourceFormNetwork];
}

- (void)yichuliClicked:(UIButton *)sender
{
    if (self.weizhangChuLiType == WeiZhangChuLiTypeYiChuLi) {
        return;
    }
    sender.selected = !sender.isSelected;
    self.btnTopBtn1.selected = NO;
    self.btnTopBtn2.selected = NO;
    [UIView animateWithDuration:0.15 animations:^{
        self.topViews.top = 64;
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.topViews.frame), kScreenW, kScreenH - CGRectGetMaxY(self.topViews.frame));
        self.lineView.center = CGPointMake(sender.center.x, self.lineView.center.y);
    }];
    self.weizhangChuLiType = WeiZhangChuLiTypeYiChuLi;
    self.severURL = @"car/tcpeccancyController.do?getProcessedPeccancy";
    self.page = 1;
    [self getDataSourceFormNetwork];
}

- (void)headDataSource
{
    self.page = 1;
    [self getDataSourceFormNetwork];
}

- (void)footerDataSource
{
    self.page ++;
    [self getDataSourceFormNetwork];
}

- (void)getDataSourceFormNetwork
{
    weak_Self(self);
    ECarConfigs * config = [ECarConfigs shareInstance];
    [[self.manager weiZhangKouKuanWithPhone:config.user.phone page:[NSString stringWithFormat:@"%zd", self.page] andSeverURL:self.severURL] subscribeNext:^(id x) {
        [weakSelf.tableView footerEndRefreshing];
        [weakSelf.tableView headerEndRefreshing];
        NSDictionary *dic = x;
        if (!dic || [NSString stringWithFormat:@"%@", dic[@"success"]].boolValue == NO) {
            [weakSelf delayHidHUD:[NSString stringWithFormat:@"%@", dic[@"msg"]]];
            return ;
        }
        if (weakSelf.page == 1) {
            [weakSelf.dataSource removeAllObjects];
        }
        NSArray *array = dic[@"obj"];
        for (NSDictionary *element in array) {
            ECarWeiZhangModel *model = [[ECarWeiZhangModel alloc] initWithDictionary:element];
            [weakSelf.dataSource addObject:model];
        }
        [weakSelf.tableView reloadData];
    } error:^(NSError *error) {
        [weakSelf delayHidHUD:MESSAGE_NoNetwork];
        [weakSelf.tableView footerEndRefreshing];
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145 / 667.f * kScreenH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECarWeiZhangTableViewCell *cell = [ECarWeiZhangTableViewCell createTableViewCellWithTableView:tableView];
    ECarWeiZhangModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell refreshUIWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECarWeiZhangModel *model = [self.dataSource objectAtIndex:indexPath.row];
    if (self.weizhangChuLiType == WeiZhangChuLiTypeDaiChuLi) {
        DaichuliViewController *daichuli = [[DaichuliViewController alloc] initWithWeiZhangModel:model];
        [self.navigationController pushViewController:daichuli animated:YES];
    } else if (self.weizhangChuLiType == WeiZhangChuLiTypeYiChuLi) {
        ECarEntrustViewController *entrust = [[ECarEntrustViewController alloc] initWithModel:model];
        entrust.title = @"违章已处理";
        [self.navigationController pushViewController:entrust animated:YES];
    } else if (self.weizhangChuLiType == WeiZhangChuLiTypeChuLiZhong) {
        ECarEntrustViewController *entrust = [[ECarEntrustViewController alloc] initWithModel:model];
        entrust.title = @"违章处理中";
        [self.navigationController pushViewController:entrust animated:YES];
    }
}

@end
