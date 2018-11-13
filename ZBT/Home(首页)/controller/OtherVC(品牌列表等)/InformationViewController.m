//
//  InformationViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "InformationViewController.h"
#import "Wheel_infoViewController.h"
#import "Globefile.h"
#import "ShowHtmlTextViewController.h"

@interface InformationViewController ()

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资讯列表";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.row];
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell layoutIfNeeded];
    [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:isNullClass(dic[@"photo"])] placeholderImage:[UIImage imageNamed:@"public"]];
    cell.topTextF.text = dic[@"title"];//@"如何识别二手艇是否为事故艇";
    cell.bottomTextF.text = [NSString stringWithFormat:@"%d浏览", arc4random() % 500];//@"2000浏览";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.dataArr[indexPath.row];
//    Wheel_infoViewController *info = [[Wheel_infoViewController alloc] init];
//    info.textString = dic[@"info"];
//    info.dateString = dic[@"add_time"];
//    [self.navigationController pushViewController:info animated:YES];
    
    ShowHtmlTextViewController *show = [[ShowHtmlTextViewController alloc] init];
    show.textString = dic[@"info"];
    [self.navigationController pushViewController:show animated:YES];
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
