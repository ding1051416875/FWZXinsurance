//
//  Check.m
//  LawyerSide
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 DingXiaoLei. All rights reserved.
//

#import "Check.h"
//下面2个是获取ip地址必须的头文件
#import <ifaddrs.h>
#import <arpa/inet.h>
@implementation Check
/**
 *  校验手机号码格式是否正确
 */
+(BOOL)isPhoneNumber:(NSString *)phoneNumber
{
    NSString *reg=@"^(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *mobliePredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    BOOL result=[mobliePredicate evaluateWithObject:phoneNumber];
    return result;
}
/**
 *  校验密码格式是否正确
 */
+(BOOL)isPasswordCorrect:(NSString *)password
{
    //密码包含数字字母和@!#$_^&.-
    NSString *reg=@"^[A-Za-z0-9@!#$_^&.-]{6,20}$";
    NSPredicate *passwordPredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    BOOL result=[passwordPredicate evaluateWithObject:password];
    return result;
}
/**
 *  校验是否是空字符串
 */
+(BOOL)isEmptyString:(NSString *)sourceString
{
    if(([sourceString isKindOfClass:[NSNull class]]||[sourceString isEqualToString:@"(null)"])||(sourceString.length==0)||(!sourceString))
        return YES;
    return NO;
}
/**
 *  校验验证码格式是否正确
 */
+(BOOL)isVerifyCodeCorrect:(NSString *)verifyCode
{
    NSString *reg=@"^[0-9]{6}$";
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    return [pre evaluateWithObject:verifyCode];
}

/**
 *  校验年龄格式是否正确
 */
+(BOOL)isAgeCorrect:(NSString *)age{
    NSString *reg=@"^([0-9]|[0-9]{2}|100)$";
    NSPredicate *agePredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    BOOL result=[agePredicate evaluateWithObject:age];
    return result;
}



+(BOOL)isiPhone4S
{
    if(kHeight==480.f)
    return YES;
    return NO;
}
+(BOOL)isiPhone5S
{
    if(kHeight==568.f)
    return YES;
    return NO;
}
+(BOOL)isiPhone6S
{
    if(kHeight==667.f)
    return YES;
    return NO;
}
+(BOOL)isiPhone6SP
{
    if(kHeight==736.f)
    return YES;
    return NO;
}
+(CGFloat)systemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}
+(NSString *)appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}
/**
 *  获取UUID
 */
+(NSString*) uuid
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
/**
 *  获取UDID
 */
+ (NSString *)udid
{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return idfv;
}
/**获取ip地址*/
+ (NSString *)deviceIPAdress
{
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;
}

@end
