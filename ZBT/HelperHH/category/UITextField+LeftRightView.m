//
//  UITextField+LeftRightView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/14.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "UITextField+LeftRightView.h"
#import "Globefile.h"

@implementation UITextField (LeftRightView)

- (void)creatLeftView:(CGRect)frame AndControl:(id)control {
    self.leftView = control;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)creatLeftView:(CGRect)frame AndTitle:(NSString *)leftString TextAligment:(NSTextAlignment)alignment Font:(UIFont *)font Color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = alignment;
    label.font = font;
    label.textColor = color;
    label.text = leftString;
    
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = label;
}

- (void)creatLeftView:(CGRect)frame AndImage:(UIImage *)leftImage {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:frame];
    if (leftImage == nil) {
        imageV.backgroundColor = RandomColor;
    }else {
        imageV.image = leftImage;
    }
    
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView   = imageV;
}

- (void)creatRightView:(CGRect)frame AndControl:(id)control {
    self.rightView = control;
    self.rightViewMode = UITextFieldViewModeAlways;
}

- (void)creatRightView:(CGRect)frame AndTitle:(NSString *)leftString TextAligment:(NSTextAlignment)alignment Font:(UIFont *)font Color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = alignment;
    label.font = font;
    label.textColor = color;
    label.text = leftString;
    
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = label;
}

- (void)creatRightView:(CGRect)frame AndImage:(UIImage *)rightImage {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:frame];
    if (rightImage == nil) {
        imageV.backgroundColor = RandomColor;
    }else {
        imageV.image = rightImage;
    }
    
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = imageV;
}

@end
