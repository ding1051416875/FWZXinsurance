//
//  CameraViewController.h
//  FWZXinsurance
//
//  Created by ding on 2017/12/14.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController
@property (nonatomic, copy) void(^saveImage)(UIImage *image);
@end
