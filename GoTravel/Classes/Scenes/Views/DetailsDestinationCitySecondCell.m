//
//  DetailsDestinationCitySecondCell.m
//  GoTravel
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "DetailsDestinationCitySecondCell.h"
#import "TabBarButton.h"

@interface DetailsDestinationCitySecondCell ()

@property (nonatomic, strong) TabBarButton *selectButton;
@property (nonatomic, strong) TabBarButton *playButton;
@property (nonatomic, strong) TabBarButton *foodButton;
@property (nonatomic, strong) TabBarButton *liveButton;

@end
@implementation DetailsDestinationCitySecondCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectButton = [TabBarButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.selectButton];
        
        self.playButton = [TabBarButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.playButton];
        
        self.foodButton = [TabBarButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.foodButton];
        
        self.liveButton = [TabBarButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.liveButton];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setWithNormalName:@"select" title:@"精选" button:self.selectButton index:0];
    [self setWithNormalName:@"play" title:@"游玩" button:self.playButton index:1];
    [self setWithNormalName:@"live" title:@"住宿" button:self.liveButton index:2];
    
}
- (void)setWithNormalName:(NSString *)normal title:(NSString *)title button:(TabBarButton *)button index:(NSInteger)index
{
    CGFloat buttonW = self.contentView.frame.size.width / 3;
    CGFloat buttonH = self.contentView.frame.size.height;
    button.frame = CGRectMake(buttonW * index, 0, buttonW, buttonH);
    button.tag = 100 + index;
    [button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    button.imageView.contentMode = UIViewContentModeCenter; // 让图片在按钮内居中
    button.imageView.layer.masksToBounds = YES;
    button.imageView.layer.cornerRadius = buttonW/2;
    button.titleLabel.textAlignment = NSTextAlignmentCenter; // 让标题在按钮内居中
    
    button.font = [UIFont systemFontOfSize:12]; // 设置标题的字体大小
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
}
- (void)buttonClicked:(TabBarButton *)button
{
    NSLog(@"%@",button.titleLabel.text);

    self.block(button.tag);
}
@end
