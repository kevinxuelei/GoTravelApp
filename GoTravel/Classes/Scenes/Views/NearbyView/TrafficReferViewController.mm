//
//  TrafficReferViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "TrafficReferViewController.h"



#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface BusLineAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation BusLineAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end



@implementation TrafficReferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置地图的view(这里必须对地图的大小设置否则无法显示)
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height - 120)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    
    _mapView.delegate = self;
    _buslinesearch = [[BMKBusLineSearch alloc]init];
    _buslinesearch.delegate = self;
    _poisearch = [[BMKPoiSearch alloc]init];
    _poisearch.delegate = self;
    
    _currentIndex = -1;
    _busPoiArray = [[NSMutableArray alloc]init];
    _cityText.text = @"北京";
    _busLineText.text  = @"717";
    
    _buslinesearch.delegate = self;
    
    _buslinesearch.delegate = self;
    
    // 设置地图级别
    //    [_mapView setZoomLevel:13];
    
    
    
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
}


//#pragma mark ---在地图View停止定位后,调用此代理方法
//- (void)didStopLocatingUser
//{
//    NSLog(@"stop locate");
//}
//
//#pragma mark ---定位失败后,调用此代理方法
//- (void)didFailToLocateUserWithError:(NSError *)error
//{
//    NSLog(@"location error");
//}












- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}


- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(BusLineAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        default:
            break;
    }
    
    return view;
}

#pragma mark -
#pragma mark imeplement BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BusLineAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(BusLineAnnotation*)annotation];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKPoiInfo* poi = nil;
        BOOL findBusline = NO;
        for (NSInteger i = 0; i < result.poiInfoList.count; i++) {
            poi = [result.poiInfoList objectAtIndex:i];
            if (poi.epoitype == 2 || poi.epoitype == 4) {
                findBusline = YES;
                [_busPoiArray addObject:poi];
            }
        }
        //开始bueline详情搜索
        if(findBusline)
        {
            _currentIndex = 0;
            NSString* strKey = ((BMKPoiInfo*) [_busPoiArray objectAtIndex:_currentIndex]).uid;
            BMKBusLineSearchOption *buslineSearchOption = [[BMKBusLineSearchOption alloc]init];
            buslineSearchOption.city= _cityText.text;
            buslineSearchOption.busLineUid= strKey;
            BOOL flag = [_buslinesearch busLineSearch:buslineSearchOption];
            if(flag)
            {
                NSLog(@"busline检索发送成功");
            }
            else
            {
                NSLog(@"busline检索发送失败");
            }
            
        }
    }
}

- (void)onGetBusDetailResult:(BMKBusLineSearch*)searcher result:(BMKBusLineResult*)busLineResult errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        
        BusLineAnnotation* item = [[BusLineAnnotation alloc]init];
        
        //站点信息
        NSInteger size = 0;
        size = busLineResult.busStations.count;
        for (NSInteger j = 0; j < size; j++) {
            BMKBusStation* station = [busLineResult.busStations objectAtIndex:j];
            item = [[BusLineAnnotation alloc]init];
            item.coordinate = station.location;
            item.title = station.title;
            item.type = 2;
            [_mapView addAnnotation:item];
        }
        
        
        //路段信息
        NSInteger index = 0;
        //累加index为下面声明数组temppoints时用
        for (NSInteger j = 0; j < busLineResult.busSteps.count; j++) {
            BMKBusStep* step = [busLineResult.busSteps objectAtIndex:j];
            index += step.pointsCount;
        }
#warning 这里有问题,请注意这里要将文件后缀名改为.mm
        //直角坐标划线
        BMKMapPoint * temppoints = new BMKMapPoint[index];
        NSInteger k=0;
        for (NSInteger i = 0; i < busLineResult.busSteps.count; i++) {
            BMKBusStep* step = [busLineResult.busSteps objectAtIndex:i];
            for (NSInteger j = 0; j < step.pointsCount; j++) {
                BMKMapPoint pointarray;
                pointarray.x = step.points[j].x;
                pointarray.y = step.points[j].y;
                temppoints[k] = pointarray;
                k++;
            }
        }
        
        
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:index];
        [_mapView addOverlay:polyLine];
        delete temppoints;
        
        BMKBusStation* start = [busLineResult.busStations objectAtIndex:0];
        [_mapView setCenterCoordinate:start.location animated:YES];
        
    }
}


- (IBAction)onClickBusLineSearch:(UIButton *)sender {
    [_busPoiArray removeAllObjects];
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= _cityText.text;
    citySearchOption.keyword = _busLineText.text;
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }

    
    
}

- (IBAction)onClickNextSearch:(UIButton *)sender {
    
    if (_busPoiArray.count > 0) {
        if (++_currentIndex >= _busPoiArray.count) {
            _currentIndex -= _busPoiArray.count;
        }
        NSString* strKey = ((BMKPoiInfo*) [_busPoiArray objectAtIndex:_currentIndex]).uid;
        BMKBusLineSearchOption *buslineSearchOption = [[BMKBusLineSearchOption alloc]init];
        buslineSearchOption.city= _cityText.text;
        buslineSearchOption.busLineUid= strKey;
        BOOL flag = [_buslinesearch busLineSearch:buslineSearchOption];
        if(flag)
        {
            NSLog(@"busline检索发送成功");
        }
        else
        {
            NSLog(@"busline检索发送失败");
        }
    }
    else {
        BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
        citySearchOption.pageIndex = 0;
        citySearchOption.pageCapacity = 10;
        citySearchOption.city= _cityText.text;
        citySearchOption.keyword = _busLineText.text;
        BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
        if(flag)
        {
            NSLog(@"城市内检索发送成功");
        }
        else
        {
            NSLog(@"城市内检索发送失败");
        }
        
    }

    
    
}

- (IBAction)textFiledReturnEditing:(UITextField *)sender {
    
     [sender resignFirstResponder];
    
    
}



@end




