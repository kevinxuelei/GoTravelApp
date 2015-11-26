//
//  WonderfulTravelDetailCell.m
//  GoTravel
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "WonderfulTravelDetailCell.h"
#import "UIImageView+WebCache.h"
@interface WonderfulTravelDetailCell ()

/**图片*/
@property (nonatomic, strong) UIImageView *myImage;

/**播放按钮*/
@property (nonatomic, strong) UIButton *playButton;

/**用户头像*/
@property (nonatomic, strong) UIImageView *headImage;

/**用户名字*/
@property (nonatomic, strong) UILabel *nameLabel;

/**标题*/
@property (nonatomic, strong) UILabel *travelTextLabel;

/**开始时间*/
@property (nonatomic, strong) UILabel *startTimeLabel;

/**总天数*/
@property (nonatomic, strong) UILabel *countDayLabel;

/**里程*/
@property (nonatomic, strong) UILabel *mileageLabel;

/**喜欢人数*/
@property (nonatomic, strong) UILabel *likePersonLabel;


@end



@implementation WonderfulTravelDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.myImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.myImage];
        
        self.playButton = [[UIButton alloc] init];
        [self.myImage addSubview:self.playButton];

        self.headImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headImage];

        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];

        self.travelTextLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.travelTextLabel];

        self.startTimeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.startTimeLabel];

        self.countDayLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.countDayLabel];

        self.mileageLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.mileageLabel];
        
        self.likePersonLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.likePersonLabel];

        
        
        
    }


    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
     self.myImage.frame = CGRectMake(10, 10, CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame) * 0.5 - 20);
    self.myImage.userInteractionEnabled = YES;
    
    self.playButton.frame = CGRectMake(0, 0, 80, 80);
    self.playButton.center = CGPointMake(self.myImage.frame.size.width * 0.5, self.myImage.frame.size.height * 0.5);
    [self.playButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headImage.frame = CGRectMake(0, CGRectGetMaxY(self.myImage.frame) + 10 ,40, 40);
    self.headImage.center = CGPointMake(self.myImage.frame.size.width * 0.5 + 10, self.headImage.center.y);
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 20;
 
    self.nameLabel.frame = CGRectMake(CGRectGetMinX(self.myImage.frame),CGRectGetMaxY(self.headImage.frame) + 10 ,CGRectGetWidth(self.myImage.frame) , 30);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
  
    
    self.travelTextLabel.frame = CGRectMake(CGRectGetMinX(self.myImage.frame), CGRectGetMaxY(self.nameLabel.frame) + 10, CGRectGetWidth(self.myImage.frame), 30);
    self.travelTextLabel.textAlignment = NSTextAlignmentCenter;
  
    
    self.startTimeLabel.frame = CGRectMake(CGRectGetMinX(self.travelTextLabel.frame), CGRectGetMaxY(self.travelTextLabel.frame) + 10, CGRectGetWidth(self.travelTextLabel.frame), 30);

    
    self.countDayLabel.frame = CGRectMake(CGRectGetMinX(self.startTimeLabel.frame),  CGRectGetMaxY(self.startTimeLabel.frame) + 10, CGRectGetWidth(self.startTimeLabel.frame), 30);

    
    self.mileageLabel.frame = CGRectMake(CGRectGetMinX(self.countDayLabel.frame), CGRectGetMaxY(self.countDayLabel.frame) + 10, CGRectGetWidth(self.countDayLabel.frame), 30);

    
    self.likePersonLabel.frame = CGRectMake(CGRectGetMinX(self.mileageLabel.frame), CGRectGetMaxY(self.mileageLabel.frame) + 10, CGRectGetWidth(self.mileageLabel.frame), 30);
    
  
    
}

- (void)binModel:(WonderfulTravelDetailModel *)model
{
    
   
   
    [self.playButton setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(changeStaty:) forControlEvents:UIControlEventTouchDown];
     [self.playButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDragExit];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_m]];
     self.nameLabel.text = model.name;
    self.travelTextLabel.text = model.textName;
    self.startTimeLabel.text = [NSString stringWithFormat:@"开始时间:%@",model.first_day];
    self.countDayLabel.text = [NSString stringWithFormat:@"总天数:%ld天",model.day_count];
  
    self.mileageLabel.text = [NSString stringWithFormat:@"里程:%.2fkm",[model.mileage doubleValue]];
    

    self.likePersonLabel.text = [NSString stringWithFormat:@"喜欢 %@",model.recommendations];
    
    if (model.trackpoints_thumbnail_image != [NSNull null]) {
        
        [self.myImage sd_setImageWithURL:[NSURL URLWithString:model.trackpoints_thumbnail_image]placeholderImage:[UIImage imageNamed:@"placeHolderimage"]];
    }
    
    

}
#pragma mark ---点击改变按钮的状态
- (void)changeStaty:(UIButton *)sender{

     [self.playButton setImage:[UIImage imageNamed:@"payChange.png"] forState:UIControlStateNormal];
}

- (void)buttonClick:(UIButton *)sender
{
    NSLog(@"=======点击了播放按钮");
     [self.playButton setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
#pragma 调用block
    self.block();
    
   
}

@end
