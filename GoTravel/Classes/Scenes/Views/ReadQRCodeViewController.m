//
//  ReadQRCodeViewController.m
//  TuanTuan
//
//  Created by lanou3g on 14-12-17.
//  Copyright (c) 2014年 yiyi. All rights reserved.
//

#import "ReadQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface ReadQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,retain)AVCaptureSession *session;
@property(nonatomic,retain)AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, retain) UIImageView * line;
@end

@implementation ReadQRCodeViewController
//定义二维码的宏
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readQRcode];
    self.view.backgroundColor = [UIColor grayColor];
   
    
    UILabel *labIntroudction = [[UILabel alloc] initWithFrame:CGRectMake(40, 60, kScreenW - 80, 70)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines= 0;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text = @"将二维码图像置于矩形方框内，离手机摄像头10CM左右，即可自动扫描。";
    [self.view addSubview:labIntroudction];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(labIntroudction.frame)+20, kScreenW - 60, kScreenW - 60)];
    imageView.image = [UIImage imageNamed:@"pick_bg@2x1"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(40, 110, 220, 2)];
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(imageView.frame), 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation) userInfo:nil repeats:YES];
    
    
    
    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    scanButton.backgroundColor = [UIColor orangeColor];
    scanButton.frame = CGRectMake((kScreenW - 120)/2, kScreenH - 70, 120, 40);
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    

}
//扫描二维码
-(void)readQRcode
{
    //1.摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.设置输入
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"出错了💔" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];

        return;
    }
    
    //3.设置输出
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //3.1设置代理
    //使用主线程队列
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //4.拍摄回话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [session addInput:input];
    [session addOutput:output];
    //4.1设置输出的格式
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    //5.设置预览图层
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    //5.1设置图层属性
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [preview setFrame:self.view.bounds];//图层大小
    [self.view.layer insertSublayer:preview atIndex:0];//将图层添加到视图的图层
    self.previewLayer = preview;
    
    //6.启动动画
    [session startRunning];
    self.session = session;
}
#pragma mark - 输出代理方法
//此方法时在识别到QRCode,并且完成转换
//如果QRCode的内容越大,转换需要的时间就越长
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //会频繁的扫描,调用代理方法
    //1.如果扫描完成,停止会话
    [self.session stopRunning];
    //删除预览图层
    [self.previewLayer removeFromSuperlayer];

    
    //设置界面显示扫描结果
    
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        if ([obj.stringValue hasPrefix:@"http://"]) {

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:obj.stringValue]];
        }else{
            UIAlertView *alret = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:obj.stringValue delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alret show];
        }
       
    }
    
}

-(void)animation
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(80, 160+2*num, 220, 2);

        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(80, 160+2*num, 220, 2);

        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}
//返回上一级
-(void)backAction
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
