//
//  Model.h
//  json
//
//  Created by Bory on 2017/12/7.
//  Copyright © 2017年 Bory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

//名字
@property (nonatomic,copy) NSString *name;

//编号
@property (nonatomic,copy) NSString *code;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)modelWithDict:(NSDictionary *)dict;



@end
