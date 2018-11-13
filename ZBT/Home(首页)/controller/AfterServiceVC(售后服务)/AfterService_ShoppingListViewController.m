//
//  AfterService_ShoppingListViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/7/27.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "AfterService_ShoppingListViewController.h"
#import "Globefile.h"
#import "AfterService_infoViewController.h"

@interface AfterService_ShoppingListViewController ()

@end

@implementation AfterService_ShoppingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务列表";
    // Do any additional setup after loading the view.
    [self getServiceList_AfterID];
    self.sectionV.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击进入售后服务详情
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AfterService_infoViewController *info = [[AfterService_infoViewController alloc] init];
    info.after_id = self.serviceList[indexPath.row][@"serve_id"];
    info.type = 2;
    [self.navigationController pushViewController:info animated:YES];
}

- (void)getServiceList_AfterID {
    if (!self.category_id) {
        return;
    }
    NSLog(@"category_id === %@", self.category_id);
    NSString *url = @"https://zbt.change-word.com/index.php/home/service/categoryService";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"category_id" : self.category_id};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"afterList ==== %@", responseObject);
        weakSelf.serviceList = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"after_ServiceList  error ==== %@", error);
    }];
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
