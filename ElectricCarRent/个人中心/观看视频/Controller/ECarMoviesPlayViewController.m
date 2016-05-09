//
//  ECarMoviesPlayViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/2/18.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarMoviesPlayViewController.h"
#import "ECarUserManager.h"
#import "ECarMovieModel.h"
#import "ECarPlayMovieTableViewCell.h"
#import "ECarPlayViewController.h"
#import <AVKit/AVKit.h>
#import "MJRefresh.h"

@interface ECarMoviesPlayViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView       * tableView;
@property (nonatomic, strong) NSMutableArray    * dataSource;
@property (nonatomic, assign) NSInteger           page;
@property (nonatomic, strong) ECarUserManager   * userManager;

@end

@implementation ECarMoviesPlayViewController

- (ECarUserManager *)userManager
{
    if (!_userManager) {
        _userManager = [[ECarUserManager alloc] init];
    }
    return _userManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"观看视频";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    [self createTableView];
    [self.tableView headerBeginRefreshing];
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headTableViewClick)];
    [self.tableView addFooterWithTarget:self action:@selector(footerTableViewClick)];
}

- (void)headTableViewClick
{
    self.page = 0;
    [self getDataSourceFromNetwork];
}

- (void)footerTableViewClick
{
    self.page ++;
    [self getDataSourceFromNetwork];
}

// 加载数据
- (void)getDataSourceFromNetwork
{
    if (!self.dataSource) {
        self.dataSource = [[NSMutableArray alloc] init];
    }
    weak_Self(self);
    [[self.userManager getMoviesListDataFromNetWorkWithPage:self.page] subscribeNext:^(id x) {
        NSMutableDictionary * dic = x;
        NSArray * dataArray = dic[@"obj"];
        if (!dataArray) {
            return;
        }
        if (weakSelf.page == 0) {
            [weakSelf.dataSource removeAllObjects];
        }
        for (NSDictionary * dic in dataArray) {
            ECarMovieModel * model = [[ECarMovieModel alloc] initWithDictinary:dic];
            [weakSelf.dataSource addObject:model];
        }
        [weakSelf.tableView reloadData];
    } error:^(NSError *error) {
        [weakSelf delayHidHUD:MESSAGE_NoNetwork];
    } completed:^{
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
    }];
}

#pragma mark - UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECarPlayMovieTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellcell"];
    if (!cell) {
        cell = [[ECarPlayMovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellcell"];
    }
    ECarMovieModel * model = self.dataSource[indexPath.row];
    [cell refrashSubViewsWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 129 / 667.f * kScreenH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ECarMovieModel * model = self.dataSource[indexPath.row];
    ECarPlayViewController * playView = [[ECarPlayViewController alloc] initWithURLString:model.movieUrl];
    [self presentViewController:playView animated:YES completion:nil];
}

@end
