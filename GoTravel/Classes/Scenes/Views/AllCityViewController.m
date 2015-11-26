
//
//  AllCityViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/14.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "AllCityViewController.h"
#import "ChoicenessStoryCell.h"
#include "NetWorkHandle.h"
#import "DetailsdestinationCityViewController.h"
#import "MJRefresh.h"

#import "MBProgressHUD+MJ.h"
#import "Extension.h"
#import "DataBasehandle.h"
@interface AllCityViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{
    BOOL isReshing;
    BOOL isLoading;
    NSInteger _currentPage;
}
@property (nonatomic, strong) UICollectionView *collectionView;

//存储数据
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *arrayAdd;
@property (nonatomic, strong) UIButton *topButton;
@end

@implementation AllCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = self.titleStr;
    self.dataArray = [NSMutableArray array];
    self.arrayAdd = [NSMutableArray array];
    _currentPage = 1;
    
    [self loadBarButtonItem];
    
    [self loadCollectionView];
    
    [self dataBasehandle];
    
    __weak AllCityViewController *newVC = self;
    //下拉刷新:
    [self.collectionView addHeaderWithCallback:^{
        if (isReshing) {
            return;
        }
        isReshing = YES;
        
        //根据页码拼接网址进行请求数据
        isReshing = NO;
        [newVC.collectionView headerEndRefreshing];
    }];
    //上拉加载:
    [self.collectionView addFooterWithCallback:^{
        if (isLoading) {
            return;
        }
        isLoading = YES;
        NSInteger integer = [[[NSUserDefaults standardUserDefaults] objectForKey:self.titleStr] integerValue];
        _currentPage = integer + 1;
        [self loadValue];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //根据现在的页码进行拼接网址请求数据加载
        isLoading = NO;
        [newVC.collectionView footerEndRefreshing];
    }];
}
- (void)loadBarButtonItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-fanhui"]style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nvImage"]];
    
}

- (void)backAction:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)loadCollectionView
{
    
    //
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat interval = 10;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(interval, interval, 0, interval);
    flowLayout.itemSize = CGSizeMake((self.view.frame.size.width - interval * 3) /2, 180);
    
    flowLayout.minimumLineSpacing = interval;
    
    
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) collectionViewLayout:flowLayout];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //注册cell
    [self.collectionView registerClass:[ChoicenessStoryCell class] forCellWithReuseIdentifier:@"CELL"];
    
    self.topButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.topButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 50, CGRectGetHeight(self.view.frame)- 70, 45, 145);
    
    [self.topButton setImage:[UIImage imageNamed:@"iconfont-uptop"] forState:UIControlStateNormal];
    [self.topButton setTintColor:[UIColor redColor]];
    [self.collectionView addSubview:self.topButton];

    [self.topButton addTarget:self action:@selector(returntopClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark ---实现点击按钮回到顶部的方法
- (void)returntopClick:(UIButton *)sender{
    
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.topButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 50, scrollView.contentOffset.y + CGRectGetHeight(self.view.frame) - 100, 30, 30);
    
}

#pragma mark ---代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}

#pragma mark ---cell的样式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChoicenessStoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    AllCityModel *model = self.dataArray[indexPath.row];
    
    [cell sendModel:model];
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}
#pragma  mark ---网络请求数据
- (void)loadValue
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
#pragma mark - 接口中的page为页数 可以进行上拉下拉 的添加
    __weak AllCityViewController *city = self;
    [NetWorkHandle getDataWithURLString:[NSString stringWithFormat:@"http://open.qyer.com/place/city/get_city_list?client_id=qyer_android&client_secret=9fcaae8aefc4f9ac4915&v=1&track_deviceid=358142031588575&track_app_version=6.8.2&track_app_channel=360m&track_device_info=hwH30-T00&track_os=Android4.2.2&app_installtime=1447157253953&lat=40.030537&lon=116.343373&page=%ld&countryid=%@",_currentPage, self.countID] compare:^(id object) {

        [_arrayAdd removeAllObjects];
        NSDictionary *dic = object;
        NSArray *array = dic[@"data"];
        [KDataBasehandle createtableName:@"all_city" Modelclass:[AllCityModel class]];
        for (NSDictionary *dic1 in array) {
            AllCityModel *model = [[AllCityModel alloc] initWithDictionary:dic1];
            model.cnname = self.titleStr;
            [city.arrayAdd addObject:model];
            [KDataBasehandle insertIntoTableModel:model];
        }
        NSInteger integer = [[[NSUserDefaults standardUserDefaults] objectForKey:self.titleStr] integerValue];
        if (_currentPage > integer) {
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld", _currentPage] forKey:self.titleStr];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [city.dataArray addObjectsFromArray:city.arrayAdd];
        [city.collectionView reloadData];
    }];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AllCityModel *model = self.dataArray[indexPath.row];
    DetailsdestinationCityViewController *city = [[DetailsdestinationCityViewController alloc] init];
    city.cityID = model.cityID;
    city.titleStr = model.catename;
    city.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:city animated:YES];
}
#pragma mark - 数据持久化
- (void)dataBasehandle
{
    
    [KDataBasehandle createtableName:@"all_city" Modelclass:[AllCityModel class]];
    NSMutableArray *arr =  [KDataBasehandle selectFromAttributeName:@"cnname" ValueStr:self.titleStr];
    
    if (arr.count != 0 ) {
        
        [self.dataArray addObjectsFromArray:arr];
    } else {
        [self loadValue];
    }
    [self.collectionView reloadData];
    
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
