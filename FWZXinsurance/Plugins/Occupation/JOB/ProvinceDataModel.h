//
//  ProvinceDataModel.h
//  FollowMeLearningPickerView
//
//  Created by LBS_ios1 on 2017/12/19.
//  Copyright © 2017年 http://www.jianshu.com/u/8acc5c21e350. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityDataModel.h"

@interface ProvinceDataModel : NSObject
@property (nonatomic, copy) NSString *jobName;
@property (nonatomic,strong) NSString *id;
@property (nonatomic, strong) NSArray<CityDataModel *> *city;

+(instancetype)showDataWith:(NSDictionary *)array;

@end
