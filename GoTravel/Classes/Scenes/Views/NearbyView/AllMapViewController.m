//
//  AllMapViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "AllMapViewController.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import "LocationViewController.h"
#import "FoodReferViewController.h"
#import "EntertainmentReferViewController.h"
#import "ShopingReferViewController.h"
#import "TrafficReferViewController.h"
#import "RouteReferViewController.h"


@interface AllMapViewController ()

@property(nonatomic,strong)BMKMapView* mapView;

@end

@implementation AllMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //设置地图的view
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height - 120)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(300, 400, 40, 40);
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    
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

- (IBAction)positionButton:(UIButton *)sender {
    LocationViewController *locationVC = [[LocationViewController alloc] init];
//    UINavigationController *locationNV = [[UINavigationController alloc] initWithRootViewController:locationVC];
//    [self presentViewController:locationNV animated:YES completion:nil];
    [self.navigationController pushViewController:locationVC animated:YES];
    
}

- (IBAction)foodButton:(UIButton *)sender {
    FoodReferViewController *foodReferVC = [[FoodReferViewController alloc] init];
    [self.navigationController  pushViewController:foodReferVC animated:YES];
    
    
}

- (IBAction)entertainment:(UIButton *)sender {
    EntertainmentReferViewController *entertainmentReferVC = [[EntertainmentReferViewController alloc] init];
    [self.navigationController pushViewController:entertainmentReferVC animated:YES];
    
    
}

- (IBAction)shopingButton:(UIButton *)sender {
    
    ShopingReferViewController *shopRederVc = [[ShopingReferViewController alloc] init];
    [self.navigationController pushViewController:shopRederVc animated:YES];
    
}

- (IBAction)trafficButton:(UIButton *)sender {
    TrafficReferViewController *trafficReferVC = [[TrafficReferViewController alloc] init];
    [self.navigationController pushViewController:trafficReferVC animated:YES];
    
    
}

- (IBAction)routwButotn:(UIButton *)sender {
    
    RouteReferViewController *routeReferVC = [[RouteReferViewController alloc]init];
    [self.navigationController pushViewController:routeReferVC animated:YES];
    
    
}
@end
