//
//  NSString+function.m
//  QuickLawyer
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 DingXiaoLei. All rights reserved.
//

#import "NSString+function.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (function)

+ (NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (uint32_t)strlen(cStr),result );
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
+ (NSString *)speciality:(NSString *)str
{
    NSString *speciality;
    if ([str isEqualToString:@"1"]) {
        speciality = @"婚姻家庭";
    }else if ([str isEqualToString:@"2"])
    {
        speciality = @"交通事故";
    }else if ([str isEqualToString:@"3"])
    {
        speciality = @"劳动纠纷";
    }else if ([str isEqualToString:@"4"])
    {
        speciality = @"刑事辩护";
    }else if ([str isEqualToString:@"5"])
    {
        speciality = @"合同纠纷";
    }else if ([str isEqualToString:@"6"])
    {
        speciality = @"房产纠纷";
    }else if ([str isEqualToString:@"7"])
    {
        speciality = @"债权债务";
    }else if ([str isEqualToString:@"8"])
    {
        speciality = @"其他纠纷";
    }else if ([str isEqualToString:@"9"])
    {
        speciality = @"公司法";
    }else if ([str isEqualToString:@"10"])
    {
        speciality = @"知识产权";
    }
    return speciality;
}
 +(NSString *)numSpeciality:(NSString *)title
{
    NSString *_specialty ;
    if ([title isEqualToString:@"婚姻家庭"]) {
        _specialty = @"1";
    }else if ([title isEqualToString:@"交通事故"]) {
        _specialty = @"2";
    }else if ([title isEqualToString:@"劳动纠纷"]) {
        _specialty = @"3";
    }else if ([title isEqualToString:@"形势辩护"]) {
        _specialty = @"4";
    }else if ([title isEqualToString:@"合同纠纷"]) {
        _specialty = @"5";
    }else if ([title isEqualToString:@"房产纠纷"]) {
        _specialty = @"6";
    }else if ([title isEqualToString:@"债权债务"]) {
        _specialty = @"7";
    }else if ([title isEqualToString:@"其他纠纷"]) {
        _specialty = @"8";
    }else if ([title isEqualToString:@"公司法"]) {
        _specialty = @"9";
    }else if ([title isEqualToString:@"知识产权"]) {
        _specialty = @"10";
    }
    return _specialty;
}
+(NSString *)alipayString:(NSString *)str
{
    NSString *alipay ;
    if ([str isEqualToString:@"9000"]) {
        alipay = @"订单支付成功";
    }else if ([str isEqualToString:@"8000"])
    {
        alipay = @"正在处理中";
    }else if ([str isEqualToString:@"4000"])
    {
        alipay = @"订单支付失败";
    }else if ([str isEqualToString:@"5000"])
    {
        alipay = @"重复请求";
    }else if ([str isEqualToString:@"6001"])
    {
         alipay = @"中途取消";
    }else if ([str isEqualToString:@"6002"])
    {
        alipay = @"网络连接出错";
    }else if ([str isEqualToString:@"6004"])
    {
        alipay = @"其他支付错误";
    }else{
        alipay = @"其它支付错误";
    }
    return alipay;
}
+(NSString *)GetNowTimes
{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f",a];
    return timeString;
}

@end
