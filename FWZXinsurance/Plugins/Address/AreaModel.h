//
//  AreaModel.h
//  json
//
//  Created by Bory on 2017/12/7.
//  Copyright © 2017年 Bory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaModel : NSObject

@property(nonatomic,strong)NSString *name;
@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSString *postCode;
+(instancetype)showDistrictDataWith:(NSDictionary *)dic;
@end
