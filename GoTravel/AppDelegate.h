//
//  AppDelegate.h
//  GoTravel
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{

    BMKMapManager* _mapManager;
}
@property (strong, nonatomic) UIWindow *window;

@end

