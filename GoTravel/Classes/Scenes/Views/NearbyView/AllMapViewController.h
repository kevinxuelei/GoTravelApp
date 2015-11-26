//
//  AllMapViewController.h
//  GoTravel
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

@interface AllMapViewController : UIViewController

- (IBAction)positionButton:(UIButton *)sender;

- (IBAction)foodButton:(UIButton *)sender;

- (IBAction)entertainment:(UIButton *)sender;

- (IBAction)shopingButton:(UIButton *)sender;

- (IBAction)trafficButton:(UIButton *)sender;

- (IBAction)routwButotn:(UIButton *)sender;


@end
