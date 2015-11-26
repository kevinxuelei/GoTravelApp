//
//  TabBarViewController.m
//  自定义
//
//  Created by lanou3g on 15/10/31.
//  Copyright (c) 2015年 WYT. All rights reserved.
//

#import "TabBarViewController.h"
#import "TabBarButton.h"
#import "RecommendViewController.h"
#import "DestinationViewController.h"
#import "NearbyViewController.h"
#import "MyViewController.h"
#import "Extension.h"



@interface TabBarViewController ()
{

    UIImageView *_tabBarView; //自定义的覆盖原先的tarbar的控件

    TabBarButton *_previousBtn; //记录前一次选中的按钮
    
}
@end

@implementation TabBarViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    /*
     
     保证在你的程序进入的第一个界面 .h 头文件里包含了 SDK 库文件：
     
     #import <AVOSCloud/AVOSCloud.h>
     
     将下面的代码拷贝到你的 app 里，比如在 viewDidLoad 方法（或者其他在运行 app 时会调用到的方法）：
     
     AVObject *testObject = [AVObject objectWithClassName:@"TestObject"];
     [testObject setObject:@"bar" forKey:@"foo"];
     [testObject save];
     
     
     
     */
    
      
    [self loadViewController];
    
    self.tabBar.hidden = YES; //隐藏原先的tabBar
    CGFloat tabBarViewY = self.view.frame.size.height - 49;
    
    _tabBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, tabBarViewY, self.view.frame.size.width, 49)];

    
    _tabBarView.userInteractionEnabled = YES; //这一步一定要设置为YES，否则不能和用户交互
    #pragma mark - 设置tabBarView的背景
    _tabBarView.image = [UIImage imageNamed:@"nvImage"];
//    _tabBarView.backgroundColor = [UIColor colorWithRed:37 green:165 blue:186 alpha:1.0];
    
    [self.view addSubview:_tabBarView];

#pragma mark - 下面的方法是调用自定义的生成按钮的方法
    [self creatButtonWithNormalName:@"recommend" andSelectName:@"recommendSelected" andTitle:@"推荐" andIndex:0];
    [self creatButtonWithNormalName:@"destination" andSelectName:@"destinationSelected" andTitle:@"目的地" andIndex:1];
    [self creatButtonWithNormalName:@"nearby" andSelectName:@"nearbySelected" andTitle:@"附近" andIndex:2];
    [self creatButtonWithNormalName:@"my" andSelectName:@"mySelected" andTitle:@"我的" andIndex:3];
    
#pragma mark - 加了button以后打开这两个方法
   TabBarButton *btn = _tabBarView.subviews[0];
    [self changeViewController:btn]; //自定义的控件中的按钮被点击了调用的方法，默认进入界面就选中第一个按钮
    
}
#pragma mark - 设置VC
- (void)loadViewController
{
#pragma mark - 自定义视图
 
    RecommendViewController *recommendVC = [[RecommendViewController alloc] init];
    recommendVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"推荐" image:IMG(@"recommend") selectedImage:nil];
    UINavigationController *recommendNC = [[UINavigationController alloc] initWithRootViewController:recommendVC];
    recommendNC.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nvImage"]];
    
    DestinationViewController *destinationVC = [[DestinationViewController alloc] init];
    destinationVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"目的地" image:IMG(@"destination") selectedImage:nil];
    UINavigationController *destinationNC = [[UINavigationController alloc] initWithRootViewController:destinationVC];
       destinationNC.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nvImage"]];
    
    NearbyViewController *nearbyVC = [[NearbyViewController alloc] init];
    nearbyVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"附近" image:IMG(@"nearby") selectedImage:nil];
    UINavigationController *nearbyNC = [[UINavigationController alloc] initWithRootViewController:nearbyVC];
    nearbyNC.navigationBar.translucent = NO;
       nearbyNC.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nvImage"]];
    
    
    MyViewController *myVC = [[MyViewController alloc] init];
    myVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:IMG(@"my") selectedImage:nil];
    UINavigationController *myNC = [[UINavigationController alloc] initWithRootViewController:myVC];
       myNC.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nvImage"]];
    
    
    self.viewControllers = @[recommendNC, destinationNC, nearbyNC, myNC];
    
    

}
#pragma mark 创建一个按钮
- (void)creatButtonWithNormalName:(NSString *)normal andSelectName:(NSString *)selected andTitle:(NSString *)title andIndex:(int)index
{
     /*
TabBarButton是自定义的一个继承自UIButton的类，自定义该类的目的是因为系统自带的Button可以设置image和title属性，但是默认的image是在title的左边，若想想上面图片中那样，将image放在title的上面，就需要自定义Button，设置一些东西。       */

    TabBarButton *button = [TabBarButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;

    CGFloat buttonW = _tabBarView.frame.size.width / 4;
     CGFloat buttonH = _tabBarView.frame.size.height;
     button.frame = CGRectMake(buttonW * index, 0, buttonW, buttonH);


     [button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
     [button setImage:[UIImage imageNamed:selected] forState:UIControlStateDisabled];
     [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    

     [button addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchDown];

     button.imageView.contentMode = UIViewContentModeCenter; // 让图片在按钮内居中
     button.titleLabel.textAlignment = NSTextAlignmentCenter; // 让标题在按钮内居中
    

    button.font = [UIFont systemFontOfSize:12]; // 设置标题的字体大小

     [_tabBarView addSubview:button];
}
#pragma mark 按钮被点击时调用
- (void)changeViewController:(TabBarButton *)sender
{
    static int a =0;
    self.selectedIndex = sender.tag; //切换不同控制器的界面
    sender.enabled = NO;
    [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    if (_previousBtn != sender) {
        _previousBtn.enabled = YES;
        [_previousBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
     _previousBtn = sender;
    if (a != 0) {
        
        UIView *view=sender.subviews[0];
        [UIView animateWithDuration:0.1 animations:
         ^(void){
             view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.5, 0.5);
             
             
         } completion:^(BOOL finished){//do other thing
             [UIView animateWithDuration:0.2 animations:
              ^(void){
                  
                  view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.2, 1.2);
                  
              } completion:^(BOOL finished){//do other thing
                  [UIView animateWithDuration:0.1 animations:
                   ^(void){
                       
                       view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
                       
                       
                   } completion:^(BOOL finished){//do other thing
                   }];
              }];
         }];

    }
    if (a == 0) {
        a++;
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
