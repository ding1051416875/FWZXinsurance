//
//  OverView.m
//  TestCamera
//
#import "IDCardOverView.h"
#import <CoreText/CoreText.h>

//屏幕的宽、高
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


@implementation IDCardOverView{
    
    CGPoint ldown;
    CGPoint rdown;
    CGPoint lup;
    CGPoint rup;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void) setRecogArea
{
    
    /*
     sRect 为检边框的frame，用户可以自定义设置
     注意：1.检边框的宽高比例要符合证件实际宽高比：高/宽 = 1.58； 护照宽高比：高/宽 = 1.43
          2.以下是demo对检边框frame的设置，仅供参考.
     */
    CGRect sRect;
    CGFloat cardScale = 1.58;   //证件类型宽高比 高/宽 = 1.58； 护照宽高比：高/宽 = 1.43 机读码：宽/高=4;
    if (_mrz) {                 //机读码
        cardScale = 4;
    }
    CGFloat tempWidth;          //检边区域宽
    CGFloat tempHeight;         //检边区域高
    CGFloat tempScale;          //检边区域宽是当前屏幕宽的缩放比例
    
    
    if (_isHorizontal) {        //横屏识别设置检边框frame
        if (_mrz) {             //机读码
            tempScale = 0.3;
            if (IS_IPAD) {      //ipad 单独适配下
                tempScale = 0.2;
            }
        }else{                  //非机读码
            tempScale = 0.7;
            if (IS_IPAD) {
                tempScale = 0.6;
            }
        }
                                //应用方向支持旋转时，宽高互换
        if (kScreenWidth < kScreenHeight) {
            tempWidth = kScreenWidth*tempScale;
            tempHeight = kScreenWidth*tempScale*cardScale;
        }else{
            tempWidth = kScreenHeight*tempScale*cardScale;
            tempHeight = kScreenHeight*tempScale;
        }
    }else{                      //竖屏识别设置检边框frame
                                //应用方向支持旋转时，宽高互换
        tempScale = 0.8;
        if (IS_IPAD) {
            tempScale = 0.7;
        }
        if (kScreenWidth < kScreenHeight) {
            tempWidth = kScreenWidth*tempScale;
            tempHeight = kScreenWidth*tempScale/cardScale;
        }else{
            tempWidth = kScreenHeight*tempScale/cardScale;
            tempHeight = kScreenHeight*tempScale;
        }
    }
    
    
    sRect = CGRectMake((kScreenWidth-tempWidth)*0.5, (kScreenHeight-tempHeight)*0.5, tempWidth,tempHeight);
    ldown = CGPointMake(CGRectGetMinX(sRect), CGRectGetMinY(sRect));
    lup  = CGPointMake(CGRectGetMaxX(sRect), CGRectGetMinY(sRect));
    rdown = CGPointMake(CGRectGetMinX(sRect), CGRectGetMaxY(sRect));
    rup = CGPointMake(CGRectGetMaxX(sRect), CGRectGetMaxY(sRect));
    self.smallrect = sRect;
    //设置机读码检边区域
    self.mrzSmallRect = sRect;

}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [[UIColor orangeColor] set];
    //获得当前画布区域
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //设置线的宽度
    CGContextSetLineWidth(currentContext, 2.0f);
    
    //mrz边框
    if (_mrz) {
        CGContextMoveToPoint(currentContext, CGRectGetMinX(self.mrzSmallRect), CGRectGetMinY(self.mrzSmallRect));
        CGContextAddLineToPoint(currentContext, CGRectGetMaxX(self.mrzSmallRect), CGRectGetMinY(self.mrzSmallRect));
        CGContextAddLineToPoint(currentContext, CGRectGetMaxX(self.mrzSmallRect), CGRectGetMaxY(self.mrzSmallRect));
        CGContextAddLineToPoint(currentContext, CGRectGetMinX(self.mrzSmallRect), CGRectGetMaxY(self.mrzSmallRect));
        CGContextAddLineToPoint(currentContext, CGRectGetMinX(self.mrzSmallRect), CGRectGetMinY(self.mrzSmallRect));
        
    }else{
        /*画线*/
        //起点--左下角
        int s = 25;
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
        if (_leftHidden) {
            CGContextMoveToPoint(currentContext, ldown.x+s, ldown.y);
            CGContextAddLineToPoint(currentContext, lup.x-s,lup.y);
        }
        if (_rightHidden) {
            CGContextMoveToPoint(currentContext, rdown.x+s,rdown.y);
            CGContextAddLineToPoint(currentContext, rup.x-s, rup.y);
        }
        
        if (_topHidden) {
            CGContextMoveToPoint(currentContext, lup.x,lup.y+s);
            CGContextAddLineToPoint(currentContext, rup.x, rup.y-s);
        }
        if (_bottomHidden) {
            CGContextMoveToPoint(currentContext, ldown.x, ldown.y+s);
            CGContextAddLineToPoint(currentContext, rdown.x,rdown.y-s);
        }
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

//设置mrz边框
- (void) setMRZBolder
{
    [self setNeedsDisplay];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
