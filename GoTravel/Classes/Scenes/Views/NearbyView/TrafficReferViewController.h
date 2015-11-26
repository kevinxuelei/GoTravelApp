//
//  TrafficReferViewController.h
//  GoTravel
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "UIImage+Rotate.h"

@interface TrafficReferViewController : UIViewController<BMKMapViewDelegate,BMKBusLineSearchDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cityText;
@property (weak, nonatomic) IBOutlet UITextField *busLineText;
- (IBAction)onClickBusLineSearch:(UIButton *)sender;
- (IBAction)onClickNextSearch:(UIButton *)sender;
- (IBAction)textFiledReturnEditing:(UITextField *)sender;


@property(nonatomic,strong)BMKLocationService *locService;

@property(nonatomic,strong)BMKMapView *mapView;

@property(nonatomic,assign)int currentIndex;

@property(nonatomic,strong)BMKPoiSearch* poisearch;

@property(nonatomic,strong)BMKBusLineSearch* buslinesearch;

@property(nonatomic,strong)BMKPointAnnotation* annotation;

@property(nonatomic,copy)NSMutableArray* busPoiArray;


@end
