//
//  BankCardOverView_iPad.m
//  BankCardRecogDemo
//


#import "BankCardOverView_iPad.h"

//屏幕的宽、高
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation BankCardOverView_iPad {
    /*以下坐标点为横屏时，检边框四个顶点位置命名*/
    CGPoint ldown; //检边框左下角点
    CGPoint rdown; //检边框右下角点
    CGPoint lup; //检边框左上角点
    CGPoint rup; //检边框右上角点
    
    CGRect pointRect; //提示文字frame
    CGRect logoRect; //logo文字frame
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setRecogArea:(BOOL)isVertical {
    
    /*
     rect 为检边框的frame，检边框的位置和大小都可以随意设置，不需其他设置均可识别
     注意：检边框的宽高比例要符合银行卡实际宽高比，银行卡的 高/宽 = 1.58
     以下是demo对检边框frame的设置，仅供参考.
     */
    CGRect rect;
    CGFloat fValue = 17.0;
    if (isVertical) {//竖屏识别
        if (kScreenWidth < kScreenHeight) {//设备上下方向时
            rect = CGRectMake(80,322 , 608, 608/1.58);//以7寸ipad屏幕大小为模板设置
        } else {//设备左右方向时
            rect = CGRectMake(322, 80, 608/1.58, 608);
        }
        
    } else {//横屏识别
        if (kScreenWidth < kScreenHeight) {//设备上下方向时
            rect = CGRectMake(184, 196, 400, 400*1.58);//以7寸ipad屏幕大小为模板设置
        } else {//设备左右方向时
            rect = CGRectMake(196, 184, 632, 632/1.58);
        }
    }
   
    //pad屏幕等比例放大
    CGFloat scale;
    if (kScreenWidth < kScreenHeight) {
        scale = kScreenWidth/768.0;
    } else {
        scale = kScreenWidth/1024.0;
    }
    
    rect = CGRectMake(CGRectGetMinX(rect)*scale, CGRectGetMinY(rect)*scale, CGRectGetWidth(rect)*scale, CGRectGetHeight(rect)*scale);
    ldown = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    lup  = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    rdown = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    rup = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    self.smallrect = rect;
    
    UILabel *pointL = [[UILabel alloc] init];
    pointL.text = @"请将银行卡正面置于此区域,尝试对齐边缘";
    pointL.font = [UIFont boldSystemFontOfSize:fValue];
    pointL.textColor = [UIColor whiteColor];
    pointL.textAlignment = NSTextAlignmentCenter;
    pointL.center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    UILabel *logoL = [[UILabel alloc] init];
//    logoL.text = @"银行卡识别技术由文通科技提供";
    logoL.font = [UIFont systemFontOfSize:(fValue-2)];
    logoL.textColor = [UIColor whiteColor];
    logoL.textAlignment = NSTextAlignmentCenter;
    if (isVertical) {//竖屏识别
        if (kScreenWidth < kScreenHeight) {//设备上下方向时
            pointL.frame = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect));
            pointL.center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
            logoL.frame = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetMaxY(rect));
            logoL.center = CGPointMake(CGRectGetMidX(rect),CGRectGetMaxX(rect) + (kScreenHeight - CGRectGetMaxX(rect))/2);
        } else {
            pointL.frame = CGRectMake(0, 0, CGRectGetHeight(rect), CGRectGetWidth(rect));
            pointL.center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
            pointL.transform = CGAffineTransformMakeRotation(-M_PI_2);
            logoL.frame = CGRectMake(0, 0,CGRectGetHeight(rect) , CGRectGetWidth(rect));
            logoL.center = CGPointMake(CGRectGetMaxX(rect) + 10, CGRectGetMidY(rect));
            logoL.center = CGPointMake((kScreenWidth - CGRectGetMaxX(rect))/2 + CGRectGetMaxX(rect), CGRectGetMidY(rect));

            logoL.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }
       
    } else {//横屏识别
        if (kScreenWidth < kScreenHeight) {//设备上下方向时
            pointL.frame = CGRectMake(0, 0, CGRectGetHeight(rect), CGRectGetWidth(rect));
            pointL.center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
            pointL.transform = CGAffineTransformMakeRotation(M_PI_2);
            logoL.frame = CGRectMake(0, 0, CGRectGetHeight(rect), CGRectGetMinX(rect));
            logoL.transform = CGAffineTransformMakeRotation(M_PI_2);
            logoL.center = CGPointMake(CGRectGetMinX(rect)/2, CGRectGetMidY(rect));
        } else {//设备左右方向时
            pointL.frame = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect));
            pointL.center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
            logoL.frame = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetMaxX(rect));
            logoL.center = CGPointMake(CGRectGetMidX(rect),(CGRectGetMaxY(rect) + CGRectGetMinY(rect) / 2));
        }
        
    }
    [self addSubview:pointL];
    [self addSubview:logoL];
}


- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [[UIColor greenColor] set];
    //获得当前画布区域
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //设置线的宽度
    CGContextSetLineWidth(currentContext, 2.0f);
    
    //检边框四角宽度
    int s = 25;
    /*画线*/
    //起点--左下角
    CGContextMoveToPoint(currentContext,ldown.x, ldown.y+s);
    CGContextAddLineToPoint(currentContext, ldown.x, ldown.y);
    CGContextAddLineToPoint(currentContext, ldown.x+s, ldown.y);
    
    //右下角
    CGContextMoveToPoint(currentContext, rdown.x,rdown.y-s);
    CGContextAddLineToPoint(currentContext, rdown.x,rdown.y);
    CGContextAddLineToPoint(currentContext, rdown.x+s,rdown.y);
    
    //左上角
    CGContextMoveToPoint(currentContext, lup.x-s,lup.y);
    CGContextAddLineToPoint(currentContext, lup.x,lup.y);
    CGContextAddLineToPoint(currentContext, lup.x,lup.y+s);
    
    //右上角
    CGContextMoveToPoint(currentContext, rup.x, rup.y-s);
    CGContextAddLineToPoint(currentContext, rup.x, rup.y);
    CGContextAddLineToPoint(currentContext, rup.x-s, rup.y);
    
    //四条线
    if (!_leftHidden) {
        CGContextMoveToPoint(currentContext, ldown.x+s, ldown.y);
        CGContextAddLineToPoint(currentContext, lup.x-s,lup.y);
    }
    if (!_rightHidden) {
        CGContextMoveToPoint(currentContext, rdown.x+s,rdown.y);
        CGContextAddLineToPoint(currentContext, rup.x-s, rup.y);
    }
    
    if (!_topHidden) {
        CGContextMoveToPoint(currentContext, lup.x,lup.y+s);
        CGContextAddLineToPoint(currentContext, rup.x, rup.y-s);
    }
    if (!_bottomHidden) {
        CGContextMoveToPoint(currentContext, ldown.x, ldown.y+s);
        CGContextAddLineToPoint(currentContext, rdown.x,rdown.y-s);
    }
    CGContextStrokePath(currentContext);
}

/*
 设置四条线的显隐
 */
- (void) setTopHidden:(BOOL)topHidden
{
    if (_topHidden == topHidden) {
        return;
    }
    _topHidden = topHidden;
    [self setNeedsDisplay];
}

- (void) setLeftHidden:(BOOL)leftHidden
{
    if (_leftHidden == leftHidden) {
        return;
    }
    _leftHidden = leftHidden;
    [self setNeedsDisplay];
}

- (void) setBottomHidden:(BOOL)bottomHidden
{
    if (_bottomHidden == bottomHidden) {
        return;
    }
    _bottomHidden = bottomHidden;
    [self setNeedsDisplay];
}

- (void) setRightHidden:(BOOL)rightHidden
{
    if (_rightHidden == rightHidden) {
        return;
    }
    _rightHidden = rightHidden;
    [self setNeedsDisplay];
}


@end
