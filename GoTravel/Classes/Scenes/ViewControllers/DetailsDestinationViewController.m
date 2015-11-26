//
//  DetailsDestinationViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "DetailsDestinationViewController.h"

#import "DetailsDestinationFristTableViewCell.h"
#import "DetailsDestinationSecondAreaCell.h"
#import "DetailsDestinationTableViewCell.h"
#import "DetailsdestinationCityViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AllCityViewController.h"

#import "NetWorkHandle.h"
#import "MyWebController.h"
#import "UMSocial.h"

#import "Extension.h"
#import "DataBasehandle.h"
#import "UIImageView+WebCache.h"

@interface DetailsDestinationViewController ()<UITableViewDataSource, UITableViewDelegate,UMSocialUIDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *topButton;
@end

@implementation DetailsDestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.titleStr;
    self.dataArray = [NSMutableArray array];
    [self loadTableView];
    [self loadNavigationItem];
    [self dataBasehandle];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)returnClicked:(UIBarButtonItem *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 初始化tableView
- (void)loadTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

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
#pragma mark - tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
    } else if (section == 1 && [self.dataArray[section] count] != 0) {
        
        return 1;
    } else if (section == 2 && [self.dataArray[section] count] != 0)  {
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
        static NSString *cellStr = @"cityCell";
        DetailsDestinationSecondAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[DetailsDestinationSecondAreaCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr];
        }
        cell.selectedBackgroundView = [[UIView alloc] init];
        NSMutableArray *array = self.dataArray[indexPath.section];
        [cell sendArray:array];
        cell.block = ^(NSString *cityID, NSString *cnnameStr) {
            DetailsdestinationCityViewController *cityVC = [[DetailsdestinationCityViewController alloc] init];
            cityVC.cityID = cityID;
            cityVC.titleStr = cnnameStr;
            [self.navigationController pushViewController:cityVC animated:YES];
        };
        return cell;
    } else if (indexPath.section == 2){
        static NSString *cellStr = @"TableViewCell";
        DetailsDestinationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[DetailsDestinationTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr];
        }
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bj"]];
        cell.selectedBackgroundView = [[UIView alloc] init];
        NSArray *array = self.dataArray[indexPath.section];
        if (array[indexPath.row] != nil) {
            [cell binModel:array[indexPath.row]];
        }
        
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
        return 100;
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
    if (section == 1) {
        label.text = @"热门城市";
        
        UIButton *buton = [UIButton buttonWithType:UIButtonTypeSystem];
        [buton setTitle:@"查看全部" forState:(UIControlStateNormal)];
        [buton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        buton.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 30);
        [buton addTarget:self action:@selector(allCityClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:buton];
        
    } else if (section == 2) {
        label.text = @"超值自由行";
    }
    [view addSubview:label];
    return view;
}
#pragma mark - 实现查看全部
- (void)allCityClicked:(UIButton *)button
{
    AllCityViewController *cityVC = [[AllCityViewController alloc] init];
    cityVC.countID = self.cityID;
    cityVC.titleStr = self.titleStr;
    cityVC.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *cityNA = [[UINavigationController alloc] initWithRootViewController:cityVC];
    cityNA .navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nvImage"]];
    [self presentViewController:cityNA animated:YES completion:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 30;
    }
    return 0;
}
#pragma mark - 解析数据
-(void)loadValue
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableArray *photosArray = [NSMutableArray array];
    NSMutableArray *discountArray = [NSMutableArray array];
    NSMutableArray *cityArray = [NSMutableArray array];
    
    __weak DetailsDestinationViewController *detailVC = self;
//    11
    [NetWorkHandle getDataWithURLString:[NSString stringWithFormat:@"http://open.qyer.com/qyer/footprint/country_detail?client_id=qyer_android&client_secret=9fcaae8aefc4f9ac4915&v=1&track_deviceid=358142031588575&track_app_version=6.8.2&track_app_channel=360m&track_device_info=hwH30-T00&track_os=Android4.2.2&app_installtime=1447157253953&lat=40.030537&lon=116.343373&country_id=%@", self.cityID] compare:^(id object) {
        NSDictionary *dic = object;
        NSDictionary *dict = dic[@"data"];
        
        
        DetailsDestinationViewModel *fristModel = [[DetailsDestinationViewModel alloc] initWithDictionary:dict];
        [photosArray addObject:fristModel];
        fristModel.cnnameStr = self.titleStr;
        NSString *path = [self pathToDocument];
        [fristModel.photosArray writeToFile:path atomically:YES];
        [KDataBasehandle createtableName:@"hot_country_photo" Modelclass:[DetailsDestinationViewModel class]];
        [KDataBasehandle insertIntoTableModel:fristModel];
        
        
        [KDataBasehandle createtableName:@"new_discount" Modelclass:[DetailsDestinationViewModel class]];
        NSArray *discountarray = dict[@"new_discount"];
        for (NSDictionary *dic1 in discountarray) {
            DetailsDestinationViewModel *model = [[DetailsDestinationViewModel alloc] initWithDictionary:dic1];
            [discountArray addObject:model];
            model.cnnameStr = self.titleStr;
            [KDataBasehandle insertIntoTableModel:model];
        }
        
        [KDataBasehandle createtableName:@"hot_city" Modelclass:[DetailsDestinationViewModel class]];
        NSArray *cityarray = dict[@"hot_city"];
        for (NSDictionary *cityDic in cityarray) {
            DetailsDestinationViewModel *model = [[DetailsDestinationViewModel alloc] initWithDictionary:cityDic];
            [cityArray addObject:model];
            model.cnnameStr = self.titleStr;
            [KDataBasehandle insertIntoTableModel:model];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.dataArray addObject:[NSArray arrayWithObjects:fristModel.photosArray, photosArray, nil]];
        [self.dataArray addObject:cityArray];
        [self.dataArray addObject:discountArray];
        [detailVC.tableView reloadData];
    }];
}
#pragma mark - 获取路径
- (NSString *)pathToDocument
{
    NSString *documentStr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
   return [documentStr stringByAppendingString:[NSString stringWithFormat:@"/%@country.txt",self.cityID]];
}
#pragma mark - 数据持久化
- (void)dataBasehandle
{
    NSString *path = [self pathToDocument];
    NSArray *pathArr =  [NSArray arrayWithContentsOfFile:path];
    
    [KDataBasehandle createtableName:@"hot_country_photo" Modelclass:[DetailsDestinationViewModel class]];
    NSMutableArray *contArr =  [KDataBasehandle selectFromAttributeName:@"cnnameStr" ValueStr:self.titleStr];
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:pathArr, contArr, nil];
    [KDataBasehandle createtableName:@"new_discount" Modelclass:[DetailsDestinationViewModel class]];
    NSMutableArray *arr1 =  [KDataBasehandle selectFromAttributeName:@"cnnameStr" ValueStr:self.titleStr];
    
    [KDataBasehandle createtableName:@"hot_city" Modelclass:[DetailsDestinationViewModel class]];
    NSMutableArray *arr2 =  [KDataBasehandle selectFromAttributeName:@"cnnameStr" ValueStr:self.titleStr];
    
    if (arr1.count != 0 || arr2.count != 0 ) {
    
        [self.dataArray addObject:arr];
        [self.dataArray addObject:arr2];
        [self.dataArray addObject:arr1];
        
    } else {
        [self loadValue];
    }
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
