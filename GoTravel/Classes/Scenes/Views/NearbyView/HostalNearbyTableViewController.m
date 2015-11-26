//
//  HostalNearbyTableViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "HostalNearbyTableViewController.h"
#import "NetWorkHandle.h"
#import "AllNearbyTableViewCell.h"
#import "AllNearbyDetailTableViewController.h"
#import "MJRefresh.h"

#import "Extension.h"
#import "DataBasehandle.h"

@interface HostalNearbyTableViewController ()

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,assign)NSInteger indexStart;

@property (nonatomic, strong) UIButton *topButton;

@property (nonatomic, strong)NearbyTableViewModel *model;

@end

@implementation HostalNearbyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        self.navigationItem.title = @"住宿";
    
    [self.tableView registerClass:[AllNearbyTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataArray = [NSMutableArray array];
    
    _indexStart = 0;
    
    [self dataBaseHandle];
    
    [self loadRefresh];
    
    
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



static CLLocationDegrees lastLatitude;
static CLLocationDegrees lastlongitude;

-(void)loadValue
{
    
    
    [NetWorkHandle getDataWithURLString:[NSString stringWithFormat:@"http://api.breadtrip.com/place/pois/nearby/?category=10&start=%ld&count=20&latitude=%f&longitude=%f",_indexStart,_latitude,_longitude] compare:^(id object) {
        
        lastLatitude = _latitude;
        lastlongitude = _longitude; lastLatitude = _latitude;
        lastlongitude = _longitude;
        
        NSDictionary *dic = object;
        NSArray *array = dic[@"items"];
        
        [KDataBasehandle createtableName:@"hostal" Modelclass:[NearbyTableViewModel class]];
        
        for (NSDictionary *dict1 in array) {
            _model = [[NearbyTableViewModel alloc] initWithDictionary:dict1];
            
            NSDictionary *dic2 = dict1[@"location"];
            _model.lat = dic2[@"lat"];
            _model.lng = dic2[@"lng"];
            
            [self.dataArray addObject:_model];
            
            
#pragma mark ---将网络下载的数据存入数据库
            [KDataBasehandle insertIntoTableModel:_model];
        }
        
        [self.tableView reloadData];
        
    }];
    
    
    
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AllNearbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
       cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bj"]];
    
    [cell binModel:self.dataArray[indexPath.row]];
    cell.backgroundColor = [UIColor colorWithRed:250/256 green:245/256 blue:230/256 alpha:0.001];
    
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 140;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AllNearbyDetailTableViewController *AllNearbyDetailVC = [[AllNearbyDetailTableViewController alloc] init];
    //属性传值第二步,把dataArray赋值给属性传值的对象
    AllNearbyDetailVC.model = self.dataArray[indexPath.row];
    
    UINavigationController *NV = [[UINavigationController  alloc] initWithRootViewController:AllNearbyDetailVC];
    
    AllNearbyDetailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:NV animated:YES completion:nil];
    
    
}


#pragma mark ---上拉刷新下拉加载
-(void)loadRefresh
{
    //上拉刷新
    
    __weak HostalNearbyTableViewController *RVC = self;
    [RVC.tableView addHeaderWithCallback:^{
        
        if (isReshing == YES) {
            return ;
        }
        isReshing = YES;
        isReshing = NO;
        
        //        [RVC.tableView reloadData];
        
        //让刷新的头部视图停止刷新
        [RVC.tableView headerEndRefreshing];
        
        
    }];
    //下拉加载
    [RVC.tableView addFooterWithCallback:^{
        if (isLoading == YES) {
            return;
        }
        isLoading = YES;
        //根据需求进行设置
        
        //这个放在请求数据里面判断
        _indexStart+=20;
        //根据现在的页码进行拼接网址请求数据加载
        [RVC loadValue];
        
        isLoading = NO;
        
        //让刷新的尾部视图停止刷新
        [RVC.tableView footerEndRefreshing];
    }];
   
}

#pragma mark ---数据持久化
-(void)dataBaseHandle
{
    [KDataBasehandle createtableName:@"hostal" Modelclass:[NearbyTableViewModel class]];
    
    
    NSMutableArray *arr1 = [KDataBasehandle selectAllModel];
    
    if (lastLatitude == _latitude && lastlongitude == _longitude) {
        [KDataBasehandle deleteFromTableModel:_model];
        [self loadValue];
        
    } else {
        
        [KDataBasehandle deleteFromTableModel:_model];
        [self loadValue];
        
    }
    
    [self.tableView reloadData];
    
    
}



@end




