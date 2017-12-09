//
//  BaseHttpTool.h
//  TJProperty
//
//  Created by Remmo on 15/6/24.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseHttpTool : NSObject

/**
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

+ (void)uploadImageWithPath:(NSString *)netPath name:(NSString *)name imagePathList:(NSArray *)imageList params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

+ (void)uploadImageWithPath:(NSString *)url indexName:(NSString *)name imagePathList:(NSArray *)imageList params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

+ (void)uploadImageWithPath:(NSString *)url indexName:(NSString *)name imagePathList:(NSArray *)imageList TypeName:(NSString *)typeName TypeImageList:(NSArray *)typeImageList params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

+ (void)uploadFileWithPath:(NSString *)url indexName:(NSString *)name fileData:(NSData *)fileData params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

@end
