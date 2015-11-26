//
//  StoryCell.m
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "StoryCell.h"
#import "UIImageView+WebCache.h"

@interface StoryCell  ()

@property (nonatomic, strong) UIImageView *myImage;//图片

@property (nonatomic, strong) UILabel *contentLabel;//内容

@property (nonatomic, strong) UIImageView *headImage;//头像

@property (nonatomic, strong) UILabel *nameLabel;//名字

@end

@implementation StoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.myImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.myImage];
        
        self.contentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.contentLabel];
        
        self.headImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headImage];
        
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    self.myImage.frame = CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height-20);
    
    self.contentLabel.frame = CGRectMake(CGRectGetMinX(self.myImage.frame), CGRectGetMaxY(self.myImage.frame)-80, CGRectGetWidth(self.myImage.frame), 40);
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    self.contentLabel.textColor = [UIColor whiteColor];
    
    self.headImage.frame = CGRectMake(CGRectGetMinX(self.contentLabel.frame), CGRectGetMaxY(self.contentLabel.frame), 30, 30);
    
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 15;
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame) + 10, CGRectGetMinY(self.headImage.frame), self.frame.size.width - 80, 30);
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.textColor = [UIColor whiteColor];
    
    
}

- (void)binModel:(RecommendModel *)model
{
    
  
    [self.myImage sd_setImageWithURL:[NSURL URLWithString:model.index_cover] placeholderImage:[UIImage imageNamed:@"placeHolderimage"]];

    self.contentLabel.text = model.index_title;
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel sizeToFit];
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_m]];
    self.nameLabel.text = model.name;
    
    
    
}




@end
