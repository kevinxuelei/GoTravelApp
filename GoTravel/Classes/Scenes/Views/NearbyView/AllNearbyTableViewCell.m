//
//  AllNearbyTableViewCell.m
//  GoTravel
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "AllNearbyTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface AllNearbyTableViewCell ()

@property(nonatomic,strong)UIImageView *photoImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *gradeLabel;
@property(nonatomic,strong)UILabel *commentLabel;
@property(nonatomic,strong)UILabel *detailLabel;
@property(nonatomic,strong)UILabel *distanceLabel;
@property(nonatomic,strong)UILabel *countPeopleLabel;

@property(nonatomic,strong)UILabel *BackgroundLabel;
@property(nonatomic,strong)UILabel *recommendedLabel;
@property(nonatomic,strong)UIImageView *recommendedImage;
@property(nonatomic,strong)UIImageView *onestarImage;
@property(nonatomic,strong)UIImageView *twostarImage;
@property(nonatomic,strong)UIImageView *threestarImage;
@property(nonatomic,strong)UIImageView *fourstarImage;
@property(nonatomic,strong)UIImageView *fivestarImage;



@end




@implementation AllNearbyTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.BackgroundLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.BackgroundLabel];
        self.BackgroundLabel.backgroundColor = [UIColor whiteColor];
      
        
        self.photoImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.photoImageView];
        
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        
        self.gradeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.gradeLabel];
        
        self.commentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.commentLabel];
        
        self.detailLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.detailLabel];
        
        self.distanceLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.distanceLabel];
        
        self.countPeopleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.countPeopleLabel];
        
        
    }

    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
      self.BackgroundLabel.frame = CGRectMake(20, 10, self.contentView.frame.size.width -40, self.contentView.frame.size.height - 20);


    
    self.photoImageView.frame = CGRectMake(40, 20, 100, self.contentView.frame.size.height - 40);
          self.photoImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"placeHolderimage"]];
    
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.photoImageView.frame) + 5, CGRectGetMinY(self.photoImageView.frame), self.contentView.frame.size.width - 150, 20);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
 
   self.gradeLabel.frame = CGRectMake(CGRectGetMaxX(self.photoImageView.frame) +70, CGRectGetMaxY(self.titleLabel.frame), self.contentView.frame.size.width - 200, 20);
    self.gradeLabel.font = [UIFont systemFontOfSize:12];
    
    
    //这里保证它只初始化一次
    if (self.onestarImage == nil) {
        for (int i = 0; i < 5; i++) {
            self.onestarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-shoucang"]];
            
            self.onestarImage.frame = CGRectMake(CGRectGetMaxX(self.photoImageView.frame) +10+ i * 10, CGRectGetMaxY(self.titleLabel.frame) +5, 10, 10);
            [self.contentView addSubview:self.onestarImage];
        }
    } else {
        return;
    }
    
  
    
   self.commentLabel.frame = CGRectMake(CGRectGetMaxX(self.gradeLabel.frame) +10, CGRectGetMaxY(self.titleLabel.frame), self.contentView.frame.size.width - 350, 20);
     self.commentLabel.font = [UIFont systemFontOfSize:12];

    
   self.detailLabel.frame = CGRectMake(CGRectGetMaxX(self.photoImageView.frame) +10, CGRectGetMaxY(self.gradeLabel.frame) ,self.contentView.frame.size.width - 200, 40);
        self.detailLabel.font = [UIFont systemFontOfSize:12];
    self.detailLabel.numberOfLines = 2;
    
    self.distanceLabel.frame = CGRectMake(CGRectGetMaxX(self.photoImageView.frame) +10, CGRectGetMaxY(self.detailLabel.frame), self.contentView.frame.size.width/5, 20);
     self.distanceLabel.font = [UIFont systemFontOfSize:12];

    
    self.countPeopleLabel.frame = CGRectMake(CGRectGetMaxX(self.distanceLabel.frame) , CGRectGetMaxY(self.detailLabel.frame), self.contentView.frame.size.width/5, 20);
     self.countPeopleLabel.font = [UIFont systemFontOfSize:12];

}

-(void)binModel:(NearbyTableViewModel *)model
{

    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_s]];
    self.titleLabel.text = model.name;
    self.gradeLabel.text = [NSString stringWithFormat:@"%@ 点评",model.tips_count];
    self.detailLabel.text = model.recommended_reason;


    NSInteger floatmi = [NSString stringWithFormat:@"%@",model.distance].floatValue * 1000;
    if (floatmi <1000) {
         self.distanceLabel.text = [NSString stringWithFormat:@"距我 %ldm",floatmi];
    } else {
  
       self.distanceLabel.text = [NSString stringWithFormat:@"距我 %ldkm",floatmi/1000];
    }
    
    
    self.countPeopleLabel.text = [NSString stringWithFormat:@"/  %@ 人去过",model.visited_count];
    
    if ([model.recommended integerValue] == 1) {
        //这里保证只初始化一次
        if (self.recommendedImage == nil) {
            self.recommendedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-tuijian"]];
            [self.contentView addSubview:self.recommendedImage];
            self.recommendedImage.frame = CGRectMake(self.contentView.frame.size.width -80, 0, 30, 30);
        } else {
        
            return;
        
        }
       

        
        
    }
    
    
    
    



}



















@end
