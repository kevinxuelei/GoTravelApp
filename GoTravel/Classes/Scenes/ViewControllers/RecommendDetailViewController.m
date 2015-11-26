//
//  RecommendDetailViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/15.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "RecommendDetailViewController.h"
#import "ChoicenssStoryFirstCell.h"
#import "ChoicenssStoryTwoCell.h"
#import "NetWorkHandle.h"
#import "RecommendDetailModel.h"
#import "UMSocialSnsService.h"
#import "UMSocial.h"
#import "UIImageView+WebCache.h"
#import "UMSocialDataService.h"
#import "MBProgressHUD+MJ.h"
#import "DataBaseTool.h"
@interface RecommendDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

/**一个大数组,存放两个*/
@property (nonatomic, strong) NSMutableArray *dataArray;
/**放第二个区所有model数组*/
@property (nonatomic, strong) NSMutableArray *arrayTwo;

/**用于放大的图片*/
@property (nonatomic, strong) UIImageView *changeImage;

/**蒙版*/
@property (nonatomic, strong) UIView *boardView;
/**滚动视图*/
@property (nonatomic, strong) UIScrollView *scrollImage;

@end

@implementation RecommendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInitViews];
   
    //判断网络是否连接，如果为连接并提示用户，网络未连接
    [[DataBaseTool shareHandle] alertInternetNotOpen:self];
    [self loadBarButtonItem];
    [self loadRequestData];
}
- (void)loadInitViews{
    self.dataArray = [NSMutableArray array];
    self.arrayTwo = [NSMutableArray array];
   
    self.boardView = [[UIView alloc] init];
    self.scrollImage = [[UIScrollView alloc] init];
    
    
}
#pragma mark ---加载navigationItem
- (void)loadBarButtonItem
{
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-fanhui"]style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
     
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-share"]style:UIBarButtonItemStyleDone target:self action:@selector(shareInfo:)];
}
#pragma mark ---分享内容
- (void)shareInfo:(UIBarButtonItem *)sender{
    
    RecommendDetailModel *model = self.dataArray[0][0];
    RecommendDetailModel *model1 = self.dataArray[1][0];
    UIImageView *bbb = [[UIImageView alloc] init];
    [bbb sd_setImageWithURL:[NSURL URLWithString:model1.photo_w640]];
    
    UIImageView *aaa = [[UIImageView alloc] init];
    [aaa sd_setImageWithURL:[NSURL URLWithString:model.avatar_m]];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5649e11ae0f55af3f00057ec"
                                      shareText:[NSString stringWithFormat:@"@%@  %@",model.name,model.text]
                                     shareImage:bbb.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToRenren,UMShareToDouban, nil] delegate:nil];
}
#pragma mark ---点击返回按钮，回到上一个界面
- (void)backAction:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark ---分区的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

#pragma mark ---分区cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return [self.dataArray[section] count];
            break;
        default:
            return 0;
            break;
    }
    
}

#pragma mark ---cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *str = @"storyCell";
            ChoicenssStoryFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            
            if (!cell) {
                
                cell = [[ChoicenssStoryFirstCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
                
            }
            RecommendDetailModel *model = self.dataArray[indexPath.section][indexPath.section];
            
            if (indexPath.row == 0) {
                
                [cell binModel:model];
                
            }else if (indexPath.row ==1){
                
                cell.textLabel.text = model.text;
                cell.textLabel.font = [UIFont systemFontOfSize:12];
                cell.textLabel.numberOfLines = 3;
                [cell.textLabel sizeToFit];
            }
            cell.userInteractionEnabled = NO;
            self.tableView.separatorStyle = UITableViewCellAccessoryNone;
            return cell;

        }
            break;
        case 1:
        {
            
            static NSString *strTwo = @"twoCell";
            ChoicenssStoryTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:strTwo];
            
            if (!cell) {
                
                cell = [[ChoicenssStoryTwoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strTwo];
            }
            
            RecommendDetailModel *modelTwo = self.dataArray[indexPath.section][indexPath.row];
            
            [cell binTwoModel:modelTwo];
            
            return cell;

        }
            break;
        default:
             return 0;
            break;
    }
    
    
}
#pragma mark ---分区的分头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 60;
            break;
        case 1:
            return 260;
            break;
            
        default:
            return 0;
            break;
    }
}

#pragma mark ---点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        
            break;
        case 1:
  
            [self scrollViewFormImage];
            break;
            
        default:
            break;
    }


}

#pragma mark ---点击放大滚动图片
- (void)scrollViewFormImage{

    //1.（本控制器是tableView）添加_boardView蒙板
    _boardView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.bounds) + 64);
    _boardView.backgroundColor = [UIColor blackColor];
    _boardView.userInteractionEnabled = YES;
    //2.scrollImage滚动视图
    self.scrollImage.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) * 0.5 - 200, CGRectGetWidth(self.view.frame), 400);
    //self.scrollImage.backgroundColor = [UIColor redColor];
    self.scrollImage.bounces = NO;//边框弹动取消
    self.scrollImage.pagingEnabled = YES;
    self.scrollImage.showsHorizontalScrollIndicator = NO;//取消滚动条
    [_boardView addSubview:self.scrollImage];
    //3.changImage，图片
    for(int i = 0; i < _arrayTwo.count; i ++){
        
        self.changeImage = [[UIImageView alloc] init];
        self.changeImage.frame = CGRectMake(i * self.view.frame.size.width, 50, self.view.frame.size.width, 300);
        RecommendDetailModel *model = _arrayTwo[i];
        NSString *imageUrl = model.photo_w640;
        [self.changeImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        
        [self.scrollImage addSubview:self.changeImage];
        
    }
    
    self.scrollImage.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * _arrayTwo.count, 400);
    
    
    //4将蒙板添加到navigationBar上
    [self.navigationController.view insertSubview:_boardView aboveSubview:self.navigationController.navigationBar];
    //在蒙板上添加一个手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancell:)];
    [_boardView addGestureRecognizer:tap];
    

}

#pragma mark ---取消蒙板
- (void)cancell:(UITapGestureRecognizer *)sender{

    [_boardView removeFromSuperview];
   
    
}
#pragma mark ---网络请求数据
- (void)loadRequestData
{
    
//    NSLog(@"========+++%@",_index);
    NSString *strUrl = [NSString stringWithFormat:@"http://api.breadtrip.com/v2/new_trip/spot/?spot_id=%@",_index];
    
    NSMutableArray *array = [NSMutableArray array];
  
    
    [NetWorkHandle getDataWithURLString:strUrl compare:^(id object) {
        
        
        NSDictionary *dictionary = object;
        NSDictionary *dictData = dictionary[@"data"];
        NSDictionary *dictTrip = dictData[@"trip"];
        NSDictionary *dictUser = dictTrip[@"user"];
        
        
        RecommendDetailModel *molde = [[RecommendDetailModel alloc] init];
        
        molde.name = dictUser[@"name"];
        molde.avatar_m = dictUser[@"avatar_m"];
        
        
        
        NSDictionary *dictSpot = dictData[@"spot"];
        molde.text = dictSpot[@"text"];
        
        NSDictionary *poi = dictSpot[@"poi"];
        
        
        if (![poi isEqual:@""]) {
            
            molde.AddressName = poi[@"name"];
        }
        
        if (poi == nil){
            
            molde.AddressName = @"";
            
        }else{
            
            molde.AddressName = @"";
            
        }
        
        [array addObject:molde];
        
        NSArray *arrayList = dictSpot[@"detail_list"];
        for (NSDictionary *list in arrayList) {
            
            RecommendDetailModel *modelTwo = [[RecommendDetailModel alloc] initWithDictionary:list];
            
            
            
            modelTwo.photo_w640 = list[@"photo_w640"];
            modelTwo.detailText = list[@"text"];
            
            [_arrayTwo addObject:modelTwo];
            
        }
        [self.dataArray addObject:array];//第一区
        
        [self.dataArray addObject:_arrayTwo];//第二区
        [self.tableView reloadData];
        
        
    }];
    
    
    
    
}



@end
