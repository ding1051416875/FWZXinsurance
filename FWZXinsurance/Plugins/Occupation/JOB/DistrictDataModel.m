//
//  DistrictDataModel.m
//  FollowMeLearningPickerView
//
//  Created by LBS_ios1 on 2017/12/19.
//  Copyright © 2017年 http://www.jianshu.com/u/8acc5c21e350. All rights reserved.
//

#import "DistrictDataModel.h"

@implementation DistrictDataModel
+(instancetype)showDistrictDataWith:(NSDictionary *)dic
{
    DistrictDataModel *model=[[DistrictDataModel alloc]init];
    NSString *string=dic[@"jobName"];
    
    model.jobName=string;
    model.jobCode = dic[@"jobCode"];
    
    return model;
    
    
}
@end
