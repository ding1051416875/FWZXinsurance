//
//  CityModel.h
//  json
//
//  Created by Bory on 2017/12/7.
//  Copyright © 2017年 Bory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

//城市名字
@property (nonatomic,copy) NSString *name;

//编号
@property (nonatomic,copy) NSString *code;

//县区列表
@property (nonatomic,strong) NSArray *cityList;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)cityModelWithDict:(NSDictionary *)dict;

@end
