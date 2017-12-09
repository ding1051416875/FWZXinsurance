//
//  PSDrawBoarderView.h
//  PSSignDrawBoarder
//
//  Created by Vic on 2017/11/25.
//  Copyright © 2017年 Vic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSDrawBoarderView : UIView

@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, copy) void(^saveImage)(UIImage *image);
@property (nonatomic, copy) void(^back)(NSString *title);

@end
