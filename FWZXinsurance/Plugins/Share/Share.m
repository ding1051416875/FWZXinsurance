//
//  Share.m
//  FWZXinsurance
//
//  Created by ding on 2017/11/29.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "Share.h"
#import <UShareUI/UShareUI.h>
#import "WXApi.h"
@implementation Share
-(void)share:(CDVInvokedUrlCommand *)command
{
//    // 判断是否安装微信
//    
//    if ([WXApi isWXAppInstalled] ){
//        
//        //判断当前微信的版本是否支持OpenApi
//        
//        if ([WXApi isWXAppSupportApi]) {
//            
//            
//          
//            //        }];
//            
//        }else{
//            [self.viewController.view showError:@"请升级微信至最新版本"];
//        }
//    }else{
//        NSLog(@"请安装微信客户端");
//        [self.viewController.view showError:@"请安装微信客户端"];
//    }
    
    NSString *title =[NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:0]];
    if ([Check isEmptyString:title]) {
        [ProgressHUD showError:@"传入数据为空"];
        return;
    }
    
    //        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    
    //        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
    // 根据获取的platformType确定所选平台进行下一步操作
    [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession title:title command:command];
    
  
}
//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title command:(CDVInvokedUrlCommand *)command
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    //    NSString *thumbURL =  [kUserDefaults objectForKey:kShareUrl];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:@"移动保险平台" thumImage:[UIImage imageNamed:@"me.png"]];
    //设置网页地址
    shareObject.webpageUrl = @"www.baidu.com";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self.viewController completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        CDVPluginResult *result = nil;
         NSMutableDictionary *dictary = [[NSMutableDictionary alloc] init];
        if (!error) {
//            result = [NSString stringWithFormat:@"分享成功"];
            [dictary setObject:@"分享成功" forKey:@"result_msg"];
            [dictary setObject:@"1" forKey:@"result_code"];

            result=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dictary];
        }
        else{
//            if (error) {
//                result = [NSString stringWithFormat:@"分享失败 code: %d\n",(int)error.code];
//            }
//            else{
//                result = [NSString stringWithFormat:@"分享失败"];
//            }
            [dictary setObject: [NSString stringWithFormat:@"分享失败 code: %d\n",(int)error.code] forKey:@"result_msg"];
            [dictary setObject:@"0" forKey:@"result_code"];
            result=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dictary];
        }
       

        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
//        [self alertWithError:error];
    }];
    
}
- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    }
    else{
        if (error) {
            result = [NSString stringWithFormat:@"分享失败 code: %d\n",(int)error.code];
        }
        else{
            result = [NSString stringWithFormat:@"分享失败"];
        }
    }
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享"
    //                                                    message:result
    //                                                   delegate:nil
    //                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
    //                                          otherButtonTitles:nil];
    //    [alert show];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"分享" message:result preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [ac addAction:confirm];
    [ac addAction:cancel];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];
}
@end
