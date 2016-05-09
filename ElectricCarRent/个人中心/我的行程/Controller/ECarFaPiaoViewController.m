//
//  ECarFaPiaoViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/3/30.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarFaPiaoViewController.h"
#import "ECarFaPiaoTableViewCell.h"
#import "MJRefresh.h"
#import "ECarUserManager.h"
#import "FaPiaoModel.h"

#import "ECarXingCFPViewController.h"
#import "ECarFapiaoHistoryViewController.h"

@interface ECarFaPiaoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectCells;
@property (nonatomic, strong) ECarUserManager *userManager;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) CGFloat priceCounts;
@property (nonatomic, strong) NSString *usePhone;

@property (nonatomic, strong)UIView * bottomView;
@property (nonatomic, strong)UILabel * allLabel;
@property (nonatomic, strong)UIButton * allButton;
@property (nonatomic, strong)UILabel * allPriceLabel;
@property (nonatomic, strong)UILabel * xianLabel;
@property (nonatomic, strong)UIButton * nextButton;


@end

@implementation ECarFaPiaoViewController

#pragma mark - 懒加载
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (ECarUserManager *)userManager
{
    if (!_userManager) {
        _userManager = [[ECarUserManager alloc] init];
    }
    return _userManager;
}

- (NSMutableArray *)selectCells
{
    if (!_selectCells) {
        _selectCells = [[NSMutableArray alloc] init];
    }
    return _selectCells;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64 - 64 / 667.f * kScreenH)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = ClearColor;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"行程发票";
    self.page = 0;
    self.priceCounts = 0;
    self.usePhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    self.view.backgroundColor = WhiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTableView];
    [self creatBottomView];
    [self createRightButton];
}

- (void)createRightButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 30);
    [btn setTitle:@"开票历史" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = btnItem;
}

- (void)rightBarButtonItemClicked:(id)sender
{
    ECarFapiaoHistoryViewController *history = [[ECarFapiaoHistoryViewController alloc] initWithTyep:ECarHistoryTypeXingcheng];
    [self.navigationController pushViewController:history animated:YES];
}

#pragma mark - 创建tableView及配置
- (void)createTableView
{
    [self.view addSubview:self.tableView];
    [self.tableView addHeaderWithTarget:self action:@selector(tableViewHeaderClicked)];
    [self.tableView addFooterWithTarget:self action:@selector(tableViewFootClicked)];
    [self.tableView headerBeginRefreshing];
}

- (void)tableViewHeaderClicked
{
    _page = 0;
    [self getDataSourceFromNetWork];
}

- (void)tableViewFootClicked
{
    _page ++;
    [self getDataSourceFromNetWork];
}

- (void)getDataSourceFromNetWork
{
    weak_Self(self);
    [[self.userManager xingchengFapiaoListWithPhone:[NSString stringWithFormat:@"%@", self.usePhone] andPage:[NSString stringWithFormat:@"%zd", _page]] subscribeNext:^(id x) {
        NSDictionary * dic = x;
        if (!dic) {
            return ;
        }
        if (_page == 0) {
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.selectCells removeAllObjects];
            weakSelf.priceCounts = 0;
            weakSelf.allButton.selected = NO;
            [weakSelf refreshBottomViewData];
        }
        NSArray * array=dic[@"obj"];
        for (NSDictionary *userdic in array) {
            FaPiaoModel *model = [[FaPiaoModel alloc] initWithDictionary:userdic];
            [weakSelf.dataSource addObject:model];
        }
        if (weakSelf.dataSource.count != weakSelf.selectCells.count) {
            weakSelf.allButton.selected = NO;
        }
        [_tableView reloadData];
    } error:^(NSError *error) {
        [weakSelf delayHidHUD:MESSAGE_NoNetwork];
    } completed:^{
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}

#pragma mark - 创建底部view
- (void)creatBottomView
{
    _bottomView =[[ UIView alloc] initWithFrame:CGRectMake(0, kScreenH - 64 / 667.f * kScreenH, kScreenW, 64 / 667.f * kScreenH)];
    _bottomView.backgroundColor = WhiteColor;
    [self.view addSubview:_bottomView];
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:_bottomView.bounds];
    imgView.image = [UIImage imageNamed:@"goumaihuiyuanfapiao375*76"];
    [self.bottomView addSubview:imgView];
    
    _allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _allButton.frame = CGRectMake(0, 0, 40, 40);
    _allButton.center = CGPointMake(20 / 375.f * kScreenW, 20);
    [_allButton addTarget:self action:@selector(allButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_allButton setImage:[UIImage imageNamed:@"danxuan"] forState:UIControlStateNormal];
    [_allButton setImage:[UIImage imageNamed:@"选中圈"] forState:UIControlStateSelected];
    [_bottomView addSubview:_allButton];
    
    _allLabel = [[UILabel alloc] initWithFrame:CGRectMake(_allButton.right +20/375.f*kScreenW, 10, 40, 20)];
    _allLabel.text = @"全选";
    _allLabel.font = [UIFont systemFontOfSize:14];
    [_bottomView addSubview:_allLabel];
    
    _allPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _allPriceLabel.font = [UIFont systemFontOfSize:12];
    _allPriceLabel.textColor = [UIColor grayColor];
    NSString * str = @"0个行程 共0.00元 （满200包邮）";
    NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc] initWithString:str];
    [attstr addAttribute:NSForegroundColorAttributeName value:RedColor range:NSMakeRange(0, 1)];
    [attstr addAttribute:NSForegroundColorAttributeName value:RedColor range:NSMakeRange(6, 4)];
    _allPriceLabel.attributedText = attstr;
    CGSize size = [_allPriceLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_allPriceLabel.font,NSFontAttributeName, nil]];
    _allPriceLabel.frame = CGRectMake(_allLabel.left,( _allLabel.bottom+10)/667.f*kScreenH, size.width, 15);
    [_bottomView addSubview:_allPriceLabel];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.frame = CGRectMake(265 / 375.f * kScreenW, 0, kScreenW- 265 / 375.f*kScreenW, _bottomView.height);
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:RedColor forState:UIControlStateNormal];
    _nextButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [_nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_nextButton];
}

- (void)refreshBottomViewData
{
    NSString *count = [NSString stringWithFormat:@"%zd", self.selectCells.count];
    NSString *price = [NSString stringWithFormat:@"%.2f", self.priceCounts];
    NSString * str = [NSString stringWithFormat:@"%@个行程 共%@元(满200包邮)", count, price];
    NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc] initWithString:str];
    [attstr addAttribute:NSForegroundColorAttributeName value:RedColor range:NSMakeRange(0, count.length)];
    [attstr addAttribute:NSForegroundColorAttributeName value:RedColor range:NSMakeRange(5 + count.length, price.length)];
    _allPriceLabel.attributedText = attstr;
    CGSize size = [_allPriceLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_allPriceLabel.font,NSFontAttributeName, nil]];
    _allPriceLabel.width = size.width;
}

- (void)allButtonAction:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    if (sender.isSelected == YES) {
        self.priceCounts = 0;
        [self.selectCells removeAllObjects];
        [self.selectCells addObjectsFromArray:self.dataSource];
        [self.tableView reloadData];
        for (FaPiaoModel * model in self.selectCells) {
            self.priceCounts += model.fpPrice.floatValue;
        }
    } else {
        self.priceCounts = 0;
        [self.selectCells removeAllObjects];
        [self.tableView reloadData];
    }
    [self refreshBottomViewData];
}

- (void)nextButtonAction:(UIButton *)sender
{
    if (self.selectCells.count == 0) {
        [self delayHidHUD:@"请选择开票项"];
        return;
    }
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (FaPiaoModel *model in self.selectCells) {
        [array addObject:model.fpId];
    }
    NSString * ids = [array componentsJoinedByString:@","];
    ECarXingCFPViewController * xingc = [[ECarXingCFPViewController alloc] initWithPrice:self.priceCounts];
    xingc.xingChengType = XingChengFangShiXingCheng;
    xingc.allIds = ids;
    xingc.title = @"行程发票";
    [self.navigationController pushViewController:xingc animated:YES];
}

#pragma mark - UITableViewDelegate实现
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECarFaPiaoTableViewCell * cell = [ECarFaPiaoTableViewCell createTableViewCellWithTableView:tableView];
    FaPiaoModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell refreshViewWithModel:model];
    if ([self.selectCells containsObject:model]) {
        cell.selectStatus = YES;
    } else {
        cell.selectStatus = NO;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90 / 667.f * kScreenH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.dataSource.count == 0) {
        return;
    }
    FaPiaoModel *model = [self.dataSource objectAtIndex:indexPath.row];
    ECarFaPiaoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.selectCells containsObject:model]) {
        cell.selectStatus = NO;
        [self.selectCells removeObject:model];
        self.priceCounts -= model.fpPrice.floatValue;
    } else {
        cell.selectStatus = YES;
        [self.selectCells addObject:model];
        self.priceCounts += model.fpPrice.floatValue;
    }
    if (self.selectCells.count == self.dataSource.count) {
        self.allButton.selected = YES;
    } else {
        self.allButton.selected = NO;
    }
    [self refreshBottomViewData];
}

@end
