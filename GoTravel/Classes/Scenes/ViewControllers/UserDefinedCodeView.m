//
//  userDefinedCodeView.m
//  GoTravel
//
//  Created by lanou3g on 15/11/23.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "userDefinedCodeView.h"

#define kArrowHeight 10.f
#define kArrowCurvature 6.f
#define SPACE 2.f
#define ROW_HEIGHT 44.f
#define TITLE_FONT [UIFont systemFontOfSize:16]
#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

@interface UserDefinedCodeView ()





@property(nonatomic,strong)UIImageView *genderImageView;



@property (nonatomic, strong) UIButton *handerView;

@property (nonatomic) CGPoint showPoint;


@property (strong, nonatomic)UIImageView *qrcodeView;


@property(nonatomic,strong)NSString *nametitle;

@property(nonatomic,strong)NSString *nameImage;

@property(nonatomic,strong)UIView *myView;


@end





@implementation UserDefinedCodeView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
          self.backgroundColor = [UIColor orangeColor];
          self.alpha = 0.f;
        
        [self addview];
        
   
    }
    
    return self;
    
}



-(void)addview
{
    _nameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
    _nameImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_nameImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameImageView.frame) +10,20, 80, 20)];
    _nameLabel.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:_nameLabel];
    
    self.myView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, self.frame.size.width - 20, self.frame.size.height - 100)];
    self.myView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.myView];
    
    self.qrcodeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 20, self.frame.size.height - 100)];
    
    //二维码生成
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:@"https://www.baidu.com/"] withSize:250.0f];
    UIImage *customQrcode = [self imageBlackToTransparent:qrcode withRed:60.0f andGreen:74.0f andBlue:89.0f];
    self.qrcodeView.image = customQrcode;
    // set shadow
    self.qrcodeView.layer.shadowOffset = CGSizeMake(0, 2);
    self.qrcodeView.layer.shadowRadius = 2;
    self.qrcodeView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.qrcodeView.layer.shadowOpacity = 0.5;
    
    [self.myView addSubview:self.qrcodeView];
    
    
    self.headImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(90, 90, 50, 50)];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 10;

    [self.qrcodeView addSubview:self.headImageView];
    
    self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.myView.frame)+5, self.myView.frame.size.width, 30)];
//    self.noteLabel.backgroundColor = [UIColor redColor];
    [self addSubview:self.noteLabel];
    
    

}

#pragma mark - InterpolatedUIImage      二维码生成(下面三个方法)
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - QRCodeGenerator
- (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}



#pragma mark ----显示视图的方法
-(void)show
{
    self.handerView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_handerView setFrame:[UIScreen mainScreen].bounds];
    [_handerView setBackgroundColor:[UIColor clearColor]];
    
    [_handerView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_handerView addSubview:self];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:_handerView];
    

    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

-(void)dismiss
{
    [self dismiss:YES];
}

-(void)dismiss:(BOOL)animate
{
    if (!animate) {
        [_handerView removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_handerView removeFromSuperview];
    }];
    
}








@end
