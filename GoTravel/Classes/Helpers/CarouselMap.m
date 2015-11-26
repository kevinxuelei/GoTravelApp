//
//  CarouselMap.m
//  LWB_Project
//
//  Created by 王剑亮 on 15/11/12.
//  Copyright © 2015年 wangjianliang. All rights reserved.
//

#import "CarouselMap.h"
//#import "DebugNSLog.h"
#import "UIImageView+WebCache.h"
@interface CarouselMap ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollview;
    UIPageControl *_mypageControl;
    
}
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *imageArray;


@end

@implementation CarouselMap

static BOOL isfoot;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageUrlStringArray = [[NSMutableArray alloc] init];
        self.titleArray = [[NSMutableArray alloc] init];
        //加载轮播图
        [self loadScrollView];
        
        
    }
    return self;
}

#pragma mark----创建轮播图
- (void)loadScrollView
{
    _scrollview = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //禁止边界回弹 开启整屏翻动
    _scrollview.bounces = NO;
    _scrollview.pagingEnabled = YES;
    //设置代理类
    _scrollview.delegate = self;
    
    //改变内部轮播图的图片每次使用的时候调用
    [self changeImage];
    
    
    
}

#pragma mark--- 改变内部轮播图的图片每次使用的时候调用
-(void)changeImage
{
#pragma mark--- 如果有那个数据源我们将 放上轮播图
    if (self.imageUrlStringArray.count != 0)
    {
        //数组初始化
        self.imageArray = [[NSMutableArray alloc] init];
        //清空界面上的所有东西
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        for(UIView *view in _scrollview.subviews )
        {
            [view removeFromSuperview];
        }
        //--------主要的
        //处理显示细节
        for (int i = 0; i < self.imageUrlStringArray.count+2; i++)
        {
            UIImageView *imageView;
            if (i == 0)
            {
                imageView = [[UIImageView alloc] init];
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlStringArray[self.imageUrlStringArray.count-1]]];

            }else if ( i == (self.imageUrlStringArray.count+1))
            {
                imageView = [[UIImageView alloc] init];
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlStringArray[0]]];
            
            }else
            {
                imageView = [[UIImageView alloc] init];
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlStringArray[i-1]]];
        
                
            }

#pragma mark--- 添加那个图片
            //放到那个imageView的数组里边以后操作使用
            [self.imageArray addObject:imageView];
        }
        
#pragma mark--- 设置一下每个控件的frame 并且添加到scrollView上
        for (int i = 0; i < self.imageUrlStringArray.count+2; i++)
        {
            UIImageView *imageView = self.imageArray[i];
            imageView.frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            //添加到scrollView上
            [_scrollview addSubview:imageView];
        }
        
        //拿到网络有关的UI 才可以跟网络有关系  在设置UI 的东西
        _scrollview.contentSize = CGSizeMake(self.imageArray.count*self.frame.size.width, self.frame.size.height);
        
        //设置一下 contentOffset 初始化是1 这样轮播图片 就可以前后都可以适应了
        _scrollview.contentOffset = CGPointMake(1 * self.frame.size.width, 0);
        [self addSubview:_scrollview];
        
        //清除标记
        isfoot = NO;
        //生成pageControl
        [self createuipagecontrol];
        
        //这个只要初始化一次
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self createTimer];
        });
        
        
    }
    
    
    
    
}

-(void)createuipagecontrol
{
    _mypageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width*1/4, self.frame.size.height-50, self.frame.size.width/2, 50)];
    _mypageControl.currentPage = 1;
    _mypageControl.numberOfPages = self.imageArray.count-2;
    _mypageControl.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    _mypageControl.backgroundColor = [UIColor clearColor];
//    _mypageControl.pageIndicatorTintColor = [UIColor grayColor];
//    _mypageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    [_mypageControl addTarget:self action:@selector(pageclicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_mypageControl];
    
    //    #pragma mark--- 这里边添加一个那个UIcontrol 用于点击轮播图回传回去index
    //    UIControl *control = [[UIControl alloc] init];
    //    control.frame = self.frame;
    //    [control addTarget:self action:@selector(tapclick:) forControlEvents:UIControlEventTouchUpInside];
    //    [self addSubview:control];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapclick:)];
    [self addGestureRecognizer:tap];
    
}
-(void)tapclick:(UITapGestureRecognizer *)tap
{
    //回传到上个界面
    
    if (self.block != nil)
    {
        self.block(_mypageControl.currentPage);
    }
    
}

#pragma mark--- 这里滑动的时候 一定要清除 到头的标志 要不然就会认为是最后一个界面了 那样就认为最后一个界面 直接 自动跳到 第一个界面
-(void)clearisfoot
{
    if(_mypageControl.currentPage != (self.imageArray.count-3))
    {
        isfoot = NO;
    }
}

#pragma mark---  pagecontrol 点击事件响应方法
-(void)pageclicked:(UIPageControl *)page
{
    static NSInteger cur = 0;
    static NSInteger next = 0;
    
    cur = _scrollview.contentOffset.x/self.frame.size.width;//当前点击后的下标
    next = _mypageControl.currentPage;//下一个界面的下标
    
    //MyLog(@"cur = %ld next = %ld",(long)cur,(long)next);
    if ( (cur == 1) && (next ==0) )
    {
        _scrollview.contentOffset = CGPointMake((self.imageArray.count - 2) * self.frame.size.width, 0);
        _mypageControl.currentPage = self.imageArray.count - 3;
    }else
        if ( (cur == (self.imageArray.count - 2)) && (next ==(self.imageArray.count - 3)) )
        {
            _scrollview.contentOffset = CGPointMake(1 * self.frame.size.width, 0);
            _mypageControl.currentPage = 0;
        }else
        {
            if (cur != (self.imageArray.count-1))//这块有时候 上一步没执行完 数组越界了 导致崩溃
            {
                //设置一下 contentOffset 点击之后切换图片
                _scrollview.contentOffset = CGPointMake((next+1) * self.frame.size.width, 0);
            }
            
        }
    
    [self clearisfoot];
}

-(void)createTimer
{
    
    if (self.timer != nil) {
        self.timer = nil;
    }
    self.timer =[NSTimer scheduledTimerWithTimeInterval:2.1 target:self selector:@selector(timerrun) userInfo:nil repeats:YES];
}

-(void)timerrun
{
    if(isfoot == YES)
    {
        [_scrollview setContentOffset:CGPointMake((self.imageArray.count-1) * self.frame.size.width, 0) animated:YES];
        _mypageControl.currentPage = 0;
        
        //等到动画执行完事 之后在执行这个 需要延时执行界面 替换
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_scrollview setContentOffset:CGPointMake(1 * self.frame.size.width, 0) animated:NO];
        });
        isfoot = NO;
    }else
    {
        _mypageControl.currentPage = _mypageControl.currentPage + 1;
        [_scrollview setContentOffset:CGPointMake((_mypageControl.currentPage+1) * self.frame.size.width, 0) animated:YES];
        
        if (_mypageControl.currentPage == self.imageArray.count-3 )
        {
            
            isfoot = YES ; //初始化一下 这个很重要
        }
    }
    
    
    
    
    
}


//将要减速的时候触发
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
   // MyLog(@"将要减速触发");
    static NSInteger cur = 0;
    static NSInteger next = 0;
    cur = _mypageControl.currentPage; //当前的界面
    ////下一个界面
    next = _scrollview.contentOffset.x/self.frame.size.width ;
    if ((next-1) != cur)//如果两个界面不相同
    {
        if(( next != self.imageArray.count-1 ) && ( next != 0 ))
        {
            _mypageControl.currentPage = (next-1) % (self.imageArray.count - 2);
        }
    }
    cur = next;
    
    //轮播图的第一步哈哈
    if( next == self.imageArray.count-1 ) //如果轮播图 到了最后一张回到初始化的位置
    {
        _mypageControl.currentPage = 0;
        //设置一下 contentOffset 初始化是1 这样轮播图片 就可以前后都可以适应了
        _scrollview.contentOffset = CGPointMake(1 * self.frame.size.width, 0);
    }
    if( next == 0 ) //如果轮播图到了第一张 那么回到最后一张 倒数第二张
    {
        _mypageControl.currentPage = self.imageArray.count -3 ;
        //设置一下 contentOffset 初始化是1 这样轮播图片 就可以前后都可以适应了
        _scrollview.contentOffset = CGPointMake((_mypageControl.currentPage+1) * self.frame.size.width, 0);
    }
    
    [self clearisfoot];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
