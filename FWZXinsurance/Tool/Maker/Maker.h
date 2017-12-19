//
//  Maker.h
//  LawyerSide
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 DingXiaoLei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Maker : NSObject
/**
 *  生成label
 *
 *  @param frame     frame
 *  @param title    title
 *  @param alignment 对齐方式
 *  @param font      字体大小
 *  @param color     颜色
 *
 *  @return label
 */
+ (UILabel *)makeLb:(CGRect)frame title:(NSString *)title alignment:(NSTextAlignment)alignment font:(UIFont *)font textColor:(UIColor *)color;

+ (UILabel *)makeLbtitle:(NSString *)title alignment:(NSTextAlignment)alignment font:(UIFont *)font textColor:(UIColor *)color;
/**
 *  生成按钮
 *
 *  @param frame  frame
 *  @param title  title
 *  @param img    image
 *  @param font   font
 *  @param target target
 *  @param action action
 *
 *  @return UIButton
 */
+(UIButton *)makeBtn:(CGRect)frame title:(NSString *)title img:(NSString *)img font:(UIFont *)font target:(id)target action:(SEL)action;



+(UIView *)makeView:(CGRect)frame backGroundColor:(UIColor *)color;
/**
 *  生成图片视图
 *
 *  @param frame frame
 *  @param img   图片
 *
 *  @return imv
 */
+(UIImageView *)makeImgView:(CGRect)frame img:(NSString *)img;
/**
 *  合成属性文本
 *
 *  @param prefix           前面部分
 *  @param prefixAttributes 前面部分的属性
 *  @param sufix            后面部分
 *  @param sufixAttributes  后面部分的属性
 *
 *  @return 属性文本
 */
+(NSAttributedString *)makeAttributeStringWithPrefix:(NSString *)prefix attributes:(NSDictionary *)prefixAttributes sufix:(NSString *)sufix attributes:(NSDictionary *)sufixAttributes;

+(NSAttributedString *)makeAttributeStringWithPrefix:(NSString *)prefix attributes:(NSDictionary *)prefixAttributes sufix:(NSString *)sufix attributes:(NSDictionary *)sufixAttributes lastfix:(NSString *)lastfix attributes:(NSDictionary *)lastfixAttributes;
/**
 *  生成UITextField
 *
 *  @param frame       frame
 *  @param placeHolder placeHolder
 *  @param color       背景颜色
 *  @param kebordType  键盘类型
 *  @param font        字体
 *
 *  @return UITextField
 */
+(UITextField *)makeTextField:(CGRect)frame placeHolder:(NSString *)placeHolder backGroundColor:(UIColor *)color keybordType:(UIKeyboardType)kebordType font:(UIFont *)font delegate:(id)delegate;


+ (UIButton *)creatButtonWithTitle:(NSString *)title image:(NSString *)image selImage:(NSString *)selImage target:(id)target selector:(SEL)sel;


@end
