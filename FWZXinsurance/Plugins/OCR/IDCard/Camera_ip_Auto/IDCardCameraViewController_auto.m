//
//  CameraViewController.m
//

#import "IDCardCameraViewController_auto.h"
#import "IDCardOverView_auto.h"
#import "IDCardSlideLine.h"
#import "ResultViewController.h"

#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
#import "IDCardOCR.h"
#endif


//屏幕的宽、高
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface IDCardCameraViewController_auto ()<UIAlertViewDelegate>{
    
    UIButton *_photoBtn; //手动拍照按钮
    IDCardOverView_auto *_overView;//预览界面覆盖层,显示是否找到边
    BOOL _on;//闪光灯是否打开
    
    NSTimer *_timer;//定时器，实现实时对焦
    CAShapeLayer *_maskWithHole;//预览界面覆盖的半透明层
    CAShapeLayer *_maskWithHole1;//预览界面覆盖的半透明层
    AVCaptureDevice *_device;//当前摄像设备
    BOOL _isFoucePixel;//是否开启对焦
    int _sliderAllLine;//机读码类型
    int _confimCount;//找到边的次数
    int _maxCount;//找边最大次数
    int _pixelLensCount;//镜头位置稳定的次数
    float _isIOS8AndFoucePixelLensPosition;//相位聚焦下镜头位置
    float _aLensPosition;//默认镜头位置
    AVCaptureConnection *_videoConnection;
    
    UIButton *_lightspotSwitch;//光斑检测开关
    BOOL _lightspotOn;//是否打开光斑检测，默认不打开
    UILabel *_lightspotLabel;//检测光斑提示
    UILabel *_scanspotLabel;;//扫描提示
    
    NSString *_originalImagepath;   //识别原图路径
    NSString *_cropImagepath;       //识别完成后裁切证件图片路径
    NSString *_headImagePath;       //识别完成后裁切头像图片路径
    
    int _unConfirmCount;  //没有检测到边线的次数
    int _isConfirmCount;  //检测到边线的次数
    int _recogReuslt;       //识别接口返回值
    
    CGPoint _point1;
    CGPoint _point2;
    CGPoint _point3;
    CGPoint _point4;
    
    NSDictionary *_conners;

}

#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
@property (strong, nonatomic) IDCardOCR *cardRecog;//核心
#endif

@property (assign, nonatomic) BOOL adjustingFocus;//是否正在对焦
@property (strong, nonatomic) UILabel *middleLabel;
@end
@implementation IDCardCameraViewController_auto

-(void)dealloc{
    
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
    //释放识别核心
    [_cardRecog recogFree];
    NSLog(@"释放识别核心!!!!!!!!");

#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    //设置图片存储路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    _originalImagepath = [documentsDirectory stringByAppendingPathComponent:@"originalImage.jpg"];
    _cropImagepath = [documentsDirectory stringByAppendingPathComponent:@"cropImage.jpg"];
    _headImagePath = [documentsDirectory stringByAppendingPathComponent:@"headImage.jpg"];
    
    //最大连续检边次数
    _maxCount = 1;
    
    
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
    //初始化识别核心
    [self initRecog];
    
    //初始化相机
    [self initialize];
    
    //创建相机界面控件
    [self createCameraView];
#endif
    
}

#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    
    _point1= CGPointMake(0, 0);
    _point2= CGPointMake(0, kScreenHeight);
    _point4= CGPointMake(kScreenWidth, 0);
    _point3= CGPointMake(kScreenWidth, kScreenHeight);
    
    _pixelLensCount = 0;
    _confimCount = 0;
    //将处理图片状态值置为NO
    self.isProcessingImage = NO;
    
    if(!_isFoucePixel){//如果不支持相位对焦，开启自定义对焦
        //定时器 开启连续对焦
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.3 target:self selector:@selector(fouceMode) userInfo:nil repeats:YES];
    }
    
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    int flags = NSKeyValueObservingOptionNew;
    //注册反差对焦通知（5s以下机型）
    [camDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
    if (_isFoucePixel) {
        [camDevice addObserver:self forKeyPath:@"lensPosition" options:flags context:nil];
    }
    [self.session startRunning];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //移除聚焦监听
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [camDevice removeObserver:self forKeyPath:@"adjustingFocus"];
    if (_isFoucePixel) {
        [camDevice removeObserver:self forKeyPath:@"lensPosition"];
    }
    [self.session stopRunning];
}
- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //关闭定时器
    if(!_isFoucePixel){
        [_timer invalidate];
        _timer = nil;
    }
}

//监听对焦
-(void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if([keyPath isEqualToString:@"adjustingFocus"]){
        self.adjustingFocus =[[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1]];
    }
    if([keyPath isEqualToString:@"lensPosition"]){
        _isIOS8AndFoucePixelLensPosition =[[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        //NSLog(@"_isIOS8AndFoucePixelLensPosition 1 = %f",_isIOS8AndFoucePixelLensPosition);
    }
}

#pragma mark -------------------- 初始化识别核心----------------------------
- (void) initRecog
{
    NSDate *before = [NSDate date];
    self.cardRecog = [[IDCardOCR alloc] init];
    
    /*提示：该开发码和项目中的授权仅为演示用，客户开发时请替换该开发码及项目中Copy Bundle Resources 中的.lsc授权文件*/
    int intRecog = [self.cardRecog InitIDCardWithDevcode:@"5LIK5RW357UF6II" recogLanguage:0];
    NSLog(@"核心初始化返回值 = %d\n返回值为0成功 其他失败\n\n常见错误：\n-10601 开发码错误(核心初始化方法传入开发码)\n-10602 Bundle identifier错误\n-10605 Bundle display name错误\n-10606 CompanyName错误\n请检查授权文件（wtproject.lsc）绑定的信息与Info.plist中设置是否一致!!!\n",intRecog);
    
    //设置扫描模式下核心的配置
    [self setRecongConfiguration];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:before];
    NSLog(@"初始化核心时间：%f", time);
    
}
//设置扫描模式下核心的配置
- (void)setRecongConfiguration{
    
    [self.cardRecog setVideoStreamCropTypeExWithType:1];
    
    [self.cardRecog setPictureClearValueEx:80];
    if (self.recogType == 3000) {
        //机读码
        [_cardRecog setParameterWithMode:1 CardType:1033];
    }else{
        //非机读码
        [_cardRecog setParameterWithMode:1 CardType:self.recogType];
    }
    //设置二代证识别类型（0-正反面 1-正面 2-背面），在调用setParameterWithMode之后调用
    [self.cardRecog SetDetectIDCardType:0];
    
    //设置检边参数 只能检边方式，检边区域为整图分辨率
    [_cardRecog setROIWithLeft:0 Top:0 Right:1280 Bottom:720];

}

#pragma mark -------------------- 初始化相机----------------------------
//初始化相机
- (void) initialize
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        //判断摄像头授权
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            
            UIAlertView * alt = [[UIAlertView alloc] initWithTitle:@"请在手机'设置'-'隐私'-'相机'里打开权限" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alt show];
            return;
        }
    }
    //1.创建会话层
    self.session = [[AVCaptureSession alloc] init];
    //设置图片品质，此分辨率为最佳识别分辨率，建议不要改动
    [self.session setSessionPreset:AVCaptureSessionPreset1280x720];
    
    //2.创建、配置输入设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in devices)
    {
        if (device.position == AVCaptureDevicePositionBack)
        {
            _device = device;
            self.captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        }
    }
    if ([self.session canAddInput:self.captureInput]) {
        [self.session addInput:self.captureInput];
    }
    
    //创建、配置预览输出设备
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    [self.session addOutput:captureOutput];
    
    //判断对焦方式
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        AVCaptureDeviceFormat *deviceFormat = _device.activeFormat;
        if (deviceFormat.autoFocusSystem == AVCaptureAutoFocusSystemPhaseDetection){
            _isFoucePixel = YES;
            _maxCount = 4;//最大连续检边次数
        }
    }
    
    //设置预览
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession: self.session];
    self.preview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.preview];
    
}

#pragma mark -------------------- 创建相机界面----------------------------
//创建相机界面
- (void)createCameraView{
    //设置检边视图层
    _overView = [[IDCardOverView_auto alloc] initWithFrame:self.view.bounds];
    _overView.backgroundColor = [UIColor clearColor];
    //居中显示
    _overView.center = self.view.center;
    //检边区域frame
    [self.view addSubview:_overView];
    
    
    //显示当前识别卡种
    self.middleLabel = [[UILabel alloc] init];
    self.middleLabel.frame = CGRectMake(0, 0, 300, 30);
    self.middleLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
    self.middleLabel.center = self.view.center;
    self.middleLabel.backgroundColor = [UIColor clearColor];
    self.middleLabel.textColor = [UIColor orangeColor];
    self.middleLabel.textAlignment = NSTextAlignmentCenter;
    self.middleLabel.text = NSLocalizedString(self.typeName, nil) ;
    [self.view addSubview:self.middleLabel];
    
    //返回、闪光灯按钮
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15,15, 35, 35)];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"back_camera_btn"] forState:UIControlStateNormal];
    backBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:backBtn];
    
    UIButton *flashBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-50,15, 35, 35)];
    [flashBtn setImage:[UIImage imageNamed:@"flash_camera_btn"] forState:UIControlStateNormal];
    [flashBtn addTarget:self action:@selector(flashBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flashBtn];
    
    //相机拍照按钮
    _photoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,60, 60)];
    _photoBtn.center = CGPointMake(kScreenWidth*0.5, kScreenHeight-30);
    [_photoBtn setImage:[UIImage imageNamed:@"take_pic_btn"] forState:UIControlStateNormal];
    [_photoBtn addTarget:self action:@selector(photoBtn) forControlEvents:UIControlEventTouchUpInside];
    [_photoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.view addSubview:_photoBtn];
    
    //光斑检测开关
    _lightspotSwitch = [UIButton buttonWithType:UIButtonTypeCustom];
    _lightspotSwitch.frame = CGRectMake(0, kScreenHeight-30, 100, 30);
    [_lightspotSwitch setTitle:@"光斑检测:开" forState:UIControlStateSelected];
    [_lightspotSwitch setTitle:@"光斑检测:关" forState:UIControlStateNormal];
    _lightspotSwitch.selected = NO;
    [_lightspotSwitch addTarget:self action:@selector(OpenLightspotSwich) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lightspotSwitch];
    
    //光斑检测提示
    _lightspotLabel = [[UILabel alloc] init];
    _lightspotLabel.frame = CGRectMake(0, 0, 200, 30);
    _lightspotLabel.center = CGPointMake(kScreenWidth*.5, 30);
    _lightspotLabel.backgroundColor = [UIColor blackColor];
    _lightspotLabel.font = [UIFont systemFontOfSize:15];
    _lightspotLabel.textColor = [UIColor whiteColor];
    _lightspotLabel.text = @"检测到光斑，请换个角度扫描";
    _lightspotLabel.textAlignment = NSTextAlignmentCenter;
    _lightspotLabel.hidden = YES;
    [self.view addSubview:_lightspotLabel];
    
    _scanspotLabel = [[UILabel alloc] init];
    _scanspotLabel.frame = CGRectMake(0, 0, 200, 30);
    _scanspotLabel.backgroundColor = [UIColor blackColor];
    _scanspotLabel.textColor = [UIColor whiteColor];
    _scanspotLabel.text = @"";
    _scanspotLabel.font = [UIFont systemFontOfSize:15];
    _scanspotLabel.textAlignment = NSTextAlignmentCenter;
    _scanspotLabel.center = CGPointMake(kScreenWidth*.5, 60);
    _scanspotLabel.hidden = YES;
    [self.view addSubview:_scanspotLabel];
    
}
- (CGPoint)realImageTranslateToScreenCoordinate:(CGPoint)point{
    CGFloat scale = 720.0/kScreenWidth; //720 is the width of current resolution
    //预览界面与真实图片坐标差值
    CGFloat dValue = (kScreenWidth/720*1280-kScreenHeight)*scale*0.5;
    CGPoint screenPoint = CGPointZero;
    screenPoint = CGPointMake((720-point.y)/scale,(point.x-dValue)/scale);
    return screenPoint;
}
//重绘透明部分
- (void) drawShapeLayerWithRect:(NSDictionary *)conners
{
    _point1 = CGPointMake(0, 0);
    _point2= CGPointMake(0, kScreenHeight);
    _point3= CGPointMake(kScreenWidth, kScreenHeight);
    _point4= CGPointMake(kScreenWidth, 0);

    //坐标系转换 真实图片坐标系转预览坐标系
    int isS = [conners[@"isSucceed"] intValue];
    if (isS == 1) {
        _point1 = [self realImageTranslateToScreenCoordinate:CGPointFromString([conners objectForKey:@"point1"])];
        _point2 = [self realImageTranslateToScreenCoordinate: CGPointFromString([conners objectForKey:@"point2"])];
        _point3= [self realImageTranslateToScreenCoordinate:  CGPointFromString([conners objectForKey:@"point3"])];
        _point4 = [self realImageTranslateToScreenCoordinate: CGPointFromString([conners objectForKey:@"point4"])];

    }
    //设置覆盖层
    if (!_maskWithHole) {
        _maskWithHole = [CAShapeLayer layer];
    }
    
    // Both frames are defined in the same coordinate system
    CGRect biggerRect = self.view.bounds;//CGRectMake(-5, -5, kScreenWidth+10, kScreenHeight+10);
    CGFloat offset = 1.0f;
    if ([[UIScreen mainScreen] scale] >= 2) {
        offset = 0.5;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    maskPath.lineWidth = 3.0;
    
    [maskPath moveToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMinY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMaxY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(biggerRect), CGRectGetMaxY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(biggerRect), CGRectGetMinY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMinY(biggerRect))];

    [maskPath moveToPoint:_point1];
    [maskPath addLineToPoint:_point2];
    [maskPath addLineToPoint:_point3];
    [maskPath addLineToPoint:_point4];
    [maskPath addLineToPoint:_point1];

    [_maskWithHole setFillRule:kCAFillRuleEvenOdd];
    [_maskWithHole setPath:[maskPath CGPath]];
    [_maskWithHole setFillColor:[[UIColor colorWithWhite:0.5 alpha:0.5] CGColor]];
    
    [self.view.layer addSublayer:_maskWithHole];
}

#pragma mark --------------------AVCaptureSession delegate----------------------------
//从摄像头缓冲区获取图像
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    
    //NSLog(@"_isIOS8AndFoucePixelLensPosition 2 = %f",_isIOS8AndFoucePixelLensPosition);
    //点击拍照按钮，走拍照导入识别流程
    if (self.isProcessingImage) {
        //快门声音
        AudioServicesPlaySystemSound(1108);
        
        //获取当前图片
        UIImage *tempImage = [self imageFromSampleBuffer:sampleBuffer];
        //停止取景
        [_session stopRunning];
        
        //调用核心识别方法
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self readyToGetImageEx:tempImage];
        });
        return;
    }

    //获取当前帧数据
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    int width = (int)CVPixelBufferGetWidth(imageBuffer);
    int height = (int)CVPixelBufferGetHeight(imageBuffer);
    
    
    //调用核心导入内存接口
    if ([self.cardRecog newLoadImageWithBuffer:baseAddress Width:width Height:height] == 0) {
        
        //调用核心检边方法
        IDCardSlideLine *sliderLine = [self.cardRecog newConfirmSlideLine];
        BOOL lineState = sliderLine.allLine>=0;
        //NSLog(@"sliderLine.allLine == %d",sliderLine.allLine);
        _sliderAllLine = sliderLine.allLine;
        
        //开启核心排他功能
        if (self.recogType==3000) {
            [self.cardRecog setIDCardRejectType:_sliderAllLine isSet:YES];
        }else{
            [self.cardRecog setIDCardRejectType:self.recogType isSet:YES];
        }
        //NSLog(@"lineState == %d",lineState);
        //获取检边四点，重新绘制边线
        _conners = [self.cardRecog obtainRealTimeFourConersID];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self showLightspotLabel];
            [self drawShapeLayerWithRect:_conners];
            [_overView setRecogArea:_conners];
        });
        
        //调用核心光斑检测接口
        if (_lightspotOn){
            //检测到光斑，禁止识别
            int spot = [self.cardRecog detectLightspot];
            if (spot == 0){
                //NSLog(@"检测到光斑");
                dispatch_async(dispatch_get_main_queue(), ^{
                    _lightspotLabel.hidden = NO;
                });
                
                CVPixelBufferUnlockBaseAddress(imageBuffer,0);
                return;
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    _lightspotLabel.hidden = YES;
                });
            }
        }
        _recogReuslt = 0;
        if (lineState==YES) {
            
            NSLog(@"————————————————————扫描识别————————————————————");
            if (self.recogType == 3000) {
                //识别机读码
                _recogReuslt = [self.cardRecog recogIDCardWithMainID:_sliderAllLine];
                //NSLog(@"recog:%d",recogReuslt);
            }else if(self.recogType == 2){
                //自动判断二代证正反面
                _recogReuslt = [self.cardRecog autoRecogChineseID];
                //NSLog(@"sum = %d", recogReuslt);
            }else{
                //识别非机读码证件
                _recogReuslt = [self.cardRecog recogIDCardWithMainID:self.recogType];
                //NSLog(@"recog:%d",recogReuslt);
            }
            if (_recogReuslt >=0) {
                
                [_session stopRunning];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getRecogResult];
                });
            }
            NSLog(@"recog:%d",_recogReuslt);
        }
    }
    
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
}

//数据帧转图片
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationUp];
    CGImageRelease(quartzImage);
    return (image);
}


#pragma mark --------------------识别证件获取结果----------------------------
//拍照识别（导入识别）模式
-(void)readyToGetImageEx:(UIImage *)image{
    
    //关闭核心排他功能
    if (self.recogType==3000) {
        [self.cardRecog setIDCardRejectType:_sliderAllLine isSet:NO];
    }else{
        [self.cardRecog setIDCardRejectType:self.recogType isSet:NO];
    }
    NSLog(@"——————————————————————拍照导入识别————————————————————");
    //保存到沙盒
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:_originalImagepath atomically:YES];
    //设置导入识别模式和证件类型
    [self.cardRecog setParameterWithMode:0 CardType:self.recogType];
    //图片预处理 7－裁切+倾斜校正+旋转
    [self.cardRecog processImageWithProcessType:7 setType:1];
    
    //导入图片数据
    int loadImage = [self.cardRecog LoadImageToMemoryWithFileName:_originalImagepath Type:0];
    NSLog(@"%d",loadImage);
    if (self.recogType != 3000) {//***注意：机读码需要自己重新设置类型来识别，拍照识别无法识别机读码
        if (self.recogType == 2) {
            
            //自动分辨二代证正反面
            [self.cardRecog autoRecogChineseID];
        }else{
            //其他证件
            [self.cardRecog recogIDCardWithMainID:self.recogType];
        }
    }
    
    //获取识别结果
    [self getRecogResult];
    
    //导入识别完成后要重新设置扫描模式下核心的配置
    [self setRecongConfiguration];
    
    //将处理图片状态值置为NO
    self.isProcessingImage = NO;
    
}

//扫描识别模式
-(void)readyToRecog
{
    //禁用拍照按钮
    _photoBtn.enabled = NO;
    
}
//获取识别结果
- (void)getRecogResult{
    
    //获取识别结果 本demo为了方便展示结果使用了字符串方式
    NSString *allResult = @"";
    //获取识别结果字典
    //NSMutableDictionary *resultMuDic = [NSMutableDictionary dictionary];
    if (self.recogType != 3000) {
        //将裁切好的头像保存到headImagePath
        int save =[self. cardRecog saveHeaderImage:_headImagePath];
        
        NSLog(@"save头像 = %d", save);
        for (int i = 1; i < 20; i++) {
            //获取字段值 
            NSString *field = [self.cardRecog GetFieldNameWithIndex:i];
            //获取字段结果
            NSString *result = [self.cardRecog GetRecogResultWithIndex:i];
            //NSLog(@"%@:%@\n",field, result);
            if (field!=nil && result!=nil) {
                allResult = [allResult stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n", field, result]];
                //字段为key，结果值为Value
                //[resultMuDic setObject:result forKey:field];
            }
        }
    }else{
        int mrzCount = _sliderAllLine == 1033 ?4:3;
        for (int i=1; i<mrzCount; i++) {
            NSString *result = [self.cardRecog GetRecogResultWithIndex:i];
            if (result!= nil) {
                allResult = [allResult stringByAppendingString:[NSString stringWithFormat:@"%@\n", result]];
                
            }else{
                break;
            }
        }
        _sliderAllLine = 0;
    }
    
    //将裁切好的全幅面保存到imagepath里
    int save = [self.cardRecog saveImage:_cropImagepath];
    NSLog(@"save裁切图 = %d", save);

    //跳转到结果展示页面
    ResultViewController *rvc = [[ResultViewController alloc] init];
    NSLog(@"allresult = %@", allResult);
    rvc.cropImagepath = _cropImagepath;
    rvc.headImagepath = _headImagePath;
    rvc.resultString = allResult;
    [self.navigationController pushViewController:rvc animated:YES];
}

#pragma mark --------------------ButtonAction----------------------------
//返回按钮按钮点击事件
- (void)backAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
 
}

//闪光灯按钮点击事件
- (void)flashBtn{
    
    AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    if (![device hasTorch]) {
        //        NSLog(@"no torch");
    }else{
        [device lockForConfiguration:nil];
        if (!_on) {
            [device setTorchMode: AVCaptureTorchModeOn];
            _on = YES;
        }
        else
        {
            [device setTorchMode: AVCaptureTorchModeOff];
            _on = NO;
        }
        [device unlockForConfiguration];
    }
}

//拍照按钮点击事件
- (void)photoBtn{

    //NSLog(@"拍照按钮点击事件");
    //将处理图片状态值置为YES
    self.isProcessingImage = YES;

}


//光斑检测开关
- (void) OpenLightspotSwich{
    _lightspotSwitch.selected = !_lightspotSwitch.selected;
    _lightspotOn = _lightspotSwitch.selected;
}

- (void)showLightspotLabel{
    if (_sliderAllLine==-145) {
        _scanspotLabel.text = @"证件太远";
        _scanspotLabel.hidden = NO;
    }else if (_recogReuslt==-6 ||_sliderAllLine==-139){
        _scanspotLabel.text = [NSString stringWithFormat:@"请识别%@",self.typeName];
        _scanspotLabel.hidden = NO;
    }else if (_sliderAllLine==-202){
        //不做操作
    }
    else{
        _scanspotLabel.hidden = YES;
    }
}

//获取摄像头位置
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if (device.position == position)
        {
            return device;
        }
    }
    return nil;
}

//对焦
- (void)fouceMode{
    NSError *error;
    AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        if ([device lockForConfiguration:&error]) {
            CGPoint cameraPoint = [self.preview captureDevicePointOfInterestForPoint:self.view.center];
            [device setFocusPointOfInterest:cameraPoint];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            [device unlockForConfiguration];
        } else {
            NSLog(@"Error: %@", error);
        }
    }
}
//隐藏状态栏
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}
#endif


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
