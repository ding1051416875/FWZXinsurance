//
//  NSString+Size.m
//  JPet
//
//  Created by apple on 2017/5/10.
//  Copyright © 2017年 DingXiaoLei. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
