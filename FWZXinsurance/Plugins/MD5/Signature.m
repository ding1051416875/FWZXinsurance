//
//  Signature.m
//  FWZXinsurance
//
//  Created by 丁晓雷 on 2017/11/24.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "Signature.h"

@implementation Signature
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
    
    if(![md isEqualToString:@""])
    {
        [dict setObject:randomcode forKey:@"randomcode"];
        [dict setObject:@"1" forKey:@"result_code"];
        [dict setObject:md forKey:@"signature"];
        result=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }else{
        [dict setObject:@"0" forKey:@"result_code"];
        result=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
    
    
    
}
@end
