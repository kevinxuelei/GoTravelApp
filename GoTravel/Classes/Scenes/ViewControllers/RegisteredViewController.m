//
//  RegisteredViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "RegisteredViewController.h"
#import "Extension.h"
#import <AVOSCloud/AVOSCloud.h>


@interface RegisteredViewController ()
{
    NSTimer *timer;
    NSInteger seconds;
}

@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UILabel *passwordLabel;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UILabel *verificationLabel;
@property (nonatomic, strong) UITextField *verificationField;
@property (nonatomic, strong) UIButton *button;

@end

@implementation RegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    seconds = 60;
    [self loadSubViews];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:(UIBarButtonItemStylePlain) target:self action:@selector(loginClicked:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-fanhui"] style:(UIBarButtonItemStylePlain) target:self action:@selector(returnClicked:)];
}
- (void)returnClicked:(UIBarButtonItem *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loginClicked:(UIBarButtonItem *)button
{
    
    if ([self.markStr isEqualToString:@"注册"]) {
        [AVUser verifyMobilePhone:self.verificationField.text withBlock:^(BOOL succeeded, NSError *error) {
            //验证结果
            if (!error) {
                if ([self.passwordField.text isEqualToString:@""]) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [self releaseTImer];
                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@", error] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                    [self releaseTImer];
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
    }
    if ([self.markStr isEqualToString:@"重置"]) {
        [AVUser resetPasswordWithSmsCode:self.verificationField.text newPassword:@"password" block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                
                if ([self.passwordField.text isEqualToString:@""]) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"更改成功" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [self releaseTImer];
                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }
                
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@", error] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [self releaseTImer];
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
        }];
       
    }
    
    
    
    
    
}
- (void)loadSubViews
{
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 100, 50)];
    self.usernameLabel.text = @"用户名";
    self.usernameLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.usernameLabel];
    
    self.passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.usernameLabel.frame), CGRectGetMaxY(self.usernameLabel.frame) + 20, CGRectGetWidth(self.usernameLabel.frame), CGRectGetHeight(self.usernameLabel.frame))];
    self.passwordLabel.text = @"密码";
    self.passwordLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.passwordLabel];
    
    self.verificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.passwordLabel.frame), CGRectGetMaxY(self.passwordLabel.frame)+10, CGRectGetWidth(self.passwordLabel.frame), CGRectGetHeight(self.passwordLabel.frame))];
    self.verificationLabel.text = @"验证码";
    self.verificationLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.verificationLabel];
    
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.usernameLabel.frame) + 20, CGRectGetMinY(self.usernameLabel.frame), kWidth - 160, CGRectGetHeight(self.usernameLabel.frame))];
    self.usernameField.placeholder = @"输入手机号";
    self.usernameField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.usernameField];
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.passwordLabel.frame) + 20, CGRectGetMinY(self.passwordLabel.frame), CGRectGetWidth(self.usernameField.frame), CGRectGetHeight(self.passwordLabel.frame))];
    self.passwordField.placeholder = @"输入密码";
    self.passwordField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.passwordField];
    
    self.verificationField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.verificationLabel.frame) + 20, CGRectGetMinY(self.verificationLabel.frame), CGRectGetWidth(self.usernameField.frame), CGRectGetHeight(self.verificationLabel.frame))];
    self.verificationField.placeholder = @"输入验证码";
    self.verificationField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.verificationField];
    
    _button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _button.frame = CGRectMake(0, 0, 100, CGRectGetHeight(self.verificationLabel.frame));
    [_button setTitle:@"获取验证码" forState: UIControlStateNormal];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _button.backgroundColor = [UIColor cyanColor];
    self.verificationField.rightView = _button;
    self.verificationField.rightViewMode = UITextFieldViewModeAlways;
    [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
}
- (void)buttonClicked:(UIButton *)button
{
    if ([self.markStr isEqualToString:@"注册"]) {
        AVUser *user = [AVUser user];
        user.username = self.usernameField.text;
        user.password =  self.passwordField.text;
        user.email = nil;
        user.mobilePhoneNumber = self.usernameField.text;
        NSError *error = nil;
        [user signUp:&error];
        [AVUser requestMobilePhoneVerify:self.usernameField.text withBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                //发送成功
                timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
                
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"信息出错：%@", error] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *determine = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                    return ;
                }];
                [alertController addAction:determine];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
    }
    if ([self.markStr isEqualToString:@"重置"] && ![self.usernameField.text isEqualToString:@""]) {
        [AVUser requestPasswordResetWithPhoneNumber:self.usernameField.text block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"信息出错：%@", error] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *determine = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                    return ;
                }];
                [alertController addAction:determine];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
    }
    
}
//倒计时方法验证码实现倒计时60秒，60秒后按钮变换开始的样子
-(void)timerFireMethod:(NSTimer *)theTimer {
    if (seconds == 1) {
        [theTimer invalidate];
        seconds = 60;
        [_button setTitle:@"获取验证码" forState: UIControlStateNormal];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button setEnabled:YES];
    }else{
        seconds--;
        NSString *title = [NSString stringWithFormat:@"时间:%02ld",seconds];
        [_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_button setEnabled:NO];
        [_button setTitle:title forState:UIControlStateNormal];
    }
}
//如果登陆成功，停止验证码的倒数，
- (void)releaseTImer {
    if (timer) {
        if ([timer respondsToSelector:@selector(isValid)]) {
            if ([timer isValid]) {
                [timer invalidate];
                seconds = 60;
            }
        }
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
