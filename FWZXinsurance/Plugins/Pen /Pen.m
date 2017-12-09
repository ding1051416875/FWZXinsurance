//
//  Pen.m
//  FWZXinsurance
//
//  Created by ding on 2017/11/30.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "Pen.h"
#import "SignDrawViewController.h"
#import "GTMBase64.h"
@implementation Pen
-(void)doSign:(CDVInvokedUrlCommand *)command
{
    
    SignDrawViewController *vc = [[SignDrawViewController alloc] init];
    vc.backImage = ^(UIImage *image, BOOL isSuccess) {
        // 如果项目需求要将电子签名上传服务器，那就可以在这里处理图片并上传服务器
        //获取js传过来的值
        // 判断图片大小进行压缩
        
        CDVPluginResult *result=nil;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if(isSuccess == YES)
        {
            NSData *imageData = UIImageJPEGRepresentation(image,1.0);
            NSString *image =[NSString stringWithFormat:@"data:image/png;base64,%@",[GTMBase64 stringByEncodingData:imageData]];
            //拼接字符串
//            NSString *addResult=[self UIImageToBase64Str:image];
            [dict setObject:@"成功" forKey:@"result_msg"];
            [dict setObject:@"1" forKey:@"result_code"];
            [dict setObject:image forKey:@"result_img"];
            result=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            //传值（消息）到JS文件
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }else if(isSuccess == NO)
        {
            [dict setObject:@"失败" forKey:@"result_msg"];
            [dict setObject:@"0" forKey:@"result_code"];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    };
    [self.viewController presentViewController:vc animated:YES completion:nil];
}
-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}
@end
