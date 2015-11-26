//
//  EntertainmentReferViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "EntertainmentReferViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface EntertainmentReferViewController ()<BMKMapViewDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate>

@property(nonatomic,strong)BMKLocationService *locService;

@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,strong)BMKPoiSearch *poisearch;
@property(nonatomic,assign)int curPage;


@property (weak, nonatomic) IBOutlet UITextField *cityText;
@property (weak, nonatomic) IBOutlet UITextField *keyText;
@property (weak, nonatomic) IBOutlet UIButton *nextPageButton;
- (IBAction)onClickOk:(UIButton *)sender;
- (IBAction)onClickNextPage:(UIButton *)sender;
- (IBAction)textFiledReturnEditing:(UITextField *)sender;

@end

@implementation EntertainmentReferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置地图的view(这里必须对地图的大小设置否则无法显示)
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height - 120)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    
    //初始化检索对象
    _poisearch = [[BMKPoiSearch alloc] init];
    _poisearch.delegate = self;
    
    _cityText.text = @"北京";
    _keyText.text  = @"北海公园";
    // 设置地图级别
    [_mapView setZoomLevel:13];
    //    _nextPageButton.enabled = false;
    _mapView.isSelectedAnnotationViewFront = YES;
    
    //标准版地图显示(默认也是这个)
    [_mapView setMapType:BMKMapTypeStandard];
    
    
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




- (IBAction)onClickOk:(UIButton *)sender {
    
    _curPage = 0;
    
    //POI详情检索(发起城市检索)
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = _curPage;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= _cityText.text;
    citySearchOption.keyword = _keyText.text;
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        _nextPageButton.enabled = true;
//        NSLog(@"城市内检索发送成功");
    }
    else
    {
        _nextPageButton.enabled = false;
//        NSLog(@"城市内检索发送失败");
    }
 
    
}

- (IBAction)onClickNextPage:(UIButton *)sender {
    
    
    _curPage++;
    //城市内检索，请求发送成功返回YES，请求发送失败返回NO
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = _curPage;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= _cityText.text;
    citySearchOption.keyword = _keyText.text;
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        _nextPageButton.enabled = true;
//        NSLog(@"城市内检索发送成功");
    }
    else
    {
        _nextPageButton.enabled = false;
//        NSLog(@"城市内检索发送失败");
    }
  
}

- (IBAction)textFiledReturnEditing:(UITextField *)sender {
 
    [sender resignFirstResponder];
  
}


#pragma mark -
#pragma mark implement BMKMapViewDelegate 地图检索的相关代理方法

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}
#pragma mark ---当选中一个annotation(标注注释) views时，调用此接口
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}

#pragma mark ---当mapView新添加annotation views时，调用此接口
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}

#pragma mark -
#pragma mark implement BMKSearchDelegate代理方法
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [annotations addObject:item];
        }
        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}






@end






