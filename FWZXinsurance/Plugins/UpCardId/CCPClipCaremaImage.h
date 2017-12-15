//
//  CCPClipCaremaImage.h
//  QHPay
//
//  Created by liqunfei on 16/3/15.
//  Copyright © 2016年 chenlizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CCPClipCaremaImage : UIView
- (void)startCamera;
- (void)stopCamera;
- (void)takePhotoWithCommit:(void (^)(UIImage *image))commitBlock;
- (BOOL)isOpenFlash;
@end
