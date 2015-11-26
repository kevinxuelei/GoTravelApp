//
//  userDefinedCodeView.h
//  GoTravel
//
//  Created by lanou3g on 15/11/23.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDefinedCodeView : UIView


@property(nonatomic,strong)UIImageView *nameImageView;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UIImageView *headImageView;


@property(nonatomic,strong)UILabel *noteLabel;

-(void)show;
-(void)dismiss;
-(void)dismiss:(BOOL)animated;


@end
