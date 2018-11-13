//
//  ChangeNameViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ChangeNameViewController.h"
#import "Globefile.h"

@interface ChangeNameViewController ()
{
    UITextField *textF;
}

@end

@implementation ChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改姓名";
    
    textF = [[UITextField alloc] initWithFrame:FRAME(0, 20, SCREENBOUNDS.width, 44)];
    textF.backgroundColor = [UIColor whiteColor];
    textF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UILabel *label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 15, 44)];
    textF.leftView = label;
    textF.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:textF];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = FRAME(15, 80, SCREENBOUNDS.width - 30, 44);
    ViewRadius(button, 5.0);
    [button setBackgroundColor:SetColor(24, 147, 219, 1)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(returnName) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self setUpNav];
}
setBack();
pop();

- (void)returnName {
    self.returnNameString(textF.text);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
