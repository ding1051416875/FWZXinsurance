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
#import "CameraViewController.h"
#import "UIImage+SubImage.h"
@interface UpCardId()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *policyId;
@property (nonatomic, copy) NSString *seqNum;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *customerType;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *urlImage;
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
    _customerId= [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:0]];
    _policyId =[NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:1]];
    //seqNum 1代表身份证正面 2代表身份证反面
    _seqNum = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:2]];
    _type = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:3]];
    _customerType = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:4]];
    _url = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:5]];
//    if ([Check isEmptyString:_customerId]||[Check isEmptyString:_policyId]||[Check isEmptyString:_seqNum]||[Check isEmptyString:_type]||[Check isEmptyString:_customerType]||[Check isEmptyString:_url]) {
////        [ProgressHUD showError:@"传入数据为空"];
//        [MBProgressHUD showError:@"传入数据为空" toView:self.viewController.view];
//        return;
//    }
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
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth/2+kWidth/4-50, (kWidth/2+kWidth/4-50)*0.65)];
    view.center = self.viewController.view.center;
    view.transform = CGAffineTransformMakeTranslation(-2, 0);
    NSString *seq = [NSString stringWithFormat:@"%@",_seqNum];
    if ([seq isEqualToString:@"1"]) {
        view.image = [UIImage imageNamed:@"cardfront"];
    }else{
        view.image = [UIImage imageNamed:@"cardback"];
    }
     image.cameraOverlayView =view;

    [self.viewController presentViewController:image animated:YES completion:nil];
//    self.iMG = [Maker makeImgView:CGRectMake(0, 100, 500, 500) img:@""];
//    [self.viewController.view addSubview:self.iMG];
//    CameraViewController *camera = [[CameraViewController alloc] init];
//    camera.saveImage = ^(UIImage *image) {
//        [self uploadImageToService:image];
//        self.iMG.image = image;
//    };
//    [self.viewController presentViewController:camera animated:YES completion:nil];
    [self configCallback:command];
    _command =command;

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *oldImage = [info objectForKey:UIImagePickerControllerEditedImage];
        CGFloat height = (kHeight- (kWidth/2+kWidth/4)*0.65)/2;
        UIImage *newImage;
        newImage = [oldImage subImageWithRect:CGRectMake(0, height, oldImage.size.width, oldImage.size.height)];
        [self uploadImageToService:oldImage newImage:newImage];
        [self back];

    }
}
- (void)uploadImageToService:(UIImage *)oldImage newImage:(UIImage *)newImage
{
//    NSString *netPath = @"http://40.125.170.204:8082/FwCustom/insure/policyHolder/sumbitImage";
//    NSString *netPath = @"/uploadDynamicImage.do?";
//    http://139.196.227.121:8088/zsdj/app//uploadDynamicImage.do?
//    if ([Check isEmptyString:_customerId]||[Check isEmptyString:_policyId]||[Check isEmptyString:_seqNum]||[Check isEmptyString:_type]||[Check isEmptyString:_customerType]||[Check isEmptyString:_url]||newImage ==nil) {
//        [ProgressHUD showError:@"传入数据为空"];
//        return;
//    }

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
    [ProgressHUD show:@"正在上传中"];
    [array addObject:newImage];
    [HttpTool postWithPath:_url name:@"file" imagePathList:array params:rdict success:^(id responseObj) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSString *result = [NSString stringWithFormat:@"%@",dict[@"code"]];
        [ProgressHUD dismiss];
        if([result isEqualToString:@"000"]){
            _urlImage = dict[@"data"];
            [ProgressHUD showSuccess:@"图片上传成功"];
            if([_seqNum isEqualToString:@"1"]){
            
            NSDictionary *options = @{@"detect_direction":@"false",@"id_card_side":@"front"};
                //身份证正面

                [[AipOcrService shardService] detectIdCardFrontFromImage:oldImage withOptions:options successHandler:_successHandle failHandler:_failHandler];
            }else if([_seqNum isEqualToString:@"2"]){
            NSDictionary *options = @{@"detect_direction":@"false",@"id_card_side":@"back"};
                //身份证反面
                [[AipOcrService shardService] detectIdCardBackFromImage:oldImage withOptions:options successHandler:_successHandle failHandler:_failHandler];
                
            }
        }else{
            [ProgressHUD showError:@"图片上传失败"];
            NSDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@"0" forKey:@"result_code"];
            [dict setValue:dict[@"message"] forKey:@"result_msg"];
            CDVPluginResult *resultId = nil;
            resultId = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
            [self.commandDelegate sendPluginResult:resultId callbackId:_command.callbackId];
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                [self back];
//            }];
        }
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"服务器正在调试"];
        NSDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:@"0" forKey:@"result_code"];
        [dict setValue:error.localizedDescription forKey:@"result_msg"];
        CDVPluginResult *resultId = nil;
        resultId = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
        [self.commandDelegate sendPluginResult:resultId callbackId:_command.callbackId];
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [self back];
//        }];
    }];
}
- (void)configCallback:(CDVInvokedUrlCommand *)command{
  
   
    __weak typeof(self) weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [weakSelf back];
    }];
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
                    }else if ([weakSelf.seqNum isEqualToString:@"2"]){
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
        [dict setValue:@"识别成功" forKey:@"result_msg"];
        [dict setValue:weakSelf.urlImage forKey:@"result_data"];
        [dict setValue:weakSelf.seqNum forKey:@"upload_type"];
        CDVPluginResult *resultId = nil;
        resultId = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [weakSelf.commandDelegate sendPluginResult:resultId callbackId:command.callbackId];
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//             [weakSelf back];
//        }];
        
    };

    _failHandler = ^(NSError *error){

        [dict setValue:@"0" forKey:@"result_code"];
        [dict setValue:error.localizedDescription forKey:@"result_msg"];
        CDVPluginResult *resultId = nil;
        resultId = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
        [weakSelf.commandDelegate sendPluginResult:resultId callbackId:command.callbackId];
       
       
    };
   
  
    
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationLandscapeLeft;
    
}



- (NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape;
    
}



- (BOOL)shouldAutorotate {
    
    return NO;
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        
        return YES;
        
    } else {
        
        return NO;
        
    }
    
}

- (void)back{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}
@end
