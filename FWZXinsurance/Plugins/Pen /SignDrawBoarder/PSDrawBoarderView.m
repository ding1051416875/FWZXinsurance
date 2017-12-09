//
//  PSDrawBoarderView.m
//  PSSignDrawBoarder
//
//  Created by Vic on 2017/11/25.
//  Copyright © 2017年 Vic. All rights reserved.
//

#import "PSDrawBoarderView.h"
#import "PSSignBoardView.h"
#import "PSDataManager.h"

@interface PSDrawBoarderView ()
{
    PSSignBoardView *myDrawer;
}

@end

@implementation PSDrawBoarderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0 ,kHeight-100, WIDTH, 60)];
//        [self addSubview:toolView];
       
        myDrawer = [[PSSignBoardView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        myDrawer.center = self.center;
//        myDrawer.backgroundColor = kColor_Red;
        myDrawer.userInteractionEnabled = YES;
        myDrawer.multipleTouchEnabled = YES;
        myDrawer.lineWidth = self.lineWidth;
        myDrawer.layer.backgroundColor = kColor_White.CGColor;
        [self addSubview:myDrawer];
        UIButton *backBtn = [Maker makeBtn:CGRectMake(20, 40, 50, 50) title:@"" img:@"back" font:kFont_Lable_14 target:self action:@selector(back:)];
        [self addSubview:backBtn];
        NSArray *array = @[@"pen_clear", @"pen_save"];
        for (NSInteger i = 0; i <array.count; i++) {
            CGFloat width3 = kWidth/3;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i==0) {
                button.frame = CGRectMake(width3-30, kHeight-90, 60, 60);
            }else{
                button.frame = CGRectMake(width3*2-30,kHeight-90,60,60);
            }
//            if(i==0)
//            {
//                button.frame = CGRectMake(kWidth-100, kHeight-200, 60, 60);
//            }else{
//                button.frame = CGRectMake(kWidth-100, kHeight-100, 60, 60);
//            }
//            button.layer.cornerRadius = 5;
            [button setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 100+i;
            [self addSubview:button];
        }
    }
    return self;
}
- (void)back:(UIButton *)btn{
    [myDrawer clearScreen];
    self.back(btn.titleLabel.text);
}
- (void)buttonClick:(UIButton *)button {
    if (button.tag == 100) {
        [myDrawer clearScreen];
    } else if (button.tag == 101) {
        
        [self saveAndBackImage];
        [myDrawer clearScreen];
    }
}
// 按需求添加或修改此方法 （某些需求是要将电子签名上传自己服务器，就要用此方法了）
- (void)saveAndBackImage {
    if (![PSDataManager sharedManager].strokeArray.count)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入签名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
 
        [alert show];
        return;
    }
    UIGraphicsBeginImageContextWithOptions(myDrawer.bounds.size, NO, 1);
    [myDrawer.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.saveImage(viewImage);
}

@end
