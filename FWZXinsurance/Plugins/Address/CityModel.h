//
//  CityModel.h
//  json
//
//  Created by Bory on 2017/12/7.
//  Copyright © 2017年 Bory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AreaModel.h"
@interface CityModel : NSObject

@property(nonatomic,strong)NSString *name;
@property (nonatomic,strong) NSString *code;
@property (nonatomic, strong) NSArray<AreaModel*> *District;

+(instancetype)showCityDataWith:(NSDictionary *)dic;

@end
