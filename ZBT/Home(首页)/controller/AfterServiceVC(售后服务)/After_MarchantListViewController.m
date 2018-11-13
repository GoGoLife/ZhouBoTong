//
//  After_MarchantListViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/6.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "After_MarchantListViewController.h"
#import "AllArticleViewController.h"

@interface After_MarchantListViewController ()

@end

@implementation After_MarchantListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家列表";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AllArticleViewController *article = [[AllArticleViewController alloc] init];
    [self.navigationController pushViewController:article animated:YES];
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
