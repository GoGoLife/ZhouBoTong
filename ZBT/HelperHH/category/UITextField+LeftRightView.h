//
//  UITextField+LeftRightView.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/14.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LeftRightView)

- (void)creatLeftView:(CGRect)frame AndControl:(id)control;

- (void)creatLeftView:(CGRect)frame AndTitle:(NSString *)leftString TextAligment:(NSTextAlignment)alignment Font:(UIFont *)font Color:(UIColor *)color;

- (void)creatLeftView:(CGRect)frame AndImage:(UIImage *)leftImage;

- (void)creatRightView:(CGRect)frame AndControl:(id)control;

- (void)creatRightView:(CGRect)frame AndTitle:(NSString *)leftString TextAligment:(NSTextAlignment)alignment Font:(UIFont *)font Color:(UIColor *)color;;

- (void)creatRightView:(CGRect)frame AndImage:(UIImage *)rightImage;

@end
