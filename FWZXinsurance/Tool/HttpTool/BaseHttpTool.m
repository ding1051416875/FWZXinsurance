//
//  BaseHttpTool.m
//  TJProperty
//
//  Created by Remmo on 15/6/24.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "BaseHttpTool.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
@implementation BaseHttpTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // 1.获得请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript", nil];
//    // 2.发送GET请求
//    [mgr GET:url parameters:params
//     success:^(AFHTTPRequestOperation *operation, id responseObj) {
//         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//         MyLog(@"url %@--- %@",url, responseObj);
//         if (success) {
//             success(responseObj);
//         }
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//         [ProgressHUD showError:@"网络不给力"];
//         if (failure) {
//             failure(error);
//             MyLog(@"error --- %@", error);
//         }
//     }];
//    
    AFHTTPSessionManager  *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        SDLog(@"url %@--- %@",url, responseObject);
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [ProgressHUD showError:@"网络不给力"];
        if (failure) {
            failure(error);
            SDLog(@"error --- %@", error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    // 1.获得请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript", nil];
//    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
//    // 2.发送POST请求
//    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        MyLog(@"url %@--- %@",url, responseObj);
//        if (success) {
//            success(responseObj);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        
//        if (failure) {
//            failure(error);
//            MyLog(@"error --- %@", error);
//            [ProgressHUD showError:@"网络不给力"];
//        }
//    }];
    AFHTTPSessionManager *manager= [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
 
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
  
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        SDLog(@"url %@--- %@",url, responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (failure) {
            failure(error);
        }
        
    }];
}

+ (void)uploadImageWithPath:(NSString *)url name:(NSString *)name imagePathList:(NSArray *)imageList params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript", nil];
//    
//    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        for (int index=0; index<imageList.count; index++) {
//            UIImage * image=[imageList objectAtIndex:index];
//            NSData * imageData=UIImageJPEGRepresentation(image, 0.8);
//            NSString * fileName=[NSString stringWithFormat:@"img%d.jpg",index];
//            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpg/file"];
//        }
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        MyLog(@"url %@--- %@",url, responseObject);
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
  
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", @"text/javascript", nil];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                for (int index=0; index<imageList.count; index++) {
                    UIImage * image=[imageList objectAtIndex:index];
                    NSData * imageData=UIImageJPEGRepresentation(image, 0.2);
                    NSString * fileName=[NSString stringWithFormat:@"img%d.jpg",index];
                    [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpg/file"];
                }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                SDLog(@"url %@--- %@",url, responseObject);
                if (success) {
                    success(responseObject);
                }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
    }];
}

+ (void)uploadImageWithPath:(NSString *)url indexName:(NSString *)name imagePathList:(NSArray *)imageList params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript", nil];
//    
//    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        for (int index=0; index<imageList.count; index++) {
//            NSString * indexName=[NSString stringWithFormat:@"%@%zd",name,index+1];
//            UIImage * image=[imageList objectAtIndex:index];
////            NSData * imageData=UIImagePNGRepresentation(image);
//            //NSData * imageData=UIImageJPEGRepresentation(image, 0.5);
//            CGSize imageSize = image.size;
//            CGFloat imageW = 300 * 2;
//            CGFloat imageH = imageW * imageSize.height / imageSize.width;
//            UIImage *newImage = [image imageWithImageSimple:image scaledToSize:CGSizeMake(imageW, imageH)];
//            NSData * imageData=UIImageJPEGRepresentation(newImage, 0.8);
//            NSString * fileName=[NSString stringWithFormat:@"img%d.jpg",index+1];
//            [formData appendPartWithFileData:imageData name:indexName fileName:fileName mimeType:@"image/jpg/file"];
//        }
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        MyLog(@"url %@--- %@",url, responseObject);
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int index=0; index<imageList.count; index++) {
            NSString * indexName=[NSString stringWithFormat:@"%@%zd",name,index+1];
            UIImage * image=[imageList objectAtIndex:index];
            //            NSData * imageData=UIImagePNGRepresentation(image);
            //NSData * imageData=UIImageJPEGRepresentation(image, 0.5);
            CGSize imageSize = image.size;
            CGFloat imageW = 300 * 2;
            CGFloat imageH = imageW * imageSize.height / imageSize.width;
            UIImage *newImage = [image imageWithImageSimple:image scaledToSize:CGSizeMake(imageW, imageH)];
            NSData * imageData=UIImageJPEGRepresentation(newImage, 0.8);
            NSString * fileName=[NSString stringWithFormat:@"img%d.jpg",index+1];
            [formData appendPartWithFileData:imageData name:indexName fileName:fileName mimeType:@"image/jpg/file"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SDLog(@"url %@--- %@",url, responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)uploadImageWithPath:(NSString *)url indexName:(NSString *)name imagePathList:(NSArray *)imageList TypeName:(NSString *)typeName TypeImageList:(NSArray *)typeImageList params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript", nil];
//    
//    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        for (int index=0; index<imageList.count; index++) {
//            NSString * indexName=[NSString stringWithFormat:@"%@%zd",name,index+1];
//            UIImage * image=[imageList objectAtIndex:index];
//            //            NSData * imageData=UIImagePNGRepresentation(image);
//            CGSize imageSize = image.size;
//            CGFloat imageW = 300 * 2;
//            CGFloat imageH = imageW * imageSize.height / imageSize.width;
//            UIImage *newImage = [image imageWithImageSimple:image scaledToSize:CGSizeMake(imageW, imageH)];
//            NSData * imageData=UIImageJPEGRepresentation(newImage, 0.8);
//            NSString * fileName=[NSString stringWithFormat:@"img%d.jpg",index+1];
//            [formData appendPartWithFileData:imageData name:indexName fileName:fileName mimeType:@"image/jpg/file"];
//        }
//        for (int index=0; index<typeImageList.count; index++) {
//            NSString * indexName=[NSString stringWithFormat:@"%@%zd",typeName,index+1];
//            UIImage * image=[typeImageList objectAtIndex:index];
//            //            NSData * imageData=UIImagePNGRepresentation(image);
//            CGSize imageSize = image.size;
//            CGFloat imageW = 300 * 2;
//            CGFloat imageH = imageW * imageSize.height / imageSize.width;
//            UIImage *newImage = [image imageWithImageSimple:image scaledToSize:CGSizeMake(imageW, imageH)];
//            NSData * imageData=UIImageJPEGRepresentation(newImage, 0.8);
//            NSString * fileName=[NSString stringWithFormat:@"typeImg%d.jpg",index+1];
//            [formData appendPartWithFileData:imageData name:indexName fileName:fileName mimeType:@"image/jpg/file"];
//        }
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        MyLog(@"url %@--- %@",url, responseObject);
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript", nil];
    manager.requestSerializer.timeoutInterval = 10;
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int index=0; index<imageList.count; index++) {
            NSString * indexName=[NSString stringWithFormat:@"%@%zd",name,index+1];
            UIImage * image=[imageList objectAtIndex:index];
            //            NSData * imageData=UIImagePNGRepresentation(image);
            CGSize imageSize = image.size;
            CGFloat imageW = 300 * 2;
            CGFloat imageH = imageW * imageSize.height / imageSize.width;
            UIImage *newImage = [image imageWithImageSimple:image scaledToSize:CGSizeMake(imageW, imageH)];
            NSData * imageData=UIImageJPEGRepresentation(newImage, 0.8);
            NSString * fileName=[NSString stringWithFormat:@"img%d.jpg",index+1];
            [formData appendPartWithFileData:imageData name:indexName fileName:fileName mimeType:@"image/jpg/file"];
        }
        for (int index=0; index<typeImageList.count; index++) {
            NSString * indexName=[NSString stringWithFormat:@"%@%zd",typeName,index+1];
            UIImage * image=[typeImageList objectAtIndex:index];
            //            NSData * imageData=UIImagePNGRepresentation(image);
            CGSize imageSize = image.size;
            CGFloat imageW = 300 * 2;
            CGFloat imageH = imageW * imageSize.height / imageSize.width;
            UIImage *newImage = [image imageWithImageSimple:image scaledToSize:CGSizeMake(imageW, imageH)];
            NSData * imageData=UIImageJPEGRepresentation(newImage, 0.8);
            NSString * fileName=[NSString stringWithFormat:@"typeImg%d.jpg",index+1];
            [formData appendPartWithFileData:imageData name:indexName fileName:fileName mimeType:@"image/jpg/file"];
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SDLog(@"url %@--- %@",url, responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

+ (void)uploadFileWithPath:(NSString *)url indexName:(NSString *)name fileData:(NSData *)fileData params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript", nil];
//    
//    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        NSString * fileName = @"video1.mp4";
//        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:@"video/quicktime"];
//    
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        MyLog(@"url %@--- %@",url, responseObject);
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        [MBProgressHUD showError:@"网络不给力"];
//        if (failure) {
//            failure(error);
//            MyLog(@"error --- %@", error);
//        }
//    }];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript", nil];
    manager.requestSerializer.timeoutInterval = 10;
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString * fileName = @"video1.mp4";
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:@"video/quicktime"];
       
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SDLog(@"url %@--- %@",url, responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"网络不给力"];
        if (failure) {
            failure(error);
            SDLog(@"error --- %@", error);
        }
    }];

}

@end
