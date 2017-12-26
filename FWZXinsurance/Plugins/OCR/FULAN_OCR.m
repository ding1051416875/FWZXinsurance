//
//  FULAN_OCR.m
//  FWZXinsurance
//
//  Created by 丁晓雷 on 2017/11/27.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "FULAN_OCR.h"
#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>
#import "IDCardCameraViewController.h"
@interface  FULAN_OCR()
@property (nonatomic,strong) CDVInvokedUrlCommand *commandID;

//@property (nonatomic,weak) CDVPluginResult *result;
@end
@implementation FULAN_OCR
- (void)getIdInfo:(CDVInvokedUrlCommand *)command
{
    //返回值
    NSString *type = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:0]];
    int inttype= [type intValue];
    //IDCardCameraViewController适配了iPad、iPhone，支持程序旋转
    IDCardCameraViewController *cameraVC = [[IDCardCameraViewController alloc] init];
    cameraVC.recogType = inttype;
    cameraVC.typeName = [NSString speciality:type];
    cameraVC.recogOrientation = 0;
    cameraVC.backIDcard = ^(NSMutableDictionary *resultdict,UIImage *image, BOOL isSuccess) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if (isSuccess == YES) {
            NSString *jsStr = [NSString stringWithFormat:@"mdResult('%@',)",[resultdict mj_JSONString]];
            [dict setObject:jsStr forKey:@"result_info"];
            [dict setValue:@"1" forKey:@"result_code"];
            [dict setObject:@"" forKey:@"result_type"];
            [dict setValue:@"识别成功" forKey:@"result_msg"];
            CDVPluginResult *resultcd = nil;
            resultcd=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
          [self.commandDelegate sendPluginResult:resultcd callbackId:command.callbackId];
        }else if(isSuccess == NO){
            [dict setValue:@"0" forKey:@"result_code"];
            [dict setValue:@"识别失败" forKey:@"result_msg"];
            CDVPluginResult *result = nil;
            result=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }
    };
    [self.viewController presentViewController:cameraVC animated:YES completion:nil];
}


@end
