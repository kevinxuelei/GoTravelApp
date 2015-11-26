//
//  MyWebController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "MyWebController.h"

@interface MyWebController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *myWebView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;//声明一个进度视图

@end

@implementation MyWebController

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-fanhui"]style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nvImage"]];
    
    self.myWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.myWebView];
    self.myWebView.delegate = self;
    self.tabBarController.tabBar.hidden = YES;
    //1.url定位资源
    NSURL *url = [NSURL URLWithString:self.webStrUrl];
    
    //2.把url告诉服务器,请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.发送给请求服务器
    [self.myWebView loadRequest:request];
    
}

- (void)backAction:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//加载前 判断是否加载
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"网页开始加载");
    //在加载等待页面 出现小菊花
    //    创建背底半透明View
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 64);
    view.tag = 108;
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [self.view addSubview:view];
    //    初始化UIActivityIndicatorView
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [view addSubview:self.activityIndicator];
    self.activityIndicator.center = view.center;
    //    设置UIActivityIndicatorView的样式
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    //    开始显示
    [self.activityIndicator startAnimating];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"网页加载完成");
    //    通过tag值找到view 并将它移除
    UIView *view = [self.view viewWithTag:108];
    [view removeFromSuperview];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"网页加载出错,error:%@", error);
    UIView *view = [self.view viewWithTag:108];
    [view removeFromSuperview];
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
