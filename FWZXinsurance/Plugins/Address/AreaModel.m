//
//  AreaModel.m
//  json
//
//  Created by Bory on 2017/12/7.
//  Copyright © 2017年 Bory. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel

+(instancetype)showDistrictDataWith:(NSDictionary *)dic
{
    AreaModel *model=[[AreaModel alloc]init];
    NSString *string=dic[@"name"];
    model.name=string;
    model.code = dic[@"code"];
    model.postCode = dic[@"postCode"];
    
    return model;
    
}
@end
