//
//  WonderfulTravelController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "WonderfulTravelController.h"
#import "WonderfulTravelDetailCell.h"
#import "NetWorkHandle.h"
#import "WonderfulTravelDetailModel.h"
#import "PictureImageModel.h"
#import "FootmarkViewController.h"
#import "MBProgressHUD+MJ.h"
#import "DataBaseTool.h"
@interface WonderfulTravelController ()<UITableViewDataSource,UITableViewDelegate>

{
    double _latitude;
    
    double _longitude;

}

/**存放所有图片的model数组*/
@property (nonatomic, strong) NSMutableArray *modelArray;

/**存放展示的数据*/
@property (nonatomic, strong) NSMutableArray *dataArray;



@end

@implementation WonderfulTravelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DataBaseTool shareHandle] alertInternetNotOpen:self];
    [self loadNavigationItem];
    [self.tableView registerClass:[WonderfulTravelDetailCell class] forCellReuseIdentifier:@"CELL"];
    
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadRequestData];

}
#pragma mark ---navigationItem设置
- (void)loadNavigationItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-fanhui"]style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
  
    self.tableView.backgroundColor = [UIColor whiteColor];
    
}
#pragma mark ---返回上一个界面
- (void)backAction:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

#pragma mark ---cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WonderfulTravelDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];

    WonderfulTravelDetailModel *model = self.dataArray[indexPath.row];
   
    
    
    
    cell.selectedBackgroundView = [[UIView alloc] init];
   
    
    [cell binModel:model];
   
    cell.block = ^()
    {
    
        FootmarkViewController *MVC = [[FootmarkViewController alloc] init];
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:MVC];
        
        MVC.pointArray = self.modelArray;
        
        MVC.headUrl = model.avatar_m;
        
        [self presentViewController:nc animated:YES completion:nil];
        
    
    };
    
    return cell;
}


#pragma mark ---设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height - 74;

}

#pragma mark ---加载网络请求数据
- (void)loadRequestData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    self.dataArray = [NSMutableArray array];
    
    [NetWorkHandle getDataWithURLString:[NSString stringWithFormat:@"http://api.breadtrip.com/trips/%ld/waypoints/",_indexNext] compare:^(id object) {
        NSLog(@"----获取上个界面传过来的参数:%ld",_indexNext);
        self.modelArray = [NSMutableArray array];
        NSDictionary *dict = object;
        
        //动画图片url和地图坐标
        NSArray *daysArray = dict[@"days"];
        for (NSDictionary *dictionary in daysArray) {
            
           NSArray *imageArray = dictionary[@"waypoints"];
            
            for (NSDictionary *dic in imageArray) {
                
                PictureImageModel *modelImage = [[PictureImageModel alloc] initWithDictionary:dic];
                 NSDictionary *loca =  dic[@"location"];
               // NSLog(@"---%@",loca);
                if  ( (NSNull *)loca == [NSNull null] ) {
              
                    modelImage.latitude = _latitude;
                    modelImage.longitude = _longitude;
//                    NSLog(@"+++++++%f",_latitude);
//                    NSLog(@"+++++++%f",_longitude);

                    
                }else{
                
                 modelImage.latitude = [loca[@"lat"] doubleValue];
                _latitude = modelImage.latitude;
                 modelImage.longitude = [loca[@"lng"] doubleValue];
                _longitude = modelImage.longitude;
                }
                NSLog(@"-----前---%ld",self.modelArray.count);
                [self.modelArray addObject:modelImage];
              // NSLog(@"地图图片数组模型: ---- %@",self.modelArray);
                NSLog(@"-------后-%ld",self.modelArray.count);
                
            }
        
            NSLog(@" ----第二次");
        }
        //用户信息和基本数据显示
        WonderfulTravelDetailModel *model = [[WonderfulTravelDetailModel alloc] initWithDictionary:dict];
         model.trackpoints_thumbnail_image = dict[@"trackpoints_thumbnail_image"];
        NSDictionary *user = dict[@"user"];
         model.name = user[@"name"];
         model.avatar_m = user[@"avatar_m"];
        
         model.textName = dict[@"name"];
         model.first_day = dict[@"first_day"];
         model.day_count = [dict[@"day_count"] integerValue];
         model.mileage = dict[@"mileage"];
         model.recommendations = dict[@"recommendations"];
        
        
        [self.dataArray addObject:model];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView reloadData];
        
        NSLog(@"======总====%ld",self.modelArray.count);
        
        
    }];





}

@end
