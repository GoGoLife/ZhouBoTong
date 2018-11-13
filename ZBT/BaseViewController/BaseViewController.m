//
//  BaseViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import "Globefile.h"

@interface BaseViewController ()

@property (nonatomic,strong)MBProgressHUD *hud;

@property (nonatomic, strong) UIView *areaBelowSafeArea;

@end

@implementation BaseViewController

- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return _hud;
}

- (void)show{
    [self.view addSubview:self.hud];
    [self.hud showAnimated:YES];
}

- (void)hidden{
    [self.hud hideAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    if (IS_IPHONE_X) {
        self.areaBelowSafeArea = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENBOUNDS.height - BOTTOM_SAFEAREA_HEIGHT, SCREENBOUNDS.width, BOTTOM_SAFEAREA_HEIGHT)];
        self.areaBelowSafeArea.backgroundColor = [UIColor colorWithRed:243/255.0 green:242/255.0 blue:247/255.0 alpha:1];
        [self.view addSubview:self.areaBelowSafeArea];
    }else {
        self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:242/255.0 blue:247/255.0 alpha:1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

setBack();
pop();

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
