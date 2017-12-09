//
//  FULAN_OCR.m
//  FWZXinsurance
//
//  Created by 丁晓雷 on 2017/11/27.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "FULAN_OCR.h"
#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import <AVFoundation/AVFoundation.h>
@interface  FULAN_OCR()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) CDVInvokedUrlCommand *commandID;
//@property (nonatomic,weak) CDVPluginResult *result;
@end
@implementation FULAN_OCR{
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
  
    
}
- (void)getIdInfo:(CDVInvokedUrlCommand *)command
{


    //    #error 【必须！】请在 ai.baidu.com中新建App, 绑定BundleId后，在此填写授权信息
    //    #error 【必须！】上传至AppStore前，请使用lipo移除AipBase.framework、AipOcrSdk.framework的模拟器架构，参考FAQ：ai.baidu.com/docs#/OCR-iOS-SDK/top
    //     授权方法1：在此处填写App的Api Key/Secret Key
//    NSString *ak = @"DUtU6MUv6Pn1yuQG9FMGhDmo";
//    NSString *sk = @"wPT0Dkkl3v8BYjE3kRYHatzPcQ11mbf3";
    [[AipOcrService shardService] authWithAK:@"DUtU6MUv6Pn1yuQG9FMGhDmo" andSK:@"wPT0Dkkl3v8BYjE3kRYHatzPcQ11mbf3"];
    _commandID = command;
    
    // 授权方法2（更安全）： 下载授权文件，添加至资源
    //    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    //    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    //    if(!licenseFileData) {
    //        [[[UIAlertView alloc] initWithTitle:@"授权失败" message:@"授权文件不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    //    }
    //    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
    

    AVAuthorizationStatus authstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authstatus ==AVAuthorizationStatusRestricted || authstatus ==AVAuthorizationStatusDenied) //用户关闭了权限
    
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在设备的设置-隐私-相机中允许访问相机。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        
        return;
        
    }
    //判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *image = [[UIImagePickerController alloc] init];
        image.delegate = self;
        image.allowsEditing = YES;
        image.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.viewController presentViewController:image animated:YES completion:nil];
    }
    [self configCallback:command];
}
#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
   
        

        NSString *mediaType =[info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage ]) {
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            NSDictionary *options = @{@"detect_direction":@"false",@"id_card_side":@"front"};
         
            [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                                                               withOptions:options
                                                                                            successHandler:_successHandler
                                                                                               failHandler:_failHandler];
            
                                              
        }
       [picker dismissViewControllerAnimated:YES completion:nil];

}
- (void)configureData{
    

    
//    UIViewController * vc =
//    [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardFont
//                                 andImageHandler:^(UIImage *image) {
//
//                                     [[AipOcrService shardService] detectIdCardFrontFromImage:image
//                                                                                  withOptions:nil
//                                                                               successHandler:_successHandler
//                                                                                  failHandler:_failHandler];
//                                 }];
//
//    [self.viewController presentViewController:vc animated:YES completion:nil];
//

//    UIViewController * vc =
//    [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardFont
//                                 andImageHandler:^(UIImage *image) {
//
//                                     [[AipOcrService shardService] detectIdCardFrontFromImage:image
//                                                                                  withOptions:nil
//                                                                               successHandler:^(id result){
//                                                                                   _successHandler(result);
//                                                                                   // 这里可以存入相册
//                                                                                   //UIImageWriteToSavedPhotosAlbum(image, nil, nil, (__bridge void *)self);
//                                                                               }
//                                                                                  failHandler:_failHandler];
//                                 }];
//    vc.view.frame = CGRectMake(0, 0, kHeight, kWidth);
//    [self.viewController presentViewController:vc animated:YES completion:nil];
}
- (void)idback{
    
    UIViewController * vc1 =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardBack
                                 andImageHandler:^(UIImage *image) {
                                     
                                     [[AipOcrService shardService] detectIdCardBackFromImage:image
                                                                                 withOptions:nil
                                                                              successHandler:_successHandler
                                                                                 failHandler:_failHandler];
                                 }];
    [self.viewController presentViewController:vc1 animated:YES completion:nil];
}
- (void)configCallback:(CDVInvokedUrlCommand *)command{
    __weak typeof(self) weakSelf = self;
     NSDictionary *dict = [[NSMutableDictionary alloc] init];
//    _result = [CDVPluginResult new];
    // 这是默认的识别成功的回调
    _successHandler = ^(id result){
        NSString *title = @"识别结果";

        NSMutableString *message = [NSMutableString string];
       
//        NSArray *ary = @[@"姓名",@"出生",@"公民身份号码",@"性别",@"住址",@"民族"];
    
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                        if ([key isEqualToString:@"姓名"]) {
                            [dict setValue:obj[@"words"]forKey:@"id_name"];
                        }else if ([key isEqualToString:@"出生"]){
                            NSString *card = obj[@"words"];
                            NSMutableString *formatStr = [[NSMutableString alloc] initWithString:card];
                            [formatStr insertString:@"-" atIndex:4];
                            [formatStr insertString:@"-" atIndex:7];
                            [dict setValue:formatStr forKey:@"id_birthday"];
                        }else if ([key isEqualToString:@"公民身份号码"]){
                            NSString *age = [obj[@"words"] ageFromIDCard];
                            [dict setValue:age forKey:@"id_age"];
                            [dict setValue:obj[@"words"] forKey:@"id_number"];
                        }else if ([key isEqualToString:@"性别"]){
                            [dict setValue:obj[@"words"] forKey:@"id_sex"];
                        }else if ([key isEqualToString:@"住址"]){
                            [dict setValue:obj[@"words"] forKey:@"id_address"];
                        }else if ([key isEqualToString:@"民族"]){
                            [dict setValue:obj[@"words"] forKey:@"id_ethnic"];
                        }else if ([key isEqualToString:@"签发日期"]){
                            NSString *card = obj[@"words"];
                            NSMutableString *formatStr = [[NSMutableString alloc] initWithString:card];
                            [formatStr insertString:@"-" atIndex:4];
                            [formatStr insertString:@"-" atIndex:7];
                            [dict setValue:formatStr forKey:@"id_signDate"];
                        }else if ([key isEqualToString:@"失效日期"]){
                            NSString *card = obj[@"words"];
                            NSMutableString *formatStr = [[NSMutableString alloc] initWithString:card];
                            [formatStr insertString:@"-" atIndex:4];
                            [formatStr insertString:@"-" atIndex:7];
                            [dict setValue:formatStr forKey:@"id_expiryDate"];
                        }else if ([key isEqualToString:@"签发机关"]){
                            [dict setValue:obj[@"words"] forKey:@"id_issueAuthority"];
                        }
                       
//
                       
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
            [dict setValue:@"1" forKey:@"result_code"];
            [dict setValue:@"成功" forKey:@"result_msg"];
            CDVPluginResult *resultcd = nil;
            resultcd=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            [weakSelf.commandDelegate sendPluginResult:resultcd callbackId:command.callbackId];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [weakSelf back];
            }];
    };
    
    _failHandler = ^(NSError *error){
        NSLog(@"%@", error);
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        
        [dict setValue:@"0" forKey:@"result_code"];
        [dict setValue:@"失败" forKey:@"result_msg"];
        CDVPluginResult *result = nil;
        result=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [weakSelf.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        
        [weakSelf.viewController dismissViewControllerAnimated:YES completion:nil];
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
- (void)back{
//     [self.viewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}


@end
