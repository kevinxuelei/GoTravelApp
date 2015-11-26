//
//  MPLocationViewController.h
//  GoTravel
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapCalloutAnnotion.h"
#import "MapCalloutAnnotationView.h"

@interface MPLocationViewController : UIViewController

@property(nonatomic,strong)MapCalloutAnnotion *model;

@property(nonatomic,strong)MapCalloutAnnotationView *mapCallputView;

@property(nonatomic,copy)NSString *mapName;

@property(nonatomic,copy)NSString *mapImage;

//当前店铺的纬度
@property(nonatomic,copy)NSString *latitude;
//当前店铺的经度
@property(nonatomic,copy)NSString *Longitude;





@end
