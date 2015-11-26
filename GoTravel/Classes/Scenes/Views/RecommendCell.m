//
//  RecommendCell.m
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "RecommendCell.h"
#import "UIImageView+WebCache.h"
#import "RecommendModel.h"
#import "MyWebController.h"
#import "CarouselMap.h"
@interface RecommendCell ()<UIScrollViewDelegate>
{
    BOOL isValue;
}
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *myImage;//图片

@property (nonatomic, strong) UIPageControl *myPage;

/**用来接收传过来的model值*/
@property (nonatomic ,strong) RecommendModel *imageModel;

@property (nonatomic, strong) NSTimer *time;//计时器
//首先声明一个轮播图属性 和 用来接收传过来的model值
@property (nonatomic, strong) CarouselMap *lunBo;
@property (nonatomic,strong) NSMutableArray *arrayStr;
@end

@implementation RecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.lunBo = [[CarouselMap alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
        [self.contentView addSubview:self.lunBo];
        _arrayStr = [NSMutableArray array];
        isValue = YES;
    }
    
    
    return self;
    
    
    
}

//重写数组的setter方法,这里只走一次
-(void)setImageArray:(NSMutableArray *)imageArray
{
    if (isValue == YES) {
        
    //接收传过来的数组(里面存放的model对象)
    _imageArray = imageArray;
    CarouselMap *lunBo = self.lunBo;
    
    //根据 pagecontrol.currenPage,从数组中 获取网址就行了
    //这个数组是用来存放model对象中的URL接口
    for (int i = 0; i < _imageArray.count; i ++) {
        //用定义的model指针指向数组中的相应的model元素
        _imageModel = self.imageArray[i];
        NSString *str = _imageModel.image_url;//图片url
        [_arrayStr addObject:str];
    }
        
    isValue = NO;
        
    
    //封装类中留出来的接口数组(将我们存储URL接口的数组,添加到封装类中的数组)
    [lunBo.imageUrlStringArray addObjectsFromArray:_arrayStr];
    //执行封装类中的方法
    [lunBo changeImage];
    //根据 pagecontrol.currenPage,从数组中 获取网址就行了
    //同理用来存储一组web接口
    NSMutableArray *arrayStr1 = [NSMutableArray array];
    for (int i = 0; i < _imageArray.count; i ++) {
        
        _imageModel = _imageArray[i];
        
        
        NSString *str = _imageModel.html_url;//点击图片进入web浏览器的接口
        
        [arrayStr1 addObject:str];
        
    }
    //在这里回传上个界面--封装类中留出来的接口
    lunBo.block = ^(NSInteger index)
    {
        
        // block == nil 会 Crash!!!!!!
        if (self.blockUrl != nil) {
            self.blockUrl(arrayStr1[index]);//自定义一个block,当点击图片的时候就入web浏览控制器,并传给它对应的web接口
        }
        
        
    };
    
 }
    
}

- (void)binModel:(RecommendModel *)model
{
    
    _imageModel = model;
    
}
@end
