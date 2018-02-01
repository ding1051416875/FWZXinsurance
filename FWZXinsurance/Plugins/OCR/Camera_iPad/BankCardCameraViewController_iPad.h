//
//  BankCardCameraViewController_iPad.h
//  BankCardRecogDemo
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMedia/CoreMedia.h>


@interface BankCardCameraViewController_iPad : UIViewController
// isVertical YES:竖屏  NO:横屏
@property (assign,nonatomic) BOOL isVertical;

@property (nonatomic, copy) void(^backBankcard)(NSMutableDictionary *dict,BOOL isSuccess);
@end
