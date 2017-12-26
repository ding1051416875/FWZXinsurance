//
//  UpCardId.m
//  FWZXinsurance
//
//  Created by ding on 2017/12/8.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "UpCardId.h"
#import <objc/runtime.h>

#import "IDCardCameraViewController.h"
@interface UpCardId()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *policyId;
@property (nonatomic, copy) NSString *seqNum;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *customerType;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *urlImage;
@property (nonatomic, copy) NSString *card_type;
@property (nonatomic,strong) CDVInvokedUrlCommand *command;
@property (nonatomic,strong) UIImageView *iMG;
@end
@implementation UpCardId
{
    //默认的识别成功的回调
    void (^_successHandle)(id);
    void (^_failHandler)(NSError *);
}
- (void)upCardId:(CDVInvokedUrlCommand *)command
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
//    <!--                                   url ：上传服务器。-->
    //返回值
     _command =command;
    _customerId= [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:0]];
    _policyId =[NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:1]];
    //seqNum 1代表身份证正面 2代表身份证反面
    _seqNum = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:2]];
    _type = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:3]];
    _customerType = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:4]];
    NSString *type = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:5]];
    _card_type = type;
    int inttype= [type intValue];
    _url = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:6]];
//    if ([Check isEmptyString:_customerId]||[Check isEmptyString:_policyId]||[Check isEmptyString:_seqNum]||[Check isEmptyString:_type]||[Check isEmptyString:_customerType]||[Check isEmptyString:_url]) {
////        [ProgressHUD showError:@"传入数据为空"];
//        [MBProgressHUD showError:@"传入数据为空" toView:self.viewController.view];
//        return;
//    }
    IDCardCameraViewController *cameraVC = [[IDCardCameraViewController alloc] init];
    cameraVC.recogType = inttype;
    cameraVC.typeName = [NSString speciality:type];
    cameraVC.recogOrientation = 0;
    cameraVC.backIDcard = ^(NSMutableDictionary *resultdict,UIImage *image, BOOL isSuccess) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if (isSuccess == YES) {
            [self uploadImage:image dict:resultdict];
            
        }else if(isSuccess == NO){
            [dict setValue:@"0" forKey:@"result_code"];
            [dict setValue:@"识别失败" forKey:@"result_msg"];
            CDVPluginResult *result = nil;
            result=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }
    };
    [self.viewController presentViewController:cameraVC animated:YES completion:nil];


}
- (void)uploadImage:(UIImage *)image dict:(NSMutableDictionary *)resultdict{
    NSMutableDictionary *rdict = [NSMutableDictionary dictionary];
    if (![Check isEmptyString:_customerId]) {
        [rdict setObject:_customerId forKey:@"customerId"];
    }
    if (![Check isEmptyString:_policyId]) {
        [rdict setObject:_policyId forKey:@"policyId"];
    }
    if (![Check isEmptyString:_seqNum]) {
        [rdict setObject:_seqNum forKey:@"seqNum"];
    }
    if (![Check isEmptyString:_type]) {
        [rdict setObject:_type forKey:@"type"];
    }
    if (![Check isEmptyString:_customerType]) {
        [rdict setObject:_customerType forKey:@"customerType"];
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:image];
    [HttpTool postWithPath:_url name:@"file" imagePathList:array params:rdict success:^(id responseObj) {
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSString *result = [NSString stringWithFormat:@"%@",data[@"code"]];
        [ProgressHUD dismiss];
        if([result isEqualToString:@"000"]){
            _urlImage = data[@"data"];
            if([_seqNum isEqualToString:@"1"]){
                
            }else if([_seqNum isEqualToString:@"2"]){
            
            }
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            NSString *jsStr = [NSString stringWithFormat:@"mdResult('%@',)",[resultdict mj_JSONString]];
            [dict setObject:jsStr forKey:@"result_info"];
            [dict setValue:@"1" forKey:@"result_code"];
            [dict setValue:@"图片上传成功" forKey:@"result_msg"];
            [dict setValue:dict[@"data"] forKey:@"result_data"];
            [dict setValue:_card_type forKey:@"result_type"];
            CDVPluginResult *resultcd = nil;
            resultcd=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:resultcd callbackId:_command.callbackId];
        }else{
            
            NSDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@"0" forKey:@"result_code"];
            [dict setValue:@"图片上传失败" forKey:@"result_msg"];
            CDVPluginResult *resultId = nil;
            resultId = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:resultId callbackId:_command.callbackId];
        }
    } failure:^(NSError *error) {
        NSDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:@"0" forKey:@"result_code"];
        [dict setValue:@"图片上传失败" forKey:@"result_msg"];
        CDVPluginResult *resultId = nil;
        resultId = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
        [self.commandDelegate sendPluginResult:resultId callbackId:_command.callbackId];
    }];
}

@end
