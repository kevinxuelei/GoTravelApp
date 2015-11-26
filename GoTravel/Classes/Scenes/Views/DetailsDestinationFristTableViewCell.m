//
//  DetailsDestinationFristTableViewCell.m
//  GoTravel
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "DetailsDestinationFristTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface DetailsDestinationFristTableViewCell ()<UIScrollViewDelegate>
//接收轮播图数组
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *myImage;//图片
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *detailsButton;
@property (nonatomic, strong) NSTimer *time;//计时器
@property (nonatomic, strong) UIPageControl *myPage;

@property (nonatomic, copy) NSString *cityUrlStr;

@end
@implementation DetailsDestinationFristTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.scrollView = [[UIScrollView alloc] init];
        [self.contentView addSubview:self.scrollView];
        
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];
        
        self.detailsButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.contentView addSubview:self.detailsButton];
        
        self.myPage = [[UIPageControl alloc] init];
        [self.contentView addSubview:self.myPage];
        
        self.time = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(action) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //scrollView的布局设置
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, 200);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;//水平方向
    self.scrollView.showsVerticalScrollIndicator = NO;//垂直方向
    //添加轮播图图片
    for (int i = 0; i <  self.dataArray.count; i++) {
        self.myImage = [[UIImageView alloc] init];
        self.myImage.frame = CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, 200);
        NSString *imageStr = self.dataArray[i];
        [self.myImage sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"xialafengjing "]];
        [self.scrollView addSubview:self.myImage];
    }
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * self.dataArray.count, self.scrollView.frame.size.height);
    
    //PageControl的布局设置
    self.myPage.currentPage = 0;
    self.myPage.numberOfPages = self.dataArray.count;
    
    self.myPage.center = CGPointMake(self.frame.size.width * 0.5, self.scrollView.frame.size.height - 30);
    [self.myPage addTarget:self action:@selector(myPageClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.nameLabel.frame = CGRectMake(20, CGRectGetMaxY(self.scrollView.frame) + 10, self.contentView.frame.size.width - 40, 70);
    self.nameLabel.numberOfLines = 0;
    
    self.detailsButton.frame = CGRectMake(self.contentView.frame.size.width - 120, CGRectGetMaxY(self.nameLabel.frame), 100, 20);
    [self.detailsButton addTarget:self action:@selector(buttonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)action
{
    if (self.dataArray.count != 0) {
        //当前页数加1,跳转到下一页面
        NSInteger index = (self.myPage.currentPage + 1) % self.dataArray.count;
        self.myPage.currentPage = index;
        [self myPageClick:self.myPage];
    }
    
    
}
//滚动监听事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //求出当前的page点
    double page = scrollView.contentOffset.x / scrollView.frame.size.width;
    //让其加上0.5,
    self.myPage.currentPage = page;
    
}
//在page点击事件中,设置scrollView的偏移量
- (void)myPageClick:(UIPageControl *)sender
{
    
    //设置偏移量
    [self.scrollView setContentOffset:CGPointMake(self.myPage.currentPage * self.frame.size.width, 0) animated:NO];
    
}
- (void)sendArray:(NSArray *)array
{
    if (array.count != 0) {
        DetailsDestinationViewCityModel *model1 = [[DetailsDestinationViewCityModel alloc] init];
        model1.photosArray = array[0];
        self.dataArray = model1.photosArray;
        
        DetailsDestinationViewCityModel *model = array[1][0];
        self.nameLabel.text = model.entryCont;
        self.nameLabel.numberOfLines = 0;
        [self.detailsButton setTitle:@"实用信息" forState:(UIControlStateNormal)];
        self.cityUrlStr = model.overview_url;
    }
    
}
- (void)buttonClicked:(UIButton *)button
{
    self.block(self.cityUrlStr);
}

@end
