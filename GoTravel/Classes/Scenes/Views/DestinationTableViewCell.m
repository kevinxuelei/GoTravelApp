//
//  DestinationTableViewCell.m
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "DestinationTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface DestinationTableViewCell ()

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UILabel *cnnameLabel;
@property (nonatomic, strong) UILabel *ennameLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *labelLabel;

@end

@implementation DestinationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.photoImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.photoImageView];
        
        self.cnnameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.cnnameLabel];
        
        self.ennameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.ennameLabel];
        
        self.countLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.countLabel];
        
        self.labelLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.labelLabel];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.photoImageView.frame = CGRectMake(20, 20, 100, self.contentView.frame.size.height - 40);
    
    self.cnnameLabel.frame = CGRectMake(CGRectGetMaxX(self.photoImageView.frame) + 10, CGRectGetMinY(self.photoImageView.frame), self.contentView.frame.size.width - 160, 20);
    
    self.ennameLabel.frame = CGRectMake(CGRectGetMaxX(self.photoImageView.frame) + 10, CGRectGetMaxY(self.cnnameLabel.frame) + 10, CGRectGetWidth(self.cnnameLabel.frame), 20);
    
    self.countLabel.frame = CGRectMake(CGRectGetMaxX(self.photoImageView.frame) + 10, CGRectGetMaxY(self.ennameLabel.frame) + 10, CGRectGetWidth(self.cnnameLabel.frame), 20);
   
    self.labelLabel.frame = CGRectMake(CGRectGetMaxX(self.photoImageView.frame) + 10, CGRectGetMaxY(self.countLabel.frame) + 10, CGRectGetWidth(self.cnnameLabel.frame), 20);

}

- (void)binModel:(DestinationViewControllerModel *)model
{
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"placeHolderimage"]];
    self.cnnameLabel.text = model.cnname;
    self.ennameLabel.text = model.enname;
    self.countLabel.text = [NSString stringWithFormat:@"%@", model.count];
    self.labelLabel.text = model.label;
}

@end
