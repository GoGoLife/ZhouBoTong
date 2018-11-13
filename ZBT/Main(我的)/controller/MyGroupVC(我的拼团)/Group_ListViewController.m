//
//  Group_ListViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/12.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Group_ListViewController.h"
#import "Globefile.h"
#import "UITextField+LeftRightView.h"

#import "Group_ListInfoViewController.h"

@interface Group_ListViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation Group_ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的拼团";
    // Do any additional setup after loading the view.
    [self getGroupList_Me];
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
    MarchantListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell layoutIfNeeded];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"group"][@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
    cell.nameLabel.text = dic[@"group"][@"group_name"];
    cell.marchantLabel.text = [isNullClass(dic[@"merchant"]) isEqualToString:@""] ? @"" : dic[@"merchant"][@"merchant_name"];//@"    喜马拉雅店";
    UIImageView *leftImageV = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 15, 15)];
    leftImageV.image = [UIImage imageNamed:@"dianpu"];
    [cell.marchantLabel creatLeftView:leftImageV.bounds AndControl:leftImageV];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, [self calculateRowWidth:@"已团10件" withFont:12] + 40, 20)];
    rightLabel.font = SetFont(12);
    rightLabel.textAlignment = NSTextAlignmentLeft;
    rightLabel.text = @"已团10件";
    [cell.marchantLabel creatRightView:rightLabel.bounds AndControl:rightLabel];
    
    cell.bottomTextF.enabled = YES;
    cell.bottomTextF.delegate = self;
    UIButton *lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lookBtn.frame = FRAME(0, 0, 40, 20);
    lookBtn.titleLabel.font = SetFont(12);
    ViewRadius(lookBtn, 10.0);
    lookBtn.backgroundColor = [UIColor redColor];
    [lookBtn setTitle:@"查看" forState:UIControlStateNormal];
    [cell.bottomTextF creatRightView:lookBtn.bounds AndControl:lookBtn];
    return cell;
}
StringWidth();

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Group_ListInfoViewController *info = [[Group_ListInfoViewController alloc] init];
    info.my_group_id = self.dataArr[indexPath.row][@"my_group_id"];
    [self.navigationController pushViewController:info animated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (void)getGroupList_Me {
    NSString *url = @"https://zbt.change-word.com/home/group/getMyGroupList";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"]};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"MyGroupList ==== %@", responseObject);
        weakSelf.dataArr = (NSArray *)responseObject[@"data"];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"MyGroupList  ==== %@", error);
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
