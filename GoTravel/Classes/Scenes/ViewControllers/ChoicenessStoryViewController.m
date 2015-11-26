//
//  ChoicenessStoryViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//精选故事全

#import "ChoicenessStoryViewController.h"
#include "ChoicenessStoryCell.h"
#include "NetWorkHandle.h"
#include "RecommendModel.h"
#include "MJRefresh.h"
#import "RecommendDetailViewController.h"

@interface ChoicenessStoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

//声明一个collectionView的对象
@property (nonatomic, strong) UICollectionView *collectionView;

//存储数据
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *arrayAdd;

/**返回顶部的按钮*/
@property (nonatomic, strong) UIButton *topButton;
@end

@implementation ChoicenessStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.dataArray = [NSMutableArray array];
    
    self.arrayAdd = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadBarButtonItem];
    
    [self loadCollectionView];
    
    [self loadRequestData];
    _indexStart = 0;
    
    //在文件的.m中导入#include "MJRefresh.h",在viewDidLoad方法里面
    
    //上拉刷新
    __weak ChoicenessStoryViewController *CSVC = self;
    [_collectionView addHeaderWithCallback:^{
        
        if (isReshing == YES) {
            return ;
        }
        isReshing = YES;
        isReshing = NO;
        
        //让刷新的头部视图停止刷新
        [CSVC.collectionView headerEndRefreshing];
        
        
    }];
    //下拉加载
    [_collectionView addFooterWithCallback:^{
        if (isLoading == YES) {
            return;
        }
        isLoading = YES;
        //根据需求进行设置
        
        //这个放在请求数据里面判断
        //          _indexStart+=12;
        //根据现在的页码进行拼接网址请求数据加载
        [CSVC loadRequestData];
        
        isLoading = NO;
        
        //让刷新的尾部视图停止刷新
        [CSVC.collectionView footerEndRefreshing];
    }];
    
    NSLog(@"------子 %@",self.view.subviews);
    
}
#pragma mark ---加载navigationBar
- (void)loadBarButtonItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-fanhui"]style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
   
    self.navigationItem.title = @"精选故事";
   
    
    
    
}


#pragma mark ---实现返回上一个界面
- (void)backAction:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark ---加载一个CollectionView及topButton按钮
- (void)loadCollectionView
{
    
   
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat interval = 10;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(interval, interval, 0, interval);
    flowLayout.itemSize = CGSizeMake((self.view.frame.size.width - interval * 3) /2, 180);
    
    flowLayout.minimumLineSpacing = interval;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    
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
    
    RecommendModel *model = self.dataArray[indexPath.row];
    
    [cell binModel:model];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    
    
    
    
    return cell;
    
}

#pragma mark --点击item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendDetailViewController *RDVC = [[RecommendDetailViewController alloc] init];
    UINavigationController *NC = [[UINavigationController alloc] initWithRootViewController:RDVC];
    
    RecommendModel *model = self.dataArray[indexPath.row];
    
    RDVC.index = model.spot_id ;

    
    [self presentViewController:NC animated:YES completion:nil];
    
}

#pragma  mark ---网络请求数据
- (void)loadRequestData
{
    
    
    //http://api.breadtrip.com/v2/index/target_waypoint_id=0
    
    [NetWorkHandle getDataWithURLString:[NSString stringWithFormat:@"http://api.breadtrip.com/v2/new_trip/spot/hot/list/?start=%ld",(long)_indexStart] compare:^(id object) {
        
        [_arrayAdd removeAllObjects];
        NSDictionary *dictionary = object;
        
        NSDictionary *dict = dictionary[@"data"];
        
        NSArray *array = dict[@"hot_spot_list"];
        
        for (NSDictionary *dic in array) {
            
            RecommendModel *model = [[RecommendModel alloc] initWithDictionary:dic];
            
            NSDictionary *userDict = dic[@"user"];
            
            model.name = userDict[@"name"];
            model.avatar_m = userDict[@"avatar_m"];
            
            [_arrayAdd addObject:model];
            
        }
        
        [self.dataArray addObjectsFromArray:_arrayAdd];
        [self.collectionView reloadData];
        
        //如果不等于12就说明没有数据了
        if(_arrayAdd.count == 12)_indexStart+=12;
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
