//
//  FootmarkViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "FootmarkViewController.h"

#import "PictureImageModel.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
#import <AVFoundation/AVFoundation.h>
#import "DataBaseTool.h"

@interface FootmarkViewController ()<AVAudioPlayerDelegate>
{
    /**音乐播放器对象*/
     AVAudioPlayer *av;
   
    /**用于判断是按钮播放状态*/
     BOOL isPlay;
}



/**开始播放按钮*/
@property (nonatomic, strong) UIButton *startBt;


/**定时器*/
@property (nonatomic, strong) NSTimer *timer;
/**用于展示的图片视图*/
@property (nonatomic, strong) UIImageView *imageView;


/**图片数组*/
@property (nonatomic, strong) NSMutableArray *imageViewArray;
/**动态图片*/
@property (nonatomic, strong) UIImageView *dongimageView;

/**刷新对象*/
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation FootmarkViewController

- (void)dealloc
{
    
    NSLog(@"----销毁%@",self.class);
 
  
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //加载navigationBar
    [self loadNavigationBar];
    //记载模糊视图
    [self loadBlurView];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    self.hud.minSize = CGSizeMake(100, 100);
    self.hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:self.hud];
    self.hud.dimBackground = YES;
    self.hud.labelText = @"正在加载,请稍等";
    
   // NSLog(@"传过来的数组： ----%ld, -----%@",_pointArray.count,_pointArray);
    
  
    self.imageViewArray = [NSMutableArray array];
 
    isPlay = YES;
}
#pragma mark ---加载模糊视图
- (void)loadBlurView{
    [[DataBaseTool shareHandle] LoadVisualEffectViews:self];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.view.frame) * 0.5 - 210 , CGRectGetWidth(self.view.frame), 300)];
    
    self.imageView.image = [UIImage imageNamed:@"xiang.png"];
    [self.view addSubview:self.imageView];
    
    
    
    self.dongimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 10, CGRectGetWidth(self.view.frame), 60)];
    self.dongimageView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.dongimageView];


}
#pragma mark ---加载navigationBar,及开始按钮的设置
- (void)loadNavigationBar{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-fanhui"]style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
    self.navigationItem.title = @"足迹相册";
    _startBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _startBt.frame = CGRectMake(0, CGRectGetMaxY(self.dongimageView.frame) + 10, 30, 30);
    _startBt.center = CGPointMake(self.view.frame.size.width * 0.5,self.view.frame.size.height - 140);
    [_startBt setImage:[UIImage imageNamed:@"iconfont-bofang"] forState:UIControlStateNormal];
   
    [_startBt addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startBt];
    
}
#pragma mark ---开始播放按钮点击方法
- (void)startClick:(UIButton *)sender
{
    
    if (isPlay == YES) {
        
        [_startBt setImage:[UIImage imageNamed:@"iconfont-bofang"] forState:UIControlStateNormal];
        
        [av stop];
        [self.imageView stopAnimating];
        
        isPlay = NO;
        
    }else{
        
        
        
        [self.hud show:YES];
       
        
        
        NSLog(@"开始播放动画");
        [_startBt setImage:[UIImage imageNamed:@"playing"] forState:UIControlStateNormal];
        
        NSMutableArray *imageArray = [NSMutableArray array];
        __block int index = 0;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(queue, ^{
            for (int  i = 0; i < _pointArray.count; i ++) {
                
                UIImageView *aa = [[UIImageView alloc] init];
                
                PictureImageModel *model = _pointArray[i];
                if (![model.photo_webtrip isEqualToString:@""] && model.photo_webtrip != nil) {
                    //加载完成才会执行我们想要做的事
                    [aa sd_setImageWithURL:[NSURL URLWithString:model.photo_webtrip] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (aa.image != nil) {
                            
                            [imageArray addObject:aa.image];
                        }
                        
                        
                        self.imageView.animationDuration = imageArray.count;
                        //播放的那组照片
                        self.imageView.animationImages = imageArray;
                        //播放的重复次数
                        self.imageView.animationRepeatCount = 9999;
                        //做一次判断，判断我们获取图片的个数是否跟传过来的相同
                        if(_pointArray.count == imageArray.count + index){
                            [self.hud hide:YES];
                            //开始动画播放
                            [self.imageView startAnimating];
                            index = 0;
                            
                            
                            NSURL *url = [[NSBundle mainBundle] URLForResource:@"很爱很爱的.mp3" withExtension:nil];
                            av = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                          
                            
                            [av prepareToPlay];
                            [av play];
                            [MBProgressHUD hideHUD];
                            av.numberOfLoops = -1;
                            av.meteringEnabled = YES;
                            av.delegate = self;
                            _timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(change) userInfo:nil repeats:YES];
                            
                            
                            
                            
                        }
                        
                    }];
                }else{
                    
                    index ++;
                }
                
                
            }
        });
        
        
        
        isPlay = YES;
    }
    
 
}


- (void)change
{
    
    [av updateMeters];
    double lowPassResults = pow(10, (0.05 * [av peakPowerForChannel:0]));//×于当前音量
    //获取电平值
    //NSLog(@"---------%f",lowPassResults);
    //现在取值范围在0~1   (每隔0.7)
    if(0 < lowPassResults < 0.06){
        
        
        [self.dongimageView setImage:[UIImage imageNamed:@"png1.png"]];
        
    }else if( 0.06< lowPassResults <= 0.13){
        
        [self.dongimageView setImage:[UIImage imageNamed:@"png2.png"]];
       
        

        
    }else if( 0.13<lowPassResults <= 0.20){
        
        [self.dongimageView setImage:[UIImage imageNamed:@"png3.png"]];
       
    }else if( 0.20 <lowPassResults <= 0.27){
        
        [self.dongimageView setImage:[UIImage imageNamed:@"png4.png"]];
        
    }else if( 0.27 <lowPassResults <= 0.34){
        
        [self.dongimageView setImage:[UIImage imageNamed:@"png5.png"]];
        
    }else if( 0.34 <lowPassResults <= 0.41){
        
        [self.dongimageView setImage:[UIImage imageNamed:@"png6.png"]];
        
    }else if( 0.41 <lowPassResults <= 0.48){
        
        [self.dongimageView setImage:[UIImage imageNamed:@"png7.png"]];
        
    }else if( 0.48 <lowPassResults <= 0.55){
        
        [self.dongimageView setImage:[UIImage imageNamed:@"png8.png"]];
        
    }else if( 0.55 <lowPassResults <= 0.62){
        
        [self.dongimageView setImage:[UIImage imageNamed:@"png9.png"]];
        
    }else if( 0.62 <lowPassResults <= 0.69){
        
        [self.dongimageView setImage:[UIImage imageNamed:@"png10.png"]];
        
    }else if( 0.69 <lowPassResults <= 0.76){
        
        [self.dongimageView setImage:[UIImage imageNamed:@"png11.png"]];
        
    }else if( 0.76 <lowPassResults <= 0.83){
        
        [self.dongimageView setImage:[UIImage imageNamed:@"png12.png"]];
        
    }else if( 0.83 <lowPassResults <= 0.90){
        
        [self.dongimageView setImage:[UIImage imageNamed:@"png13.png"]];
        
    }else{
        
        
        [self.dongimageView setImage:[UIImage imageNamed:@"png14.png"]];
        
    }
}

#pragma mark ---点击返回按钮
- (void)backAction:(UIBarButtonItem *)sender
{
    [av stop];
    [_timer invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}






@end
