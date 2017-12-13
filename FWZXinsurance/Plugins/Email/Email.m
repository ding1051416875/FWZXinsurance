//
//  Email.m
//  FWZXinsurance
//
//  Created by 丁晓雷 on 2017/11/24.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "Email.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface Email()<MFMailComposeViewControllerDelegate>
@property (nonatomic,strong) CDVInvokedUrlCommand *command;
@property (nonatomic,strong) CDVPluginResult *result;

@end

@implementation Email
-(void)sendEmail:(CDVInvokedUrlCommand *)command
{
    
    NSString *recipient =[command.arguments objectAtIndex:0];
    NSString *emailTheme =[command.arguments objectAtIndex:1];
    NSString *emailBody=[command.arguments objectAtIndex:2];
//    NSString *emailfile =[command.arguments objectAtIndex:3];
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        [self alertControler:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
        return;
    }
    if (![mailClass canSendMail]) {
        [self alertControler:@"用户没有设置邮件账户"];
        return;
    }
    _command = command;
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject:emailTheme];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject:recipient];
    [mailPicker setToRecipients:toRecipients];
//    //添加抄送
//    NSArray *ccRecipients = [NSArray arrayWithObjects:@"516022482@qq.com",@"dingxiaolei55@163.com", nil];
//    [mailPicker setCcRecipients:ccRecipients];
//    //添加密送
//    NSArray *bccRecipients = [NSArray arrayWithObjects:@"1806791218@qq.com", nil];
//    [mailPicker setBccRecipients:bccRecipients];
    
//    //添加一张图片
//    UIImage *addPic = [UIImage imageNamed:@"me.png"];
//    NSData *imageData = UIImagePNGRepresentation(addPic);
//    //关于mimeType：http://www.iana.org/assignments/media-types/index.html
//    [mailPicker addAttachmentData:imageData mimeType:@"" fileName:@"me"];
    //添加一个pdf附件
    NSString *file = [[NSBundle mainBundle] pathForResource:@"面试题-C部分" ofType:@"pdf"];
    NSData *pdf  = [NSData dataWithContentsOfFile:file];
//    [mailPicker addAttachmentData:@"" mimeType:@"" fileName:@"面试图-C部分"];
    
//    NSString *emailBody = @"<font color='red'>eMail</font>正文";
    
    [mailPicker setMessageBody:emailBody isHTML:YES];
   
//    [self.viewController presentModalViewController:mailPicker animated:YES];
   
    [self.viewController presentViewController:mailPicker animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
//    [self.viewController dismissModalViewControllerAnimated:YES];
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
        msg = @"用户取消编辑邮件";
        break;
        case MFMailComposeResultSaved:
        msg =@"用户成功保存邮件";
        break;
        case MFMailComposeResultSent:
        msg = @"用户点击发送，将邮件放到队列中，还没发送";
        break;
        case MFMailComposeResultFailed:
        msg = @"用户试图保存或者发送邮件失败";
        break;
        default:
        break;
    }
//    [self alertControler:msg];
    NSMutableDictionary *dictary = [[NSMutableDictionary alloc] init];
    
    if([msg isEqualToString:@"用户点击发送，将邮件放到队列中，还没发送"]){
        [dictary setObject:@"成功" forKey:@"result_msg"];
        [dictary setObject:@"1" forKey:@"result_code"];
     
        _result=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dictary];
        
    }else{
        [dictary setObject:@"失败" forKey:@"result_msg"];
        [dictary setObject:@"0" forKey:@"result_code"];
        _result=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dictary];
        
    }
    [self.commandDelegate sendPluginResult:_result callbackId:_command.callbackId];
    
}
- (void)alertControler:(NSString *)status
{
    NSString *message = [NSString stringWithFormat:@"%@",status];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    //
    //    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    //    [alert addAction:cancel];
    [alert addAction:sure];
    [self.viewController presentViewController:alert animated:YES completion:nil];
}
@end
