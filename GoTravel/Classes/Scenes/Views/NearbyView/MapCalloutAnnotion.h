//
//  MapCalloutAnnotion.h
//  GoTravel
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapCalloutAnnotion : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy,readonly) NSString *title;
@property (nonatomic, copy,readonly) NSString *subtitle;

#pragma mark 左侧图标
@property (nonatomic,strong) UIImage *icon;
#pragma mark 详情描述
@property (nonatomic,copy) NSString *detail;
#pragma mark 星级评价
@property (nonatomic,strong) UIImage *rate;



@end
