//
//  LocationViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "LocationViewController.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "DCPathButton.h"

#import "FoodReferViewController.h"
#import "EntertainmentReferViewController.h"
#import "ShopingReferViewController.h"
#import "TrafficReferViewController.h"
#import "RouteReferViewController.h"






@interface LocationViewController () <BMKMapViewDelegate,BMKLocationServiceDelegate,DCPathButtonDelegate>

@property(nonatomic,strong)BMKLocationService *locService;

@property(nonatomic,strong)BMKMapView* mapView;

@property(nonatomic,strong)DCPathButton *dcPathButton;


@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置地图的view
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    _mapView.delegate = self;

    
    [self loadPiontAnnotation];
    [self loadLocationService];
    [self loadMoveButton];
    
    
}


-(void)loadMoveButton
{
    self.view.frame = CGRectMake(0, 0,self.view.frame.size.width *0.8,self.view.frame.size.height/4 +10);
    _dcPathButton = [[DCPathButton alloc]
                                  initDCPathButtonWithSubButtons:6
                                  totalRadius:60
                                  centerRadius:20
                                  subRadius:15
                                  centerImage:@"iconfont-jiahao"
                                  centerBackground:nil
                                  subImages:^(DCPathButton *dc){
                                      [dc subButtonImage:@"iconfont-dingwei11" withTag:0];
                                      [dc subButtonImage:@"iconfont-meishiicon" withTag:1];
                                      [dc subButtonImage:@"iconfont-yule" withTag:2];
                                      [dc subButtonImage:@"iconfont-gouwu" withTag:3];
                                      [dc subButtonImage:@"iconfont-llroutebusicon" withTag:4];
                                      [dc subButtonImage:@"iconfont-xianlu" withTag:5];
                                  }
                                  subImageBackground:nil
                                  inLocationX:0 locationY:0 toParentView:self.view];
    _dcPathButton.delegate = self;
    
    // Do any additional setup after loading the view, typically from a nib.

}
#pragma mark - DCPathButton delegate
//定位按钮
static int a = 0;
- (void)button_0_action{
    NSLog(@"Button Press Tag 0 定位!!");
    if (a == 0) {
        [self.view sendSubviewToBack:self.mapView];
        a++;
    }else{
        a--;
        
        [self.view insertSubview:self.mapView atIndex:1];
    }
    
    
}

- (void)button_1_action{
    NSLog(@"Button Press Tag 1!!");
    FoodReferViewController *foodReferVC = [[FoodReferViewController alloc] init];
    [self.navigationController pushViewController:foodReferVC animated:YES];
    
    [self.view bringSubviewToFront:self.mapView];
    [self.mapView addSubview:_dcPathButton];
    
}

- (void)button_2_action{
    NSLog(@"Button Press Tag 2!!");
    EntertainmentReferViewController *entertainmentReferVC = [[EntertainmentReferViewController alloc] init];
    [self.navigationController pushViewController:entertainmentReferVC animated:YES];
    [self.view bringSubviewToFront:self.mapView];
    [self.mapView addSubview:_dcPathButton];
}

- (void)button_3_action{
    NSLog(@"Button Press Tag 3!!");
    ShopingReferViewController *shopingReferVC = [[ShopingReferViewController alloc] init];
    [self.navigationController pushViewController:shopingReferVC animated:YES];
    [self.view bringSubviewToFront:self.mapView];
    [self.mapView addSubview:_dcPathButton];
}

- (void)button_4_action{
    NSLog(@"Button Press Tag 4!!");
    TrafficReferViewController *trafficReferVC = [[TrafficReferViewController alloc] init];
    [self.navigationController pushViewController:trafficReferVC animated:YES];
    [self.view bringSubviewToFront:self.mapView];
    [self.mapView addSubview:_dcPathButton];
}

- (void)button_5_action{
    NSLog(@"Button Press Tag 5!!");
    RouteReferViewController *routeReferVC = [[RouteReferViewController alloc] init];
    [self.navigationController pushViewController:routeReferVC animated:YES];
    [self.view bringSubviewToFront:self.mapView];
    [self.mapView addSubview:_dcPathButton];
}










#pragma mark ---大头针标注
-(void)loadPiontAnnotation
{
    // 添加一个PointAnnotation （添加一个大头针，并设位置位置）
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 39.915;
    coor.longitude = 116.404;
    annotation.coordinate = coor;
    annotation.title = @"这里是北京";
    [_mapView addAnnotation:annotation];
    

}
#pragma mark ---大头针的代理方法
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
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

}

#pragma mark ---处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}




- (IBAction)startLocation:(UIButton *)sender {
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    [_startBtn setEnabled:NO];
    [_startBtn setAlpha:0.6];
    [_stopBtn setEnabled:YES];
    [_stopBtn setAlpha:1.0];
    [_followHeadBtn setEnabled:YES];
    [_followHeadBtn setAlpha:1.0];
    [_followingBtn setEnabled:YES];
    [_followingBtn setAlpha:1.0];
 
}

- (IBAction)startFollowing:(UIButton *)sender {
    NSLog(@"进入跟随态");
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;

  
}

//罗盘态
-(IBAction)startFollowHeading:(id)sender
{
    NSLog(@"进入罗盘态");
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    _mapView.showsUserLocation = YES;
    
}


- (IBAction)stopLocation:(UIButton *)sender {
    [_locService stopUserLocationService];
    _mapView.showsUserLocation = NO;
    [_stopBtn setEnabled:NO];
    [_stopBtn setAlpha:0.6];
    [_followHeadBtn setEnabled:NO];
    [_followHeadBtn setAlpha:0.6];
    [_followingBtn setEnabled:NO];
    [_followingBtn setAlpha:0.6];
    [_startBtn setEnabled:YES];
    [_startBtn setAlpha:1.0];
  
}



@end





