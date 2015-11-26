//
//  LocationViewController.h
//  GoTravel
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

@interface LocationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property (weak, nonatomic) IBOutlet UIButton *followingBtn;
@property (weak, nonatomic) IBOutlet UIButton *followHeadBtn;

@property (weak, nonatomic) IBOutlet UIButton *stopBtn;

- (IBAction)startLocation:(UIButton *)sender;

- (IBAction)startFollowing:(UIButton *)sender;
- (IBAction)stopLocation:(UIButton *)sender;
-(IBAction)startFollowHeading:(id)sender;


@end
