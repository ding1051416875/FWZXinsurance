//
//  DistrictDataModel.h
//  FollowMeLearningPickerView
//
//  Created by LBS_ios1 on 2017/12/19.
//  Copyright © 2017年 http://www.jianshu.com/u/8acc5c21e350. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DistrictDataModel : NSObject
@property(nonatomic,strong)NSString *jobName;
@property (nonatomic,strong) NSString *jobCode;
+(instancetype)showDistrictDataWith:(NSDictionary *)dic;

@end
