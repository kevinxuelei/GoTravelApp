//
//  DetailsdestinationCityViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "DetailsdestinationCityViewController.h"
#import "NetWorkHandle.h"
#import "DetailsDestinationViewCityModel.h"

#import "DetailsDestinationFristTableViewCell.h"
#import "DetailsDestinationCityThirdCell.h"
#import "DetailsDestinationTableViewCell.h"
#import "MBProgressHUD+MJ.h"
#import "MyWebController.h"
#import <CoreLocation/CoreLocation.h>
#import "UMSocial.h"

#import "Extension.h"
#import "DataBasehandle.h"
#import "UIImageView+WebCache.h"

@interface DetailsdestinationCityViewController ()<UITableViewDataSource, UITableViewDelegate, UMSocialUIDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *topButton;
@end

@implementation DetailsdestinationCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.titleStr;
    self.dataArray = [NSMutableArray array];
    [self loadTableView];
    [self dataBasehandle];
    [self loadNavigationItem];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)returnClicked:(UIBarButtonItem *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - navigationItem
- (void)loadNavigationItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-fanhui"] style:(UIBarButtonItemStylePlain) target:self action:@selector(returnClicked:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-share"] style:(UIBarButtonItemStylePlain) target:self action:@selector(sharebuttonClicked:)];
    
    self.topButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.topButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 50, CGRectGetHeight(self.view.frame)- 70, 45, 45);
    [self.topButton setImage:[UIImage imageNamed:@"iconfont-uptop"] forState:UIControlStateNormal];
    [self.topButton setTintColor:[UIColor redColor]];
    [self.tableView addSubview:self.topButton];
    [self.topButton addTarget:self action:@selector(returntopClick:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark ---实现点击按钮回到顶部的方法
- (void)returntopClick:(UIButton *)sender{
    
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.topButton.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - 50, scrollView.contentOffset.y + CGRectGetHeight(self.view.bounds) - 100, 30, 30);
    
}
#pragma mark - 点击弹出分享
- (void)sharebuttonClicked:(UIBarButtonItem *)barButton
{
    NSString *path = [self pathToDocument];
    NSArray *pathArr =  [NSArray arrayWithContentsOfFile:path];
    UIImageView *bbb = [[UIImageView alloc] init];
    [bbb sd_setImageWithURL:[NSURL URLWithString:pathArr[0]]];
    
    DetailsDestinationViewCityModel *fristModel = self.dataArray[0][1][0];
    //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5649e11ae0f55af3f00057ec"
                                      shareText:fristModel.entryCont
                                     shareImage:bbb.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToRenren,UMShareToDouban, nil]
                                       delegate:self];
}
#pragma mark - 初始化tableView
- (void)loadTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    if (self.tabBarController == nil) {
        self.tableView.frame = self.view.frame;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
}
#pragma mark - tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1 && [self.dataArray[section] count] != 0) {
        return 1;
    } else if (section == 2 && [self.dataArray[section] count] != 0){
        NSArray *array = self.dataArray[section];
        return array.count;
    }
    return 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        static NSString *cellStr = @"photoCell";
        DetailsDestinationFristTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[DetailsDestinationFristTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr];
        }
        cell.selectedBackgroundView = [[UIView alloc] init];
        [cell sendArray:self.dataArray[indexPath.section]];
        cell.block = ^(NSString *cityUrlStr) {
            MyWebController *webVC = [[MyWebController alloc] init];
            webVC.webStrUrl = cityUrlStr;
            UINavigationController *webNA = [[UINavigationController alloc] initWithRootViewController:webVC];
            [self presentViewController:webNA animated:YES completion:nil];
        };
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *cellStr = @"TableViewCell";
        DetailsDestinationCityThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[DetailsDestinationCityThirdCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr];
        }
        cell.selectedBackgroundView = [[UIView alloc] init];
        NSMutableArray *array = self.dataArray[indexPath.section];
        [cell sendArray:array];
        return cell;
    } else if (indexPath.section == 2){
        static NSString *cellStr = @"tableViewCell";
        DetailsDestinationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[DetailsDestinationTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr];
        }
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bj"]];
        cell.selectedBackgroundView = [[UIView alloc] init];
        NSArray *array = self.dataArray[indexPath.section];
        [cell binModel:array[indexPath.row]];
        return cell;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 300;
    } else if (indexPath.section == 1) {
        return 230;
    } else if (indexPath.section == 2) {
        return 150;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    view.backgroundColor = [UIColor cyanColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 30)];
    if (section == 1 && [self.dataArray[section] count] != 0) {
        label.text = @"精彩当地游";
    } else if (section == 2 && [self.dataArray[section] count] != 0) {
        label.text = @"超值自由行";
    }
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 30;
    }
    return 0;
}
#pragma mark - 解析数据
- (void)loadValue
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableArray *photosArray = [NSMutableArray array];
    NSMutableArray *collectionArray = [NSMutableArray array];
    NSMutableArray *discountArray = [NSMutableArray array];
    __weak DetailsdestinationCityViewController *detailVC = self;
//    香港50 澳门51
    [NetWorkHandle getDataWithURLString:[NSString stringWithFormat:@"http://open.qyer.com/qyer/footprint/city_detail?client_id=qyer_android&client_secret=9fcaae8aefc4f9ac4915&v=1&track_user_id=7004851&track_deviceid=863092021867505&track_app_version=6.8.2&track_app_channel=xiaomi&track_device_info=armani&track_os=Android4.4.4&app_installtime=1447126585362&lat=40.030375&lon=116.343078&city_id=%@&oauth_token=3e8ea67823d5b924b36845d74047d49b", self.cityID] compare:^(id object) {
        NSDictionary *dic = object;
        NSDictionary *dict = dic[@"data"];
        
        DetailsDestinationViewCityModel *fristModel = [[DetailsDestinationViewCityModel alloc] initWithDictionary:dict];
        [photosArray addObject:fristModel];
        fristModel.cnname = self.titleStr;
        
        NSString *path = [self pathToDocument];
        [fristModel.photosArray writeToFile:path atomically:YES];
        [KDataBasehandle createtableName:@"hot_city_photo" Modelclass:[DetailsDestinationViewCityModel class]];
       [KDataBasehandle insertIntoTableModel:fristModel];
        
       
        [KDataBasehandle createtableName:@"local_discount" Modelclass:[DetailsDestinationViewCityModel class]];
        NSArray *discountarray = dict[@"local_discount"];
        for (NSDictionary *dic1 in discountarray) {
            DetailsDestinationViewCityModel *model = [[DetailsDestinationViewCityModel alloc] initWithDictionary:dic1];
            [collectionArray addObject:model];
            model.cnname = self.titleStr;
            [KDataBasehandle insertIntoTableModel:model];
        }
        
        [KDataBasehandle createtableName:@"new_discount_city" Modelclass:[DetailsDestinationViewCityModel class]];
        NSArray *discountarray1 = dict[@"new_discount"];
        for (NSDictionary *dic2 in discountarray1) {
            DetailsDestinationViewCityModel *model = [[DetailsDestinationViewCityModel alloc] initWithDictionary:dic2];
            [discountArray addObject:model];
            model.cnname = self.titleStr;
            [KDataBasehandle insertIntoTableModel:model];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.dataArray addObject:[NSArray arrayWithObjects: fristModel.photosArray, photosArray, nil]];
        [self.dataArray addObject:collectionArray];
        [self.dataArray addObject:discountArray];
        [detailVC.tableView reloadData];
    }];
    
}
#pragma mark - 获取路径
- (NSString *)pathToDocument
{
    NSString *documentStr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [documentStr stringByAppendingString:[NSString stringWithFormat:@"/%@city.txt",self.cityID]];
}
#pragma mark - 数据持久化
- (void)dataBasehandle
{
    NSString *path = [self pathToDocument];
    NSArray *pathArr =  [NSArray arrayWithContentsOfFile:path];
    
    [KDataBasehandle createtableName:@"hot_city_photo" Modelclass:[DetailsDestinationViewCityModel class]];
    NSMutableArray *contArr =  [KDataBasehandle selectFromAttributeName:@"cnname" ValueStr:self.titleStr];
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:pathArr, contArr, nil];
    [KDataBasehandle createtableName:@"local_discount" Modelclass:[DetailsDestinationViewCityModel class]];
    NSMutableArray *arr1 =  [KDataBasehandle selectFromAttributeName:@"cnname" ValueStr:self.titleStr];
    
    [KDataBasehandle createtableName:@"new_discount_city" Modelclass:[DetailsDestinationViewCityModel class]];
    NSMutableArray *arr2 =  [KDataBasehandle selectFromAttributeName:@"cnname" ValueStr:self.titleStr];
    
    if (arr1.count != 0 || arr2.count != 0 ) {
        
        [self.dataArray addObject:arr];
        [self.dataArray addObject:arr1];
        [self.dataArray addObject:arr2];
        
    } else {
        [self loadValue];
    }
    [self.tableView reloadData];
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
