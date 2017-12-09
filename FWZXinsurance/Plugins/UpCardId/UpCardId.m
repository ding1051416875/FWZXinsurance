//
//  UpCardId.m
//  FWZXinsurance
//
//  Created by ding on 2017/12/8.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "UpCardId.h"
#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import <AVFoundation/AVFoundation.h>
@interface UpCardId()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *policyId;
@property (nonatomic, copy) NSString *seqNum;
@property (nonatomic, copy) NSString *url;
@end
@implementation UpCardId
{
    //默认的识别成功的回调
    void (^_successHandle)(id);
    void (^_failHandler)(NSError *);
}
- (void)upCardId:(CDVInvokedUrlCommand *)command
{
    //返回值
    _customerId= [command.arguments objectAtIndex:0];
    _policyId = [command.arguments objectAtIndex:1];
    _seqNum = [command.arguments objectAtIndex:2];
    _url = [command.arguments objectAtIndex:3];
    
    //ocr
    [[AipOcrService shardService] authWithAK:@"DUtU6MUv6Pn1yuQG9FMGhDmo" andSK:@"wPT0Dkkl3v8BYjE3kRYHatzPcQ11mbf3"];
    
    AVAuthorizationStatus authstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authstatus == AVAuthorizationStatusRestricted || authstatus == AVAuthorizationStatusDenied)//用户关闭了权限
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在设备的设置-隐私-相机中允许访问相机。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        
        return;
    }
    //身份证正面
    UIImagePickerController *image = [[UIImagePickerController alloc] init];
    image.delegate = self;
    image.sourceType = UIImagePickerControllerSourceTypeCamera;
    image.allowsEditing = YES;
    [self.viewController presentViewController:image animated:YES completion:nil];
    [self configCallback:command ];

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSDictionary *options = @{@"detect_direction":@"false",@"id_card_side":@"front"};
        if([_seqNum isEqualToString:@"1"]){
            //身份证正面
            [[AipOcrService shardService] detectIdCardFrontFromImage:image withOptions:options successHandler:_successHandle failHandler:_failHandler];
            
            [self uploadImageToService:image];
        }else if([_seqNum isEqualToString:@"0"]){
            //身份证反面
            [[AipOcrService shardService] detectIdCardBackFromImage:image withOptions:options successHandler:_successHandle failHandler:_failHandler];
            [self uploadImageToService:image];
            
        }

    }
}
- (void)uploadImageToService:(UIImage *)filePath
{
    NSString *netPath = @"insure/policyHolder/sumbitImage";
    NSMutableDictionary *rdict = [NSMutableDictionary dictionary];
    [rdict setObject:@([_customerId integerValue]) forKey:@"customerId"];
    [rdict setObject:_policyId forKey:@"policyId"];
    [rdict setObject:_seqNum forKey:@"seqNum"];
    NSData *imageData = UIImageJPEGRepresentation(filePath, 0.8);
    [HttpTool postWithPath:netPath indexName:@"file" fileData:imageData params:rdict success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        NSString *result = [NSString stringWithFormat:@"%@",dict[@"result"]];
        if([result isEqualToString:@"1"]){
            
        }else{
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)configCallback:(CDVInvokedUrlCommand *)command{
   
    __weak typeof(self) weakSelf = self;
    NSDictionary *dict = [[NSMutableDictionary alloc] init];
    _successHandle = ^(id result){
        NSMutableString *message = [[NSMutableString alloc] init];
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result" ]enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
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
                }else{
                    [message appendFormat:@"%@: %@\n",key,obj];
                }
                    
                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]]&&[obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n",obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@\n",obj];
                    }
                }
            }
        }else{
            [message appendFormat:@"%@",result];
        }
        [dict setValue:@"1" forKey:@"result_code"];
        [dict setValue:@"成功" forKey:@"result_msg"];
        CDVPluginResult *resultId = nil;
        resultId = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [weakSelf.commandDelegate sendPluginResult:resultId callbackId:command.callbackId];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf back];
        }];
    };
    
    _failHandler = ^(NSError *error){
//       NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        [dict setValue:@"0" forKey:@"result_code"];
        [dict setValue:@"失败" forKey:@"result_msg"];
        CDVPluginResult *resultId = nil;
        resultId = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [weakSelf.commandDelegate sendPluginResult:resultId callbackId:command.callbackId];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [[[UIAlertView alloc] initWithTitle:@"识别失败" message:msg delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
             [weakSelf back];
        }];
       
    };
    
}



- (void)back{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}
@end
