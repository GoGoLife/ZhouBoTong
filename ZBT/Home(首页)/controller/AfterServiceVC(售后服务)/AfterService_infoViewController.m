//
//  AfterService_infoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/7/25.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "AfterService_infoViewController.h"

@interface AfterService_infoViewController ()

@end

@implementation AfterService_infoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.addView.DPButton.hidden = YES;
    self.addView.KFButton.hidden = YES;
    self.addView.AddCartsButton.hidden = YES;
    [self getAfterInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 3) {
//        NSString *string = self.dataDic[@"describe"] ?: self.dataDic[@"info"];
//        CGFloat info_height = [self calculateRowHeight:string fontSize:14 withWidth:SCREENBOUNDS.width - 10];
//        return 200 + 20 + info_height;
//    }
    return 60.0;
}

StringWidth();
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EquipmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    switch (indexPath.section) {
        case 0:
            
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
//                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [cell.textF creatLeftView:FRAME(0, 0, [self calculateRowWidth:@"规格/数量" withFont:14], 60) AndTitle:@"服务次数" TextAligment:NSTextAlignmentLeft Font:SetFont(14) Color:[UIColor blackColor]];
                    [cell.textF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"选择规格" withFont:14], 60) AndTitle:@"1次" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:SetColor(147, 147, 147, 1)];
                }
                    break;
                case 1:
                {
                    cell.textF.font = SetFont(14);
                    cell.textF.text = @"2000公里";
                    [cell.textF creatLeftView:FRAME(0, 0, [self calculateRowWidth:@"配送范围：" withFont:14], 60) AndTitle:@"服务范围：" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:[UIColor blackColor]];
                }
                    break;
//                case 2:
//                {
//                    cell.textF.font = SetFont(14);
//                    cell.textF.text = @"¥2000";
//                    [cell.textF creatLeftView:FRAME(0, 0, [self calculateRowWidth:@"配送费：" withFont:14], 60) AndTitle:@"配送费：" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:[UIColor blackColor]];
//                }
//                    break;
                default:
                    break;
            }
            
        }
            break;
        case 2:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textF.text = [@"    " stringByAppendingString:isNullClass(self.dataDic[@"merchant"][@"merchant_name"])];
            [cell.textF creatLeftView:FRAME(0, 0, 20, 20) AndImage:[UIImage imageNamed:@"dianpu"]];
            [cell.textF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"一键拨号" withFont:14], 60) AndTitle:@"一键拨号" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:SetColor(147, 147, 147, 1)];
        }
            break;
        case 3:
        {
            cell.textF.leftViewMode = UITextFieldViewModeNever;
            cell.textF.rightViewMode = UITextFieldViewModeNever;
            cell.textF.text = self.dataDic[@"info"];//@"Marquis yacht.LLC.USA";
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        GroupBuyView *view = [[GroupBuyView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 100)];
        //收藏
        view.collectBtn.hidden = YES;
        view.backgroundColor = [UIColor whiteColor];
        view.isNewLayout = YES;
        view.topTextF.text = self.dataDic[@"serve_name"];
        view.priceLeftString = [NSString stringWithFormat:@"¥%@", self.dataDic[@"price"]];
        view.remarkLabel.font = SetFont(12);
        view.remarkLabel.text = @"";
        
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@", self.dataDic[@"down_payment"]] attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)}];
//        view.priceTextF.attributedText = attrStr;
        view.priceTextF.text = [NSString stringWithFormat:@"定金：%@",self.dataDic[@"down_payment"]];
        return view;
    }else if(section == 3) {
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(15, 0, SCREENBOUNDS.width - 15, 40)];
        label.font = SetFont(12);
        label.textColor = SetColor(165, 165, 165, 1);
        label.text = @"详细信息";
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        LoopView *loopV = [[LoopView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 200)];
        loopV.imageArray = @[@"1", @"2", @"3", @"4"];
        return loopV;
        //        [self.view addSubview:loopV];
    }
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 10)];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}

- (void)getAfterInfo {
    NSLog(@"11111111");
    if (!self.after_id) {
        NSLog(@"2222222");
        return;
    }
    NSString *url = @"https://zbt.change-word.com/home/service/serviceInfo";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"after_id" : self.after_id};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"afterInfo  === %@", responseObject);
        weakSelf.dataDic = (NSDictionary *)responseObject[@"data"];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"infoerror === %@", error);
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
