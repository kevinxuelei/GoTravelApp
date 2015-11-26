//
//  ChoicenssStoryFirstCell.m
//  GoTravel
//
//  Created by lanou3g on 15/11/15.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "ChoicenssStoryFirstCell.h"
#import "UIImageView+WebCache.h"
@interface ChoicenssStoryFirstCell()

/**用户的头像*/
@property (nonatomic, strong) UIImageView *myImage;

/**用户的名字*/
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *addressLabel;


@end


@implementation ChoicenssStoryFirstCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.myImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.myImage];
        
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];
        
        self.addressLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.addressLabel];
        
    }
    
    
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.myImage.frame = CGRectMake(10, 10, 40, 40);
    self.myImage.layer.masksToBounds = YES;
    self.myImage.layer.cornerRadius = 20;
   
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.myImage.frame) + 10, CGRectGetMinY(self.myImage.frame), CGRectGetWidth(self.frame)- self.myImage.frame.size.width - 30, CGRectGetHeight(self.myImage.frame) * 0.5);
    
    self.addressLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame), CGRectGetWidth(self.nameLabel.frame), CGRectGetHeight(self.nameLabel.frame));
    
    
    
}
- (void)binModel:(RecommendDetailModel *)model
{
    
    [self.myImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_m]placeholderImage:[UIImage imageNamed:@"placeHolderimage"]];
    self.nameLabel.text = model.name;
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    
    if (![model.AddressName isEqualToString:@""]) {
        
        self.addressLabel.text = [NSString stringWithFormat:@"故事发生在%@",model.AddressName];
        self.addressLabel.font = [UIFont systemFontOfSize:14];
        
    }
}


@end
