//
//  DetailsDestinationCityThirdCollectionCell.m
//  GoTravel
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "DetailsDestinationCityThirdCollectionCell.h"
#import "UIImageView+WebCache.h"

@interface DetailsDestinationCityThirdCollectionCell ()

@property (nonatomic, strong) UIImageView *landscapeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceoffLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end
@implementation DetailsDestinationCityThirdCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.landscapeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.contentView.frame.size.width, self.contentView.frame.size.height - 100)];
        [self.contentView addSubview:self.landscapeImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.landscapeImageView.frame), CGRectGetMaxY(self.landscapeImageView.frame) + 5, CGRectGetWidth(self.landscapeImageView.frame), 50)];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.numberOfLines = 0;
        
        self.priceoffLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 5, self.contentView.frame.size.width/2, 20)];
        [self.contentView addSubview:self.priceoffLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.priceoffLabel.frame) , CGRectGetMaxY(self.priceoffLabel.frame) - 20, CGRectGetWidth(self.priceoffLabel.frame), 20)];
        [self.contentView addSubview:self.priceLabel];
        
    }
    return self;
}

- (void)binModel:(DetailsDestinationViewCityModel *)model
{
    [self.landscapeImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"placeHolderimage"]];
    self.titleLabel.text = model.title;
    self.titleLabel.numberOfLines = 0;
    self.priceoffLabel.text = model.priceoff;
    
    NSArray *array = [model.price componentsSeparatedByString:@">"];
    
    NSMutableArray *array1 = [NSMutableArray array];
    for (NSString *str in array) {
        NSArray *array2 = [str componentsSeparatedByString:@"<"];
        [array1 addObject:array2];
    }
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@%@", array1[1][0], array1[2][0]];
}
@end
