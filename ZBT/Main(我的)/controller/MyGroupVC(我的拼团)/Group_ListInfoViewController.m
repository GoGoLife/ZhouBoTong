//
//  Group_ListInfoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/28.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Group_ListInfoViewController.h"
#import "Globefile.h"

@interface Group_ListInfoViewController ()

@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation Group_ListInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.addV removeFromSuperview];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self getGroupListInfo_Me];
}

StringWidth();
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textF.enabled = NO;
    cell.textF.textAlignment = NSTextAlignmentLeft;
    cell.textF.font = SetFont(14);
    cell.textF.textColor = SetColor(69, 69, 69, 1);
    CGFloat width = [self calculateRowWidth:@"规格/数量：" withFont:14];
    
    if (indexPath.section == 1) {
        NSArray *leftArray = @[@"当前人数", @"配送范围：", @"运费："];
        [cell layoutIfNeeded];
        [cell.textF creatLeftView:FRAME(0, 0, width, 50.0) AndTitle:leftArray[indexPath.row] TextAligment:NSTextAlignmentLeft Font:SetFont(14) Color:SetColor(69, 69, 69, 1)];
        if (indexPath.row == 0) {
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textF.textAlignment = NSTextAlignmentRight;
            NSString *string = [NSString stringWithFormat:@"当前团购：%@人", self.dataDic[@"group"][@"current_number"]];
            [cell.textF creatRightView:FRAME(0, 0, width * 2, 50) AndTitle:string TextAligment:NSTextAlignmentRight Font:SetFont(14) Color:SetColor(69, 69, 69, 1)];
        }else if (indexPath.row == 1) {
            cell.textF.text = [NSString stringWithFormat:@"%@公里", [isNullClass(self.dataDic[@"merchant"]) isEqualToString:@""] ? @"0" : self.dataDic[@"merchant"][@"distribution_scope"]];//@"2000公里";
        }else {
            cell.textF.text = [NSString stringWithFormat:@"¥%@",  [isNullClass(self.dataDic[@"merchant"]) isEqualToString:@""] ? @"0" : self.dataDic[@"merchant"][@"distribution_fee"]];//@"¥1222";
        }
    }else if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *leftImageV = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 20, 20)];
        leftImageV.image = [UIImage imageNamed:@"dianpu"];
        [cell.textF creatLeftView:leftImageV.bounds AndControl:leftImageV];
        cell.textF.text = [NSString stringWithFormat:@"%@%@", @"   ", [isNullClass(self.dataDic[@"merchant"]) isEqualToString:@""] ? @"" : self.dataDic[@"merchant"][@"merchant_name"]];
        [cell.textF creatRightView:FRAME(0, 0, width, 50) AndTitle:@"一键拨号" TextAligment:NSTextAlignmentRight Font:SetFont(14) Color:SetColor(69, 69, 69, 1)];
    }else {
        cell.textF.text = self.dataDic[@"group"][@"info"]; //@"详细信息";
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        self.GroupHeaderView = [[GroupBuyView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 120)];
        self.GroupHeaderView.collectBtn.hidden = YES;
        self.GroupHeaderView.backgroundColor = [UIColor whiteColor];
        self.GroupHeaderView.dateTextF.font = SetFont(12);
        self.GroupHeaderView.remarkLabel.font = SetFont(12);
        self.GroupHeaderView.dateTextF.textColor = [UIColor redColor];
        self.GroupHeaderView.remarkLabel.textColor = [UIColor redColor];
        self.GroupHeaderView.topTextF.text = self.dataDic[@"group"][@"group_name"];
        self.GroupHeaderView.priceLeftString = [NSString stringWithFormat:@"￥%@", self.dataDic[@"group"][@"group_price"]];//@"¥7000";
        self.GroupHeaderView.dateLeftString = @"团购时间：";
        self.GroupHeaderView.dateTextF.text = [NSString stringWithFormat:@"%@ - %@", self.dataDic[@"group"][@"start_time"],self.dataDic[@"group"][@"end_time"]];//@"2018-3-12至2018-12-12";
        self.GroupHeaderView.dateRightString = @"";//[NSString stringWithFormat:@"当前团购：%@人", self.dataDic[@"group"][@"current_number"]];//@"当前团购：2人";
        self.GroupHeaderView.remarkLabel.text = @"";
        return self.GroupHeaderView;
    }
    return [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getGroupListInfo_Me {
    NSString *url = @"https://zbt.change-word.com/index.php/home/group/MyGroupInfo";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"my_group_id" : self.my_group_id};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"MyGroupListInfo ==== %@", responseObject);
        if ([responseObject[@"resultCode"] integerValue] == 1) {
            weakSelf.dataDic = ((NSArray *)responseObject[@"data"]).firstObject;
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"MyGroupListInfo  ==== %@", error);
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
