//
//  CityModel.m
//  json
//
//  Created by Bory on 2017/12/7.
//  Copyright © 2017年 Bory. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel
+(instancetype)showCityDataWith:(NSDictionary *)dic{
    
    CityModel *model=[[CityModel alloc]init];
    NSString *string=dic[@"name"];
    model.name=string;
    model.code = dic[@"code"];
    NSArray *arrayT=[dic objectForKey:@"areaList"];
    NSMutableArray *data=[[NSMutableArray alloc]init];
    [arrayT enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AreaModel *teanModels=[AreaModel showDistrictDataWith:obj];
        [data addObject:teanModels];
        
    }];
    model.District= data;
    
    return model;
}
@end
