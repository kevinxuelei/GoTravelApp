//
//  AppDelegate.m
//  GoTravel
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "TabBarViewController.h"
#import "UMSocial.h"
#import "SDWebImageManager.h"
// 屏幕的物理高度
#define  ScreenHeight  [UIScreen mainScreen].bounds.size.height

// 屏幕的物理宽度
#define  ScreenWidth   [UIScreen mainScreen].bounds.size.width


@interface AppDelegate ()<UIScrollViewDelegate>
{
    
    UIScrollView * _introduceView;
    UIImageView  * _firImageView;
    UIImageView  * _secImageView;
    UIImageView  * _thirdImageView;
    //    UIView       * _stopView;
    //    UIImageView  * _imageView;
    
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //百度地图
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"zlcHmqYGHw6R6pU1vGSuo4tE"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }


    //如果使用美国站点，请加上这行代码 [AVOSCloud useAVCloudUS];
    [AVOSCloud setApplicationId:@"Lc9b2CA1HedxJSvD3qBzFfVy"
                      clientKey:@"rWpyNbJpRzv84GF8Yzurii5l"];
    
    //跟踪统计应用的打开情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    TabBarViewController *myTB = [[TabBarViewController alloc] init];
    
    self.window.rootViewController = myTB;
    
    [self.window makeKeyAndVisible];
    
#pragma mark  window在执行完上面那句话之后才会产生,切记!切记!
    [self onlyOneAddIntroduceView];
    //友盟分享
    [UMSocialData setAppKey:@"5649e11ae0f55af3f00057ec"];
    //设置统一背影图
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nvImage"] forBarMetrics:UIBarMetricsDefault];
    
    return YES;    
}
#pragma mark - 引导页只执行一次
- (void)onlyOneAddIntroduceView{
    
    //  读取沙盒数据
    NSUserDefaults * settings1 = [NSUserDefaults standardUserDefaults];
    NSString *key1 = @"is_first";
    NSString *value = [settings1 objectForKey:key1];
    //  如果没有数据
    if (!value)
    {
        //  加入引导页
        [self addIntroduceView];
        //  写入数据
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        NSString * key = @"is_first";
        [setting setObject:[NSString stringWithFormat:@"false"] forKey:key];
        [setting synchronize];
    }
    
}


#pragma mark - 添加引导页效果
- (void)addIntroduceView{
    
    _introduceView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _introduceView.showsHorizontalScrollIndicator = NO;
    _introduceView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    _introduceView.pagingEnabled = YES;
    _introduceView.bounces = NO;
    _introduceView.delegate = self;
    [self.window addSubview:_introduceView];
    
    _thirdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*2, 0, ScreenWidth, ScreenHeight)];
    _thirdImageView.image = [UIImage imageNamed:@"xialafengjing "];
    _thirdImageView.userInteractionEnabled = YES;
    [_introduceView addSubview:_thirdImageView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [_thirdImageView addGestureRecognizer:tapGestureRecognizer];
    
    _secImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight)];
    _secImageView.image = [UIImage imageNamed:@"xialafengjing "];
    _secImageView.alpha = 1.0;
    [_introduceView addSubview:_secImageView];
    
    _firImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _firImageView.image = [UIImage imageNamed:@"xialafengjing "];
    [_introduceView addSubview:_firImageView];
    
    
}
- (void)gestureRecognizerHandle:(UITapGestureRecognizer *)gesture{
    
    [UIView animateWithDuration:3.0 animations:^{
        
        _thirdImageView.alpha = 0.0;
        _thirdImageView.transform = CGAffineTransformScale(_thirdImageView.transform, 0, 0);
    } completion:^(BOOL finished) {
        
        [_introduceView removeFromSuperview];
        
    }];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    
    [mgr cancelAll];
    
    [mgr.imageCache clearMemory];
    
}
@end
