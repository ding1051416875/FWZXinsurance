//
//  AreaModel.h
//  json
//
//  Created by Bory on 2017/12/7.
//  Copyright © 2017年 Bory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaModel : NSObject

//县区名字
@property (nonatomic,copy) NSString *name;

//编号
@property (nonatomic,copy) NSString *code;

//区列表
@property (nonatomic,strong) NSArray *areaList;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)areaModelWithDict:(NSDictionary *)dict;

@end
