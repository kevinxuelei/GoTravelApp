//
//  DetailsDestinationCitySecondCell.h
//  GoTravel
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^myblock)(NSInteger);
@interface DetailsDestinationCitySecondCell : UITableViewCell
@property (nonatomic, copy) myblock block;
@end
