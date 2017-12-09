//
//  SDLog.m
//  SDKit
//
//  Created by boai on 16/4/19.
//  Copyright (c) 2016年 boai. All rights reserved.
//

#import "SDLog.h"

static NSString *logString = @"";

@implementation SDLog

void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...)
{
    va_list ap;
    
    va_start (ap, format);
    
    if (![format hasSuffix: @"\n"])
    {
        format = [format stringByAppendingString: @"\n"];
    }
    
    NSString *body = [[NSString alloc] initWithFormat:format
                                            arguments:ap];
    
    va_end (ap);
    
    NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
    fprintf(stderr, "(🎈%s🎈) (📍%s:%d📍) 📚%s📚", functionName, [fileName UTF8String], lineNumber, [body UTF8String]);
    
    if([logString isEqualToString:@""])
        logString = body;
    else
        logString = [NSString stringWithFormat:@"%@%@", logString, body];
}

+ (NSString *)logString
{
    return logString;
}

+ (void)clearLog
{
    logString = @"";
}

@end
