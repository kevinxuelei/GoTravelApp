//
//  ChoicenssStoryTwoCell.m
//  GoTravel
//
//  Created by lanou3g on 15/11/15.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "ChoicenssStoryTwoCell.h"
#import "UIImageView+WebCache.h"
@interface ChoicenssStoryTwoCell ()

/**图片*/
@property (nonatomic, strong) UIImageView *myImage;

/**图片描述*/
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation ChoicenssStoryTwoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.myImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.myImage];
        
        self.contentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.contentLabel];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.myImage.frame = CGRectMake(10, 10, CGRectGetWidth(self.frame) - 20, 200);
    
    
    self.contentLabel.frame = CGRectMake(CGRectGetMinX(self.myImage.frame), CGRectGetMaxY(self.myImage.frame) + 10, CGRectGetWidth(self.myImage.frame), 30);
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    
    
}

- (void)binTwoModel:(RecommendDetailModel *)model
{
    
    [self.myImage sd_setImageWithURL:[NSURL URLWithString:model.photo_w640]placeholderImage:[UIImage imageNamed:@"placeHolderimage"]];
    
    self.contentLabel.text = model.text;
    
    
}


@end
