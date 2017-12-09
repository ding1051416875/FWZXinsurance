//
//  NSError+Description.m
//  QuickLawyer
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 DingXiaoLei. All rights reserved.
//

#import "NSError+Description.h"

@implementation NSError (Description)

-(NSString *)errorDescription
{
    if([self.localizedDescription isEqualToString:@"Could not connect to the server."])
        return @"无法连接至服务器";
    return self.localizedDescription;
}

@end
