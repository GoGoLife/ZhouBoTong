//
//  Boat_InfoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/4.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Boat_InfoViewController.h"
#import "StandardsView.h"
#import "Globefile.h"

#import "Boat_OrderInfoViewController.h"
#import "MarchantInfoViewController.h"

@interface Boat_InfoViewController ()
{
    UIView *backgroundView;
}

@end

@implementation Boat_InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self setUpNav];
    
    
    // Do any additional setup after loading the view.
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self removeButtonTarget];
//    [self.addView.DPButton addTarget:self action:@selector(pushDPView) forControlEvents:UIControlEventTouchUpInside];
//    [self.addView.PayButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
}

//- (void)pushDPView {
//    MarchantInfoViewController *info = [[MarchantInfoViewController alloc] init];
//    [self.navigationController pushViewController:info animated:YES];
//}

//- (void)payAction:(UIButton *)button {
//    Boat_OrderInfoViewController *order = [[Boat_OrderInfoViewController alloc] init];
//    [self.navigationController pushViewController:order animated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 1 && indexPath.row == 0) {
//        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        backgroundView = [[UIView alloc] initWithFrame:delegate.window.bounds];
//        backgroundView.backgroundColor = SetColor(189, 189, 189, 0.5);
//        backgroundView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
//        [backgroundView addGestureRecognizer:tap];
//        [delegate.window addSubview:backgroundView];
//        [self showView:backgroundView];
//    }
//}
//
//- (void)showView:(UIView *)view {
//    StandardsView *bottomV = [[StandardsView alloc] init];
//    bottomV.backgroundColor = [UIColor whiteColor];
//    [view addSubview:bottomV];
//    __weak typeof(self) weakSelf = self;
//    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.view.mas_left);
//        make.right.equalTo(weakSelf.view.mas_right);
//        make.bottom.equalTo(weakSelf.view.mas_bottom);
//        make.height.mas_equalTo(@(280));
//    }];
//}
//
//- (void)removeView:(UITapGestureRecognizer *)tap {
//    [backgroundView removeFromSuperview];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
