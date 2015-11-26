//
//  AboutUsViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "AboutUsViewController.h"
#import "Extension.h"


@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"关于我们";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"个人中心" style:UIBarButtonItemStylePlain target:self action:@selector(didLeftBarButtonItemAction:)];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-44)];
    [self.view addSubview:scrollView];
    
    UIImageView * headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 200, 100)];
    headImage.image = IMG(@"xialafengjing ");
    headImage.center = CGPointMake(kWidth/2, 60);
    [scrollView addSubview:headImage];
    
    UILabel * iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxX(headImage.frame)+10, kWidth-20, 30)];
    iconLabel.center = CGPointMake(kWidth/2, headImage.center.y*2+10);
    iconLabel.text = @"软件版本1.0";
    iconLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:iconLabel];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, kWidth-20, 20)];
    label.center = CGPointMake(kWidth/2, iconLabel.center.y+30);
    label.text = @"描述:";
    label.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:105/255.0 alpha:1.0];
    [scrollView addSubview:label];

    UILabel * contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame)+10, kWidth-20, 40)];
    contentLabel.text = @"\t本app所有内容，包括文字、图片、音频、视频、软件、程序、以及版式设计等均在网上搜集。\n\t访问者可将本app提供的内容或服务用于个人学习、研究或欣赏，以及其他非商业性或非盈利性用途，但同时应遵守著作权法及其他相关法律的规定，不得侵犯本app及相关权利人的合法权利。除此以外，将本app任何内容或服务用于其他用途时，须征得本app及相关权利人的书面许可，并支付报酬。\n\t本app内容原作者如不愿意在本app刊登内容，请及时通知本app，予以删除。\n地址：北京市海淀区清河毛纺路路南甲36号金五星商业大厦五层。\nUI设计:魏义涛，任义春，程登辉；\n联系邮箱:weiyitao_wyt@163.com。";
    contentLabel.numberOfLines = 0;
    [contentLabel sizeToFit];
    [scrollView addSubview:contentLabel];
    CGFloat height = [self stringHeightWithString:contentLabel.text fontSize:18 contentSize:CGSizeMake(kWidth, 100000)];
    scrollView.contentSize = CGSizeMake(kWidth, CGRectGetMaxY(label.frame)+10+height);
}
- (CGFloat)stringHeightWithString:(NSString *)str fontSize:(CGFloat)fontSize contentSize:(CGSize)size
{
    //    第一个参数 代表最大的范围
    //    第二个参数 代表 是否考虑字体、字号
    //    第三个参数 代表使用什么字体、字号
    //    第四个参数 用不到 所以基本为nil
    CGRect stringRect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return stringRect.size.height;
}
- (void)didLeftBarButtonItemAction:(UIBarButtonItem *)leftBtn{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



@end
