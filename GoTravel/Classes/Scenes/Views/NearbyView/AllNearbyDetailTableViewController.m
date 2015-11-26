//
//  AllNearbyDetailTableViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/14.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "AllNearbyDetailTableViewController.h"
#import "NetWorkHandle.h"
#import "AllNearbyDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AllNearbyTableViewCell.h"
#import "NearbyViewController.h"
#import "AlllNearbyFirstCell.h"
#import "UMSocial.h"
#import "MPLocationViewController.h"
#import "UIImageView+WebCache.h"


const CGFloat TopViewH = 250;

@interface AllNearbyDetailTableViewController ()<UMSocialUIDelegate>


@property(nonatomic,strong)UIView *headerView;

@property (nonatomic, strong) UIImageView *topView;

@end

@implementation AllNearbyDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //cell的自适应高度
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
  

    
//    //设置UINavigationBar为透明
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
   
    self.navigationController.navigationBar.translucent = NO;


    [self loadtopView];

    [self loadNavigation];
    
    

}



#pragma mark ---顶部的navigationItem按钮
-(void)loadNavigation
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-fanhui"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBackClick)];
    
    UIBarButtonItem *burtemShare = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-share"] style:UIBarButtonItemStyleDone target:self action:@selector(sharelick)];
    UIBarButtonItem *burtemMap = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-map"] style:UIBarButtonItemStyleDone target:self action:@selector(mapLick)];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nvImage"]];
    //给左右两边的barbuttonitem一组视图,自动排列   利用的是UIBarbuttonItem创建的对象
    self.navigationItem.rightBarButtonItems = @[burtemShare,burtemMap];

}
//navigationItem左边的返回按钮
-(void)leftBackClick
{
    AllNearbyDetailTableViewController * AllNearbyDetailTVC = [[AllNearbyDetailTableViewController alloc] init];
    
    [self dismissViewControllerAnimated:AllNearbyDetailTVC completion:^{
        
    }];


}

//内容分享
-(void)sharelick
{

    //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5649e11ae0f55af3f00057ec"
                                      shareText:@"你要分享的文字"
                                     shareImage:[UIImage imageNamed:@"nil"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToRenren,UMShareToDouban, nil]
                                       delegate:self];

}


#pragma mark ---顶部图片的下拉实现
-(void)loadtopView
{
    
    //1.下拉方大图片,肯定不是tableView的头部视图,肯定是tableView的子控件,它的y坐标肯定低于头部视图的y值也就是(0)
    _topView = [[UIImageView alloc] init];
    [_topView  sd_setImageWithURL:[NSURL URLWithString:self.model.cover]];
    _topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"xialafengjing "]];
    _topView.frame = CGRectMake(0, -TopViewH  , self.view.frame.size.width, TopViewH);
    //等比例伸缩
    _topView.contentMode = UIViewContentModeScaleAspectFill;//原来宽高比Aspect,,伸缩Scale
      [self.tableView insertSubview:_topView atIndex:0];//插入到最下面
    
    //2.设置内边距(让cell往下移动一段距离)
    self.tableView.contentInset = UIEdgeInsetsMake(TopViewH *0.7, 0, 0, 0);//上边切200的高度,相当于我们的cell的y值从原来的0-->200,这时我们将我们图片的高度设置为200,那它从-200开始,刚好显示在我们的视图原来的0点上
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    //向下拽了多少
    CGFloat down = - (TopViewH * 0.5) - scrollView.contentOffset.y;
    
    if (down < 0) {//如果为负数,直接返回,这样我们向上推的时候,图片不会离我们太远
        return;
    }

    CGRect frame = self.topView.frame;
    frame.size.height = TopViewH + down;//它也觉得变大的系数--想要变大快点,就down * 3 ==3觉得我们变大的系统
    self.topView.frame = frame;

    

}


#pragma mark - Table view data source

#pragma mark ---返回分区的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

#pragma mark ---个分区cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        
        return 1;
    }else if (section ==1 ){
        
        return 4;
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        
        static NSString *str = @"cell";
        AlllNearbyFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[AlllNearbyFirstCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        }
       
        if (indexPath.row == 0) {
                [cell binModelFirst:self.model];
//            cell.textLabel.text = self.model.name;
//            cell.textLabel.font = [UIFont boldSystemFontOfSize:24];
//            cell.textLabel.textAlignment = NSTextAlignmentCenter;

        }
        
        
        
    
  
        
        return cell;
        
        
    } else if (indexPath.section == 1) {
        static NSString *str = @"twocell";
        AllNearbyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[AllNearbyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        }

          if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"概况 \n%@",self.model.mydescription];
        cell.textLabel.numberOfLines = 0;
        [cell.textLabel sizeToFit];
    } else if (indexPath.row == 1){
        cell.textLabel.text = [NSString stringWithFormat:@"地址 \n%@",self.model.address];
        cell.textLabel.numberOfLines = 0;
    } else if(indexPath.row == 2){
        cell.textLabel.text = [NSString stringWithFormat:@"联系电话 \n %@",self.model.tel];
        cell.textLabel.numberOfLines = 0;
    }

    
    return cell;
}

    
    return 0;
}

-(CGFloat)stringHeightWithString:(NSString *)str fontSize:(CGFloat)fontSize  contentSize:(CGSize)size
{
    //第一个参数,代表最大的范围
    //第二个参数 代表是否考虑字体和字号
    //第三个参数 代表是使用什么字体和字号
    //第四个参数  用不到  基本上是 nil
    CGRect  stringRect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return stringRect.size.height;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return 150;
        
    }  else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return [self stringHeightWithString:self.model.mydescription
                                       fontSize:18 contentSize:CGSizeMake(self.view.frame.size.width - 20,10000)] + 20 + 40;
        }
        if (indexPath.row == 1) {
            return [self stringHeightWithString:self.model.address
                                       fontSize:18 contentSize:CGSizeMake(self.view.frame.size.width - 20,10000)] + 20 + 40;
        }
        if (indexPath.row == 2) {
            return [self stringHeightWithString:self.model.tel
                                       fontSize:18 contentSize:CGSizeMake(self.view.frame.size.width - 20,10000)] + 20 + 40;
        }

       
        
    }
   
        
    return 0;

}







//进入地图界面的点击时间
-(void)mapLick
{
    MPLocationViewController * mpLocationVC = [[MPLocationViewController alloc] init];
    //属性传值第二步,把dataArray赋值给属性传值的对象
    mpLocationVC.mapName = self.model.name;
    mpLocationVC.mapImage = self.model.icon;
    mpLocationVC.latitude = self.model.lat;
    mpLocationVC.Longitude = self.model.lng;
    mpLocationVC.view.backgroundColor = [UIColor whiteColor];
    
    
    mpLocationVC.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *NV = [[UINavigationController  alloc] initWithRootViewController:mpLocationVC];
    
    mpLocationVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:NV animated:YES completion:nil];
    
    
    
}



















@end

