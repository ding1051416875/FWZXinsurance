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
@interface Pen()
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *policyId;
@property (nonatomic, copy) NSString *seqNum;
@property (nonatomic, copy) NSString *url;
@end

@implementation Pen
-(void)doSign:(CDVInvokedUrlCommand *)command
{
    
    //返回值
    _customerId= [command.arguments objectAtIndex:0];
    _policyId = [command.arguments objectAtIndex:1];
    _seqNum = [command.arguments objectAtIndex:2];
    _url = [command.arguments objectAtIndex:3];
    SignDrawViewController *vc = [[SignDrawViewController alloc] init];
    vc.backImage = ^(UIImage *image, BOOL isSuccess) {
        // 如果项目需求要将电子签名上传服务器，那就可以在这里处理图片并上传服务器
        //获取js传过来的值
        // 判断图片大小进行压缩
        
        
       
        if(isSuccess == YES)
        {
//            NSData *imageData = UIImageJPEGRepresentation(image,1.0);
//            NSString *image =[NSString stringWithFormat:@"data:image/png;base64,%@",[GTMBase64 stringByEncodingData:imageData]];
            [self uploadImageToService:image command:command];
            //拼接字符串
//            NSString *addResult=[self UIImageToBase64Str:image];
//            [dict setObject:@"成功" forKey:@"result_msg"];
//            [dict setObject:@"1" forKey:@"result_code"];
//            [dict setObject:image forKey:@"result_img"];
//            result=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
//            //传值（消息）到JS文件
//            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }else if(isSuccess == NO)
        {
            
            [ProgressHUD showError:@"没有保存成功"];
            NSDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@"0" forKey:@"result_code"];
            [dict setValue:@"失败" forKey:@"result_msg"];
            CDVPluginResult *resultId = nil;
            resultId = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:resultId callbackId:command.callbackId];
//            [dict setObject:@"失败" forKey:@"result_msg"];
//            [dict setObject:@"0" forKey:@"result_code"];
//            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
//            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }
//        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    };
    [self.viewController presentViewController:vc animated:YES completion:nil];
}

- (void)uploadImageToService:(UIImage *)filePath command:(CDVInvokedUrlCommand *)command
{

    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
//    NSString *netPath = @"http://40.125.170.204:8082/FwCustom/insure/policyHolder/sumbitImage";
    NSMutableDictionary *rdict = [NSMutableDictionary dictionary];
    [rdict setObject:@([_customerId integerValue]) forKey:@"customerId"];
    [rdict setObject:_policyId forKey:@"policyId"];
    [rdict setObject:_seqNum forKey:@"seqNum"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:filePath];
    [HttpTool postWithPath:_url name:@"file" imagePathList:array params:rdict success:^(id responseObj) {

        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSString *result = [NSString stringWithFormat:@"%@",dictionary[@"code"]];
        if([result isEqualToString:@"000"]){
            NSData *imageData = UIImageJPEGRepresentation(filePath,1.0);
            NSString *image =[NSString stringWithFormat:@"data:image/png;base64,%@",[GTMBase64 stringByEncodingData:imageData]];
            [dict setObject:@"成功" forKey:@"result_msg"];
            [dict setObject:@"1" forKey:@"result_code"];
            [dict setObject:dictionary[@"data"] forKey:@"result_data"];
            [dict setObject:image forKey:@"result_img"];
            CDVPluginResult *result=nil;
            result =[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
                        //传值（消息）到JS文件
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }else{
            [ProgressHUD showError:dict[@"message"]];
            NSDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@"0" forKey:@"result_code"];
            [dict setValue:@"失败" forKey:@"result_msg"];
            CDVPluginResult *resultId = nil;
            resultId = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:resultId callbackId:command.callbackId];
         
        }
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"服务器正在调试"];
        NSDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:@"0" forKey:@"result_code"];
        [dict setValue:@"失败" forKey:@"result_msg"];
        CDVPluginResult *resultId = nil;
        resultId = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
        [self.commandDelegate sendPluginResult:resultId callbackId:command.callbackId];
  
    }];
}
-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}
@end
