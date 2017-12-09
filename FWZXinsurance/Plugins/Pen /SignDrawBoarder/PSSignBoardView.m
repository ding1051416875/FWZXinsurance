//
//  PSSignBoardView.m
//  PSSignDrawBoarder
//
//  Created by Vic on 2017/11/25.
//  Copyright © 2017年 Vic. All rights reserved.
//

#import "PSSignBoardView.h"
#import "PSDataManager.h"

@interface PSSignBoardView ()
{
    PSDataManager *dataManager;
}
@property (nonatomic, strong) UIBezierPath *bPath;
@property (nonatomic, strong) CAShapeLayer *sLayer;

@end

@implementation PSSignBoardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        dataManager = [PSDataManager sharedManager];
        if (dataManager.strokeArray.count > 0) {
            for (NSInteger i = 0; i < dataManager.strokeArray.count; i++) {
                [self.layer addSublayer:dataManager.strokeArray[i]];
            }
        }
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint startP = [self pointWithTouches:touches];
    if (startP.x < 0) {
        return;
    }
    
    if ([event allTouches].count == 1) {
        UIBezierPath *path = [self paintPathWithLinePoint:startP];
        _bPath = path;
        
        CAShapeLayer *slayer = [CAShapeLayer layer];
        slayer.path = path.CGPath;
        slayer.fillColor = [UIColor clearColor].CGColor;
        slayer.lineCap = kCALineCapRound;
        slayer.lineJoin = kCALineJoinRound;
        slayer.strokeColor = [UIColor blackColor].CGColor;
        slayer.lineWidth = path.lineWidth;
        [self.layer addSublayer:slayer];
        _sLayer = slayer;
        [dataManager.strokeArray addObject:_sLayer];
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint moveP = [self pointWithTouches:touches];
    if (moveP.x < 0) {
        return;
    }
    
    if ([event allTouches].count > 1) {
        [self.superview touchesMoved:touches withEvent:event];
    } else if ([event allTouches].count == 1) {
        [_bPath addLineToPoint:moveP];
        _sLayer.path = _bPath.CGPath;
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([event allTouches].count > 1) {
        [self.superview touchesMoved:touches withEvent:event];
    }
}

// 划线
- (void)drawLine {
    if (!dataManager.strokeArray.count) {
        return;
    }
    [self.layer addSublayer:dataManager.strokeArray.lastObject];
}

// 清屏
- (void)clearScreen {
    if (!dataManager.strokeArray.count) {
        return;
    }
    [dataManager.strokeArray makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [dataManager.strokeArray removeAllObjects];
}

// 根据touches获取对应的触摸点
- (CGPoint)pointWithTouches:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (point.x <= 0 || point.x >= (WIDTH - 20) || point.y <= 0 || point.y >= kHeight) {
        CGPoint p = {-1, 0};
        return p;
    } else {
        return point;
    }
}

- (UIBezierPath *)paintPathWithLinePoint:(CGPoint)startP {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth = self.lineWidth ? self.lineWidth : 5;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [path moveToPoint:startP];
    return path;
}

@end
