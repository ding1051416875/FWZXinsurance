//
//  PSDataManager.h
//  PSSignDrawBoarder
//
//  Created by Vic on 2017/11/25.
//  Copyright © 2017年 Vic. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WIDTH ([[UIScreen mainScreen] bounds].size.width)       
#define HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface PSDataManager : NSObject

// 存储线数据
@property (nonatomic, strong) NSMutableArray *strokeArray;

+ (PSDataManager *)sharedManager;

@end
