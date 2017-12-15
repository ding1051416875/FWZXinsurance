//
//  QCode.m
//  FWZXinsurance
//
//  Created by 丁晓雷 on 2017/11/24.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "QCode.h"
#import "QRCodeGenerator.h"
#import "SDPhotoBrowser.h"
#import "CodeViewController.h"
#import "GTMBase64.h"
@interface QCode ()<SDPhotoBrowserDelegate>
@property (nonatomic,strong) UIImage *codeImage;


@end
@implementation QCode
- (void)saveCode:(CDVInvokedUrlCommand *)command
{
    //获取js传过来的值
//    CDVPluginResult *result=nil;
    NSString *code=[NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:0]];
    if([Check isEmptyString:code])
    {
        [ProgressHUD showError:@"传入数据为空"];
        return;
    }
    //转换 二维码图片
    _codeImage = [QRCodeGenerator qrImageForString:code imageSize:300];
//    CodeViewController *codeview = [[CodeViewController alloc] init];
//    codeview.codeImage = _codeImage;
//    [self.viewController presentViewController:codeview animated:YES completion:nil];
    
//    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
//    browser.backgroundColor = kColor_White;
//    NSInteger index = 0;
//    browser.currentImageIndex =index;
//    browser.sourceImagesContainerView = self.viewController.view;
//    browser.imageCount = 1;
//    browser.delegate = self;
//    [browser show];
    NSData *imageData = UIImageJPEGRepresentation(_codeImage,1.0);
    NSString *image =[NSString stringWithFormat:@"data:image/png;base64,%@",[GTMBase64 stringByEncodingData:imageData]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    CDVPluginResult *result=nil;
    if(code)
    {
        [dict setObject:@"1" forKey:@"result_code"];
        [dict setObject:@"加载成功" forKey:@"result_msg"];
        [dict setObject:image forKey:@"result_img"];
        result =[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }else{
        [dict setObject:@"0" forKey:@"result_code"];
        [dict setObject:@"加载失败" forKey:@"result_msg"];
        result=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
    
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = [self UIImageToBase64Str:_codeImage];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}
-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

//- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageForIndex:(NSInteger)index
//{
//    return _codeImage;
//}


-(UIImage *)Base64StrToUIImage:(NSString *)encodedImageStr
{
    NSData  *decodedImageData   = [[NSData alloc] initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *decodedImage      = [UIImage imageWithData:decodedImageData ];
    return decodedImage;
}
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [self Base64StrToUIImage:@"ffffff"];
    
    return _codeImage;
}


@end
