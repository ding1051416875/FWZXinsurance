//
//  FULAN_IFLY.m
//  FWZXinsurance
//
//  Created by ding on 2017/11/28.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "FULAN_IFLY.h"
#import <iflyMSC/iflyMSC.h>
@interface FULAN_IFLY()<IFlyRecognizerViewDelegate>
{
    //带界面的语音识别
    IFlyRecognizerView *_iflyRecognizerView;
    //获取js传过来的值
    CDVPluginResult *result;
    CDVInvokedUrlCommand *commandID;
}

@end


@implementation FULAN_IFLY
- (void)getIfly:(CDVInvokedUrlCommand *)command
{

    commandID = command;
    [self initRecognized];
    [self.viewController.view endEditing:YES];
    //    self.commentView.text = @"";
    //启动识别服务
    [_iflyRecognizerView start];
}
- (void)initRecognized
{
    if (_iflyRecognizerView== nil) {
        //初始化语音识别控件
        _iflyRecognizerView = [[IFlyRecognizerView  alloc] initWithCenter:self.viewController.view.center];
        _iflyRecognizerView.delegate = self;
        [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
        
        [_iflyRecognizerView setParameter:@"asrview.pcm " forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
    }
//    result =[[CDVPluginResult alloc]init];
}

- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast {
    NSLog(@"arr:%@",resultArray);
    //数组的第一个元素是一个字典
    NSDictionary *dict = resultArray[0];
    NSMutableString *str = [[NSMutableString alloc] init];
    //字典的key 就是 识别的内容 是json 格式的字符串
    for (NSString *key in dict) {
        [str appendString:key];
    }
    //解析
    NSString *newStr = [self stringFromJson:str];
//    if([md isEqualToString:@""])
//    {
//        [dict setObject:randomcode forKey:@"rangdomcode"];
//        [dict setObject:@"100" forKey:@"code"];
//        [dict setObject:md forKey:@"Signature"];
//        NSString *jsStr = [NSString stringWithFormat:@"mdResult('%@',)",[dict mj_JSONString]];
//        result=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsStr];
//        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
//    }else{
//        [dict setObject:randomcode forKey:@"rangdomcode"];
//        [dict setObject:@"100" forKey:@"code"];
//        [dict setObject:md forKey:@"Signature"];
//        NSString *jsStr = [NSString stringWithFormat:@"mdResult('%@',)",[dict mj_JSONString]];
//        result=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsStr];
//        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
//    }
    //解析
    NSMutableDictionary *dictary = [[NSMutableDictionary alloc] init];

    if(![Check isEmptyString:newStr]){
        [dictary setObject:@"识别成功" forKey:@"result_msg"];
        [dictary setObject:@"1" forKey:@"result_code"];
        if ([Check isEmptyString:newStr]) {
            [ProgressHUD showError:@"请重新输入"];
            return;
        }
        [dictary setObject:newStr forKey:@"text"];
        result=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dictary];
    
    }else{
        [dictary setObject:@"识别失败" forKey:@"result_msg"];
        [dictary setObject:@"0" forKey:@"result_code"];
        result=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dictary];
    
    }
    [self.commandDelegate sendPluginResult:result callbackId:commandID.callbackId];
}
- (NSString *)stringFromJson:(NSString*)params
{
    if (params == NULL) {
        return nil;
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //返回的格式必须为utf8的,否则发生未知错误
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if (resultDic!= nil) {
        NSArray *wordArray = [resultDic objectForKey:@"ws"];
        
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                [tempStr appendString: str];
            }
        }
    }
    return tempStr;
}
- (void)onError:(IFlySpeechError *)error {
    NSLog(@"识别结束");
}
#pragma mark - UITextField
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.viewController.view endEditing:YES];
}

//结束输入
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.viewController.view endEditing:YES];
    
}
@end
