//
//  ECarTableController.m
//  ElectricCarRent
//
//  Created by 程元杰 on 15/11/10.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarTableController.h"
#import "ECarMapManager.h"
#import "UIViewExt.h"
#import "ITTSegement.h"
#import "ECarCarInfo.h"
#import "ECarTableViewCell.h"
#import "AFNetworking.h"
#import "ITTModel.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"

@interface ECarTableController ()

@property (nonatomic, strong) MBProgressHUD * hud;
@property (nonatomic, strong) ITTSegement *segment;
@property (nonatomic, assign) NSInteger page;

@end

@implementation ECarTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = @"车辆列表";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    self.CYJmanager = [ECarMapManager new];

    self.view.backgroundColor = WhiteColor;
    _buttonView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 43)];
    [self.view addSubview:_buttonView];
    
    _bgView=[[UIView alloc] initWithFrame:CGRectMake(0, _buttonView.bottom, kScreenW, kScreenH-64-_buttonView.height)];
    _bgView.backgroundColor = WhiteColor;
    [self.view addSubview:_bgView];
    
    _tableView = [[UITableView alloc] initWithFrame:_bgView.bounds  style:UITableViewStylePlain];
    _tableView.delegate=self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.dataSource = self;
    _tableView.backgroundColor = WhiteColor;
    [self setupRefresh];
    [_bgView addSubview:_tableView];
    
    // 注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"ECarTableViewCell" bundle:nil] forCellReuseIdentifier:@"ECarCell"];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    NSArray *items = @[@"距离", @"续航", @"步行时间"];
    
    _segment = [[ITTSegement alloc] initWithItems:items];
    _segment.frame = CGRectMake(kScreenW / 5  + 5, 4, kScreenW / 4 * 3, 43);
    [_segment addTarget:self action:@selector(sgAction:) forControlEvents:UIControlEventValueChanged];
    _segment.selectedIndex=0;
    [_buttonView addSubview:_segment];
    
    UIView * viewred1=[[UIView alloc] initWithFrame:CGRectMake(0, _buttonView.bounds.size.height - 1, kScreenW, 1)];
    viewred1.backgroundColor = [UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:1.0];
    [_buttonView addSubview:viewred1];
}

// 网络请求数据
- (void)setupRefresh
{
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_tableView headerBeginRefreshing];
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

- (void)headerRereshing
{
    _page = 0;
    [self getDataFromSer:@"1" type:@"distance"];
}

- (void)footerRereshing
{
    _page ++;
    [self getDataFromSer:@"1" type:@"distance"];
}

- (void)goBack
{
    if (self.refrashBlock) {
        self.refrashBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sgAction:(ITTSegement *)sg
{
    NSArray * array = [self sortedArrayWithIndex:sg.selectedIndex];
    if (!array) {
        return;
    }
    [_dataList removeAllObjects];
    [_dataList addObjectsFromArray:array];
    [_tableView reloadData];
}

- (NSArray *)sortedArrayWithIndex:(NSInteger)index
{
    NSArray * array = nil;
    switch (index) {
        case 0:
        {
            array = [_dataList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                if (_segment.currentState) {
                    NSComparisonResult result = [(ECarCarInfo *)obj1 distance].floatValue / 100.f > [(ECarCarInfo *)obj2 distance].floatValue / 100.f ? NSOrderedAscending: NSOrderedDescending;
                    return result;
                } else {
                    NSComparisonResult result = [(ECarCarInfo *)obj1 distance].floatValue / 100.f < [(ECarCarInfo *)obj2 distance].floatValue / 100.f ? NSOrderedAscending: NSOrderedDescending;
                    return result;
                }
            }];
            break;
        }
        case 1:
        {
            array = [_dataList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                if (_segment.currentState) {
                    return [(ECarCarInfo *)obj1 Mileage].floatValue / 100.f > [(ECarCarInfo *)obj2 Mileage].floatValue / 100.f ? NSOrderedAscending: NSOrderedDescending;
                } else {
                    return [(ECarCarInfo *)obj1 Mileage].floatValue / 100.f < [(ECarCarInfo *)obj2 Mileage].floatValue / 100.f ? NSOrderedAscending: NSOrderedDescending;
                }
            }];
            break;
        }
        case 2:
        {
            array = [_dataList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                if (_segment.currentState) {
                    return [(ECarCarInfo *)obj1 duration].floatValue / 100.f > [(ECarCarInfo *)obj2 duration].floatValue / 100.f ? NSOrderedAscending: NSOrderedDescending;
                } else {
                    return [(ECarCarInfo *)obj1 duration].floatValue / 100.f < [(ECarCarInfo *)obj2 duration].floatValue / 100.f ? NSOrderedAscending: NSOrderedDescending;
                }
            }];
            break;
        }
        default:
            break;
    }
    return array;
}

//网络请求数据
- (void)getDataFromSer:(NSString *)order type:(NSString *)type
{
    weak_Self(self);
    if (!self.dataList) {
        self.dataList = [[NSMutableArray alloc] init];
    }
    NSString * str=@"findAreaCarList";
    ECarConfigs * user=[ECarConfigs shareInstance];
    [self showHUD:@"正在加载"];
    [[_CYJmanager carTableListUserCoordinate:user.userCoordinate order:order type:type states:str andPage:[NSString stringWithFormat:@"%zd", _page]] subscribeNext:^(id x) {
        [self hideHUD];
        if (_page == 0) {
            [_dataList removeAllObjects];
        }
        [_dataList addObjectsFromArray:x];
        NSArray * array = [weakSelf sortedArrayWithIndex:_segment.selectedIndex];
        if (!array) {
            return ;
        }
        [_dataList removeAllObjects];
        [_dataList addObjectsFromArray:array];
        [_tableView reloadData];
    } completed:^{
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        [self hideHUD];
    }];
}

- (void)rightButtonAction:(UIButton *)sender
{
    [self callServerAction];
}

- (void)callServerAction
{
    UIAlertView *serviceAlert = [[UIAlertView alloc] initWithTitle:@"联系客服" message:@"400-6507265" delegate:self cancelButtonTitle:@"呼叫" otherButtonTitles:@"取消", nil];
    [serviceAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [ToolKit callTelephoneNumber:@"400-6507265" addView:self.view];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECarTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ECarCell"];
    cell.contentView.backgroundColor = WhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ECarCarInfo *model = _dataList[indexPath.row];
    
    cell.carNumberLabel.text = [NSString stringWithFormat:@"%@",model.carno];
    cell.carLichengLabel.text = [NSString stringWithFormat:@"续航里程%@公里",model.Mileage];
    
    if (_segment.selectedIndex == 2) {
        cell.carDistanceLabel.text = [NSString stringWithFormat:@"步行约%zd分钟",[model.duration integerValue]];
    }else{
        cell.carDistanceLabel.text = [NSString stringWithFormat:@"距您%.2lf公里",[model.distance doubleValue] / 1000.f];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ECarCarInfo *car = _dataList[indexPath.row];
    NSString * duration = [NSString stringWithFormat:@"%@", car.duration];
    if (duration.integerValue > 200) {
        UIAlertView *serviceAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您距离目标车辆太远，暂不能预定，请选择其他附近车辆进行预订" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        //            serviceAlert.whiteView.frame = CGRectMake(0, 64, kScreenW, kScreenH - 64);
        [serviceAlert show];
        return;
    }
    if (self.backBlock) {
        self.backBlock(car);
    }
    if (self.backBlock) {
        self.backBlock(car);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//// 切换编辑状态
//-(void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing:editing animated:animated];
//    
//    _tableView.editing = !_tableView.editing;
//}
//
//// 允许对列表进行编辑
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//
//// 改写delete按钮
//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    ECarCarInfo *car = _dataList[indexPath.row];
//    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"  预定  " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        // 实现点击事件
//        NSString * duration = [NSString stringWithFormat:@"%@", car.duration];
//        if (duration.integerValue > 200) {
//            UIAlertView *serviceAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您距离目标车辆太远，暂不能预定，请选择其他附近车辆进行预订" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
////            serviceAlert.whiteView.frame = CGRectMake(0, 64, kScreenW, kScreenH - 64);
//            [serviceAlert show];
//            return;
//        }
//        if (self.backBlock) {
//            self.backBlock(car);
//        }
//        if (self.backBlock) {
//            self.backBlock(car);
//        }
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
//    deleteRowAction.backgroundColor = [UIColor colorWithRed:232/255.0 green:82/255.0 blue:152/255.0 alpha:1.0];
//    return @[deleteRowAction];
//}
//
//// 1.删除数据源，2.并且操作当前cell（删除／插入..）
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(editingStyle == UITableViewCellEditingStyleDelete) {}
//}

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

@end
