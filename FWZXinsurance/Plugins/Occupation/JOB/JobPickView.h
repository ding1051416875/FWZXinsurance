//
//  JobPickView.h
//  FWZXinsurance
//
//  Created by ding on 2017/12/27.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import <UIKit/UIKit.h>
// 屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

// 屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

typedef void(^determineBtnActionBlock)(NSString *shiName, NSString *xianName);

@interface JobPickView : UIView

@property (copy, nonatomic) determineBtnActionBlock determineBtnBlock;
- (instancetype)initWithFrame:(CGRect)frame data:(NSString *)data;
- (void)show;

- (void)dismiss;
@end
