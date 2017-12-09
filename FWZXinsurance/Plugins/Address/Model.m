//
//  Model.m
//  json
//
//  Created by Bory on 2017/12/7.
//  Copyright © 2017年 Bory. All rights reserved.
//

#import "Model.h"

@implementation Model

- (instancetype)initWithDict:(NSDictionary *)dict{
    
    self = [super init];
    
    if (self) {
        
        self.name = dict[@"name"];
        
        self.code = dict[@"code"];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    
    return [[self alloc] initWithDict:dict];
}

@end
