//
//  AllineceViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "AllineceViewController.h"
#import "BrandListInfoViewController.h"
#import "Globefile.h"

@interface AllineceViewController ()

@property (nonatomic, strong) NSArray *Allinece_DataArray;

@end

@implementation AllineceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"船厂联盟";
    // Do any additional setup after loading the view.
    [self Allinece_GetDataForService];
}

- (void)Allinece_GetDataForService {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    __weak typeof(self) weakSelf = self;
    [manager GET:@"https://zbt.change-word.com/index.php/home/brand/shipyardBrand" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"responseObject11111 === %@", responseObject);
//        NSLog(@"-=-=-=-%@", ((NSArray *)responseObject[@"data"]).firstObject[@"brand_id"]);
        weakSelf.Allinece_DataArray = responseObject[@"data"];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error === %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.Allinece_DataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //    cell.CellHeight = 110.0;
    [cell layoutIfNeeded];
    NSString *url = self.Allinece_DataArray[indexPath.row][@"photo"];
    [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:url]];
    cell.topTextF.text = self.Allinece_DataArray[indexPath.row][@"brand_name"];
    cell.bottomTextF.text = [NSString stringWithFormat:@"%d个合作商家", arc4random() % 20];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BrandListInfoViewController *info = [[BrandListInfoViewController alloc] init];
    info.title = @"船厂商家";
    info.brand_id = self.Allinece_DataArray[indexPath.row][@"brand_id"];
    info.imageUrl = self.Allinece_DataArray[indexPath.row][@"photo"];
    [self.navigationController pushViewController:info animated:YES];
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
