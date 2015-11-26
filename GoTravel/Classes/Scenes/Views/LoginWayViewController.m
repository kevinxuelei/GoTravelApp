//
//  LoginWayViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/23.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "LoginWayViewController.h"
#import "LoignViewController.h"
#import "UMSocial.h"

@interface LoginWayViewController ()

@property (nonatomic, strong) UIButton *phoneButton;
@property (nonatomic, strong) UIButton *sinaButton;
@property (nonatomic, strong) NSString *userName;
@end

@implementation LoginWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-fanhui"] style:(UIBarButtonItemStylePlain) target:self action:@selector(loginClicked:)];
}
- (void)loginClicked:(UIBarButtonItem *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)loadSubView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xialafengjing "]];
    imageView.frame = CGRectMake(10, 10, self.view.frame.size.width-20, self.view.frame.size.width-20);
    [self.view addSubview:imageView];
    
    self.phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.phoneButton.frame = CGRectMake(CGRectGetMinX(imageView.frame), CGRectGetMaxY(imageView.frame)+10, CGRectGetWidth(imageView.frame), 30);
    self.phoneButton.tag = 501;
    [self.phoneButton addTarget:self action:@selector(buttonClicedToLogin:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.phoneButton setTitle:@"手机号登陆" forState:(UIControlStateNormal)];
    [self.phoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.phoneButton];
    [self.phoneButton setBackgroundImage:[UIImage imageNamed:@"threeButton"] forState:(UIControlStateNormal)];
    
    self.sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sinaButton.frame = CGRectMake(CGRectGetMinX(self.phoneButton.frame), CGRectGetMaxY(self.phoneButton.frame)+10, CGRectGetWidth(self.phoneButton.frame), 30);
    self.sinaButton.tag = 502;
    [self.sinaButton addTarget:self action:@selector(buttonClicedToLogin:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.sinaButton setTitle:@"新浪登陆" forState:(UIControlStateNormal)];
    [self.sinaButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.sinaButton];
    [self.sinaButton setBackgroundImage:[UIImage imageNamed:@"threeButton"] forState:(UIControlStateNormal)];
}
- (void)buttonClicedToLogin:(UIButton *)button
{
    switch (button.tag) {
        case 501:
        {
            LoignViewController *loignVC = [[LoignViewController alloc] init];
            loignVC.view.backgroundColor = [UIColor whiteColor];
            UINavigationController *NA  = [[UINavigationController alloc] initWithRootViewController:loignVC];
//            self.block(self.userName);
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"dataBase" object:nil];
            [self presentViewController:NA animated:YES completion:nil];
        }
            break;
        case 502:
        {
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                //          获取微博用户名、uid、token等
                if (response.responseCode == UMSResponseCodeSuccess) {
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                    
//                    NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                    self.userName = snsAccount.userName;
                }});
        }
            break;
            
        default:
            break;
    }
}

- (void)notification:(NSNotification *)sender
{
    self.userName = sender.object;
}
- (void)viewDidAppear:(BOOL)animated
{
    if (self.userName != nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
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
