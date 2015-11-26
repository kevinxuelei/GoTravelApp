//
//  AlllNearbyFirstCell.m
//  GoTravel
//
//  Created by lanou3g on 15/11/15.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "AlllNearbyFirstCell.h"
#import "UIImageView+WebCache.h"

@interface AlllNearbyFirstCell ()

//行业分类图片
@property(nonatomic,strong)UIImageView *icon;
//店名
@property(nonatomic,strong)UILabel *titleLabel;
//星级
@property(nonatomic,strong)UIImageView *onestarImage;

//点评数量
@property(nonatomic,strong)UILabel *tips_count;




@end

@implementation AlllNearbyFirstCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];


        
        
        self.icon = [[UIImageView alloc] init];
        [self.contentView addSubview:self.icon];
        
        self.tips_count = [[UILabel alloc] init];
        [self.contentView addSubview:self.tips_count];
   
    }
    
    return self;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
     self.icon.frame = CGRectMake( self.contentView.frame.size.width/2 - 20, -15, 30, 30);
    self.icon.layer.cornerRadius = 15;
    self.icon.layer.masksToBounds = YES;
    
    self.titleLabel.frame = CGRectMake( self.contentView.frame.size.width/4, 50, self.contentView.frame.size.width - 150, 30);
    self.titleLabel.center = CGPointMake(self.contentView.frame.size.width/2, 50);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    self.titleLabel.textAlignment = UITextAlignmentCenter;
   
    
    
    //这里保证它只初始化一次
    if (self.onestarImage == nil) {
        for (int i = 0; i < 5; i++) {
            self.onestarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-shoucang"]];
            
            self.onestarImage.frame = CGRectMake(self.contentView.frame.size.width/3 + i *15, CGRectGetMaxY(self.titleLabel.frame) + 20, 15, 15);
            [self.contentView addSubview:self.onestarImage];
        }
    } else {
        return;
    }
    
    self.tips_count.frame = CGRectMake(220, CGRectGetMaxY(self.titleLabel.frame) +20, 50, 15);
    
    
    
  
}

-(void)binModelFirst:(NearbyTableViewModel *)model
{
    
    
      self.titleLabel.text = model.name;
    
    self.textLabel.font = [UIFont boldSystemFontOfSize:24];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    
    
      self.tips_count.text = [NSString stringWithFormat:@"%@ 点评",model.tips_count];
   
}


@end










