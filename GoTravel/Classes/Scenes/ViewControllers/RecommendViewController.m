//
//  RecommendViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendCell.h"
#import "StoryCell.h"
#import "TravelNotesCell.h"
#import "NetWorkHandle.h"
#import "RecommendModel.h"
#import "TravelNotesModel.h"
#import "MyWebController.h"
#import "ChoicenessStoryViewController.h"
#import "MJRefresh.h"
#import "RecommendDetailViewController.h"
#import "WonderfulTravelController.h"
#import "MBProgressHUD.h"
#define kViewW self.view.frame.size.width
#define kViewH self.view.frame.size.height
#import "DataBaseTool.h"

#define kRecimmendData  [DataBaseTool shareHandle]
@interface RecommendViewController ()<UITableViewDataSource,UITableViewDelegate>



@property (nonatomic, strong) UIView *topView;//用于轮播图

/**存放三个分区的总数组*/
@property (nonatomic, strong) NSMutableArray *dataArray;

/**存放加载数组*/
@property (nonatomic, strong) NSMutableArray *nextDataArray;
/**存放第二组*/
@property (nonatomic, strong) NSMutableArray *storyArray;
/**轮播图数组*/
@property (nonatomic, strong) NSMutableArray *imageAarray;

/**用来存放加载更多的参数*/
@property (nonatomic, strong) TravelNotesModel *modelNext;

/**网络状态*/
@property (nonatomic, assign) BOOL NETStates;

/**精选游记的详情id*/

@property (nonatomic, assign) NSInteger travelNotesDetail;
//声明一个MBProgressHUD对象
@property (nonatomic, strong) MBProgressHUD *hud;

/**返回顶部的按钮*/
@property (nonatomic, strong) UIButton *topButton;

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInitArrays];
    //打开数据库
    [kRecimmendData openData];
    //创建表格
    [kRecimmendData createRecommendOneTable];
    [kRecimmendData createRecommendThreeTable];
    [kRecimmendData createRecommendTwoTable];

    [self loadNavigationItems];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  
    
    NSLog(@"---%@",self.tableView.subviews);
#pragma mark ---根据网络状态，判断网络类型
    [DataBaseTool checkNetWorkStatus:^(AFNetworkReachabilityStatus status) {
       
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"网络状态：未知");
                self.NETStates = NO;
                
                
                [self getNativeData];
                //存储网络状态
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"NETStates"];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"网络状态：无连接");
                self.NETStates = NO;
                
                //加载数据库中的数据
                [self getNativeData];
                //存储网络状态
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"NETStates"];
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"网络状态：3G");
                self.NETStates = YES;
                //默认加载我们的网络数据
                
                [self getNativeData];
               
                //存储网络状态
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"NETStates"];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"网络状态：局域网络Wifi");
                self.NETStates = YES;
                //默认加载网络请求数据
                
                [self getNativeData];
                
                //存储网络状态
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"NETStates"];
               
                break;
                
            default:
                break;
        }
        
        
        
    }];
    

   
   
}

- (void)loadInitArrays{
    self.dataArray = [NSMutableArray array];
    _imageAarray = [NSMutableArray array];
    _storyArray = [NSMutableArray array];
    _nextDataArray = [NSMutableArray array];
}
#pragma mark ---第三方上拉，下拉刷新
- (void)loadRefreshing{
    
    
    //上拉刷新
    __weak RecommendViewController *RVC = self;
    [RVC.tableView addHeaderWithCallback:^{
        
        if (isReshing == YES) {
            return ;
        }
        isReshing = YES;
        
        //网络请求刷新
        [RVC loadRequestData];
        
        
        isReshing = NO;
        
       
        
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
            [self.tableView reloadData];
            //这个放在请求数据里面判断
            // _nextStart+=12;
            //根据现在的页码进行拼接网址请求数据加载
            
        
            
            [RVC loadRequestNextData];
          
            isLoading = NO;
            
            //让刷新的尾部视图停止刷新
            [RVC.tableView footerEndRefreshing];
            [self.tableView reloadData];
        }];
   
    
   
    
}

#pragma mark ---设置NavationItems
- (void)loadNavigationItems{
    [[DataBaseTool shareHandle] LoadVisualEffectViews:self];
   
    self.navigationItem.title = @"推荐";
    
    self.topButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.topButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 50, CGRectGetHeight(self.view.frame)- 70, 45, 45);
    [self.topButton setImage:[UIImage imageNamed:@"iconfont-uptop"] forState:UIControlStateNormal];
    [self.topButton setTintColor:[UIColor redColor]];
    [self.view addSubview:self.topButton];
    [self.topButton addTarget:self action:@selector(returntopClick:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
   
}
#pragma mark ---实现点击按钮回到顶部的方法
- (void)returntopClick:(UIButton *)sender{

    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    self.topButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 50, scrollView.contentOffset.y + CGRectGetHeight(self.view.frame) - 100, 30, 30);
    
}
#pragma mark ---获取本地存储的数据
- (void)getNativeData{
    //加载数据库中的数据

    _imageAarray = [kRecimmendData selectRecommendOneModelFormTable];
    _storyArray = [kRecimmendData selectRecommendTwoModelFromTable];
    _nextDataArray = [kRecimmendData selectRecommendThreeModelFromTable];
    //将取出的数据放入存本所有数据的数组中
    [self.dataArray addObject:_imageAarray];
    [self.dataArray addObject:_storyArray];
    [self.dataArray addObject:_nextDataArray];
    //停止刷新
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //更新UI
    if (_imageAarray.count != 0 && _storyArray.count != 0 && _nextDataArray.count != 0) {
        
        
     
        if (self.NETStates == NO) {
            
            NSLog(@"%d",self.NETStates);
            [[DataBaseTool shareHandle] alertInternetNotOpen:self];
            [self.tableView reloadData];
        }else{
            
            [self loadRefreshing];
            [self.tableView reloadData];
           
            
        }
        
        
     
    }else{
    
        [self loadRequestData];
        [self loadRefreshing];
       
        
        
    }
    
    
    
    



}

#pragma mark ---分区cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    switch (section) {
        case 0:
            
            return 1;
            break;
        case 1:
            
            return [self.dataArray[section] count];
            break;
        case 2:
            
            return [self.dataArray[section] count];
            break;
            
        default:
            return 0;
            break;
    }
    
}

#pragma mark ---分区的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.dataArray.count;
}
#pragma mark ---cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            static NSString  *str = @"cell";
            RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            
            if (!cell) {
                
                cell = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
            }
            
            RecommendModel *model1 = self.dataArray[indexPath.section][indexPath.row];
            
            cell.imageArray = _imageAarray;
            
            [cell binModel:model1];
            
            
            //block回调 跳到下个界面
            cell.blockUrl = ^(NSString *urlStr){
            [[DataBaseTool shareHandle] alertInternetNotOpen:self];
            MyWebController *myWebVC = [[MyWebController alloc] init];
            
            myWebVC.webStrUrl = urlStr;
            
            UINavigationController *NVC = [[UINavigationController alloc] initWithRootViewController:myWebVC];
            [self presentViewController:NVC animated:YES completion:nil];
            
        };
            cell.selectedBackgroundView = [[UIView alloc] init];
            return cell;
            
    }
            break;
        case 1:
        {
            static NSString *str1 = @"storyCell";
            StoryCell *cell = [tableView dequeueReusableCellWithIdentifier:str1];
            if (!cell) {
                
                cell = [[StoryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str1];
            }
            
            RecommendModel *model2 = self.dataArray[indexPath.section][indexPath.row];
            [cell binModel:model2];
            cell.selectedBackgroundView = [[UIView alloc] init];
            return cell;
            
        }
            break;
        case 2:
        {
            
            static NSString *str2 = @"travelNotesCell";
            TravelNotesCell *cell = [tableView dequeueReusableCellWithIdentifier:str2];
            
            if (!cell) {
                
                cell = [[TravelNotesCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str2];
            }
            
            TravelNotesModel *model3 = self.dataArray[indexPath.section][indexPath.row];
            
            [cell binModel1:model3];
            cell.selectedBackgroundView = [[UIView alloc] init];
            
            return cell;
    }
            break;
        default:
            return 0;
            break;
    }
}
#pragma mark ---定义分区头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
        {
            UIView *view = [self headerViewWithText:@"每日精选故事"];
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(self.view.frame.size.width - 70, 10, 60, 30);
            
            button.backgroundColor = [UIColor whiteColor];
            [view addSubview:button];
            [button setImage:[UIImage imageNamed:@"iconfont-jiantou"] forState:UIControlStateNormal];
            
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            return view;

        }
            break;
        case 2:
            return [self headerViewWithText:@"精彩游记"];
            break;
        default:
             return 0;
            break;
    }
   
    
}

//封装区头视图
-(UIView *)headerViewWithText:(NSString *)text{

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(10, 15, 3, 18);
    label1.backgroundColor = [UIColor cyanColor];
    [headerView addSubview:label1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(13, 10, self.view.frame.size.width - 20, 30)];
    label.text = text;
    [headerView addSubview:label];

    
     return headerView;
    

}

#pragma mark ---点击按钮进入每日精选故事展示全部界面
- (void)buttonClick:(UIButton *)sender
{
     [[DataBaseTool shareHandle] alertInternetNotOpen:self];
    ChoicenessStoryViewController *choicenessVC = [[ChoicenessStoryViewController alloc] init];
    UINavigationController *NC = [[UINavigationController alloc] initWithRootViewController:choicenessVC];
    
    [self  presentViewController:NC animated:YES completion:nil];
}

#pragma mark ---每个分区的区头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 40;
            break;
        case 2:
            return 40;
            break;
        default:
            return 0;
            break;
    }
}


#pragma mark ---点击cell的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
        {
            [[DataBaseTool shareHandle] alertInternetNotOpen:self];
            RecommendDetailViewController *RDVC = [[RecommendDetailViewController alloc] init];
            UINavigationController *NC = [[UINavigationController alloc] initWithRootViewController:RDVC];
            
            RecommendModel *model1 = self.dataArray[indexPath.section][indexPath.row];
            
            RDVC.index = model1.spot_id ;
            
            
            
            [self presentViewController:NC animated:YES completion:nil];

        }
            break;
        case 2:
        {
            [[DataBaseTool shareHandle] alertInternetNotOpen:self];
            WonderfulTravelController *WTVC = [[WonderfulTravelController alloc] init];
            
            UINavigationController *NC = [[UINavigationController alloc] initWithRootViewController:WTVC];
#warning ==========点击====
            _modelNext = self.dataArray[indexPath.section][indexPath.row];
            
            WTVC.indexNext = _modelNext.ID;
            NSLog(@"--------%ld",WTVC.indexNext);
            NSLog(@"--------%ld",_modelNext.ID);
            
            [self presentViewController:NC animated:YES completion:nil];

        }
            break;
            
        default:
            break;
    }
 
    
}
#pragma mark --- cell的高度
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
            return 200;
            break;
        case 1:
            return 210;
            break;
        case 2:
            return 210;
            break;
            
        default:
            return 0;
            break;
    }
   
}

#pragma mark ---网络加载数据
- (void)loadRequestData
{
    
    if (self.NETStates == YES) {
        [kRecimmendData DELETERecommendOneTable];
        [kRecimmendData DELETERecommendThreeTable];
        [kRecimmendData DELETERecommendTwoTable];
       
        
    }else{
        [[DataBaseTool shareHandle] alertInternetNotOpen:self];
        return;
    }
    
    

    
    [NetWorkHandle getDataWithURLString:@"http://api.breadtrip.com/v2/index/" compare:^(id object) {
        [_imageAarray removeAllObjects];
        [_storyArray removeAllObjects];
        [_nextDataArray removeAllObjects];
        NSDictionary *dic = object;
        NSDictionary *dictionary = dic[@"data"];
        NSArray *array = dictionary[@"elements"];
        NSDictionary *next_start = dic[@"data"];
        _modelNext.next_start =  [next_start[@"next_start"] intValue];
        NSLog(@"========获取每日精彩故事加载的id======%ld",_modelNext.next_start);
        
        
        for (NSDictionary *dict in array) {
            
            switch ([dict[@"type"] intValue]) {
                case 1:
                {//轮播图的model
                    NSArray *array4 = dict[@"data"];
                    
                    NSArray *arr = array4[0];
                    
                    for (NSDictionary *dic1 in arr) {
                        
                        RecommendModel *model = [[RecommendModel alloc] initWithDictionary:dic1];
                        
                        [_imageAarray addObject:model];
                      
                      
                        [kRecimmendData insertIntoRecommendOneModel:model];
                       
                        
                    }

                }
                    break;
                case 10:
                {//精选故事的model
                    NSArray *array5 = dict[@"data"];
                    
                    for (NSDictionary *dic2 in array5) {
                        
                        RecommendModel *model1 = [[RecommendModel alloc] initWithDictionary:dic2];
                        
                        NSDictionary *dic3 = dic2[@"user"];
                        model1.name = dic3[@"name"];
                        model1.avatar_m = dic3[@"avatar_m"];
                        
                        model1.ID = [dic3[@"id"] integerValue];
                       
                        NSLog(@"字符----%ld",model1.ID);
                        [_storyArray addObject:model1];
                        [kRecimmendData insertIntoRecommendTwoModel:model1];
                        
                    }

                }
                    break;
                case 4:
                {//精彩游记的model
                    NSArray *array6 = dict[@"data"];
                    
                    for (NSDictionary *dic4 in array6) {
                        
                        _modelNext = [[TravelNotesModel alloc] initWithDictionary:dic4];
                        _modelNext.index_title = dic4[@"name"];
                        NSDictionary *dic5 = dic4[@"user"];
                        _modelNext.name = dic5[@"name"];
                        _modelNext.avatar_m = dic5[@"avatar_m"];
                        _modelNext.ID = [dic4[@"id"] integerValue];
                       
                        
                        NSLog(@"-点击ID %ld",_modelNext.ID);
                        
                        if (_nextStart == 0) {
                            
                            NSDictionary *next_start = dic[@"data"];
                            _modelNext.next_start =  [next_start[@"next_start"] integerValue];
                            _nextStart = _modelNext.next_start;
                            NSLog(@"----------首次%ld",_nextStart);
                            
                        }
                        [_nextDataArray addObject:_modelNext];
                        [kRecimmendData insertIntoRecommendThreeModel:_modelNext];
                    }

                }
                    break;
                    
                default:
                    break;
            }
            
        }
        //将最终获取数组的三个小的model数组添加到我们的大数组中的
    
        [self.dataArray removeAllObjects];
        [self.dataArray addObject:_imageAarray];
        [self.dataArray addObject:_storyArray];
        [self.dataArray addObject:_nextDataArray];
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
        
        
    }];
    
    

    
}

- (void)loadRequestNextData
{
    
    __block NSInteger newIndex = 0;
    if (_nextStart == 0) {
     TravelNotesModel *model = _nextDataArray[0];
       newIndex = model.next_start;
    }else{
        
       newIndex = _nextStart;
    
    }
    NSLog(@"_________________%ld",newIndex);
    NSString *urlStr = [NSString stringWithFormat:@"http://api.breadtrip.com/v2/index/?next_start=%ld",newIndex];
    NSLog(@"_________________%ld",newIndex);
    [NetWorkHandle getDataWithURLString:urlStr compare:^(id object) {
        
       NSDictionary *dic = object;
        NSDictionary *next_start = dic[@"data"];
        NSArray *array =  next_start[@"elements"];
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSDictionary *dict in array) {
            
            NSArray *arrData = dict[@"data"];
            for (NSDictionary *d in arrData) {
                
                _modelNext = [[TravelNotesModel alloc] initWithDictionary:d];
                
                _modelNext.index_title = d[@"name"];
                NSDictionary *dic5 = d[@"user"];
                _modelNext.name = dic5[@"name"];
                _modelNext.avatar_m = dic5[@"avatar_m"];
                
                _modelNext.ID = [d[@"id"] integerValue];
                
            }
            
            [arr addObject:_modelNext];
        }
        
        _nextStart =  [next_start[@"next_start"] integerValue];
        NSLog(@"--------下拉的参数：%ld",_nextStart);
       
       // newIndex = _nextStart;
        [self.dataArray[2] addObjectsFromArray:arr];
        [self.tableView reloadData];
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end




