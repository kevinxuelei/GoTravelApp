//
//  ThirdRegistViewController.m
//  友盟第三方登陆练习
//
//  Created by lanou3g on 15/11/22.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "ThirdRegistViewController.h"
#import "UMSocial.h"
#import "UIImageView+WebCache.h"

@interface ThirdRegistViewController ()



@end

@implementation ThirdRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];

#pragma mark ---在授权完成后调用获取用户信息的方法
    //获取accestoken以及新浪用户信息，得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
        
        //screen_name
        //profile_image_url
        
        NSDictionary *dic = response.data;
       self.nameLabel.text =  dic[@"screen_name"];
        //[self.icon sd_setImageWithURL:[NSURL URLWithString:model.icon]];
        [self.userImage sd_setImageWithURL:[NSURL URLWithString:dic[@"profile_image_url"]]];

    }];
    
    
    
    
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
