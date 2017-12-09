//
//  PSDataManager.m
//  PSSignDrawBoarder
//
//  Created by Vic on 2017/11/25.
//  Copyright © 2017年 Vic. All rights reserved.
//

#import "PSDataManager.h"

@implementation PSDataManager

+ (PSDataManager *)sharedManager {
    static PSDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PSDataManager alloc] init];
    });
    return manager;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.strokeArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

@end
