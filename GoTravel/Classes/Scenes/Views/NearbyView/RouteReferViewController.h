//
//  RouteReferViewController.h
//  GoTravel
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>


@interface RouteReferViewController : UIViewController <BMKMapViewDelegate, BMKRouteSearchDelegate,BMKLocationServiceDelegate>

@property(nonatomic,strong)BMKLocationService *locService;

//地图的显示
@property(nonatomic,strong)BMKMapView *mapView;

@property(nonatomic,strong)BMKRouteSearch *routesearch;

@property (weak, nonatomic) IBOutlet UITextField *startCityText;
@property (weak, nonatomic) IBOutlet UITextField *startAddrText;
@property (weak, nonatomic) IBOutlet UITextField *endCityText;
@property (weak, nonatomic) IBOutlet UITextField *endAddrText;

- (IBAction)onClickBusSearch;


- (IBAction)onClickDriveSearch;


- (IBAction)onClickWalkSearch;

- (IBAction)textFiledReturnEditing:(UITextField *)sender;







@end
