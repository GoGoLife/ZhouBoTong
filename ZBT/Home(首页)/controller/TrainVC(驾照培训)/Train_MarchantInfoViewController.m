//
//  Train_MarchantInfoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Train_MarchantInfoViewController.h"
#import "SellProjectViewController.h"
//#import "BrandHeaderView.h"
//#import "CustomTableViewCell.h"

@interface Train_MarchantInfoViewController ()

@end

@implementation Train_MarchantInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商户信息";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSLog(@"train === %@", dic);
    MarchantListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
    cell.nameLabel.text = dic[@"name"];
    cell.marchantLabel.text = [NSString stringWithFormat:@"【%@】", dic[@"merchant"][@"merchant_name"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@", dic[@"price"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"zzzzzzzzzzzzzzzzz");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SellProjectViewController *sell = [[SellProjectViewController alloc] init];
    sell.train_type_id = self.dataArray[indexPath.row][@"train_type_id"];
    [self.navigationController pushViewController:sell animated:YES];
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
