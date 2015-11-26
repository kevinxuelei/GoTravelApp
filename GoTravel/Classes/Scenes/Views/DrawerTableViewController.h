//
//  DrawerTableViewController.h
//  GoTravel
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^myBlock)(NSString *);
@interface DrawerTableViewController : UIViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) myBlock block;


@end
