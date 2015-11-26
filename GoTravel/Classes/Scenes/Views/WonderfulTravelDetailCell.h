//
//  WonderfulTravelDetailCell.h
//  GoTravel
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WonderfulTravelDetailModel.h"
@interface WonderfulTravelDetailCell : UITableViewCell


- (void)binModel:(WonderfulTravelDetailModel *)model;

@property (nonatomic, copy) void (^block)();

@end
