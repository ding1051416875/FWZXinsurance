//
//  UIView+UIViewController.m
//  JPet
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 DingXiaoLei. All rights reserved.
//

#import "UIView+UIViewController.h"

@implementation UIView (UIViewController)
- (UIViewController*)getViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end
