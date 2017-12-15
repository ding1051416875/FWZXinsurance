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
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *customerType;
@property (nonatomic, copy) NSString *agentId;
@property (nonatomic, copy) NSString *url;
@end

@implementation Pen
-(void)doSign:(CDVInvokedUrlCommand *)command
{
    
    //    <!--                UpCardId.upCardId (success(function), error(function)-->
    //                                           <!--                                   , customerId, policyId, seqNum, type, customerType, url);-->
    //    <!--                                   success :成功回调；-->
    //    <!--                                   error：失败回调;-->
    //    <!--                                   customerId：customerId;-->
    //    <!--                                   policyId : policyId;-->
    //    <!--                                   seqNum : seqNum（1正面，2反面）；-->
    //    <!--                                   type:上传文件类型，0为身份证，1为签名-->
    //    <!--                                   customerType: 0投保人，1被保人，2代理人-->
    //                                           agentId
    //    <!--                                   url ：上传服务器。-->
        
    //返回值
    _customerId= [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:0]];
    _policyId =[NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:1]];
    //seqNum 1代表身份证正面 2代表身份证反面
    _seqNum = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:2]];
    _type = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:3]];
    _customerType = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:4]];
    _url = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:5]];
    if ([Check isEmptyString:_customerId]||[Check isEmptyString:_policyId]||[Check isEmptyString:_seqNum]||[Check isEmptyString:_type]||[Check isEmptyString:_customerType]||[Check isEmptyString:_url]) {
        [ProgressHUD showError:@"传入数据为空"];
        return;
    }
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
            [dict setValue:@"没有保存成功" forKey:@"result_msg"];
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

    if ([Check isEmptyString:_customerId]||[Check isEmptyString:_policyId]||[Check isEmptyString:_seqNum]||[Check isEmptyString:_type]||[Check isEmptyString:_customerType]||[Check isEmptyString:_url]||filePath ==nil) {
        [ProgressHUD showError:@"传入数据为空"];
        return;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
//    NSString *netPath = @"http://40.125.170.204:8082/FwCustom/insure/policyHolder/sumbitImage";
    NSMutableDictionary *rdict = [NSMutableDictionary dictionary];
    [rdict setObject:@([_customerId integerValue]) forKey:@"customerId"];
    [rdict setObject:_policyId forKey:@"policyId"];
    [rdict setObject:_seqNum forKey:@"seqNum"];
    [rdict setObject:_type forKey:@"type"];
    [rdict setObject:_customerType forKey:@"customerType"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:filePath];
    [HttpTool postWithPath:_url name:@"file" imagePathList:array params:rdict success:^(id responseObj) {

        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSString *result = [NSString stringWithFormat:@"%@",dictionary[@"code"]];
        if([result isEqualToString:@"000"]){
            NSData *imageData = UIImageJPEGRepresentation(filePath,1.0);
            NSString *image =[NSString stringWithFormat:@"data:image/png;base64,%@",[GTMBase64 stringByEncodingData:imageData]];
            [dict setObject:@"上传成功" forKey:@"result_msg"];
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
            [dict setValue:dictionary[@"message"] forKey:@"result_msg"];
            CDVPluginResult *resultId = nil;
            resultId = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:resultId callbackId:command.callbackId];
         
        }
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"服务器正在调试"];
        NSDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:@"0" forKey:@"result_code"];
        [dict setValue:error.localizedDescription forKey:@"result_msg"];
        CDVPluginResult *resultId = nil  ;
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
