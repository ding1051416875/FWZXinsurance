//
//  ProvinceModel.h
//  FWZXinsurance
//
//  Created by ding on 2017/12/27.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityModel.h"
@interface ProvinceModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic,strong) NSString *code;
@property (nonatomic, strong) NSArray<CityModel *> *city;

+(instancetype)showDataWith:(NSDictionary *)array;
@end
