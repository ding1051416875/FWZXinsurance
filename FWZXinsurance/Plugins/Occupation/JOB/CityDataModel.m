//
//  CityDataModel.m
//  FollowMeLearningPickerView
//
//  Created by LBS_ios1 on 2017/12/19.
//  Copyright © 2017年 http://www.jianshu.com/u/8acc5c21e350. All rights reserved.
//

#import "CityDataModel.h"

@implementation CityDataModel
+(instancetype)showCityDataWith:(NSDictionary *)dic{
    
    CityDataModel *model=[[CityDataModel alloc]init];
    NSString *string=dic[@"jobName"];
    model.jobName=string;
    model.id = dic[@"id"];
    NSArray *arrayT=[dic objectForKey:@"job"];
    NSMutableArray *data=[[NSMutableArray alloc]init];
    [arrayT enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        DistrictDataModel *teanModels=[DistrictDataModel showDistrictDataWith:obj];
        [data addObject:teanModels];
        
    }];
    model.District= data;
    
    return model;
}
@end
