//
//  OverView.m
//  TestCamera
//
#import "IDCardOverView_auto.h"
#import <CoreText/CoreText.h>
//屏幕的宽、高
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation IDCardOverView_auto{
    
    CGPoint _point1;
    CGPoint _point3;
    CGPoint _point4;
    CGPoint _point2;
    CGRect _sRect;
    int _isSucceed;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _sRect = CGRectMake(45, 100, 230, 363);
        if (self.bounds.size.height == 480) { //iphone4屏幕，设置检边框frame
            _sRect = CGRectMake(45, 50, 230, 363);
        }
        CGFloat scale = self.bounds.size.width/320;
        _sRect = CGRectMake(CGRectGetMinX(_sRect)*scale, CGRectGetMinY(_sRect)*scale, CGRectGetWidth(_sRect)*scale, CGRectGetHeight(_sRect)*scale);
        
    }
    return self;
}
- (CGPoint)realImageTranslateToScreenCoordinate:(CGPoint)point{
    CGFloat scale = 720.0/kScreenWidth; //720 is the width of current resolution
    //预览界面与真实图片坐标差值
    CGFloat dValue = (kScreenWidth/720*1280-kScreenHeight)*scale*0.5;
    CGPoint screenPoint = CGPointZero;
    screenPoint = CGPointMake((720-point.y)/scale,(point.x-dValue)/scale);
    return screenPoint;
}

- (void) setRecogArea:(NSDictionary *)conners{
    
    _isSucceed = [conners[@"isSucceed"] intValue];
    if (_isSucceed==1) {
        _point1 = [self realImageTranslateToScreenCoordinate:CGPointFromString([conners objectForKey:@"point1"])];
        _point2 = [self realImageTranslateToScreenCoordinate:CGPointFromString([conners objectForKey:@"point2"])];
        _point3  = [self realImageTranslateToScreenCoordinate:CGPointFromString([conners objectForKey:@"point3"])];
        _point4 = [self realImageTranslateToScreenCoordinate:CGPointFromString([conners objectForKey:@"point4"])];
    }else{
        _point1 = CGPointMake(CGRectGetMinX(_sRect), CGRectGetMinY(_sRect));
        _point2 = CGPointMake(CGRectGetMinX(_sRect), CGRectGetMaxY(_sRect));
        _point3 = CGPointMake(CGRectGetMaxX(_sRect), CGRectGetMaxY(_sRect));
        _point4  = CGPointMake(CGRectGetMaxX(_sRect), CGRectGetMinY(_sRect));
    }
    [self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [[UIColor orangeColor] set];
    //获得当前画布区域
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (_isSucceed==1) {
        //设置线的宽度
        CGContextSetLineWidth(currentContext, 2.0f);
    }else{
        //设置虚线宽度
        CGContextSetLineWidth(currentContext, 2.0f);
        //设置虚线绘制起点
        CGContextMoveToPoint(currentContext, 0, 0);
        //设置虚线绘制终点
        //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
        CGFloat arr1[] = {3,1};
        //下面最后一个参数“2”代表排列的个数。
        CGContextSetLineDash(currentContext, 0, arr1, 2);
        
    }
    CGContextMoveToPoint(currentContext, _point1.x, _point1.y);
    CGContextAddLineToPoint(currentContext, _point2.x, _point2.y);
    CGContextAddLineToPoint(currentContext, _point3.x, _point3.y);
    CGContextAddLineToPoint(currentContext, _point4.x, _point4.y);
    CGContextAddLineToPoint(currentContext, _point1.x, _point1.y);
    CGContextStrokePath(currentContext);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
