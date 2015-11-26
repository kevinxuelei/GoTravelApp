//
//  GeneralMapViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/22.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "GeneralMapViewController.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface GeneralMapViewController ()

@property(nonatomic,strong)BMKMapView* mapView;

@end

@implementation GeneralMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置地图的view
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];


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
