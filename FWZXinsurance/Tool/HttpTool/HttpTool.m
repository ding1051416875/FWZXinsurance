//
//  HttpTool.m
//  TJProperty
//
//  Created by Remmo on 15/6/24.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "HttpTool.h"
#import "BaseHttpTool.h"
//#import "NSString+Hash.h"

//static NSString *const bocKey = @"fqqbocweb";

@implementation HttpTool

/**
 * get请求
 */
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    // 拼接参数
    NSDictionary *allParams = [self jointParamsWithDict:params];
    
//     拼接url
    NSString *netPath = [NSString stringWithFormat:@"%@%@",kHostAdress,path];
    // 拼接url
//    NSString *netPath = [NSString stringWithFormat:@"%@",kHostAdress];
    [BaseHttpTool get:netPath params:allParams success:success failure:failure];
}

/**
 * POST请求
 */
+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *allParams = [self jointParamsWithDict:params];
    NSString *netPath = [NSString stringWithFormat:@"%@%@",kHostAdress,path];
    [BaseHttpTool post:netPath params:allParams success:success failure:failure];
}

/**
 * post请求，加图片上传
 */
+ (void)postWithPath:(NSString *)path name:(NSString *)name imagePathList:(NSArray *)imageList params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *allParams = [self jointParamsWithDict:params];
    NSString *netPath = [NSString stringWithFormat:@"%@/%@",kHostAdress,path];
    if (imageList == nil || imageList.count == 0) {
        [BaseHttpTool post:netPath params:params success:success failure:failure];
    }else{
        [BaseHttpTool uploadImageWithPath:netPath name:(NSString *)name imagePathList:imageList params:allParams success:success failure:failure];
    }
}

/**
 * post请求，多张图片上传
 */
+ (void)postWithPath:(NSString *)path indexName:(NSString *)name imagePathList:(NSArray *)imageList params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *allParams = [self jointParamsWithDict:params];
    NSString *netPath = [NSString stringWithFormat:@"%@/%@",kHostAdress,path];
    if (imageList == nil || imageList.count == 0) {
        [BaseHttpTool post:netPath params:params success:success failure:failure];
    }else{
        [BaseHttpTool uploadImageWithPath:netPath indexName:(NSString *)name imagePathList:imageList params:allParams success:success failure:failure];
    }
}

//发布房源2组图片参数
+ (void)postWithPath:(NSString *)path indexName:(NSString *)name imagePathList:(NSArray *)imageList TypeName:(NSString *)typeName TypeImageList:(NSArray *)typeImageList params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *allParams = [self jointParamsWithDict:params];
    NSString *netPath = [NSString stringWithFormat:@"%@/%@",kHostAdress,path];
    if ((imageList == nil || imageList.count == 0) && (typeImageList == nil || typeImageList.count == 0)) {
        [BaseHttpTool post:netPath params:params success:success failure:failure];
    }else{
        [BaseHttpTool uploadImageWithPath:netPath indexName:name imagePathList:imageList TypeName:typeName TypeImageList:typeImageList params:allParams success:success failure:failure];
    }
}

//文件上传
+ (void)postWithPath:(NSString *)path indexName:(NSString *)name fileData:(NSData *)fileData params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *allParams = [self jointParamsWithDict:params];
    NSString *netPath = [NSString stringWithFormat:@"%@/%@",kHostAdress,path];
    if (fileData == nil || fileData == NULL) {
        [BaseHttpTool post:netPath params:params success:success failure:failure];
    }else{
        [BaseHttpTool uploadFileWithPath:netPath indexName:name fileData:fileData params:allParams success:success failure:failure];
    }
}

+ (NSDictionary *)jointParamsWithDict:(NSDictionary *)params
{
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:params];
//    NSDate *date = [NSDate date];
//    NSTimeInterval interval = [date timeIntervalSince1970];
//    NSString *intervalString = [NSString stringWithFormat:@"%.f",interval];
//    [allParams setObject:intervalString forKey:@"timestrap"];
//    [allParams setObject:kAppVersion forKey:@"version"];
    
    
    
//    NSDate *date = [NSDate date];
//    NSTimeInterval interval = [date timeIntervalSince1970];
//    NSString *intervalString = [NSString stringWithFormat:@"%.f",interval];
//    [allParams setObject:intervalString forKey:@"timeline"];
//    // 拼接sign参数
//    NSString *joinStr = @"";
//    
//    joinStr = [intervalString stringByAppendingString:BocKey];
//    //MyLog(@"joinStr --- %@", joinStr);
//    NSString *md5SignString = [NSString md5:joinStr];
//    //MyLog(@"md5 string --- %@", md5SignString);
//    
//    [allParams setObject:md5SignString forKey:@"sign"];
//    
    return allParams;

}


@end
