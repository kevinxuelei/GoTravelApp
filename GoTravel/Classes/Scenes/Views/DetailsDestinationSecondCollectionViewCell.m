//
//  DetailsDestinationSecondCollectionViewCell.m
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "DetailsDestinationSecondCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface DetailsDestinationSecondCollectionViewCell ()

@property (nonatomic, strong) UIImageView *cityImageView;
@property (nonatomic, strong) UILabel *cnnameLabel;
@property (nonatomic, strong) UILabel *ennameLabel;

@end
@implementation DetailsDestinationSecondCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cityImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.cityImageView];
        [self.contentView sendSubviewToBack:self.cityImageView];
        
        self.cnnameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.cnnameLabel];
        
        self.ennameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.ennameLabel];
        
        self.cityImageView.frame = CGRectMake(10, 10, self.contentView.frame.size.width - 20, self.contentView.frame.size.height - 20);
        self.cnnameLabel.frame = CGRectMake(CGRectGetMinX(self.cityImageView.frame) + 10, CGRectGetMaxY(self.cityImageView.frame)-50, CGRectGetWidth(self.cityImageView.frame), 20);
        self.ennameLabel.frame = CGRectMake(CGRectGetMinX(self.cityImageView.frame) + 10, CGRectGetMaxY(self.cityImageView.frame)-30, CGRectGetWidth(self.cityImageView.frame), 20);
    }
    return self;
}

- (void)binDictionary:(NSDictionary *)dict
{
    [self.cityImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"photo"]]];
    self.cnnameLabel.text = dict[@"cnname"];
    self.ennameLabel.text = dict[@"enname"];
    NSLog(@"++++----%@", self.ennameLabel.text);
}

@end
