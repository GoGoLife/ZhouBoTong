//
//  callAcitonView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/7/26.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "callAcitonView.h"

@implementation callAcitonView

+ (void)showCallActionWithTitle:(NSString *)title AndShowView:(id)control {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拨号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取目标号码字符串,转换成URL
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",title]];
        //调用系统方法拨号
        [[UIApplication sharedApplication] openURL:url];
    }]];
    
    [control presentViewController:alert animated:YES completion:nil];
}

+ (void)showSheetView:(id)control {
    UIAlertController *sheetView = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"银行卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
//    [sheetView addAction:action1];
    [sheetView addAction:action2];
//    [sheetView addAction:action3];
    [sheetView addAction:action4];
    
    [control presentViewController:sheetView animated:YES completion:nil];
}

@end
