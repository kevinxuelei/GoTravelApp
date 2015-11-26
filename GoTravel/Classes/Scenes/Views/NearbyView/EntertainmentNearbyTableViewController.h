//
//  EntertainmentNearbyTableViewController.h
//  GoTravel
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <CoreLocation/CLAvailability.h>

@interface EntertainmentNearbyTableViewController : UITableViewController

{
    //在文件的.h中声明三个属性
    BOOL isReshing;//用来判断是个正在刷新
    BOOL isLoading;//用来判断是个正在加载
    NSInteger _nextStart;//网络请求加载的参数
}
@property(nonatomic,assign)CLLocationDegrees latitude;
@property(nonatomic,assign)CLLocationDegrees longitude;


@end
