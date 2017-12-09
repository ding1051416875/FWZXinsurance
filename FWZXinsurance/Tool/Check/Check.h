//
//  Check.h
//  LawyerSide
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 DingXiaoLei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Check : NSObject

/**
 *  校验手机号码格式是否正确
 */
+(BOOL)isPhoneNumber:(NSString *)phoneNumber;
/**
 *  校验密码格式是否正确
 */
+(BOOL)isPasswordCorrect:(NSString *)password;
/**
 *  校验是否是空字符串
 */
+(BOOL)isEmptyString:(NSString *)sourceString;
/**
 *  校验验证码格式是否正确
 */
+(BOOL)isVerifyCodeCorrect:(NSString *)verifyCode;

/**
 *  校验年龄格式是否正确
 */
+(BOOL)isAgeCorrect:(NSString *)age;

/**
 *  判断设备及系统版本
 */

/**
 *  是否是iPhone 4/iPhone 4S
 */
+(BOOL)isiPhone4S;
/**
 *  是否是iPhone 5/iPhone 5S
 */
+(BOOL)isiPhone5S;
/**
 *  是否是iPhone 6/iPhone 6S
 */
+(BOOL)isiPhone6S;
/**
 *  是否是iPhone 6 Plus/iPhone 6S Plus
 */
+(BOOL)isiPhone6SP;
/**
 *  系统版本号
 */
+(CGFloat)systemVersion;
/**
 *  app版本号
 */
+(NSString *)appVersion;
/**
 *  获取UUID
 */
+(NSString*) uuid;
/**
 *  获取UDID
 */
+(NSString *)udid;
/**
 *  获取获取ip地址
 */
+ (NSString *)deviceIPAdress;


@end
