//
//  CeshiPlugin.m
//  Plugin
//
//  Created by lawyee on 15/5/7.
//
//

#import "CeshiPlugin.h"

@implementation CeshiPlugin
-(void)addstr:(CDVInvokedUrlCommand *)command
{
    //获取js传过来的值
    CDVPluginResult *result=nil;
    NSString *ceshi1=[command.arguments objectAtIndex:0];
    NSString *ceshi2=[command.arguments objectAtIndex:1];
    NSString *ceshi3=[command.arguments objectAtIndex:2];
    if(ceshi1!=nil&&[ceshi1 length]>0&&[ceshi2 length]>0&&ceshi2!=nil&&ceshi3!=nil&&[ceshi3 length]>0)
    {
        //拼接字符串
        NSString *addResult=[NSString stringWithFormat:@"%@%@%@",ceshi1,ceshi2,ceshi3];
        result=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:addResult];
        //传值（消息）到JS文件
//        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }else
    {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"cuowu"];
//        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
