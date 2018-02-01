//
//  BankCardCameraViewController_iPad.m
//  BankCardRecogDemo
//


#import "BankCardCameraViewController_iPad.h"
#import "BankCardOverView_iPad.h"
#import "BankSlideLine.h"
#import "BankCardResultViewController.h"

//#if TARGET_IPHONE_SIMULATOR//模拟器
//#elif TARGET_OS_IPHONE//真机
#import "BankCardRecogPro.h"
//#endif

//屏幕的宽、高
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface BankCardCameraViewController_iPad ()<UIAlertViewDelegate,AVCaptureVideoDataOutputSampleBufferDelegate> {
    AVCaptureSession *_session;
    AVCaptureDeviceInput *_captureInput;
    AVCaptureStillImageOutput *_captureOutput;
    AVCaptureVideoPreviewLayer *_preview;
    AVCaptureDevice *_device;
    AVCaptureConnection *_videoConnection;
    
//#if TARGET_IPHONE_SIMULATOR//模拟器
//
//#elif TARGET_OS_IPHONE//真机
    BankCardRecogPro *_cardRecog;
//#endif
    
    
    BankCardOverView_iPad *_overView; //检边视图
    NSTimer *_timer; //定时器
    BOOL _on; //闪光灯状态
    BOOL _capture;//导航栏动画是否完成
    BOOL _isFoucePixel;//是否相位对焦
    CGRect _imgRect;//拍照裁剪
    int _count;//每几帧识别
    CGFloat _isLensChanged;//镜头位置
    
    /*相位聚焦下镜头位置 镜头晃动 值不停的改变 */
    CGFloat _isIOS8AndFoucePixelLensPosition;
    
    /*
     控制识别速度，最小值为1！数值越大识别越慢。
     相机初始化时，设置默认值为1（不要改动），判断设备若为相位对焦时，设置此值为2（可以修改，最小为1，越大越慢）
     此值的功能是为了减小相位对焦下，因识别速度过快，在银行卡放入检边框移动过程中识别，导致出现识别后裁剪出的图片模糊的概率
     此值在相机初始化中设置，在相机代理中使用，用户若无特殊需求不用修改。
     */
    int _MaxFR;
}
@property (assign, nonatomic) BOOL adjustingFocus;
@property (nonatomic, retain) CALayer *customLayer;
@property (nonatomic,assign) BOOL isProcessingImage;
@end

@implementation BankCardCameraViewController_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
    //初始化识别核心
    [self initRecog];
#endif
    
    //初始化相机
    [self initialize];
    
    //创建相机界面控件
    [self createCameraView];
    

}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //设置一个全局变量 视图出现后0.4秒后才去识别 防止导航栏动画未完成push下一控制器引起崩溃
    _capture = NO;
    [self performSelector:@selector(changeCapture) withObject:nil afterDelay:0.4];
    //不支持相位对焦情况下(iPhone6以后的手机支持相位对焦) 设置定时器 开启连续对焦
    if (!_isFoucePixel) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.3 target:self selector:@selector(fouceMode) userInfo:nil repeats:YES];
        //NSLog(@"非相位对焦");
    }
    
    
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    int flags =NSKeyValueObservingOptionNew;
    //注册通知
    [camDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
    if (_isFoucePixel) {
        [camDevice addObserver:self forKeyPath:@"lensPosition" options:flags context:nil];
    }
    [_session startRunning];
    
    UIButton *upBtn = (UIButton *)[self.view viewWithTag:1001];
    upBtn.hidden = NO;
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    //关闭定时器
    if (!_isFoucePixel) {
        [_timer invalidate];
        _timer = nil;
    }
    

    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [camDevice removeObserver:self forKeyPath:@"adjustingFocus"];
    if (_isFoucePixel) {
        [camDevice removeObserver:self forKeyPath:@"lensPosition"];
    }
    [_session stopRunning];
    
    //隐藏四条边框
    [_overView setLeftHidden:YES];
    [_overView setRightHidden:YES];
    [_overView setBottomHidden:YES];
    [_overView setTopHidden:YES];
    
    _capture = NO;
    UIButton *photoBtn = (UIButton *)[self.view viewWithTag:1000];
    photoBtn.hidden = YES;
}

//设置延迟0.4秒  防止导航栏动画未完成时识别成功push下一控制器引起崩溃
- (void) changeCapture{
    _capture = YES;
}

//初始化识别核心
- (void) initRecog{
    /*
     初始化识别核心 传入开发码（授权文件与开发码是对应的）根据返回值判断核心是否初始化成功
     返回值为0成功 其他失败
     */
    
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
    _cardRecog = [[BankCardRecogPro alloc] init];
    int init = [_cardRecog InitBankCardWithDevcode:@"5LIK5RW357UF6II"];
    NSString *coreVersion = [_cardRecog getRecogCoreVersion];
    NSLog(@"\n识别核心版本号：%@\n核心初始化返回值 = %d\n返回值为0成功 其他失败\n\n常见错误：\n-10601 开发码错误\n核心初始化方法-(int)InitBankCardWithDevcode:(NSString *)devcode;参数为开发码\n\n-10602 Bundle identifier错误\n-10605 Bundle display name错误\n-10606 CompanyName错误\n请检查授权文件（wtproject.lsc）绑定的信息与Info.plist中设置是否一致!!!",coreVersion,init);
#endif
    
    //设置检边视图层
    _overView = [[BankCardOverView_iPad alloc] initWithFrame:self.view.bounds];
    // 设置识别区域 YES:竖屏   NO:横屏
    [_overView setRecogArea:self.isVertical];
    //设置检边参数
    CGRect rect = _overView.smallrect;
    // 设置横竖屏的检边参数和拍照识别裁切frame
    int top,bottom,left,right;
    CGFloat scale,dValue;
    if (self.isVertical) { // 竖屏识别
        if (kScreenWidth < kScreenHeight) {//设备上下方向时
            scale = 720/kScreenWidth;//720为当前分辨率(1280*720)中的宽
            dValue = (kScreenWidth/720*1280-kScreenHeight)*scale*0.5;//预览界面与实际图片坐标差值
            //设置检边参数
            top = CGRectGetMinY(rect)*scale + dValue;
            bottom = CGRectGetMaxY(rect)*scale + dValue;
            left = CGRectGetMinX(rect)*scale;
            right = CGRectGetMaxX(rect)*scale;
            //设置拍照裁切frame
            CGFloat x = CGRectGetMinX(rect)*scale;
            CGFloat y = CGRectGetMinY(rect)*scale + dValue;
            CGFloat w = rect.size.width*scale;
            CGFloat h = rect.size.height*scale;
            _imgRect = CGRectMake(x, y, w, h);
        } else {//设备左右方向时
            scale = 720/kScreenHeight;//720为当前分辨率(1280*720)中的高
            dValue = (kScreenHeight/720*1280 - kScreenWidth)*scale*0.5;
            
            top = CGRectGetMinX(rect)*scale + dValue;
            bottom = CGRectGetMaxX(rect)*scale + dValue;
            left = (kScreenHeight - CGRectGetMaxY(rect))*scale;
            right = (kScreenHeight - CGRectGetMinY(rect))*scale;
            //设置拍照裁切frame
            CGFloat x = CGRectGetMinX(rect)*scale + dValue;
            CGFloat y = CGRectGetMinY(rect)*scale;
            CGFloat w = rect.size.width*scale;
            CGFloat h = rect.size.height*scale;
            _imgRect = CGRectMake(x, y, w, h);
        }
    } else { // 横屏识别
        if (kScreenWidth < kScreenHeight) {//设备上下方向时
            scale = 720/kScreenWidth;
            dValue = (kScreenWidth/720*1280-kScreenHeight)*scale*0.5;
            
            top = (kScreenWidth - CGRectGetMaxX(rect))*scale;
            bottom = (kScreenWidth - CGRectGetMinX(rect))*scale;
            left = CGRectGetMinY(rect)*scale+dValue;
            right = (CGRectGetMinY(rect) + CGRectGetHeight(rect))*scale+dValue;
            //设置拍照裁切frame
            CGFloat x = CGRectGetMinY(rect)*scale+dValue;
            CGFloat y = (kScreenWidth - CGRectGetMaxX(rect))*scale;
            CGFloat w = rect.size.height*scale;
            CGFloat h = rect.size.width*scale;
            _imgRect = CGRectMake(x, y, w, h);
        } else {//设备左右方向时
            scale = 720/kScreenHeight;
            dValue = (kScreenHeight/720*1280 - kScreenWidth)*scale*0.5;
            
            top = CGRectGetMinY(rect)*scale;
            bottom = CGRectGetMaxY(rect)*scale;
            left = CGRectGetMinX(rect)*scale + dValue ;
            right = CGRectGetMaxX(rect)*scale + dValue;
            //设置拍照裁切frame
            CGFloat x = CGRectGetMinX(rect)*scale + dValue;
            CGFloat y = CGRectGetMinY(rect)*scale;
            CGFloat w = rect.size.width*scale;
            CGFloat h = rect.size.height*scale;
            _imgRect = CGRectMake(x, y, w, h);
        }
    }
    
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
    /*
     设置核心扫描检边参数
     */
    [_cardRecog setRoiWithLeft:left Top:top Right:right Bottom:bottom];
    
    //开启检测识别信用卡有效日期功能 不调用默认为不开启
    [_cardRecog setBankExpiryDateFlag:YES];
    
    //不开启过滤无效银行卡功能 不调用默认为不开启
    [_cardRecog setInvalidBankCard:NO];
    
#endif
    
}

//监听对焦
-(void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    
    /*反差对焦 监听反差对焦此*/
    if([keyPath isEqualToString:@"adjustingFocus"]){
        self.adjustingFocus =[[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1]];
    }
    /*监听相位对焦此*/
    if([keyPath isEqualToString:@"lensPosition"]){
        _isIOS8AndFoucePixelLensPosition =[[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        //NSLog(@"监听_isIOS8AndFoucePixelLensPosition == %f",_isIOS8AndFoucePixelLensPosition);
    }
}

//初始化相机
- (void) initialize{
    //判断摄像头授权
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        self.view.backgroundColor = [UIColor blackColor];
        UIAlertView * alt = [[UIAlertView alloc] initWithTitle:@"未获得授权使用摄像头" message:@"请在'设置-隐私-相机'打开" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alt show];
        return;
    }
    
    _MaxFR = 1;
    //1.创建会话层
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPreset1280x720];
    
    //2.创建、配置输入设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in devices){
        if (device.position == AVCaptureDevicePositionBack){
            _device = device;
            _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        }
    }
    //if ([_session canAddInput:_captureInput]) {
    [_session addInput:_captureInput];
    //}
    
    //2.创建视频流输出
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    [_session addOutput:captureOutput];
    
    //3.创建、配置静态拍照输出
    _captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [_captureOutput setOutputSettings:outputSettings];
    [_session addOutput:_captureOutput];
    
    //4.预览图层
    _preview = [AVCaptureVideoPreviewLayer layerWithSession: _session];
    _preview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_preview];
    
    for (AVCaptureConnection *connection in captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                _videoConnection = connection;
                break;
            }
        }
        if (_videoConnection) { break; }
    }
    
    //当前应用方向
    UIInterfaceOrientation currentInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];;
    //根据当前应用方向设置视频流方向
    AVCaptureVideoOrientation VideoOrientation = [self avOrientationForInterfaceOrientation:currentInterfaceOrientation];
    if (self.isVertical) {//竖屏识别设置视频流方向
        if (currentInterfaceOrientation == UIInterfaceOrientationPortrait || currentInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            _videoConnection.videoOrientation = VideoOrientation;
        } else if (currentInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            _videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
        } else if (currentInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
            _videoConnection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
        }
    } else {//横屏识别设置视频流方向
        if (currentInterfaceOrientation == UIInterfaceOrientationPortrait) {
            _videoConnection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        } else if (currentInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            _videoConnection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        } else if (currentInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || currentInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            _videoConnection.videoOrientation = VideoOrientation;
        }
    }
    
    _preview.connection.videoOrientation = VideoOrientation;
    
    //判断是否相位对焦
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        AVCaptureDeviceFormat *deviceFormat = _device.activeFormat;
        if (deviceFormat.autoFocusSystem == AVCaptureAutoFocusSystemPhaseDetection){
            _isFoucePixel = YES;
            _MaxFR = 2;
        }
    }
    [_session startRunning];
    
}
//手动拍照
-(void)captureimage{
    //将处理图片状态值置为YES
    self.isProcessingImage = YES;
}

//从摄像头缓冲区获取图像
#pragma mark -
#pragma mark AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection{
    
    if (self.isProcessingImage) {
        
        //快门声音
        AudioServicesPlaySystemSound(1108);
        //获取当前图片
        UIImage *bandCardImg = [self imageFromSampleBuffer:sampleBuffer];
        //停止取景
        [_session stopRunning];
        //        [self performSelectorOnMainThread:@selector(readyToGetImage:) withObject:bandCardImg waitUntilDone:NO];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self readyToGetImage:bandCardImg];
        });
        //将处理图片状态值置为NO
        //        self.isProcessingImage = NO;
        return;
    }
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    //检边识别
    if (_capture == YES) { //导航栏动画完成
        if (self.isProcessingImage==NO) {  //点击拍照后 不去识别
            if (!self.adjustingFocus) {  //反差对焦下 非正在对焦状态（相位对焦下self.adjustingFocus此值不会改变）
                if (_isLensChanged == _isIOS8AndFoucePixelLensPosition) {
                    
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
                    _count++;
                    if (_count == _MaxFR) {
                        BankSlideLine *sliderLine = [_cardRecog RecognizeStreamNV21Ex:baseAddress Width:(int)width Height:(int)height];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_overView setLeftHidden:!sliderLine.leftLine];
                            [_overView setRightHidden:!sliderLine.rightLine];
                            [_overView setBottomHidden:!sliderLine.bottomLine];
                            [_overView setTopHidden:!sliderLine.topLine];
                        });
                        if (sliderLine.allLine == 0 ) //检到边 识别成功
                        {
                            _count = 0;
                            
                            // 停止取景
                            [_session stopRunning];
                            
                            //设置震动
                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                            
                            //识别完成获取银行卡整图
//                            UIImage *bankImage = [self imageFromSampleBuffer:sampleBuffer];
                            
                            //                            [self performSelectorOnMainThread:@selector(readyToGetImage:) withObject:_cardRecog.resultImg waitUntilDone:NO];
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [self readyToGetImage:_cardRecog.resultImg];
                            });
                            
                        }else if (sliderLine.allLine == 1 ){ //检到边 未识别
                            _count--;
                        }else{
                            _count = 0;
                        }
                    }
#endif
                }else{
                    _isLensChanged = _isIOS8AndFoucePixelLensPosition;
                    _count = 0;
                }
            }
        }
    }
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
}

//获取结果信息
-(void)readyToGetImage:(UIImage *)image{
    
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
    //获取银行卡信息
    NSString *str = [_cardRecog.resultStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([Check isEmptyString:str]){
        if(self.backBankcard){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@"识别失败" forKey:@"result"];
            self.backBankcard(dict, NO);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
    NSDictionary *infoDic = [_cardRecog getBankInfoWithCardNO:str];
    //字典中的所有value如果没有值 均为空字符串@""
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
    [resultDic setObject:str forKey:@"id_number"];
    [resultDic setObject:resultDic[@"bankName"] forKey:@"id_name"];
     if(self.backBankcard){
        self.backBankcard(resultDic, YES);
        [self.navigationController popViewControllerAnimated:YES];
     }
    }
//    BankCardResultViewController *resultVC = [[BankCardResultViewController alloc ] init];
//    resultVC.resultDic = resultDic;
//    resultVC.image = image;
//    [self.navigationController pushViewController:resultVC animated:YES];
//
//    if (_cardRecog.resultImg) {
//        _cardRecog.resultImg = nil;
//    }
    //将处理图片状态值置为NO
    self.isProcessingImage = NO;
#endif
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices){
        if (device.position == position){
            return device;
        }
    }
    return nil;
}

- (void)createCameraView{
    
    //设置覆盖层
    CAShapeLayer *maskWithHole = [CAShapeLayer layer];
    // Both frames are defined in the same coordinate system
    CGRect biggerRect = self.view.bounds;
    CGFloat offset = 1.0f;
    if ([[UIScreen mainScreen] scale] >= 2) {
        offset = 0.5;
    }
    CGRect smallFrame = _overView.smallrect;
    CGRect smallerRect = CGRectInset(smallFrame, -offset, -offset);
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath moveToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMinY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMaxY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(biggerRect), CGRectGetMaxY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(biggerRect), CGRectGetMinY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMinY(biggerRect))];
    [maskPath moveToPoint:CGPointMake(CGRectGetMinX(smallerRect), CGRectGetMinY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(smallerRect), CGRectGetMaxY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(smallerRect), CGRectGetMaxY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(smallerRect), CGRectGetMinY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(smallerRect), CGRectGetMinY(smallerRect))];
    [maskWithHole setPath:[maskPath CGPath]];
    [maskWithHole setFillRule:kCAFillRuleEvenOdd];
    [maskWithHole setFillColor:[[UIColor colorWithWhite:0 alpha:0.35] CGColor]];
    [self.view.layer addSublayer:maskWithHole];
    [self.view.layer setMasksToBounds:YES];
    
    //隐藏四条边框
    [_overView setLeftHidden:YES];
    [_overView setRightHidden:YES];
    [_overView setBottomHidden:YES];
    [_overView setTopHidden:YES];
    _overView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_overView];
    
    /* 相机按钮 适配了iPhone和ipad 不同需求自行修改界面*/
    //返回、闪光灯按钮
    CGFloat backWidth = 35;
    if (kScreenHeight>=1024) {
        backWidth = 50;
    }
    CGFloat s = 80;
    CGFloat s1 = 0;
    if (kScreenHeight==480) {
        s = 60;
        s1 = 10;
    }
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/16,kScreenWidth/16-s1, backWidth, backWidth)];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"BundleForBankCard.bundle/back_camera_btn"] forState:UIControlStateNormal];
    backBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:backBtn];
    
    UIButton *flashBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kScreenWidth/16-backWidth,kScreenWidth/16-s1, backWidth, backWidth)];
    [flashBtn setImage:[UIImage imageNamed:@"BundleForBankCard.bundle/flash_camera_btn"] forState:UIControlStateNormal];
    [flashBtn addTarget:self action:@selector(modeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flashBtn];
    
    //拍照视图 上拉按钮 拍照按钮
    UIButton *upBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2-60, kScreenHeight-20, 120, 20)];
    upBtn.tag = 1001;
    [upBtn addTarget:self action:@selector(upBtn:) forControlEvents:UIControlEventTouchUpInside];
    [upBtn setImage:[UIImage imageNamed:@"BundleForBankCard.bundle/locker_btn_def"] forState:UIControlStateNormal];
//    [self.view addSubview:upBtn];
    
    UIButton *photoBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2-30,kScreenHeight-s,60, 60)];
    photoBtn.tag = 1000;
    photoBtn.hidden = YES;
    [photoBtn setImage:[UIImage imageNamed:@"BundleForBankCard.bundle/take_pic_btn"] forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(photoBtn) forControlEvents:UIControlEventTouchUpInside];
    [photoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.view addSubview:photoBtn];
    
}

#pragma mark - ButtonAction
//返回按钮按钮点击事件
- (void)backAction{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"您取消了操作" forKey:@"result"];
    self.backBankcard(dict, NO);
    [self.navigationController popViewControllerAnimated:YES];
}

//闪光灯按钮点击事件
- (void)modeBtn{
    
    if (![_device hasTorch]) {
        //NSLog(@"no torch");
    }else
    {
        [_device lockForConfiguration:nil];
        if (!_on) {
            [_device setTorchMode: AVCaptureTorchModeOn];
            _on = YES;
        }else{
            [_device setTorchMode: AVCaptureTorchModeOff];
            _on = NO;
        }
        [_device unlockForConfiguration];
    }
}

//上拉按钮点击事件
- (void)upBtn:(UIButton *)upBtn{
    
    UIButton *photoBtn = (UIButton *)[self.view viewWithTag:1000];
    photoBtn.hidden = NO;
    upBtn.hidden = YES;
}

//拍照按钮点击事件
- (void)photoBtn{
    
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
    //识别后 不进行拍照
    if (!_cardRecog.resultImg) {
        [self captureimage];
    }
#endif
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

//隐藏状态栏
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}

//对焦
- (void)fouceMode{
    
    NSError *error;
    AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        if ([device lockForConfiguration:&error]) {
            CGPoint cameraPoint = [_preview captureDevicePointOfInterestForPoint:self.view.center];
            [device setFocusPointOfInterest:cameraPoint];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            [device unlockForConfiguration];
        } else {
            //NSLog(@"Error: %@", error);
        }
    }
}

//数据帧转图片
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer{
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
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationUp];
    CGImageRelease(quartzImage);
    
    CGRect rect = _imgRect;
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context1, rect, subImageRef);
    UIImageOrientation oritation = [self getBankCardOrientation:_cardRecog.imageRotate];
    UIImage *image1 = [UIImage imageWithCGImage:subImageRef scale:1.0 orientation:oritation];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    
    return (image1);
}



//矫正银行卡方向
- (UIImageOrientation)getBankCardOrientation:(int)imageRotate{
    
    switch (imageRotate) {
        case 1:
            return UIImageOrientationDown;
            break;
        case 3:
            return UIImageOrientationRight;
            break;
        case 4:
            return UIImageOrientationLeft;
            break;
        default:
            break;
    }
    return UIImageOrientationUp;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//根据控制器方向设置视频流方向和预览图层方向
- (void)interfaceOrientationChanged {
    UIInterfaceOrientation currentInterfaceOrientation = self.preferredInterfaceOrientationForPresentation;

    AVCaptureVideoOrientation VideoOrientation = [self avOrientationForInterfaceOrientation:currentInterfaceOrientation];
    
    _videoConnection.videoOrientation = VideoOrientation;
    _preview.connection.videoOrientation = VideoOrientation;
    
}

//根据控制器方向返回视频流方向
- (AVCaptureVideoOrientation)avOrientationForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    AVCaptureVideoOrientation result;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            result = AVCaptureVideoOrientationPortrait;
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            result = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            result = AVCaptureVideoOrientationLandscapeLeft;
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            result = AVCaptureVideoOrientationLandscapeRight;
            break;
            
        default:
            break;
    }
    return result;
}




@end
