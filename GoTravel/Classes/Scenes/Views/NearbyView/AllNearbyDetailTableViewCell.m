//
//  AllNearbyDetailTableViewCell.m
//  GoTravel
//
//  Created by lanou3g on 15/11/14.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "AllNearbyDetailTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface AllNearbyDetailTableViewCell ()

//图片
@property(nonatomic,strong)UIImageView *photoImageView;
//行业分类图标
@property(nonatomic,strong)UIImageView *icon;
//店名
@property(nonatomic,strong)UILabel *titleLabel;
//本店详情介绍
@property(nonatomic,strong)UILabel *detailLabel;
//本店地址
@property(nonatomic,strong)UILabel *address;
//联系电话
@property(nonatomic,strong)UILabel *tel;

//详情页面的cover


@end


@implementation AllNearbyDetailTableViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    self.photoImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.photoImageView];

     
    self.icon = [[UIImageView alloc] init];
    [self.contentView addSubview:self.icon];
        
        
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.text = self.model.name;
        
    self.detailLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.detailLabel];
    
    self.address = [[UILabel alloc] init];
    [self.contentView addSubview:self.address];
    
    self.tel = [[UILabel alloc] init];
    [self.contentView addSubview:self.tel];
     
 }

    return self;
}



-(void)layoutSubviews
{
    [super layoutSubviews];



}

//重写model的setter方法  将model接收到的值,赋给本身的label
-(void)setModel:(NearbyTableViewModel *)model
{
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_s]];
    self.titleLabel.text = model.name;
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel sizeToFit];
    self.detailTextLabel.text = model.mydescription;
    self.address.text = model.address;
    self.tel.text = [NSString stringWithFormat:@"%@",model.tel];
   

}








@end












