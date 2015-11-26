//
//  RecommendCell.h
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"
@interface RecommendCell : UITableViewCell

- (void)binModel:(RecommendModel *)model;

/**用来接收传过来的数组*/
@property (nonatomic, strong) NSMutableArray *imageArray;//图片数组

//利用block给webControll界面传值
@property (nonatomic, copy) void(^blockUrl)(NSString *urlStr);

@end
