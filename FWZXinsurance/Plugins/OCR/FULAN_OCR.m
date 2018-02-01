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
#import "BankCardCameraViewController_iPad.h"
@interface  FULAN_OCR()
@property (nonatomic,strong) CDVInvokedUrlCommand *commandID;

//@property (nonatomic,weak) CDVPluginResult *result;
@end
@implementation FULAN_OCR
- (void)getIdInfo:(CDVInvokedUrlCommand *)command
{
    //返回值
    NSString *type = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:0]];
    if ([Check isEmptyString:type]) {
        [ProgressHUD showError:@"传入类型为空"];
        return;
    };
    //type 5001  为识别银行卡
    if ([type isEqualToString:@"5001"]) {
        //iPad相机 支持4个方向
        BankCardCameraViewController_iPad *cameraVC = [[BankCardCameraViewController_iPad alloc] init];
        cameraVC.isVertical = NO;
        cameraVC.backBankcard = ^(NSMutableDictionary *resultDic, BOOL isSuccess) {
        
//
//                bankCode = 03080000;
//                bankName = "\U62db\U5546\U94f6\U884c";
//                cardName = "\U4e00\U5361\U901a(\U94f6\U8054\U5361)";
//                cardNumber = "6225 8812 0816 2981";
//                cardType = "\U501f\U8bb0\U5361";

            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
         
            if (isSuccess == YES) {
                NSString *jsStr = [NSString stringWithFormat:@"%@",[resultDic mj_JSONString]];
                [dict setObject:jsStr forKey:@"result_info"];
                [dict setValue:@"1" forKey:@"result_code"];
                [dict setObject:type forKey:@"result_type"];
                [dict setValue:@"识别成功" forKey:@"result_msg"];
                CDVPluginResult *resultcd = nil;
                resultcd=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
                [self.commandDelegate sendPluginResult:resultcd callbackId:command.callbackId];
            }else if(isSuccess == NO){
                [dict setValue:@"0" forKey:@"result_code"];
                [dict setValue:resultDic[@"result"] forKey:@"result_msg"];
                CDVPluginResult *result = nil;
                result=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            }
        };
        self.viewController.navigationController.navigationBarHidden = YES;
        [self.viewController.navigationController pushViewController:cameraVC animated:YES];
    }else{
        int inttype= [type intValue];
        //IDCardCameraViewController适配了iPad、iPhone，支持程序旋转
        IDCardCameraViewController *cameraVC = [[IDCardCameraViewController alloc] init];
        cameraVC.recogType = inttype;
        cameraVC.typeName = [NSString speciality:type];
        cameraVC.recogOrientation = 0;
        cameraVC.backIDcard = ^(NSMutableDictionary *resultdict,UIImage *image, BOOL isSuccess) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            if (isSuccess == YES) {
                NSString *jsStr = [NSString stringWithFormat:@"%@",[resultdict mj_JSONString]];
                [dict setObject:jsStr forKey:@"result_info"];
                [dict setValue:@"1" forKey:@"result_code"];
                [dict setObject:type forKey:@"result_type"];
                [dict setValue:@"识别成功" forKey:@"result_msg"];
                CDVPluginResult *resultcd = nil;
                resultcd=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
                [self.commandDelegate sendPluginResult:resultcd callbackId:command.callbackId];
            }else if(isSuccess == NO){
                [dict setValue:@"0" forKey:@"result_code"];
                [dict setValue:resultdict[@"result"] forKey:@"result_msg"];
                CDVPluginResult *result = nil;
                result=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            }
        };
        [self.viewController.navigationController pushViewController:cameraVC animated:YES];
    }
    
    
}


@end
