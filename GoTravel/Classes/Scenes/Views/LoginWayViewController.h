//
//  LoginWayViewController.h
//  GoTravel
//
//  Created by lanou3g on 15/11/23.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sendName)(NSString *);
@interface LoginWayViewController : UIViewController
@property (nonatomic, copy)sendName block;

@end
