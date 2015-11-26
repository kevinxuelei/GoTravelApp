//
//  MapCalloutAnnotationView.h
//  GoTravel
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapCalloutAnnotion.h"

@interface MapCalloutAnnotationView : MKAnnotationView

@property (nonatomic ,strong) UIView *backgroundView;
@property (nonatomic ,strong) UIImageView *iconView;
@property (nonatomic ,strong) UILabel *detailLabel;
@property (nonatomic ,strong) UIImageView *rateView;


@property (nonatomic ,strong) MapCalloutAnnotion *annotation;

#pragma mark 从缓存取出标注视图
+(instancetype)calloutViewWithMapView:(MKMapView *)mapView;

-(void)binModel;

@end
