//
//  NSString+Size.h
//  JPet
//
//  Created by apple on 2017/5/10.
//  Copyright © 2017年 DingXiaoLei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
@end
