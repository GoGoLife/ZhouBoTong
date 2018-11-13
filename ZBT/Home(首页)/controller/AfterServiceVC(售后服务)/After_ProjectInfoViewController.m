//
//  After_ProjectInfoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/6.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "After_ProjectInfoViewController.h"
#import "After_ReserveViewController.h"

@interface After_ProjectInfoViewController ()

@end

@implementation After_ProjectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    // Do any additional setup after loading the view.
    [self removeTarget];
    [self.button addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushVC {
    After_ReserveViewController *reserve = [[After_ReserveViewController alloc] init];
    [self.navigationController pushViewController:reserve animated:YES];
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
