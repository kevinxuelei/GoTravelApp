//
//  LoignViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "LoignViewController.h"
#import "RegisteredViewController.h"
#import <AVOSCloud/AVOSCloud.h>
@interface LoignViewController ()

@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *passwordLabel;
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *loignButton;
@property (nonatomic, strong) UIButton *registeredButton;

@property (nonatomic, strong) UIButton *forgetButton;
@end

@implementation LoignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-fanhui"] style:(UIBarButtonItemStylePlain) target:self action:@selector(loginClicked:)];
}
- (void)loginClicked:(UIBarButtonItem *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)loadSubViews
{
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 100, 50)];
    self.usernameLabel.text = @"用户名";
    self.usernameLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.usernameLabel];
    
    self.passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.usernameLabel.frame), CGRectGetMaxY(self.usernameLabel.frame) + 20, CGRectGetWidth(self.usernameLabel.frame), CGRectGetHeight(self.usernameLabel.frame))];
    self.passwordLabel.text = @"密码";
    self.passwordLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.passwordLabel];
    
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.usernameLabel.frame) + 20, CGRectGetMinY(self.usernameLabel.frame), CGRectGetWidth(self.usernameLabel.frame) + 50, CGRectGetHeight(self.usernameLabel.frame))];
    self.usernameField.placeholder = @"输入用户名";
    self.usernameField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.usernameField];
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.passwordLabel.frame) + 20, CGRectGetMinY(self.passwordLabel.frame), CGRectGetWidth(self.passwordLabel.frame) + 50, CGRectGetHeight(self.passwordLabel.frame))];
    self.passwordField.placeholder = @"输入密码";
    self.passwordField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.passwordField];
    
    self.loignButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.loignButton.frame = CGRectMake(CGRectGetMinX(self.passwordLabel.frame), CGRectGetMaxY(self.passwordLabel.frame) + 20, self.view.frame.size.width - 100, CGRectGetHeight(self.passwordLabel.frame));
    [self.loignButton setTitle:@"登陆" forState:UIControlStateNormal];
    [self.loignButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.loignButton.backgroundColor = [UIColor greenColor];
    [self.loignButton setBackgroundImage:[UIImage imageNamed:@"threeButton"] forState:(UIControlStateNormal)];
    [self.loignButton addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loignButton];
    
    self.registeredButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.registeredButton.frame = CGRectMake(CGRectGetMinX(self.loignButton.frame) , CGRectGetMaxY(self.loignButton.frame)+10, CGRectGetWidth(self.loignButton.frame), CGRectGetHeight(self.loignButton.frame));
    [self.registeredButton setTitle:@"手机号注册" forState:UIControlStateNormal];
    [self.registeredButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.registeredButton.backgroundColor = [UIColor greenColor];
    [self.registeredButton setBackgroundImage:[UIImage imageNamed:@"threeButton"] forState:(UIControlStateNormal)];
    [self.view addSubview:self.registeredButton];
    [self.registeredButton addTarget:self action:@selector(registered:) forControlEvents:UIControlEventTouchUpInside];
    
    self.forgetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.forgetButton.frame = CGRectMake(CGRectGetMinX(self.loignButton.frame), CGRectGetMaxY(self.registeredButton.frame)+10, CGRectGetWidth(self.loignButton.frame), CGRectGetHeight(self.loignButton.frame));
    [self.forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.forgetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.forgetButton.backgroundColor = [UIColor greenColor];
    [self.forgetButton setBackgroundImage:[UIImage imageNamed:@"threeButton"] forState:(UIControlStateNormal)];
    [self.view addSubview:self.forgetButton];
    [self.forgetButton addTarget:self action:@selector(forget:) forControlEvents:UIControlEventTouchUpInside];
}
//登陆
- (void)loginClick:(UIButton *)button
{
    [AVUser logInWithMobilePhoneNumberInBackground:self.usernameField.text  password:self.passwordField.text block:^(AVUser *user, NSError *error) {
        if (!error) {
//            NSLog(@"user====%@",user);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"登陆成功" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dataBase" object:self.usernameField.text];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@", error] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }];
}
//注册
- (void)registered:(UIButton *)button
{
    RegisteredViewController *registerVC = [[RegisteredViewController alloc] init];
    registerVC.markStr = @"注册";
    registerVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:registerVC animated:YES];
}
//忘记密码
- (void)forget:(UIButton *)button
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否重置密码" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *determine = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        RegisteredViewController *registerVC = [[RegisteredViewController alloc] init];
        registerVC.markStr = @"重置";
        registerVC.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:registerVC animated:YES];
    }];
    UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    [alertController addAction:determine];
    [alertController addAction:quxiao];
    [self presentViewController:alertController animated:YES completion:nil];
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
