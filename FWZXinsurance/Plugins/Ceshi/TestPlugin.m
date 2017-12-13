//
//  TestPlugin.m
//  JS_OC_Cordova
//
//  Created by 丁晓雷 on 2017/11/23.
//  Copyright © 2017年 Haley. All rights reserved.
//

#import "TestPlugin.h"

@implementation TestPlugin
- (void)getSignature:(CDVInvokedUrlCommand *)command;
{
    //获取js传过来的值
    CDVPluginResult *result=nil;
    NSString *openname = @"fwd";
    NSString *openkey  = @"fairyland";
    NSString *nameAndKey = [openname stringByAppendingString:openkey];
    NSString *nameAndKeyMd5 = [NSString md5:nameAndKey];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *curentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //生成五位随机数
    NSString *strRandom = @"";
    for (int i=0; i<5; i++) {
        strRandom = [strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    NSString *randomcode = [curentDateStr stringByAppendingString:strRandom];
    NSString *totalCode = [nameAndKeyMd5 stringByAppendingString:randomcode];
    NSString *md =[NSString md5:totalCode];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if([md isEqualToString:@""])
    {
        [dict setObject:randomcode forKey:@"rangdomcode"];
        [dict setObject:@"000" forKey:@"code"];
        [dict setObject:md forKey:@"Signature"];
        NSString *jsStr = [NSString stringWithFormat:@"mdResult('%@',)",[dict mj_JSONString]];
        result=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:jsStr];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }else{
        [dict setObject:randomcode forKey:@"rangdomcode"];
        [dict setObject:@"100" forKey:@"code"];
        [dict setObject:md forKey:@"Signature"];
        NSString *jsStr = [NSString stringWithFormat:@"mdResult('%@',)",[dict mj_JSONString]];
        result=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsStr];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
  
 
     
}
@end
