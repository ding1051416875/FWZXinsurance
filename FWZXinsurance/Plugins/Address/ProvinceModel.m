//
//  ProvinceModel.m
//  FWZXinsurance
//
//  Created by ding on 2017/12/27.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "ProvinceModel.h"

@implementation ProvinceModel
+(instancetype)showDataWith:(NSDictionary *)array{
    ProvinceModel *model=[[ProvinceModel alloc]init];
    
    
    NSDictionary *dic=(NSDictionary *)array;
    NSString *string=dic[@"name"];
    model.name=string;
    model.code = dic[@"code"];
    
    NSArray *arrayT=[dic objectForKey:@"cityList"];
    
    
    NSMutableArray *data=[[NSMutableArray alloc]init];
    [arrayT enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        CityModel *Models=[CityModel showCityDataWith:obj];
        
        [data addObject:Models];
        
        
    }];
    
    model.city=data;
    
    return model;
    
}
@end
