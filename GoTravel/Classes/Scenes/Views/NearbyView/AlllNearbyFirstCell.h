//
//  AlllNearbyFirstCell.h
//  GoTravel
//
//  Created by lanou3g on 15/11/15.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearbyTableViewModel.h"

@interface AlllNearbyFirstCell : UITableViewCell

@property(nonatomic,strong)NearbyTableViewModel *model;

-(void)binModelFirst:(NearbyTableViewModel *)model;


@end
