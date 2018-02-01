//
//  PPT.m
//  FWZXinsurance
//
//  Created by ding on 2017/12/29.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "PPT.h"
#import "WebViewController.h"
@implementation PPT
{
    NSString *_statusStr;
}

- (void)openPPT:(CDVInvokedUrlCommand *)command
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"text" ofType:@"ppt"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSString *title = [NSString stringWithFormat:@"%@",url];
//    NSString *title =[command.arguments objectAtIndex:0];
    
    if([Check isEmptyString:title])
    {
        [ProgressHUD showError:@"没有传入"];
        CDVPluginResult *result=nil;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"没有传入" forKey:@"result_msg"];
        [dict setObject:@"0" forKey:@"result_code"];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    WebViewController *web = [[WebViewController alloc] init];
    web.urlString = [NSString stringWithFormat:@"%@",@"http://www.hmdata.com.cn/video/banner03.mp4"];
    
    web.backStatus = ^(NSString *status) {
        _statusStr = [NSString stringWithFormat:@"%@",status];
        CDVPluginResult *result=nil;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if([status isEqualToString:@"加载成功"])
        {
            //拼接字符串
            //            NSString *addResult=[self UIImageToBase64Str:image];
            [dict setObject:@"加载成功" forKey:@"result_msg"];
            [dict setObject:@"1" forKey:@"result_code"];
            result=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            //传值（消息）到JS文件
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }else{
            [dict setObject:@"加载失败" forKey:@"result_msg"];
            [dict setObject:@"0" forKey:@"result_code"];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }
    };
    [self.viewController.navigationController pushViewController:web animated:YES];
}
@end
