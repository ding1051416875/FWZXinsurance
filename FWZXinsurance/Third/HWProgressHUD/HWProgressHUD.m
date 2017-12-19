//
//  HWProgressHUD.m
//  HWProgressHUD
//
//  Created by sxmaps_w on 2017/4/21.
//  Copyright © 2017年 wqb. All rights reserved.
//

#import "HWProgressHUD.h"

#define KPLabelMaxW 240.0f
#define KPLabelMaxH 300.0f
#define KDefaultDuration 2.0f
#define KMainW [UIScreen mainScreen].bounds.size.width
#define KMainH [UIScreen mainScreen].bounds.size.height

@interface HWProgressHUD ()

@property (nonatomic, strong) UIWindow *pWindow;
@property (nonatomic, weak) UILabel *pLabel;
@property (nonatomic, weak) UIImageView *pImageView;
@property (nonatomic, weak) UIView *backView;

@end

@implementation HWProgressHUD

+ (HWProgressHUD *)sharedView
{
    static HWProgressHUD *sharedView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedView = [[HWProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    
    return sharedView;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

+ (void)show
{
    [[HWProgressHUD sharedView] showWithMessage:nil duration:KDefaultDuration pushing:NO];
}

+ (void)showWhilePushing
{
    [[HWProgressHUD sharedView] showWithMessage:nil duration:KDefaultDuration pushing:YES];
}

+ (void)showWhilePushing:(BOOL)pushing
{
    [[HWProgressHUD sharedView] showWithMessage:nil duration:KDefaultDuration pushing:pushing];
}

+ (void)showMessage:(NSString *)message
{
    [[HWProgressHUD sharedView] showWithMessage:message duration:KDefaultDuration pushing:nil];
}

+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration
{
    [[HWProgressHUD sharedView] showWithMessage:message duration:duration pushing:nil];
}

+ (void)dismiss
{
    [[HWProgressHUD sharedView] dismiss];
}

- (void)showWithMessage:(NSString *)message duration:(NSTimeInterval)duration pushing:(BOOL)pushing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.superview) [self.pWindow addSubview:self];
        [self.pWindow makeKeyAndVisible];
        if (message) {
            if (_pImageView) {
                _pImageView.hidden = YES;
                [self stopLoadingAnimation];
            }
            
            self.pLabel.text = message;
            CGSize stringSize = [message boundingRectWithSize:CGSizeMake(KPLabelMaxW, KPLabelMaxH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_pLabel.font} context:nil].size;

            _pLabel.frame = CGRectMake(20, 20, stringSize.width, stringSize.height);
//            _backView.frame = CGRectMake((KMainW - stringSize.width) * 0.5 - 20, (KMainH - stringSize.height) * 0.5 - 20, stringSize.width + 40, stringSize.height + 40);
//            _backView.frame = CGRectMake(KMainW/2-, kHeight/2-, <#CGFloat width#>, <#CGFloat height#>)
            _backView.center = self.center;
            
            [UIView animateWithDuration:0.2f animations:^{
                _backView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((duration - 0.4) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.2f animations:^{
                        _backView.alpha = 0.0f;
                    } completion:^(BOOL finished) {
                        [self dismiss];
                    }];
                });
            }];
//            _pWindow.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }else {
            self.pImageView.hidden = NO;
            
            CGFloat imgViewW = pushing ? 200 : 60;
            _pImageView.backgroundColor = pushing ? [UIColor clearColor] : [[UIColor blackColor] colorWithAlphaComponent:0.7f];
            _pImageView.frame = CGRectMake((KMainW - imgViewW) * 0.5, (KMainH - imgViewW) * 0.5, imgViewW, imgViewW);
            
            if (pushing) {
                [self startPushingLoadingAnimation];
            }else {
                [self startLoadingAnimation];
            }
        }
    });
}

//转圈加载动画
- (void)startLoadingAnimation
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 8; i++) {
        NSString *imageName = [NSString stringWithFormat:@"com_loading%02d", i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        [array addObject:image];
    }
    
    [_pImageView setAnimationImages:array];
    [_pImageView setAnimationDuration:0.6f];
    [_pImageView startAnimating];
}

//空页面加载动画
- (void)startPushingLoadingAnimation
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading_img%02d.jpg", i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        [array addObject:image];
    }
    
    [_pImageView setAnimationImages:array];
    [_pImageView setAnimationDuration:0.4f];
    [_pImageView startAnimating];
}

- (void)stopLoadingAnimation
{
    [_pImageView stopAnimating];
    [_pImageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:0];
}

- (void)dismiss
{
    [self stopLoadingAnimation];
    
    NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
    [windows removeObject:_pWindow];
    _pWindow = nil;
}

- (UIWindow *)pWindow
{
    if (!_pWindow) {
        _pWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    
    return _pWindow;
}

- (UILabel *)pLabel
{
    if (!_pLabel) {
        UILabel *pLabel = [[UILabel alloc] init];
        pLabel.textColor = [UIColor whiteColor];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textAlignment = NSTextAlignmentCenter;
        pLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        pLabel.numberOfLines = 0;
        [self.backView addSubview:pLabel];
        _pLabel = pLabel;
    }
    
    return _pLabel;
}

- (UIView *)backView
{
    if (!_backView) {
        UIView *backView = [[UIView alloc] init];
        backView.alpha = 0.f;
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        backView.layer.cornerRadius = 3.f;
        backView.layer.masksToBounds = YES;
        [self addSubview:backView];
        _backView = backView;
    }
    
    return _backView;
}

- (UIImageView *)pImageView
{
    if (!_pImageView) {
        UIImageView *pImageView = [[UIImageView alloc] init];
        pImageView.hidden = YES;
        pImageView.layer.cornerRadius = 3.f;
        pImageView.layer.masksToBounds = YES;
        [self addSubview:pImageView];
        _pImageView = pImageView;
    }
    
    return _pImageView;
}

@end
