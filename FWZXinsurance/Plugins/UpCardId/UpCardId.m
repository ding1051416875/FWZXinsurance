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
@property (nonatomic, copy) NSString *urlImage;
@property (nonatomic,strong) CDVInvokedUrlCommand *command;
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
    [self configCallback:command];
    _command =command;

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        [self uploadImageToService:image];

    }
}
- (void)uploadImageToService:(UIImage *)filePath
{
    NSString *netPath = @"http://40.125.170.204:8082/FwCustom/insure/policyHolder/sumbitImage";
//    NSString *netPath = @"/uploadDynamicImage.do?";
//    http://139.196.227.121:8088/zsdj/app//uploadDynamicImage.do?
    NSMutableDictionary *rdict = [NSMutableDictionary dictionary];
    [rdict setObject:@([_customerId integerValue]) forKey:@"customerId"];
    [rdict setObject:_policyId forKey:@"policyId"];
    [rdict setObject:_seqNum forKey:@"seqNum"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:filePath];
    [HttpTool postWithPath:netPath name:@"file" imagePathList:array params:rdict success:^(id responseObj) {
       
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];

        
        NSString *result = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if([result isEqualToString:@"000"]){
            _urlImage = dict[@"data"];
            if([_seqNum isEqualToString:@"1"]){
                
                
            NSDictionary *options = @{@"detect_direction":@"false",@"id_card_side":@"front"};
                //身份证正面
                [[AipOcrService shardService] detectIdCardFrontFromImage:filePath withOptions:options successHandler:_successHandle failHandler:_failHandler];
            }else if([_seqNum isEqualToString:@"0"]){
            NSDictionary *options = @{@"detect_direction":@"false",@"id_card_side":@"front"};
                //身份证反面
                [[AipOcrService shardService] detectIdCardBackFromImage:filePath withOptions:options successHandler:_successHandle failHandler:_failHandler];
                
            }
        }else{
            [ProgressHUD showError:dict[@"message"]];
            NSDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@"0" forKey:@"result_code"];
            [dict setValue:@"失败" forKey:@"result_msg"];
            CDVPluginResult *resultId = nil;
            resultId = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:resultId callbackId:_command.callbackId];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self back];
            }];
        }
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"服务器正在调试"];
        NSDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:@"0" forKey:@"result_code"];
        [dict setValue:@"失败" forKey:@"result_msg"];
        CDVPluginResult *resultId = nil;
        resultId = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [self.commandDelegate sendPluginResult:resultId callbackId:_command.callbackId];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self back];
        }];
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
                    if ([weakSelf.seqNum isEqualToString:@"1"]) {
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
                        }
                    }else if ([weakSelf.seqNum isEqualToString:@"0"]){
                        if ([key isEqualToString:@"签发日期"]){
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
        
          [dict setValue:weakSelf.urlImage forKey:@"result_data"];
           CDVPluginResult *resultId = nil;
          resultId = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
          [weakSelf.commandDelegate sendPluginResult:resultId callbackId:command.callbackId];
           [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             [weakSelf back];
           }];
        
    };

    _failHandler = ^(NSError *error){

        [dict setValue:@"0" forKey:@"result_code"];
        [dict setValue:@"失败" forKey:@"result_msg"];
        CDVPluginResult *resultId = nil;
        resultId = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [weakSelf.commandDelegate sendPluginResult:resultId callbackId:command.callbackId];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             [weakSelf back];
        }];
       
    };
   
  
    
}



- (void)back{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}
@end
