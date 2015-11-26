//
//  MyViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>


#import "MyViewController.h"
#import "Extension.h"
#import "AllNearbyDetailTableViewController.h"
#import "UMSocial.h"
#import "AboutUsViewController.h"
#import "SDImageCache.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "LoginWayViewController.h"
#import "ReadQRCodeViewController.h"
#import "userDefinedCodeView.h"

typedef enum : NSUInteger {
    MyRecommend = 0,
    Scan,
    ClearFile,
    ClearCache,
    NightMode,
    CheckUpdate,
    AboutUs
} MyEnum;

static CGFloat TopViewH = 400;
@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate, UMSocialUIDelegate, UIScrollViewDelegate>
{
    MBProgressHUD *_HUD;                    //  第三方提示框
}
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) NSString * clearCacheName;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *userImage;

@property(nonatomic,strong)UIButton *userQRCodeButton;



@property (strong, nonatomic)UserDefinedCodeView *userView;


@property(nonatomic, assign)MyEnum myenum;
@end

@implementation MyViewController
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"dataBase" object:nil];
#pragma mark ---在授权完成后调用获取用户信息的方法
    if (self.userName != nil) {
        self.nameLabel.text = self.userName;

        self.userImage.image = [UIImage imageNamed:@"phoneHeader"];
        self.userImage.backgroundColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:(UIBarButtonItemStylePlain) target:self action:@selector(loginClicked:)];
    } else {
        //获取accestoken以及新浪用户信息，得到的数据在回调Block对象形参respone的data属性
        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
            NSLog(@"SnsInformation is %@",response.data);
            
            //screen_name
            //profile_image_url
            
            NSDictionary *dic = response.data;
            NSString *nameStr = dic[@"screen_name"];
            if (![nameStr isEqualToString:@""] && (nameStr != nil)) {
                self.nameLabel.text = nameStr;
                [self.userImage sd_setImageWithURL:[NSURL URLWithString:dic[@"profile_image_url"]]];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:(UIBarButtonItemStylePlain) target:self action:@selector(loginClicked:)];
            } else {
                self.nameLabel.text = @"用户未登录";
                self.userImage.image = [UIImage imageNamed:@"userQQ"];
                self.userImage.backgroundColor = [UIColor whiteColor];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆" style:(UIBarButtonItemStylePlain) target:self action:@selector(loginClicked:)];
            }
        }];

    }
    [self refreshCacheData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[@"推荐给小伙伴们",@"扫一扫", @"清理缓存文件", @"", @"夜间模式",@"检查版本更新",@"关于我们"];
    [self loadTableView];
    [self loadTopView];
}
- (void)notification:(NSNotification *)sender
{
    self.userName = sender.object;
}

#pragma mark - 头部视图---------------------------------
- (void)loadTopView
{
    _topView = [[UIImageView alloc] init];
    _topView.image = [UIImage imageNamed:@"xialafengjing "];
    _topView.frame = CGRectMake(0, -TopViewH, self.view.frame.size.width, TopViewH);
    //等比例伸缩
    _topView.contentMode = UIViewContentModeScaleAspectFill;//原来宽高比Aspect,,伸缩Scale
    [self.tableView insertSubview:_topView atIndex:0];//插入到最下面
    //2.设置内边距(让cell往下移动一段距离)
    self.tableView.contentInset = UIEdgeInsetsMake(TopViewH * 0.5, 0, 0, 0);
    
    self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 120, 100, 100)];
    [self.view addSubview:self.userImage];
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.cornerRadius = 50;
    
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userImage.frame)+10, CGRectGetMidY(self.userImage.frame), 130, 50)];
    [self.view addSubview:self.nameLabel];
    
    self.userQRCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+20 , CGRectGetMidY(self.userImage.frame), 30, 30)];
    [self.userQRCodeButton addTarget:self action:@selector(codeClick) forControlEvents:UIControlEventTouchUpInside];

    //二维码生成按钮
    [self.userQRCodeButton setImage:[UIImage imageNamed:@"iconfont-erweima"] forState:UIControlStateNormal];
    [self.view addSubview:self.userQRCodeButton];
    
    
    
}

#pragma mark ---二维码生成
-(void)codeClick
{
    
    _userView = [[UserDefinedCodeView alloc] initWithFrame:CGRectMake(60, 200, self.view.frame.size.width - 120, self.view.frame.size.height/2)];
    [self.view addSubview:_userView];
    [_userView show];
    
    
    self.userView.nameLabel.text = self.nameLabel.text;
    
    self.userView.nameImageView.image =  self.userImage.image;
    
    if ( [self.userView.nameLabel.text isEqualToString: @"用户未登录"]) {
        
         self.userView.headImageView.image = nil;
    } else{
    
       self.userView.headImageView.image = self.userImage.image;
    }
   
    
    self.userView.noteLabel.text = @"为您生成手机APP专属二维码";
    self.userView.noteLabel.font  = [UIFont systemFontOfSize:12.0];
}





- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //向下拽了多少
    CGFloat down = - (TopViewH * 0.5) - scrollView.contentOffset.y;
    self.userImage.frame =  CGRectMake(10, 60+down, 100, 100);
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame)+10, CGRectGetMidY(self.userImage.frame), 130, 50);
    
    self.userQRCodeButton.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+20 , CGRectGetMidY(self.userImage.frame), 30, 30);
    if (down < 0) {//如果为负数,直接返回,这样我们向上推的时候,图片不会离我们太远
        
        return;
    }
    
    CGRect frame = self.topView.frame;
    frame.size.height = TopViewH + down;//变大的系数--想要变大快点,就down * 3 ==3觉得我们变大的系统
    self.topView.frame = frame;
}
- (void)loginClicked:(UIBarButtonItem *)button
{
    if ([self.nameLabel.text isEqualToString:@"用户未登录"]) {
        LoginWayViewController *loginVC = [[LoginWayViewController alloc] init];
//        loginVC.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"xialafengjing "]];
        loginVC.view.backgroundColor = [UIColor whiteColor];
        UINavigationController *NA = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:NA animated:YES completion:nil];
        
        
    } else {
        
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
            self.nameLabel.text = @"用户未登录";
            self.userImage.image = [UIImage imageNamed:@"userQQ"];
            self.userImage.backgroundColor = [UIColor whiteColor];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆" style:(UIBarButtonItemStylePlain) target:self action:@selector(loginClicked:)];
        }];
        
    }
    
}
- (void)loadTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    if (indexPath.row == 3) {
        
        float tmpSize = [[SDImageCache sharedImageCache] getSize]/3000000.0;
        self.clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理图片缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理图片缓存(%.2fK)",tmpSize * 1024];
        cell.textLabel.text = _clearCacheName;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
/*
 MyRecommend,@"推荐给小伙伴们" 
 Scan,,@"扫一扫"
 ClearFile, @"删除缓存文件"
 ClearCache,@"",
 NightMode,@"夜间模式",
 CheckUpdate,@"检查版本更新",
 AboutUs @"关于我们"
 */
    switch (indexPath.row) {
            #pragma mark    分享
        case MyRecommend:
        {
//注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
            [UMSocialSnsService presentSnsIconSheetView:self
                                                appKey:@"5649e11ae0f55af3f00057ec"
                                              shareText:@"分享的文字"
                                             shareImage:[UIImage imageNamed:@"xialafengjing "]
                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToRenren,UMShareToDouban, nil]
                                               delegate:self];
        }
            break;
            #pragma mark ---二维码扫描
        case Scan:
        {
            ReadQRCodeViewController *readQRVC = [ReadQRCodeViewController new];
            [self showDetailViewController:readQRVC sender:nil];
        }
            break;
#pragma mark ---删除缓存文件 直接把document文件夹删了
        case ClearFile:
        {
            [self jumpToClearCashsData];
            NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentFolderPath = [searchPaths objectAtIndex:0];
            NSError *err;
            [[NSFileManager defaultManager] removeItemAtPath:documentFolderPath error:&err];
            [self.tableView reloadData];
            
        }
            break;

            #pragma mark  清除缓存
        case ClearCache:
            [self jumpToClearCashsData];
            break;
            #pragma mark  夜间模式
        case NightMode:
        {
            if (self.view.window.alpha == 1) {
                self.view.window.alpha = 0.5;
            }else{
                self.view.window.alpha = 1;
            }
        }
            break;
            #pragma mark  版本更新
        case CheckUpdate:
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前已是最新版本" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
            #pragma mark  关于我们
        case AboutUs:
        {
            [self jumpToAboutOursViewController];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 跳转关于我们界面
- (void)jumpToAboutOursViewController{
    
    AboutUsViewController * aboutOursVC = [[AboutUsViewController alloc] init];
    aboutOursVC.modalPresentationStyle = UIModalPresentationFullScreen;
    aboutOursVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    aboutOursVC.view.backgroundColor = [UIColor whiteColor];
    
    UINavigationController * aboutOursNC = [[UINavigationController alloc] initWithRootViewController:aboutOursVC];
    [self presentViewController:aboutOursNC animated:YES completion:nil];

}
#pragma mark - 跳转清除缓存界面
- (void)jumpToClearCashsData{
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.dimBackground = YES;
    _HUD.labelText = @"正在清除";
    [_HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
        // 清除缓存
        [[SDImageCache sharedImageCache] clearDisk];
        
    } completionBlock:^{
        
        [_HUD removeFromSuperview];
        _HUD = nil;
        
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
        _HUD.dimBackground = YES;
        _HUD.labelText = @"清除成功";
        _HUD.mode = MBProgressHUDModeCustomView;
        [self.tableView reloadData];
        [_HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            
            [_HUD removeFromSuperview];
            _HUD = nil;
        }];
    }];
}

#pragma mark - 即时刷新缓存大小数据
- (void)refreshCacheData{
    
    float tmpSize = [[SDImageCache sharedImageCache] getSize]/3000000.0;
    self.clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
    [self.tableView reloadData];
    
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
