//
//  Maker.m
//  LawyerSide
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 DingXiaoLei. All rights reserved.
//

#import "Maker.h"

@implementation Maker

+ (UILabel *)makeLb:(CGRect)frame title:(NSString *)title alignment:(NSTextAlignment)alignment font:(UIFont *)font textColor:(UIColor *)color
{
    UILabel *lb = [[UILabel alloc] initWithFrame:frame];
    lb.text = title;
    lb.font = font;
    lb.adjustsFontSizeToFitWidth = YES;
    
    
    lb.textAlignment = alignment;
    if (color)
      lb.textColor = color;
    return lb;
}
+ (UILabel *)makeLbtitle:(NSString *)title alignment:(NSTextAlignment)alignment font:(UIFont *)font textColor:(UIColor *)color
{
    UILabel *lb = [[UILabel alloc] init];
    lb.text = title;
    lb.font = font;
    lb.adjustsFontSizeToFitWidth = YES;
    
    
    lb.textAlignment = alignment;
    if (color)
        lb.textColor = color;
    return lb;
}
+(UIButton *)makeBtn:(CGRect)frame title:(NSString *)title img:(NSString *)img font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[[UIButton alloc]initWithFrame:frame];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    btn.titleLabel.font=font;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
//+ (UIButton *)creatButtonWithtitle:(NSString *)title image:(NSString *)image selImage:(NSString *)selImage target:(id)target selector:(SEL)action
//{
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
//    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
//    [btn  setTitle:title forState:UIControlStateNormal];
//    btn.titleLabel.font = kFont_Light_14;
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,0)];
//    [btn setTitleColor:kColor_BlackTitle forState:UIControlStateNormal];
//    return btn;
//}
+(UIImageView *)makeImgView:(CGRect)frame img:(NSString *)img
{
    UIImageView *imv=[[UIImageView alloc] initWithFrame:frame];
    imv.image=[UIImage imageNamed:img];
    return imv;
}
+ (UIView *)makeView:(CGRect)frame backGroundColor:(UIColor *)color
{
    UIView *line= [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    return line;
}
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
+(NSAttributedString *)makeAttributeStringWithPrefix:(NSString *)prefix attributes:(NSDictionary *)prefixAttributes sufix:(NSString *)sufix attributes:(NSDictionary *)sufixAttributes
{
    NSMutableAttributedString *mutale=[[NSMutableAttributedString alloc]init];
    if(prefix.length>0)
    {
        NSAttributedString *head=[[NSAttributedString alloc]initWithString:prefix attributes:prefixAttributes];
        [mutale appendAttributedString:head];
    }
    if(sufix.length>0)
    {
        NSAttributedString *tail=[[NSAttributedString alloc]initWithString:sufix attributes:sufixAttributes];
        [mutale appendAttributedString:tail];
    }
    return mutale;
}
+(NSAttributedString *)makeAttributeStringWithPrefix:(NSString *)prefix attributes:(NSDictionary *)prefixAttributes sufix:(NSString *)sufix attributes:(NSDictionary *)sufixAttributes lastfix:(NSString *)lastfix attributes:(NSDictionary *)lastfixAttributes
{
    NSMutableAttributedString *mutale=[[NSMutableAttributedString alloc]init];
    if(prefix.length>0)
    {
        NSAttributedString *head=[[NSAttributedString alloc]initWithString:prefix attributes:prefixAttributes];
        [mutale appendAttributedString:head];
    }
    if(sufix.length>0)
    {
        NSAttributedString *tail=[[NSAttributedString alloc]initWithString:sufix attributes:sufixAttributes];
        [mutale appendAttributedString:tail];
    }
    if (lastfix.length>0) {
        NSAttributedString *last =[[NSAttributedString alloc] initWithString:lastfix attributes:lastfixAttributes];
        [mutale appendAttributedString:last];
    }
    return mutale;
}

+(UITextField *)makeTextField:(CGRect)frame placeHolder:(NSString *)placeHolder backGroundColor:(UIColor *)color keybordType:(UIKeyboardType)kebordType font:(UIFont *)font delegate:(id)delegate
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    textField.placeholder=placeHolder;
    textField.font=font;
    textField.backgroundColor=color;
    textField.keyboardType=kebordType;
    textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    //左视图
    textField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
//    textField.leftViewMode=UITextFieldViewModeAlways;
    //右视图
    textField.rightView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    //大写模式
    textField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    //返回键为完成
    textField.returnKeyType=UIReturnKeyDone;
    //代理
    textField.delegate=delegate;
    
    return textField;
    
    
}



+ (UIButton *)creatButtonWithTitle:(NSString *)title image:(NSString  *)image selImage:(NSString *)selImage target:(id)target selector:(SEL)sel
{
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kColor_BlackTitle forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    return btn;
}




@end
