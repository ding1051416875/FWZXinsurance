//
//  NSError+Description.h
//  QuickLawyer
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 DingXiaoLei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Description)


@property(nonatomic,copy,readonly)NSString *errorDescription;

@end
