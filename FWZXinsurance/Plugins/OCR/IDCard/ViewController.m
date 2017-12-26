//
//  ViewController.m
//  IDCardDemo
//

#import "ViewController.h"
#import "ResultViewController.h"

#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机

#import "IDCardOCR.h"
#import "IDCardCameraViewController_auto.h"
#import "IDCardCameraViewController.h"

#endif

@interface ViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSString *_originalImagepath;   //识别原图路径
    NSString *_cropImagepath;       //识别完成后裁切证件图片路径
    NSString *_headImagePath;       //识别完成后裁切头像图片路径
    NSDictionary *_IDTypeDic;
}

@property (strong, nonatomic) NSMutableArray *types;

@property (assign, nonatomic) int cardType;

@property (assign, nonatomic) int resultCount;

@property (strong, nonatomic) NSString *typeName;

#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
@property (strong, nonatomic) IDCardOCR *cardRecog;
#endif


@end

@implementation ViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置图片存储路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    _originalImagepath = [documentsDirectory stringByAppendingPathComponent:@"originalImage.jpg"];
    _cropImagepath = [documentsDirectory stringByAppendingPathComponent:@"cropImage.jpg"];
    _headImagePath = [documentsDirectory stringByAppendingPathComponent:@"headImage.jpg"];
    
    //初始化证件类型
    [self setCardTypes];
    
    //默认证件类型为二代证正面
    self.cardType = 2;
    self.typeName = NSLocalizedString(@"二代身份证", nil) ;
}

- (void)setCardTypes{
    
    /*证件类型对应代号字典*/
    //部分主要证件类型做了本地化
    _IDTypeDic =@{
                  /*证件类型ID:证件名字*/
                  
                  @2:NSLocalizedString(@"二代身份证", nil),
                  @6:NSLocalizedString(@"中国行驶证", nil),

                  @4:NSLocalizedString(@"临时身份证", nil),
                  @5:NSLocalizedString(@"中国驾照", nil),
                  @28:NSLocalizedString(@"中国驾照副页", nil),
                  @1:NSLocalizedString(@"一代身份证", nil),
                  @7:NSLocalizedString(@"军官证", nil),
                  @9:NSLocalizedString(@"中华人民共和国往来港澳通行证", nil),
                  @22:NSLocalizedString(@"新版港澳通行证", nil),
                  @10:NSLocalizedString(@"台湾居民往来大陆通行证(台胞证)", nil),
                  @11:NSLocalizedString(@"大陆居民往来台湾通行证", nil),
                  @12:NSLocalizedString(@"中国签证", nil),
                  @13:NSLocalizedString(@"护照", nil),
                  @14:NSLocalizedString(@"港澳居民来往内地通行证正面（回乡证）", nil),
                  @15:NSLocalizedString(@"港澳居民来往内地通行证背面（回乡证）", nil),
                  @16:NSLocalizedString(@"户口本", nil),
                  @1000:NSLocalizedString(@"居住证", nil),
                  @1001:NSLocalizedString(@"香港永久性居民身份证", nil),
                  @1005:NSLocalizedString(@"澳门身份证", nil),
                  @1012:NSLocalizedString(@"新版澳门身份证", nil),
                  @1007:NSLocalizedString(@"律师证(A)(信息页)", nil),
                  @1008:NSLocalizedString(@"律师证(B)(照片页)", nil),
                  @1009:NSLocalizedString(@"中华人民共和国道路运输证IC卡", nil),
                  @3000:NSLocalizedString(@"机读码", nil),
                  @1030:NSLocalizedString(@"全民健康保险卡", nil),
                  @1031:NSLocalizedString(@"台湾身份证正面", nil),
                  @1032:NSLocalizedString(@"台湾身份证背面", nil),
                  @2001:NSLocalizedString(@"马来西亚身份证", nil),
                  @2002:NSLocalizedString(@"加利福尼亚驾照", nil),
                  @2003:NSLocalizedString(@"新西兰驾照", nil),
                  @2004:NSLocalizedString(@"新加坡身份证", nil),
 
                  @25:NSLocalizedString(@"新版台胞证(正面)", nil),
                  @26:NSLocalizedString(@"新版台胞证(背面)", nil),
                  @2010:NSLocalizedString(@"印度尼西亚身份证", nil),
                  @2011:NSLocalizedString(@"泰国身份证", nil),
                  @1021:NSLocalizedString(@"北京社保卡", nil),
                  };
}

//选择证件类型
- (IBAction)selectCardType:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.delegate = self;
    actionSheet.title = NSLocalizedString(@"选择证件类型", nil);
    
    for (NSString *str in [_IDTypeDic allValues]) {
        [actionSheet addButtonWithTitle:str];
    }
    [actionSheet addButtonWithTitle:NSLocalizedString(@"取消", nil)];
    actionSheet.cancelButtonIndex = [[_IDTypeDic allKeys] count];
    [actionSheet showInView:self.view];
    
}
#pragma mark - UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    self.cardType = [[[_IDTypeDic allKeys] objectAtIndex:buttonIndex] intValue];
    self.typeName = [[_IDTypeDic allValues] objectAtIndex:buttonIndex];
}

#if TARGET_IPHONE_SIMULATOR//模拟器

#elif TARGET_OS_IPHONE//真机
- (IBAction)scanningInHorizontalScreen:(id)sender{
    //横屏指导框识别
    [self initCameraWithRecogOrientation:0];
}
- (IBAction)scanningInVerticalScreen:(id)sender{
    //竖屏指导框扫描识别
    [self initCameraWithRecogOrientation:1];
}

- (IBAction)scanningIntelligent:(id)sender {
    //智能检边识别
    IDCardCameraViewController_auto *cameraVC = [[IDCardCameraViewController_auto alloc] init];
    cameraVC.recogType = self.cardType;
    cameraVC.typeName = self.typeName;
//    [self.navigationController pushViewController:cameraVC animated:YES];
    [self presentViewController:cameraVC animated:YES completion:nil];
}


- (void) initCameraWithRecogOrientation: (int)recogOrientation
{
    //IDCardCameraViewController适配了iPad、iPhone，支持程序旋转
    IDCardCameraViewController *cameraVC = [[IDCardCameraViewController alloc] init];
    cameraVC.recogType = self.cardType;
    cameraVC.typeName = self.typeName;
    cameraVC.recogOrientation = recogOrientation;
//    [self.navigationController pushViewController:cameraVC animated:YES];
    [self presentViewController:cameraVC animated:YES completion:nil];
}
//选择识别
- (IBAction)selectToRecog:(id)sender{
    
    //初始化识别核心
    [self initRecog];
    //初始化相册
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType=sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

//初始化核心
- (void) initRecog
{
    NSDate *before = [NSDate date];
    
    /*获取当前系统语言，中文环境加载中文模板，非中文语言环境下加载英文模板
        英文模板下的字段名字为英文，例如中文字段名“姓名”，英文模板下为“Name”
     */
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    //获取当前语言环境
    int initLanguages;
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    if ([preferredLang rangeOfString:@"zh"].length > 0) {
        initLanguages = 0;
    }else{
        initLanguages = 3;
    }
    self.cardRecog = [[IDCardOCR alloc] init];
    /*提示：该开发码和项目中的授权仅为演示用，客户开发时请替换该开发码及项目中Copy Bundle Resources 中的.lsc授权文件*/
    int intRecog = [self.cardRecog InitIDCardWithDevcode:@"5AAM5Y2R6ZUG5ZU" recogLanguage:initLanguages];
    NSLog(@"intRecog = %d",intRecog);
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:before];
    NSLog(@"%f", time);
}

#pragma mark--选取相册图片
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image=[info objectForKey:UIImagePickerControllerOriginalImage];
    [self performSelectorInBackground:@selector(didFinishedSelect:) withObject:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//存储照片
-(void)didFinishedSelect:(UIImage *)image{
    //存储图片
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:_originalImagepath atomically:YES];
    NSLog(@"_originalImagepath= %@",_originalImagepath);
    [self performSelectorInBackground:@selector(recog) withObject:nil];
}

//取消选择
-(void)imagePickerControllerDIdCancel:(UIImagePickerController*)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)recog{
    
    //关闭核心排他功能
    [self.cardRecog setIDCardRejectType:self.cardType isSet:NO];
    
    //设置导入识别模式和证件类型
    [self.cardRecog setParameterWithMode:0 CardType:self.cardType];
    //图片预处理 7－裁切+倾斜校正+旋转
    [self.cardRecog processImageWithProcessType:7 setType:1];
    
    //导入图片数据
    int loadImage = [self.cardRecog LoadImageToMemoryWithFileName:_originalImagepath Type:0];
    NSLog(@"loadImage = %d", loadImage);
    if (self.cardType != 3000) {//***注意：机读码需要自己重新设置类型来识别
        if (self.cardType == 2) {
            
            //自动分辨二代证正反面
            [self.cardRecog autoRecogChineseID];
        }else{
            //其他证件
            int recog = [self.cardRecog recogIDCardWithMainID:self.cardType];
            NSLog(@"recog = %d",recog);
        }
        //非机读码，保存头像
        [self.cardRecog saveHeaderImage:_headImagePath];
        
        //获取识别结果
        NSString *allResult = @"";
        [self.cardRecog saveImage:_cropImagepath];
        
        for (int i = 1; i < 20; i++) {

            //获取字段值
            NSString *field = [self.cardRecog GetFieldNameWithIndex:i];
            //获取字段结果
            NSString *result = [self.cardRecog GetRecogResultWithIndex:i];
            NSLog(@"%@:%@\n",field, result);
            if(field != NULL){
                allResult = [allResult stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n", field, result]];
            }
        }
        if (![allResult isEqualToString:@""]) {
            //识别结果不为空，跳转到结果展示页面
            [self performSelectorOnMainThread:@selector(createResultView:) withObject:allResult waitUntilDone:YES];
        }else{
            NSLog(@"识别失败");
        }
    }
}

- (void)createResultView:(NSString *)allResult{
    ResultViewController *rvc = [[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
    NSLog(@"allresult = %@", allResult);
    rvc.resultString = allResult;
    rvc.cropImagepath = _cropImagepath;
    rvc.headImagepath = _headImagePath;
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#endif


@end
