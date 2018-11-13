//
//  Classify_infoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/21.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Classify_infoViewController.h"
#import "StandardsView.h"
#import "Globefile.h"

@interface Classify_infoViewController ()

{
    UIView *backgroundView;
}
@end

@implementation Classify_infoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    [self setUpNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 0) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        backgroundView = [[UIView alloc] initWithFrame:delegate.window.bounds];
        backgroundView.backgroundColor = SetColor(189, 189, 189, 0.5);
        backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
        [backgroundView addGestureRecognizer:tap];
        [delegate.window addSubview:backgroundView];
        [self showView:backgroundView];
    }
}

- (void)showView:(UIView *)view {
    StandardsView *bottomV = [[StandardsView alloc] init];
    bottomV.backgroundColor = [UIColor whiteColor];
    [view addSubview:bottomV];
    __weak typeof(self) weakSelf = self;
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(@(280));
    }];
}

- (void)removeView:(UITapGestureRecognizer *)tap {
    [backgroundView removeFromSuperview];
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
