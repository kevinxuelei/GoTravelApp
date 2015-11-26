//
//  DetailsDesSecCollectionViewCell.m
//  GoTravel
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "DetailsDesSecCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface DetailsDesSecCollectionViewCell ()

@property (nonatomic, strong) UIImageView *cityImageView;
@property (nonatomic, strong) UILabel *cnnameLabel;
@property (nonatomic, strong) UILabel *ennameLabel;

@end
@implementation DetailsDesSecCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        [self.contentView addSubview:self.cityImageView];
        [self.contentView sendSubviewToBack:self.cityImageView];
        
        self.cnnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.cityImageView.frame) + 10, CGRectGetMaxY(self.cityImageView.frame) - 40, CGRectGetWidth(self.cityImageView.frame)-20, 20)];
        [self.contentView addSubview:self.cnnameLabel];
        
        self.ennameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.cityImageView.frame) + 10, CGRectGetMaxY(self.cityImageView.frame) - 20, CGRectGetWidth(self.cityImageView.frame)-20, 20)];
        [self.contentView addSubview:self.ennameLabel];

    }
    return self;
}

- (void)binModel:(DetailsDestinationViewModel *)model
{
    [self.cityImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"placeHolderimage"]];
    self.cnnameLabel.text = model.cnname;
    self.ennameLabel.text = model.enname;
    
    self.cnnameLabel.textColor = [UIColor whiteColor];
    self.ennameLabel.textColor = [UIColor whiteColor];
    
    self.cnnameLabel.font = [UIFont fontWithName:@"STHeiti-Medium.ttc" size:12.f];
    self.ennameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.f];
}
@end
