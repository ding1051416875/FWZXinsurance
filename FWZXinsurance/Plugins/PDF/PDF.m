//
//  PDF.m
//  FWZXinsurance
//
//  Created by ding on 2017/12/5.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "PDF.h"
#import "WebViewController.h"
@implementation PDF
{
    NSString *_statusStr;
}
- (void)openPDF:(CDVInvokedUrlCommand *)command
{
  
    NSString *title =[command.arguments objectAtIndex:0];
    if([Check isEmptyString:title])
    {
        [ProgressHUD showError:@"没有传入"];
        CDVPluginResult *result=nil;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"失败" forKey:@"result_msg"];
        [dict setObject:@"0" forKey:@"result_code"];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    WebViewController *web = [[WebViewController alloc] init];
    web.urlString = title;
    
    web.backStatus = ^(NSString *status) {
        _statusStr = [NSString stringWithFormat:@"%@",status];
        CDVPluginResult *result=nil;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if([status isEqualToString:@"加载成功"])
        {
            //拼接字符串
            //            NSString *addResult=[self UIImageToBase64Str:image];
            [dict setObject:@"成功" forKey:@"result_msg"];
            [dict setObject:@"1" forKey:@"result_code"];
            result=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            //传值（消息）到JS文件
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }else{
            [dict setObject:@"失败" forKey:@"result_msg"];
            [dict setObject:@"0" forKey:@"result_code"];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }
    };
    [self.viewController presentViewController:web animated:YES completion:nil];
}
@end
