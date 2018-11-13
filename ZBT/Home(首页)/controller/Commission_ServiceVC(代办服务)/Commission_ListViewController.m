//
//  Commission_ListViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/7.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Commission_ListViewController.h"
#import "Commission_InfoViewController.h"
#import "Globefile.h"

@interface Commission_ListViewController ()

@end

@implementation Commission_ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    MarchantListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
    cell.nameLabel.text = dic[@"serve_name"];
    cell.marchantLabel.text = [NSString stringWithFormat:@"【%@】", dic[@"merchant"][@"merchant_name"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@", dic[@"price"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Commission_InfoViewController *info = [[Commission_InfoViewController alloc] init];
    info.commission_id = self.dataArray[indexPath.row][@"serve_id"];
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
