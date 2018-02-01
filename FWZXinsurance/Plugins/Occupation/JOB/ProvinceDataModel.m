//
//  ProvinceDataModel.m
//  FollowMeLearningPickerView
//
//  Created by LBS_ios1 on 2017/12/19.
//  Copyright © 2017年 http://www.jianshu.com/u/8acc5c21e350. All rights reserved.
//

#import "ProvinceDataModel.h"

@implementation ProvinceDataModel
+(instancetype)showDataWith:(NSDictionary *)array{
    ProvinceDataModel *model=[[ProvinceDataModel alloc]init];
    
    
    NSDictionary *dic=(NSDictionary *)array;
    NSString *string=dic[@"jobName"];
    model.jobName=string;
    model.id = dic[@"id"];
    
    NSArray *arrayT=[dic objectForKey:@"jobVo"];
    
    
    NSMutableArray *data=[[NSMutableArray alloc]init];
    [arrayT enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        CityDataModel *Models=[CityDataModel showCityDataWith:obj];
        
        [data addObject:Models];
        
        
    }];
    
    model.city=data;
    
    return model;
    
}
@end
