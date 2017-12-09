//
//  SignDrawViewController.h
//  FWZXinsurance
//
//  Created by ding on 2017/11/30.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignDrawViewController : UIViewController
@property (nonatomic, copy) void(^backImage)(UIImage *image, BOOL isSuccess);

@end
