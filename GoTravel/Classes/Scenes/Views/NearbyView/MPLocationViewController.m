//
//  MPLocationViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "MPLocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "AllNearbyDetailTableViewController.h"
#import "MapAnnotation.h"
#import "MapCalloutAnnotion.h"
#import "UIImageView+WebCache.h"
#import "NetWorkHandle.h"


#include "MapCalloutAnnotationView.h"



@interface MPLocationViewController ()<MKMapViewDelegate>
{
    CLLocationManager *_locationManager;
    MKMapView *_mapView;

}

//@property(nonatomic,copy)NSString *encodedPoints;

@property(nonatomic,strong)MKPolylineView *routeLineView;

@property(nonatomic,strong)MKPolyline *routeLine;

@property(nonatomic,strong)MapAnnotation *annotation1;
@property(nonatomic,strong)MapAnnotation *annotation2;


@end

@implementation MPLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNavigation];

  [self initGUI];

}

//导航栏的设置
-(void)loadNavigation
{
   
    self.navigationItem.title = [NSString stringWithFormat:@"当前位置-->%@",self.mapName];
    
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-arrows"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBackClick)];
    

}

//navigationItem左边的返回按钮
-(void)leftBackClick
{
    AllNearbyDetailTableViewController * AllNearbyDetailTVC = [[AllNearbyDetailTableViewController alloc] init];
    
    [self dismissViewControllerAnimated:AllNearbyDetailTVC completion:^{
        
    }];
    
    
}






#pragma mark 添加地图控件
-(void)initGUI{

    _mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    _mapView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_mapView];
    //设置代理
    _mapView.delegate=self;
    
    //请求定位服务
    _locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
    
    //添加大头针
    [self addAnnotation];
}

#pragma mark 添加大头针
-(void)addAnnotation{
    
    float a = [[NSString stringWithFormat:@"%@",self.latitude] floatValue];
    float b = [[NSString stringWithFormat:@"%@",self.Longitude] floatValue];
    
   //相似类型的店家的地理位置
    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(a + 0.01, b +0.01);
    CLLocation *maplocation1 = [[CLLocation alloc] initWithLatitude:a + 0.01 longitude:b +0.01];
    self.annotation1=[[MapAnnotation alloc]init];

    _annotation1.coordinate=location1;
    _annotation1.image=[UIImage imageNamed:@"icon_pin_floating.png"];
    _annotation1.icon=[UIImage imageNamed:@"icon_mark2.png"];
    _annotation1.detail=@"类似店铺一家……";
    _annotation1.rate=[UIImage imageNamed:@"icon_Movie_Star_rating.png"];
    [_mapView addAnnotation:_annotation1];

       //详细坐标地理位置
        CLLocationCoordinate2D location2=CLLocationCoordinate2DMake( a, b);
    self.annotation2=[[MapAnnotation alloc]init];
     CLLocation *maplocation2 = [[CLLocation alloc] initWithLatitude:a longitude:b];

    _annotation2.coordinate=location2;
    _annotation2.image=[UIImage imageNamed:@"icon_paopao_waterdrop_streetscape.png"];
    _annotation2.icon=[UIImage imageNamed:@"icon_mark1.png"];

    
    _annotation2.detail = self.mapName;
    _annotation2.rate=[UIImage imageNamed:@"icon_Movie_Star_rating.png"];
    [_mapView addAnnotation:_annotation2];
    
    
//#warning 给定两个坐标位置，然后调用画线方法就可以实现两点间的画线
//    NSArray *array = [NSArray arrayWithObjects:maplocation1, maplocation2, nil];
//    [self drawLineWithLocationArray:array];
    
    
}

#pragma mark - 地图控件代理方法
#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[MapAnnotation class]]) {
        static NSString *key1=@"AnnotationKey1";
        MKAnnotationView *annotationView=[_mapView dequeueReusableAnnotationViewWithIdentifier:key1];
        //如果缓存池中不存在则新建
        if (!annotationView) {
            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
            //            annotationView.canShowCallout=true;//允许交互点击
            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_classify_cafe.png"]];//定义详情左侧视图
        }
        
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation=annotation;
        annotationView.image=((MapAnnotation *)annotation).image;//设置大头针视图的图片
        
        return annotationView;
    }
    else if([annotation isKindOfClass:[MapCalloutAnnotion class]]){
        
        //对于作为弹出详情视图的自定义大头针视图无弹出交互功能（canShowCallout=false，这是默认值），在其中可以自由添加其他视图（因为它本身继承于UIView）
        
        MapCalloutAnnotationView *calloutView=[MapCalloutAnnotationView calloutViewWithMapView:mapView];
        calloutView.annotation=annotation;
        return calloutView;
    }
       else {
           return nil;
        
    }
    
    
}

#pragma mark 选中大头针时触发
//点击一般的大头针MapAnnotation时添加一个大头针作为所点大头针的弹出详情视图
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    MapAnnotation *annotation=view.annotation;
    if ([view.annotation isKindOfClass:[MapAnnotation class]]) {
        //点击一个大头针时移除其他弹出详情视图
        //        [self removeCustomAnnotation];
        //添加详情大头针，渲染此大头针视图时将此模型对象赋值给自定义大头针视图完成自动布局
        MapCalloutAnnotion *annotation1=[[MapCalloutAnnotion alloc]init];
        annotation1.icon=annotation.icon;
        annotation1.detail=annotation.detail;
        annotation1.rate=annotation.rate;
        annotation1.coordinate=view.annotation.coordinate;
        [mapView addAnnotation:annotation1];
    }
}

#pragma mark 取消选中时触发
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    [self removeCustomAnnotation];
}

#pragma mark 移除所用自定义大头针
-(void)removeCustomAnnotation{
    [_mapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[MapCalloutAnnotion class]]) {
            [_mapView removeAnnotation:obj];
        }
    }];
}

#pragma mark - 地图控件代理方法
#pragma mark 更新用户位置，只要用户改变则调用此方法（包括第一次定位到用户位置）
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    NSLog(@"%@",userLocation);
    //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
        MKCoordinateSpan span=MKCoordinateSpanMake(1, 1);
        MKCoordinateRegion region=MKCoordinateRegionMake(userLocation.location.coordinate, span);
        [_mapView setRegion:region animated:true];
}


#pragma amrk ----MKMapView提供了addOverlay功能（以及addAnnotation），让我们可以在地图上放一层遮罩。如果要放一组遮罩，可以用addOverlays。
- (void)drawLineWithLocationArray:(NSArray *)locationArray
{
    NSInteger pointCount = [locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    [_mapView setVisibleMapRect:[self.routeLine boundingMapRect]];
    [_mapView addOverlay:self.routeLine];
    
}


#pragma amrk ---MKPolyLine为我们提供了方便绘制多条线段的功能，它实现了MKOverlay协议，但并不能作为遮罩。我们需要实现相应的遮罩代理方法：
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if(overlay == self.routeLine) {
        if(nil == self.routeLineView) {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 8;
        }
        return self.routeLineView;
    }
    return nil;
}

//-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t
//{
//    NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
//    NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
//    
//    NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
//    NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
//    NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl];
////    NSString* encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
//    self.encodedPoints = [NSString string];
//    [NetWorkHandle getDataWithURLString:apiResponse compare:^(id object) {
//          _encodedPoints = object;
//
//        
//    }];
//    return [self decodePolyLine:[_encodedPoints mutableCopy]:f to:t];
//}










@end






