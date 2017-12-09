//
//  NSString+function.h
//  QuickLawyer
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 DingXiaoLei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (function)
+ (NSString *) md5:(NSString *)str;
+ (NSString *) speciality:(NSString *)str;
+ (NSString *) numSpeciality:(NSString *)str;
+ (NSString *) alipayString:(NSString *)str;
+ (NSString *) GetNowTimes;

@end
