//
//  FoodReferViewController.h
//  GoTravel
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>



@interface FoodReferViewController : UIViewController 


@property (weak, nonatomic) IBOutlet UITextField *cityText;
@property (weak, nonatomic) IBOutlet UITextField *keyText;
@property (weak, nonatomic) IBOutlet UIButton *nextPageButton;


- (IBAction)onClickOk:(UIButton *)sender;
- (IBAction)nextPageButton:(UIButton *)sender;

- (IBAction)textFiledReturnEditing:(UITextField *)sender;





@end
