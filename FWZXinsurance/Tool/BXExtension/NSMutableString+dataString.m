//
//  NSMutableString+dataString.m
//  QuickLawyerDemo
//
//  Created by apple on 16/12/19.
//  Copyright © 2016年 DingXiaoLei. All rights reserved.
//

#import "NSMutableString+dataString.h"

@implementation NSMutableString (dataString)

/**转化成签名后的字典*/
+(NSMutableString *)partnerSignOrder:(NSDictionary*)paramDic
{
    NSArray *keyArray = [paramDic allKeys];
    // 对字段进行字母序排序
    NSMutableArray *sortedKeyArray = [NSMutableArray arrayWithArray:keyArray];
    [sortedKeyArray sortUsingComparator:^NSComparisonResult(NSString* key1, NSString* key2) {
        return [key1 compare:key2];
    }];
    
    NSMutableString *paramString = [NSMutableString stringWithString:@""];
    // 拼接成 A=B&X=Y
    for (NSString *key in sortedKeyArray)
    {
        //        if ([paramDic[key] length] != 0)
        //        {
        [paramString appendFormat:@"&%@=%@", key, paramDic[key]];
        //        }
    }
    
    if ([paramString length] > 1)
    {
        [paramString deleteCharactersInRange:NSMakeRange(0, 1)];    // remove first '&'
    }
    [paramString appendFormat:@"&signStr=%@", @"co.jishilvshi.www"];
    //    NSString *signString = [self signString:paramString];
    NSString *signString = [NSString md5:paramString];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [dict setObject:signString forKey:@"sign"];
    
    
    NSArray *keyArray1 = [dict allKeys];
    // 对字段进行字母序排序
    NSMutableArray *sortedKeyArray1 = [NSMutableArray arrayWithArray:keyArray1];
    [sortedKeyArray1 sortUsingComparator:^NSComparisonResult(NSString* key1, NSString* key2) {
        return [key1 compare:key2];
    }];
    
    NSMutableString *paramString1 = [NSMutableString stringWithString:@""];
    // 拼接成 A=B&X=Y
    for (NSString *key in sortedKeyArray1)
    {
        //        if ([paramDic[key] length] != 0)
        //        {
        [paramString1 appendFormat:@"&%@=%@", key, dict[key]];
        //        }
    }
    
    if ([paramString1 length] > 1)
    {
        [paramString1 deleteCharactersInRange:NSMakeRange(0, 1)];    // remove first '&'
    }
    return paramString1;
}
@end
