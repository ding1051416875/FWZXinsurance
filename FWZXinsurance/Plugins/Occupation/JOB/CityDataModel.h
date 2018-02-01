//
//  CityDataModel.h
//  FollowMeLearningPickerView
//
//  Created by LBS_ios1 on 2017/12/19.
//  Copyright © 2017年 http://www.jianshu.com/u/8acc5c21e350. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DistrictDataModel.h"
@interface CityDataModel : NSObject
@property(nonatomic,strong)NSString *jobName;
@property (nonatomic,strong) NSString *id;
@property (nonatomic, strong) NSArray<DistrictDataModel*> * District;

+(instancetype)showCityDataWith:(NSDictionary *)dic;

@end
