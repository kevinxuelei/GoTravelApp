//
//  CarouselMap.h
//  LWB_Project
//
//  Created by 王剑亮 on 15/11/12.
//  Copyright © 2015年 wangjianliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarouselMap : UIView
#pragma mark--- 网络图片的 NSString 地址数组
@property (nonatomic, strong) NSMutableArray *imageUrlStringArray;
#pragma mark--- title的数组
@property (nonatomic, strong) NSMutableArray *titleArray;
#pragma mark--- 改变内部轮播图的图片每次使用的时候调用
-(void)changeImage;

#pragma mark--- block回传点击事件的index 上个界面跳转到新闻的详情
@property (nonatomic, copy) void (^block)(NSInteger index);
@end
