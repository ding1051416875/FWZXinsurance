//
//  BankCardOverView_iPad.h
//  BankCardRecogDemo
//


#import <UIKit/UIKit.h>

@interface BankCardOverView_iPad : UIView
@property (assign, nonatomic) BOOL leftHidden;
@property (assign, nonatomic) BOOL rightHidden;
@property (assign, nonatomic) BOOL topHidden;
@property (assign, nonatomic) BOOL bottomHidden;

@property (assign ,nonatomic) CGRect smallrect;
// 设置识别区域 YES:竖屏 NO:横屏
- (void)setRecogArea:(BOOL)isVertical;
@end
