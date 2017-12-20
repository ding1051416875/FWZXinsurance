//
//  UILabel+Common.m
//  AddressPicker
//
//  Created by Sam on 2017/7/12.
//  Copyright © 2017年 http://www.jianshu.com/u/a6249cca0aaf. All rights reserved.
//

#import "UILabel+Common.h"
#import "NSString+Common.h"
@implementation UILabel (Common)

- (void)updateWidth {
    [self setWidth:[self.text getWidthWithFont:self.font constrainedToSize:CGSizeMake(kWidth, self.height)]];
}

@end
