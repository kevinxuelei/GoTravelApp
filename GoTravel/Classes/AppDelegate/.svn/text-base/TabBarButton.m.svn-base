//
//  TabBarButton.m
//  自定义
//
//  Created by lanou3g on 15/10/31.
//  Copyright (c) 2015年 WYT. All rights reserved.
//

#import "TabBarButton.h"

@implementation TabBarButton

#pragma mark 设置Button内部的image的范围
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
     CGFloat imageW = contentRect.size.width;
     CGFloat imageH = contentRect.size.height * 0.6;

     return CGRectMake(0, 5, imageW, imageH);
}

#pragma mark 设置Button内部的title的范围
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height *0.6+5;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;

    return CGRectMake(0, titleY, titleW, titleH);
}





@end
