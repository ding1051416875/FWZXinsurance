//
//  AreaModel.m
//  json
//
//  Created by Bory on 2017/12/7.
//  Copyright © 2017年 Bory. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    
    self = [super init];
    
    if (self) {
        
        self.name = dict[@"name"];
        
        self.code = dict[@"code"];
        
        self.areaList = dict[@"areaList"];
        
    }
    return self;
}

+ (instancetype)areaModelWithDict:(NSDictionary *)dict{
    
    return [[self alloc] initWithDict:dict];
}
@end
