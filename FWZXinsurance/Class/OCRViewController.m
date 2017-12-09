//
//  OCRViewController.m
//  FWZXinsurance
//
//  Created by ding on 2017/11/28.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "OCRViewController.h"
#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>
@interface OCRViewController ()

@end

@implementation OCRViewController{
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    #error 【必须！】请在 ai.baidu.com中新建App, 绑定BundleId后，在此填写授权信息
    //    #error 【必须！】上传至AppStore前，请使用lipo移除AipBase.framework、AipOcrSdk.framework的模拟器架构，参考FAQ：ai.baidu.com/docs#/OCR-iOS-SDK/top
    //     授权方法1：在此处填写App的Api Key/Secret Key
    [[AipOcrService shardService] authWithAK:@"DUtU6MUv6Pn1yuQG9FMGhDmo" andSK:@"wPT0Dkkl3v8BYjE3kRYHatzPcQ11mbf3"];
    
    
    // 授权方法2（更安全）： 下载授权文件，添加至资源
    //    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    //    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    //    if(!licenseFileData) {
    //        [[[UIAlertView alloc] initWithTitle:@"授权失败" message:@"授权文件不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    //    }
    //    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
    
  
 
    [self configCallback];
//    UIButton *btn = [Maker makeBtn:CGRectMake(100, 100, 100, 40) title:@"身份证" img:@"" font:kFont_Lable_15 target:self action:@selector(btnClick)];
//    [self.view addSubview:btn];
}
- (void)btnClick
{
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configureData];
}
- (void)configureData{
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardFont
                                 andImageHandler:^(UIImage *image) {
                                     
                                     [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                                                  withOptions:nil
                                                                               successHandler:_successHandler
                                                                                  failHandler:_failHandler];
                                 }];
    
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    
    // 这是默认的识别成功的回调
    _successHandler = ^(id result){
        NSLog(@"%@", result);
        NSString *title = @"识别结果";
        NSMutableString *message = [NSMutableString string];
        
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@: %@\n", key, obj];
                    }
                    
                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@\n", obj];
                    }
                    
                }
            }
            
        }else{
            [message appendFormat:@"%@", result];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }];
    };
    
    _failHandler = ^(NSError *error){
        NSLog(@"%@", error);
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[[UIAlertView alloc] initWithTitle:@"识别失败" message:msg delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];
    };
}
- (void)mockBundlerIdForTest {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self mockClass:[NSBundle class] originalFunction:@selector(bundleIdentifier) swizzledFunction:@selector(sapicamera_bundleIdentifier)];
#pragma clang diagnostic pop
}

- (void)mockClass:(Class)class originalFunction:(SEL)originalSelector swizzledFunction:(SEL)swizzledSelector {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
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
