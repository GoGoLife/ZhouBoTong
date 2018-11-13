//
//  Globefile.h
//  ZBT
//
//  Created by 钟文斌 on 2018/5/4.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#ifndef Globefile_h
#define Globefile_h

#import <Masonry.h>
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"

#define SCREENBOUNDS [UIScreen mainScreen].bounds.size
#define FRAME(X, Y, W, H) CGRectMake(X, Y, W, H)
#define IS_IPHONE_X     (( fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)812) < DBL_EPSILON ) || (fabs((double)[[UIScreen mainScreen] bounds].size.width - (double)812) < DBL_EPSILON ))
#define STATUS_HEIGHT   (IS_IPHONE_X?44:20)
#define BOTTOM_SAFEAREA_HEIGHT (IS_IPHONE_X? 34 : 0)
#define TABBAR_HEIGHT   (IS_IPHONE_X? (49 + 34) : 49)

//百度地图安全码
#define BAIDU_MCODE @"com.zhong.phone"
#define BAIDU_AK @"G5D0r4BzFCPc2vQSQTMusvFjzFj6pEVP"


//返回按钮
#define setBack()\
\
- (void)setUpNav {\
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];\
    self.navigationItem.leftBarButtonItem = backItem;\
}

//返回方法
#define pop()\
\
- (void)pop {\
[self.navigationController popViewControllerAnimated:YES];\
}

//判断是不是null类型
#define isNullClass(object)\
({\
    NSString *string = @"";\
    if ([object isKindOfClass:[NSNull class]])\
        string = @"";\
    else\
        string = [NSString stringWithFormat:@"%@", object];\
    (string);\
})\

//判断是否为整形：
#define isPureInt(string) \
({\
    BOOL success;\
    NSScanner* scan = [NSScanner scannerWithString:string];\
    int val;\
    success = [scan scanInt:&val] && [scan isAtEnd];\
    (success);\
})\

//判断是否为浮点数
#define isPureFloat(string) \
({\
BOOL success;\
NSScanner* scan = [NSScanner scannerWithString:string];\
int val;\
success = [scan scanInt:&val] && [scan isAtEnd];\
(success);\
})\

//View圆角和加边框
#define ViewBorderRadius(View,Radius,Width,Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View圆角
#define ViewRadius(View,Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//tableview 设置group样式  去除顶部多余部分
#define DropView(tableView)\
\
tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);\


#define StringWidth() - (CGFloat)calculateRowWidth:(NSString *)string withFont:(CGFloat)font {\
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};\
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 30) options:NSStringDrawingUsesLineFragmentOrigin |\
               NSStringDrawingUsesFontLeading attributes:dic context:nil];\
    return rect.size.width;\
}\

#define StringHeight() - (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize withWidth:(CGFloat)width{\
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};\
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin |\
               NSStringDrawingUsesFontLeading attributes:dic context:nil];\
return rect.size.height;\
}\


#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]//随机色生成

#define SetColor(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]  //设置颜色

#define SetFont(font) [UIFont systemFontOfSize:font]

#define BaseViewColor [UIColor colorWithRed:243/255.0 green:242/255.0 blue:247/255.0 alpha:1]

//分割线颜色
#define LineColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]

#define Color176 [UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1]

#endif /* Globefile_h */
