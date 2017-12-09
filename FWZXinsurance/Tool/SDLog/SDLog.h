//
//  SDLog.h
//  SDKit
//
//  Created by boai on 16/4/19.
//  Copyright (c) 2016年 boai. All rights reserved.
//

#import <Foundation/Foundation.h>

void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...);


@interface SDLog : NSObject

/*! NSLog 仅在调试模式 */
#ifdef DEBUG
#define SDLog(args ...) ExtendNSLog(__FILE__, __LINE__, __PRETTY_FUNCTION__, args);
#define SDLogString [SDLog logString]
#define SDLogClear [SDLog clearLog]
#else
#define SDLog(args ...)
#define SDLogString
#define SDLogClear
#endif

/**
*  清除日志字符串.
*  可以用SDLogClear宏调用它
*/
+ (void)clearLog;

/**
 *  获取日志字符串.
 *  可以用STLogString宏调用它
 */
+ (NSString *)logString;



@end
