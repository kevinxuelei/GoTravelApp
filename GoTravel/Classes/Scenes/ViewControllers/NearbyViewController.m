//
//  NearbyViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "NearbyViewController.h"
#import "NearbyTableViewModel.h"
#import "AllNearbyDetailTableViewController.h"
#import "TabBarButton.h"

#import "AllNearbyTableViewController.h"
#import "EntertainmentNearbyTableViewController.h"
#import "HostalNearbyTableViewController.h"
#import "RestaurantNearbyTableViewController.h"
#import "SceneryNearbyTableViewController.h"
#import "ShoppingNearbyTableViewController.h"
#import "GeneralMapViewController.h"
#import "LocationViewController.h"

#import <BaiduMapAPI_Location/BMKLocationComponent.h>


#import "AllMapViewController.h"
#import "AllNearbyTableViewController.h"

#define kButtonX  20
#define kButtonW 60
#define kButtonH 30
#define kButtonInterval 100
#define kRandomColor arc4random()%255/256.0

@interface NearbyViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)BMKLocationService *locService;
@property(nonatomic,strong)BMKMapView* mapView;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *buttonView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIScrollView *detailScrollView;
//声明一个UIPageControl的属性
@property(nonatomic,retain)UIPageControl *pageControl;

@property(nonatomic,strong)UIButton *button;


@property(nonatomic,strong)UIView *viewOne;
@property(nonatomic,strong)UIView *viewTwo;
@property(nonatomic,assign)int index;


@property(nonatomic,assign)CLLocationDegrees latitude;
@property(nonatomic,assign)CLLocationDegrees longitude;

@end



@implementation NearbyViewController


-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"附近";

    
    
//    //显示的时按钮的UIScrollView
//    [self loadScrollView];
//    //下面显示详情的UIdetailScrollView32
//    [self loadDetailScrollView];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    // 第三步：指定UITableView的两个代理方法的代理人
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 第四步：添加到self.view 上
    [self.view addSubview:self.tableView];

    _mapView.delegate = self;
    
   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self loadLocationService];
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    

    
    
}

#pragma mark ----定位服务的方法
-(void)loadLocationService
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    

    
}



//#pragma mark ---开启定位的代理方法
//- (void)willStartLocatingUser
//{
//    NSLog(@"start locate");
//}

#pragma mark ---处理坐标位置更新
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
//    NSLog(@"heading is %@",userLocation.heading);
}

#pragma mark ---处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];

    self.latitude = userLocation.location.coordinate.latitude;
    self.longitude = userLocation.location.coordinate.longitude;
    
//    [_locService stopUserLocationService];

}

#pragma mark ---在地图View停止定位后,调用此代理方法
- (void)didStopLocatingUser
{

}






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
    static NSString *str = @"abc";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
//    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bj"]];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
            self.viewOne = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 280)];
//            _viewOne.backgroundColor = [UIColor orangeColor];
            [cell.contentView addSubview:_viewOne];
         cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

           [self loadScrollView];
            [self loadPagecontrol];
           [self loadButton];
        
        }
 
    return cell;
        
      }
    else if (indexPath.row == 1) {
        
        static NSString *str1 = @"twocell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str1];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str1];
        
        
            self.viewTwo = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.height/2)];
            [cell.contentView addSubview:_viewTwo];
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 30)];
            label.text = @"附近地图:";
            [self.viewTwo addSubview:label];
            
            
            //设置地图的view
            self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 40, self.viewTwo.frame.size.width, self.viewTwo.frame.size.height -40)];
 
            [self.viewTwo addSubview:self.mapView];
            //切换为普通地图
                [_mapView setMapType:BMKMapTypeStandard];
            //在地图上添加手势
            [self addCustomGestures];
            
          }
     
    
        return cell;
        
    }
    return 0;
    
}

#pragma mark ----设置ScrollView
-(void)loadScrollView
{
    
    UIImageView *travelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewOne.frame.size.width ,60)];
    travelImageView.image = [UIImage imageNamed:@"goTravel"];
    [self.viewOne addSubview:travelImageView];
    travelImageView.backgroundColor = [UIColor orangeColor];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,40, self.viewOne.frame.size.width, 120)];

    self.scrollView.contentSize = CGSizeMake(self.viewOne.frame.size.width *2, -10);
    self.scrollView.delegate  = self;
    //是否整平翻动
    self.scrollView.pagingEnabled = YES;
    //设置边框是否回弹
    self.scrollView.bounces = NO;
    
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.bounces = NO;
    [self.viewOne addSubview:_scrollView];

}

#pragma mark ----设置Pagecontrol
-(void)loadPagecontrol
{
    //UIPageControl的初始化方法
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame) - 20, self.viewOne.frame.size.width , 50)];

    //指定页面的个数
    self.pageControl.numberOfPages = 2;
    //指定当前页
    self.pageControl.currentPage = 0;
    [self.viewOne  addSubview:self.pageControl];
    //设置背景色
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    
    //UIPageControl的addTarget/action事件
    [self.pageControl addTarget:self action:@selector(pageAction) forControlEvents:UIControlEventTouchUpInside];
    
}
//此为addtarget/action的事件执行
-(void)pageAction
{
    //通过pageControl当前页乘以宽度,计算出当前的偏移量,从而通过偏移量的变化实现相片的变化
    [self.scrollView setContentOffset:CGPointMake(self.pageControl.currentPage*self.view.frame.size.width, 0) animated:YES];
}
//代理的实现方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //利用偏移量计算计算出当前是第几张图片
    NSInteger index = self.scrollView.contentOffset.x/self.viewOne.frame.size.width;
    //然后将计算出的第几张图片的下标赋给currentPage,从而实现图片切换
    self.pageControl.currentPage = index;
}


#pragma mark ---设置按钮
-(void)loadButton
{
    [self creatButtonWithNormalName:@"iconfont-jingdianxiangqingyejingdianjieshao" andSelectName:@"iconfont-jingdianxiangqingyejingdianjieshao" andTitle:@"全部" andIndex:0];
    [self creatButtonWithNormalName:@"iconfont-lvyou-1" andSelectName:@"iconfont-lvyou-1" andTitle:@"景点" andIndex:1];
    [self creatButtonWithNormalName:@"iconfont-zhusu-1" andSelectName:@"iconfont-zhusu-1" andTitle:@"住宿" andIndex:2];
    [self creatButtonWithNormalName:@"iconfont-canting" andSelectName:@"iconfont-canting" andTitle:@"餐厅" andIndex:3];
    [self creatButtonWithNormalName:@"iconfont-xiuxianyule-1" andSelectName:@"iconfont-xiuxianyule-1" andTitle:@"休闲娱乐" andIndex:4];
    [self creatButtonWithNormalName:@"iconfont-gouwu" andSelectName:@"iconfont-gouwu" andTitle:@"购物" andIndex:5];

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row ==0) {
        return self.view.frame.size.height/3  ;
    }  else if (indexPath.row ==1){
        
    return self.view.frame.size.height/2 +20 ;
    }
    return 0;
}

-(void)buttonImage
{
//    UIView *viewOne = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 80, 100)];
//    viewOne.backgroundColor = [UIColor redColor];
//    [self.viewOne addSubview:viewOne];
    
}
#pragma mark 创建一个按钮
- (void)creatButtonWithNormalName:(NSString *)normal andSelectName:(NSString *)selected andTitle:(NSString *)title andIndex:(int)index
    {
        /*
         TabBarButton是自定义的一个继承自UIButton的类，自定义该类的目的是因为系统自带的Button可以设置image和title属性，但是默认的image是在title的左边，若想想上面图片中那样，将image放在title的上面，就需要自定义Button，设置一些东西。       */
        
        TabBarButton *button = [TabBarButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        
        CGFloat buttonW = self.viewOne.frame.size.width / 3;
        CGFloat buttonH = self.viewOne.frame.size.height/3 + 20;
            button.frame = CGRectMake(buttonW * index, 0, buttonW, buttonH);

        [button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selected] forState:UIControlStateDisabled];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        
        [button addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchDown];
        
        button.imageView.contentMode = UIViewContentModeCenter; // 让图片在按钮内居中
        button.titleLabel.textAlignment = NSTextAlignmentCenter; // 让标题在按钮内居中
        
        
        button.font = [UIFont systemFontOfSize:15]; // 设置标题的字体大小
        
        [self.scrollView addSubview:button];
    }

- (void)changeView:(TabBarButton *)sender
{
//   sender.tag; //切换不同控制器的界面
    if (sender.tag ==0) {
        AllNearbyTableViewController *allView = [[AllNearbyTableViewController alloc] init];
        [self.navigationController pushViewController:allView animated:YES];
#pragma mark ---传递定位信息的地方
        allView.latitude = self.latitude;
        allView.longitude = self.longitude;
        
    }
    else if (sender.tag == 1){
        SceneryNearbyTableViewController *allView = [[SceneryNearbyTableViewController alloc] init];
        [self.navigationController pushViewController:allView animated:YES];
        allView.latitude = self.latitude;
        allView.longitude = self.longitude;
        
    } else if (sender.tag == 2){
        HostalNearbyTableViewController *allView = [[HostalNearbyTableViewController alloc] init];
        [self.navigationController pushViewController:allView animated:YES];
        allView.latitude = self.latitude;
        allView.longitude = self.longitude;
        
    }  else if (sender.tag == 3){
        RestaurantNearbyTableViewController *allView = [[RestaurantNearbyTableViewController alloc] init];
        [self.navigationController pushViewController:allView animated:YES];
        allView.latitude = self.latitude;
        allView.longitude = self.longitude;
        
    }  else if (sender.tag ==4){
        EntertainmentNearbyTableViewController *allView = [[EntertainmentNearbyTableViewController alloc] init];
        [self.navigationController pushViewController:allView animated:YES];
        allView.latitude = self.latitude;
        allView.longitude = self.longitude;
        
    }  else if (sender.tag == 5){
            ShoppingNearbyTableViewController *allView = [[ShoppingNearbyTableViewController alloc] init];
            [self.navigationController pushViewController:allView animated:YES];
        allView.latitude = self.latitude;
        allView.longitude = self.longitude;
        
        
        }

}

#pragma mark ---添加手势
- (void)addCustomGestures {
    /*
     *注意：
     *添加自定义手势时，必须设置UIGestureRecognizer的属性cancelsTouchesInView 和 delaysTouchesEnded 为NO,
     *否则影响地图内部的手势处理
     */
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.cancelsTouchesInView = NO;
    doubleTap.delaysTouchesEnded = NO;
    
    [self.mapView addGestureRecognizer:doubleTap];
    
   
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)theDoubleTap {
    /*
     *do something
     */
    


    LocationViewController *locationMapVC = [[LocationViewController alloc] init];
        [self.navigationController pushViewController:locationMapVC animated:YES];
}




















@end
