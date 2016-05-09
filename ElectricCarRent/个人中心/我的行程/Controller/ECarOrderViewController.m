//
//  ECarOrderViewController.m
//  ElectricCarRent
//
//  Created by 程元杰 on 15/11/5.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarOrderViewController.h"
#import "ECarOrderTableViewCell.h"
#import "KKHttpServices.h"
#import "ECarMapManager.h"
#import "MJRefresh.h"
#import "ECarZhiFuViewController.h"
#import "MBProgressHUD.h"
#import "ECarCarInfo.h"
#import "ECarDDFapiaoViewController.h"

@interface ECarOrderViewController () <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

//@property (nonatomic, strong) ECarMapManager * mapManager;
@property (nonatomic, strong) NSMutableArray * array;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) ECarMapManager * manager;
@property (nonatomic, strong) ECarZhiFuViewController * zhifu;

@end

@implementation ECarOrderViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = kWhiteColor;
    self.manager = [ECarMapManager new];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createRightButton];
    [self createUI];
}

- (void)createRightButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 30);
    [btn setTitle:@"发     票" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = btnItem;
}

- (void)rightBarButtonItemClicked:(id)sender
{
    ECarDDFapiaoViewController *fapiao = [[ECarDDFapiaoViewController alloc] init];
    [self.navigationController pushViewController:fapiao animated:YES];
}

- (void)createUI
{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = @"我的行程";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    self.view.backgroundColor = WhiteColor;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.backgroundColor = WhiteColor;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    _dataList = [[NSMutableArray alloc] init];
    _bgView=[[UIView alloc] initWithFrame:self.view.bounds];
    _imageView=[[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.image=[UIImage imageNamed:@"meineirong"];
    [_bgView addSubview:_imageView];
    _bgView.hidden = YES;
    [self.view addSubview:_bgView];
    [self setupRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ordernotificationClicked) name:@"zhifuwancheng" object:nil];
}

- (void)ordernotificationClicked
{
    if (_zhifu) {
        self.navigationController.navigationBar.hidden = NO;
        [_zhifu.view removeFromSuperview];
        [self headerRereshing];
        _zhifu = nil;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifer = @"OrderCell";
    ECarOrderTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        
        cell = [[ECarOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = WhiteColor;
    }
    if (indexPath.row != 0) {
        
        cell.button.enabled = NO;
    }
    OrderModel * model=_dataList[indexPath.row];
    
    cell.model = model;
//    [cell relayOutUIWithModel:model];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 205;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel * model = _dataList[indexPath.row];
    //    NSLog(@"%@", _dataList);
    //    PDLog(@"ewrqr  ret  %@   %@", model.carPLongtitude, model.orderID);
    if (model.isfinish.intValue == 4) {
        [self addzhifuViewJieshuWithModel:model];
    } else if (model.isfinish.intValue == 1) {
        if ([self.orderDelegate respondsToSelector:@selector(presentDringNavigationWithModel:andCarInfo:)]) {
            [ECarConfigs shareInstance].jinruZhuangTai = 10;
            [ECarConfigs shareInstance].orignOrderNo = model.orderID;
            ECarCarInfo * carInfo = [[ECarCarInfo alloc] init];
            carInfo.carLatitude = model.endPLongitude;
            carInfo.carlongitude = model.endPLongitude;
            carInfo.carno = model.carno;
            carInfo.lanYaName = model.lanYaDic[@"lanYaName"];
            carInfo.lanYaPassWord = model.lanYaDic[@"lanYaPassWord"];
            carInfo.lanYaServiceName = model.lanYaDic[@"lanYaServiceName"];
            carInfo.lanYaWriteCharacteristiceName = model.lanYaDic[@"lanYaWriteCharacteristiceName"];
            carInfo.lanYaNotifyCharacteristiceName = model.lanYaDic[@"lanYaNotifyCharacteristiceName"];
            if (self.mainViewOrder == 5) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            [self.orderDelegate presentDringNavigationWithModel:model andCarInfo:carInfo];
        }
    } else if (model.isfinish.intValue == 0) {
        [ECarConfigs shareInstance].orignOrderNo = model.orderID;
        //        PDLog(@"234345v  %@  %@", model.carPLatitude, model.carPLongtitude);
        if (self.mainViewOrder == 5) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        [self.orderDelegate presentWarkingNavigationWithModel:model andCarInfo:nil];
    }
}

- (void)addzhifuViewJieshuWithModel:(OrderModel *)model
{
    ECarConfigs * config = [ECarConfigs shareInstance];
    
    config.orignOrderNo = model.orderID;
    if (model.rmb.floatValue < 0.001) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本次用车没有发生费用，欢迎下次用车" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    weak_Self(self);
    self.zhifu = [[ECarZhiFuViewController alloc] init];
    self.zhifu.panduan = YES;
    if (model.powerunit) {
        NSString * str = [NSString stringWithFormat:@"%@", model.powerunit];
        if (str.boolValue == 1) {
            self.zhifu.sendType = sendToHouTaiByVip;
        }
    }
    config.currentPrice = [NSString stringWithFormat:@"%@", model.rmb];
    self.zhifu.priceCar = [NSString stringWithFormat:@"%@", model.rmb];
    self.zhifu.orderID = model.orderID;
    self.zhifu.view.frame = self.view.bounds;
    self.zhifu.backblock = ^{
        [weakSelf.zhifu.view removeFromSuperview];
        weakSelf.navigationController.navigationBar.hidden = NO;
        weakSelf.zhifu = nil;
    };
    self.navigationController.navigationBar.hidden = YES;
    //    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [self.view addSubview:self.zhifu.view];
    [self.view bringSubviewToFront:self.zhifu.view];
}

//网络请求数据

- (void)setupRefresh
{
    //下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_tableView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

//下拉刷新
- (void)headerRereshing
{
    _page = 0;
    [self refreshRequestDataWithMore];
}
//上拉加载
- (void)footerRereshing
{
    _page ++;
    [self refreshRequestDataWithMore];
}

- (void)refreshRequestDataWithMore
{
    ECarConfigs * user=[ECarConfigs shareInstance];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:user.user.user_id forKey:@"memberId"];
    [params setObject:user.TokenID forKey:@"tokenId"];
    [params setObject:[NSString stringWithFormat:@"%zd", _page] forKey:@"page"];
    
    [[self.manager orderList:user.user.user_id page:_page] subscribeNext:^(id x) {
        if (_page == 0) {
            [_dataList removeAllObjects];
        }
        NSDictionary *dic = x;
        if (!dic) {
            return;
        }
        NSArray * array=dic[@"obj"];
        for (NSDictionary *userdic in array) {
//             转换成数据原型对象
            OrderModel *model = [[OrderModel alloc] initWithContentsOfDic:userdic];
//            PDLog(@"asderytty %@", model.endPLongitude);
            // 添加到可变字典中
            [_dataList addObject:model];
        }
        
        [_tableView reloadData];
    } completed:^{
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        if (_dataList.count == 0) {
            _bgView.hidden = NO;
            [self.view bringSubviewToFront:_bgView];
        }else {
            _bgView.hidden = YES;
        }
    }];

    
    
}
@end
