//
//  WebViewController.h
//  FWZXinsurance
//
//  Created by ding on 2017/11/29.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (nonatomic,strong) NSString *urlString;
@property (nonatomic, copy) void(^backStatus)(NSString *status);
@end
