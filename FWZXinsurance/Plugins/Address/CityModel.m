//
//  CityModel.m
//  json
//
//  Created by Bory on 2017/12/7.
//  Copyright © 2017年 Bory. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    
    self = [super init];
    
    if (self) {
        
        self.name = dict[@"name"];
        
        self.code = dict[@"code"];
        
        self.cityList = dict[@"cityList"];
        
    }
    return self;
}

+ (instancetype)cityModelWithDict:(NSDictionary *)dict{
    
    return [[self alloc] initWithDict:dict];
}
@end
