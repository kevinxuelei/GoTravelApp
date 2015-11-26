//
//  DestinationViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "DestinationViewController.h"
#import "DrawerTableViewController.h"
#import "NetWorkHandle.h"
#import "DestinationTableViewCell.h"
#import "Extension.h"
#import "DetailsDestinationViewController.h"
#import "DetailsdestinationCityViewController.h"
#import "MBProgressHUD+MJ.h"

#import "DataBasehandle.h"

static int number = 0;

@interface DestinationViewController ()<UITableViewDelegate, UITableViewDataSource>

#pragma mark - 抽屉里的tableView
@property (nonatomic, strong) DrawerTableViewController *drawerTableView;
@property (nonatomic, strong) UIView *bgView;
#pragma mark - 本页的tableView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
//接收州的名字
@property (nonatomic, copy) NSString *stateStr;
@property (nonatomic, strong) UIButton *topButton;
@end

@implementation DestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"亚洲";
    self.dataArray = [NSMutableArray array];
    [self loadTableView];
    [self dataBasehandle];
    [self loadNavigationController];
    [self loadDrawerTableView];
    [self loadBGView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark - 设置navigationController
- (void)loadNavigationController
{
//    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMG(@"destination_btn_nav_list") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClicked:)];
    
    self.topButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.topButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 50, CGRectGetHeight(self.view.frame)- 70, 45, 45);
    [self.topButton setImage:[UIImage imageNamed:@"iconfont-uptop"] forState:UIControlStateNormal];
    [self.topButton setTintColor:[UIColor redColor]];
    [self.tableView addSubview:self.topButton];
    [self.topButton addTarget:self action:@selector(returntopClick:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark ---实现点击按钮回到顶部的方法
- (void)returntopClick:(UIButton *)sender{
    
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.topButton.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - 50, scrollView.contentOffset.y + CGRectGetHeight(self.view.bounds) - 100, 30, 30);
    
}
#pragma mark - 实现左边的BarButton
- (void)leftBarButtonClicked:(UIBarButtonItem *)button
{
    __weak DestinationViewController *destination = self;
    if (number == 0) {
        
        [UIView animateWithDuration:0.5 animations:^{
            destination.drawerTableView.tableView.frame = CGRectMake(0, 0, 100, kHeight);
            destination.bgView.frame = CGRectMake(100, 0, kWidth, kHeight);
            destination.tableView.frame = destination.bgView.frame;
            
        }];
        
        [self.view bringSubviewToFront:_bgView];
        number++;
    } else {
        
        [UIView animateWithDuration:0.5 animations:^{
            destination.drawerTableView.tableView.frame = CGRectMake(-100, 0, 100, kHeight);
            destination.bgView.frame = destination.view.bounds;
            destination.tableView.frame = destination.bgView.frame;
        }];
        [self.view sendSubviewToBack:_bgView];
        number--;
    }
    self.drawerTableView.block = ^(NSString *stateStr){
        destination.navigationItem.title = stateStr;
        destination.stateStr = stateStr;
        [UIView animateWithDuration:0.5 animations:^{
            destination.drawerTableView.tableView.frame = CGRectMake(-100, 0, 100, destination.view.frame.size.height);
            destination.bgView.frame = destination.view.bounds;
            destination.tableView.frame = destination.bgView.frame;
        }];
        [destination.view sendSubviewToBack:destination.bgView];
        number--;
        [destination dataBasehandle];
    };
}
#pragma mark - 初始化抽屉里的tableView
- (void)loadDrawerTableView
{
    self.drawerTableView = [[DrawerTableViewController alloc] init];
    self.drawerTableView.view.frame = CGRectMake(-100, 0, 100, kHeight);
    self.drawerTableView.tableView.frame = CGRectMake(-100, 0, 100, kHeight);
    [self.view addSubview:self.drawerTableView.tableView];
    [self.view bringSubviewToFront:self.drawerTableView.tableView];
    self.drawerTableView.tableView.tableFooterView = [[UIView alloc] init];
    self.drawerTableView.tableView.scrollEnabled = NO;
}
#pragma mark - 初始化背景view
- (void)loadBGView
{
    _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.5;
    [self.view addSubview:_bgView];
    [self.view sendSubviewToBack:_bgView];
}
#pragma mark - 解析数据
- (void)loadValue
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak DestinationViewController *destination = self;
    [NetWorkHandle getDataWithURLString:@"http://open.qyer.com/qyer/footprint/continent_list?client_id=qyer_android&client_secret=9fcaae8aefc4f9ac4915&v=1&track_user_id=7004851&track_deviceid=863092021867505&track_app_version=6.8.2&track_app_channel=xiaomi&track_device_info=armani&track_os=Android4.4.4&app_installtime=1447126585362&lat=40.030375&lon=116.343078" compare:^(id object) {
        
        NSDictionary *dic = object;
        NSArray *array = dic[@"data"];
        for (NSDictionary *dict1 in array) {
            if ((self.stateStr == nil) || [self.stateStr isEqualToString:dict1[@"cnname"]]) {
                destination.navigationItem.title = dict1[@"cnname"];
                [self.dataArray removeAllObjects];
                NSArray *hotCountry = dict1[@"hot_country"];
                NSArray *country = dict1[@"country"];
                NSMutableArray *hotCountryArray = [NSMutableArray array];
                NSMutableArray *countryArray = [NSMutableArray array];
                [destination.dataArray addObject:hotCountryArray];
                [destination.dataArray addObject:countryArray];
                
                [KDataBasehandle createtableName:@"hot_country" Modelclass:[DestinationViewControllerModel class]];
                for (NSDictionary *dict in hotCountry) {
                    DestinationViewControllerModel *model = [[DestinationViewControllerModel alloc] initWithDictionary:dict];
                    model.bigcnname = self.navigationItem.title;
                    [destination.dataArray[0] addObject:model];
                    
                    [KDataBasehandle insertIntoTableModel:model];
                }
                
                [KDataBasehandle createtableName:@"country" Modelclass:[DestinationViewControllerModel class]];
                for (NSDictionary *dict in country) {
                    DestinationViewControllerModel *model = [[DestinationViewControllerModel alloc] initWithDictionary:dict];
                    [destination.dataArray[1] addObject:model];
                    
                    model.bigcnname = self.navigationItem.title;
                    [KDataBasehandle insertIntoTableModel:model];
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [destination.tableView reloadData];
                return;
            }
        }
    }];
}
#pragma mark - 初始化tableView
- (void)loadTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 110) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[DestinationTableViewCell class] forCellReuseIdentifier:@"cell"];
}
#pragma mark - tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array = self.dataArray[section];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DestinationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bj"]];
    NSMutableArray *array = self.dataArray[indexPath.section];
    [cell binModel:array[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    if (section == 0) {
        nameLabel.text = @"热门城市";
    } else {
        nameLabel.text = @"其他城市";
    }
#pragma mark - 设置头视图的背景
    nameLabel.backgroundColor = [UIColor cyanColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    return nameLabel;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = self.dataArray[indexPath.section];
    DestinationViewControllerModel *model = array[indexPath.row];
    if ([model.label isEqualToString:@"城市"]) {
        DetailsDestinationViewController *detailsVC = [[DetailsDestinationViewController alloc] init];
        
        detailsVC.titleStr = model.cnname;
        detailsVC.cityID = [NSString stringWithFormat:@"%@", model.cityID];
        detailsVC.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:detailsVC animated:YES];
    } else {
        DetailsdestinationCityViewController *cityVC = [[DetailsdestinationCityViewController alloc] init];
        cityVC.titleStr = model.cnname;
        cityVC.cityID = [NSString stringWithFormat:@"%@", model.cityID];
        cityVC.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:cityVC animated:YES];
    }
}
#pragma mark - 数据持久化
- (void)dataBasehandle
{
    
    [KDataBasehandle createtableName:@"hot_country" Modelclass:[DestinationViewControllerModel class]];
    NSMutableArray *arr =  [KDataBasehandle selectFromAttributeName:@"bigcnname" ValueStr:self.navigationItem.title];
    [KDataBasehandle createtableName:@"country" Modelclass:[DestinationViewControllerModel class]];
    NSMutableArray *arr1 =  [KDataBasehandle selectFromAttributeName:@"bigcnname" ValueStr:self.navigationItem.title];
    NSLog(@"%@",self.navigationItem.title);
    if (arr.count != 0 || arr1.count != 0) {
        self.dataArray = [NSMutableArray array];
        [self.dataArray addObject:arr];
        [self.dataArray addObject:arr1];
    } else {
        [self loadValue];
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
