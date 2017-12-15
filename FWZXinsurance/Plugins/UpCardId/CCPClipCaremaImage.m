//
//  CCPClipCaremaImage.m
//  QHPay
//
//  Created by liqunfei on 16/3/15.
//  Copyright © 2016年 chenlizhu. All rights reserved.
//

#import "CCPClipCaremaImage.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Rotate.h"
#define MAINSCREEN_BOUNDS  [UIScreen mainScreen].bounds
#define ScreenScaleRatio [UIScreen mainScreen].bounds.size.width/414.0
@interface CCPClipCaremaImage()
@property (nonatomic,strong) AVCaptureSession *captureSession;
@property (nonatomic,strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic,strong) AVCaptureStillImageOutput *imageOutput;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *VPlayer;
@property (nonatomic,strong) AVCaptureDevice *captureDevice;
@end

@implementation CCPClipCaremaImage

- (id) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setUpCameraPreviewLayer];
        [self addSubview:[self makeScanCameraShadowViewWithRect]];
        //创建自定义视图
        [self createCusphoto];
        
    }
    return self;
}
- (void)createCusphoto
{
    
}
- (void)setUpCameraPreviewLayer {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return;
    }
    if (!_VPlayer) {
        [self initSession];
        self.VPlayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        self.VPlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.VPlayer.position = self.center;
        self.VPlayer.bounds = self.bounds;
//        self.VPlayer.transform =   CGAffineTransformMakeRotation(M_PI*3);
        [self.layer insertSublayer:self.VPlayer atIndex:0];
    }
}

- (void)initSession {
    self.captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [self.captureDevice lockForConfiguration:nil];
    [self.captureDevice unlockForConfiguration];
    
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    self.deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithDirection:AVCaptureDevicePositionBack] error:nil];
    self.imageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.imageOutput setOutputSettings:outputSettings];
    if ([self.captureSession canAddInput:self.deviceInput]) {
        [self.captureSession addInput:self.deviceInput];
    }
    if ([self.captureSession canAddOutput:self.imageOutput]) {
        [self.captureSession addOutput:self.imageOutput];
    }
}

- (AVCaptureDevice *)cameraWithDirection:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

/**屏幕尺寸-宽度*/
#define kWidth ([UIScreen mainScreen].bounds.size.width)
/**屏幕尺寸-高度*/
#define kHeight ([UIScreen mainScreen].bounds.size.height)
/*
 返回中间框大小
 */
- (CGRect)makeScanReaderInterrestRect {
    
    CGFloat cardwidth = (kHeight-kHeight/4)*0.63;
    CGRect scanRect = CGRectMake((kWidth-cardwidth)/2, 0, cardwidth, kHeight-kHeight/4);
//    scanRect.origin.x = MAINSCREEN_BOUNDS.size.width/2 - scanRect.size.width / 2;
    scanRect.origin.y = kHeight/8;
    return scanRect;
}

/*
 相机界面
 */
- (UIImageView *)makeScanCameraShadowViewWithRect{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:MAINSCREEN_BOUNDS];
    UIGraphicsBeginImageContext(imgView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0, 0, 0, 0.3);
    CGContextFillRect(context, MAINSCREEN_BOUNDS);
    CGContextClearRect(context, [self makeScanReaderInterrestRect]);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imgView.image = image;
    CGFloat cardwidth = (kHeight-kHeight/4)*0.63;
//    CGRect scanRect = CGRectMake((kWidth-cardwidth)/2, 0, cardwidth, kHeight-kHeight/4);

    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth-cardwidth)/2, 0, cardwidth, kHeight-kHeight/4)];
    headView.image = [UIImage imageNamed:@"xuxian.png"];
    headView.center = imgView.center;
    headView.transform = CGAffineTransformMakeRotation(M_PI*2);
    [imgView addSubview:headView];
    
    return imgView;
}

/*
 拍照事件
 */
- (void)takePhotoWithCommit:(void (^)(UIImage *image))commitBlock {
    AVCaptureConnection *vConnection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    vConnection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;//控制输出照片方向
    __block UIImage *image;
    if (!vConnection) {
        NSLog(@"failed");
        return ;
    }
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:vConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return ;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        image = [UIImage imageWithData:imageData];
//        image  = [self fixOrientation:image];
        image = [image rotate:UIImageOrientationRight];
//        CGRect rect1 = [self transfromRectWithImageSize:image.size];
////        CGFloat cardwidth = (kHeight-kHeight/4)*0.63;
////        CGRect rect1=CGRectMake((kWidth-cardwidth)/2, kHeight/8, cardwidth, kHeight-kHeight/4);
//        UIGraphicsBeginImageContext(rect1.size);
//        CGImageRef subImgeRef = CGImageCreateWithImageInRect(image.CGImage, rect1);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextDrawImage(context, rect1, subImgeRef);
//        image = [UIImage imageWithCGImage:subImgeRef];
//        UIGraphicsEndImageContext();
        commitBlock(image);
    }];
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
/*
 比例剪切照片
 */
- (CGRect)transfromRectWithImageSize:(CGSize)size {
    CGRect newRect;
    CGRect clipRect = [self makeScanReaderInterrestRect];
    CGFloat  clipWidth = clipRect.size.width;
    CGFloat  clipHeigth = clipRect.size.height;
    CGFloat  imageH = size.height;
    CGFloat  imageW = size.width;
    CGFloat  vpLayerW = self.bounds.size.width;
    CGFloat  vpLayerH = self.bounds.size.height;
    newRect.size = CGSizeMake(imageW * clipWidth / vpLayerW, imageH * clipHeigth / vpLayerH);
//    newRect.size = CGSizeMake(imageH * clipHeigth / vpLayerH, imageW * clipWidth / vpLayerW);
    newRect.origin = CGPointMake((imageW - newRect.size.width)/2, (imageH - newRect.size.height)/2);

    return newRect;
}

- (void)startCamera
{
    if (self.captureSession) {
        [self.captureSession startRunning];
    }
}

- (void)stopCamera {
    if (self.captureSession) {
        [self.captureSession stopRunning];
    }
}

/*
 闪光灯
 */
- (BOOL)isOpenFlash {
    if ([self.captureDevice hasFlash] && [self.captureDevice hasTorch]) {
        if (self.captureDevice.torchMode == AVCaptureTorchModeOff) {
            [self.captureSession beginConfiguration];
            [self.captureDevice lockForConfiguration:nil];
            [self.captureDevice setTorchMode:AVCaptureTorchModeOn];
            [self.captureDevice setFlashMode:AVCaptureFlashModeOn];
            [self.captureDevice unlockForConfiguration];
            return YES;
        }
        else if (self.captureDevice.torchMode == AVCaptureTorchModeOn) {
            [self.captureSession beginConfiguration];
            [self.captureDevice lockForConfiguration:nil];
            [self.captureDevice setTorchMode:AVCaptureTorchModeOff];
            [self.captureDevice setFlashMode:AVCaptureFlashModeOff];
            [self.captureDevice unlockForConfiguration];
            return NO;
        }
        [self.captureSession commitConfiguration];
    }
    return YES;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationLandscapeLeft;
    
}



- (NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape;
    
}



- (BOOL)shouldAutorotate {
    
    return YES;
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        
        return YES;
        
    } else {
        
        return NO;
        
    }
    
}

@end
