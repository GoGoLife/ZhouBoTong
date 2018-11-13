//
//  Commission_InfoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/7.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Commission_InfoViewController.h"
#import "Commission_ProjectInfoViewController.h"
#import "PlayVideo_TableViewCell.h"

@interface Commission_InfoViewController ()

@end

@implementation Commission_InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.SellHeaderTopString = @"游艇代办牌照";
    self.SellView.topLabel.text = @"游艇代办牌照";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

StringWidth();
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isWharfGoVC) {
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textF.textAlignment = NSTextAlignmentLeft;
        cell.textF.enabled = NO;
        switch (indexPath.section) {
            case 0:break;
            case 1:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.isNewLayout = YES;
                cell.textF.enabled = NO;
                //                cell.textF.text = @"杭州市小码头";
                CGFloat width = [self calculateRowWidth:@"规格/人数" withFont:14];
                [cell.textF creatLeftView:FRAME(0, 0, width, cell.bounds.size.height) AndTitle:@"规格/人数" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:[UIColor blackColor]];
                [cell.textF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"选择规格" withFont:14], cell.bounds.size.height) AndTitle:@"选择规格" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:SetColor(162, 162, 162, 1)];
            }
                break;
            case 2:
            {
                cell.textF.text = self.dataDic[@"merchant"][@"merchant_name"];//@"Marquis yachts.LLC.USA";
            }
                break;
            case 3:
            {
//                cell.textF.text = @"Marquis yachts.LLC.USA(播放视频)";
                PlayVideo_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.info_string = self.dataDic[@"info"];
                cell.info_label.text = self.dataDic[@"info"];
                cell.video_URLString = @"";
                return cell;
            }
                break;
            case 4:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.isNewLayout = YES;
                if (indexPath.row == 0) {
                    cell.textF.text = self.dataDic[@"merchant"][@"shop_address"];//@"杭州市小码头";
                    CGFloat width = [self calculateRowWidth:@"地址：" withFont:14];
                    [cell.textF creatLeftView:FRAME(0, 0, width, cell.bounds.size.height) AndTitle:@"地址：" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:[UIColor blackColor]];
                    [cell.textF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"导航" withFont:14], cell.bounds.size.height) AndTitle:@"导航" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:SetColor(162, 162, 162, 1)];
                }else if(indexPath.row == 1){
                    cell.textF.text = self.dataDic[@"merchant"][@"shop_phone"];//@"18268865135";
                    CGFloat width = [self calculateRowWidth:@"电话：" withFont:14];
                    [cell.textF creatLeftView:FRAME(0, 0, width, cell.bounds.size.height) AndTitle:@"电话：" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:[UIColor blackColor]];
                    [cell.textF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"一键拨号" withFont:14], cell.bounds.size.height) AndTitle:@"一键拨号" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:SetColor(162, 162, 162, 1)];
                }
            }
                break;
                
            default:
                break;
        }
        return cell;
    }else {
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textF.textAlignment = NSTextAlignmentLeft;
        cell.textF.enabled = NO;
        switch (indexPath.section) {
            case 0:break;
            case 1:
            {
                cell.textF.text = self.dataDic[@"info"];//@"Marquis yachts.LLC.USA";
            }
                break;
            case 2:
            {
//                cell.textF.text = @"Marquis yachts.LLC.USA(播放视频)";
                PlayVideo_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.info_string = self.dataDic[@"info"];
                cell.info_label.text = self.dataDic[@"info"];
                cell.video_URLString = @"";
                return cell;
            }
                break;
            case 3:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.isNewLayout = YES;
                if (indexPath.row == 0) {
                    cell.textF.text = self.dataDic[@"merchant"][@"shop_address"];//@"杭州市小码头";
                    CGFloat width = [self calculateRowWidth:@"地址：" withFont:14];
                    [cell.textF creatLeftView:FRAME(0, 0, width, cell.bounds.size.height) AndTitle:@"地址：" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:[UIColor blackColor]];
                    [cell.textF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"导航" withFont:14], cell.bounds.size.height) AndTitle:@"导航" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:SetColor(162, 162, 162, 1)];
                }else {
                    cell.textF.text = self.dataDic[@"merchant"][@"shop_phone"];//@"18268865135";
                    CGFloat width = [self calculateRowWidth:@"电话：" withFont:14];
                    [cell.textF creatLeftView:FRAME(0, 0, width, cell.bounds.size.height) AndTitle:@"电话：" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:[UIColor blackColor]];
                    [cell.textF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"一键拨号" withFont:14], cell.bounds.size.height) AndTitle:@"一键拨号" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:SetColor(162, 162, 162, 1)];
                }
            }
                break;
                
            default:
                break;
        }
        return cell;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isWharfGoVC) {
        if (section == 0) {
            LoopView *loopV = [[LoopView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 200.0)];
            loopV.imageArray = @[@"1", @"2", @"3", @"4"];
            return loopV;
        }
        if (section == 1) {
            self.SellView = [[SellHeaderView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 80.0)];
            [self.SellView layoutIfNeeded];
            self.SellView.topLabel.text = self.dataDic[@"serve_name"];//@"Marquis Yachts.LLC.USA";
            self.SellView.bottomTextF.text = [NSString stringWithFormat:@"定金：%@", self.dataDic[@"down_payment"]];//@"定金：100";
            NSString *price = [NSString stringWithFormat:@"¥%@", self.dataDic[@"price"]];
            CGFloat width = [self calculateRowWidth:price withFont:17];
            [self.SellView.bottomTextF creatLeftView:FRAME(0, 0, width + 10, self.SellView.bottomTextF.bounds.size.height) AndTitle:price TextAligment:NSTextAlignmentLeft Font:SetFont(17) Color:[UIColor redColor]];
            return self.SellView;
        }
    }else {
        if (section == 0) {
            LoopView *loopV = [[LoopView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 200.0)];
            loopV.imageArray = @[@"1", @"2", @"3", @"4"];
            return loopV;
        }
    }
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 44.0)];
    view.backgroundColor = [UIColor whiteColor];
    UITextField *label = [[UITextField alloc] initWithFrame:FRAME(10, 0, view.bounds.size.width - 20, view.bounds.size.height)];
    label.textAlignment = NSTextAlignmentLeft;
    label.enabled = NO;
    [view addSubview:label];
    label.font = SetFont(12);
    NSInteger sectionIndex = 1;
    if (self.isWharfGoVC) {
        sectionIndex = 2;
    }
    if (section == sectionIndex) {
        label.textColor = SetColor(63, 63, 63, 1);
        label.text = @"项目介绍";
    }else if (section == sectionIndex + 1) {
        label.textColor = SetColor(63, 63, 63, 1);
        label.text = @"项目详情";
    }else if (section == sectionIndex + 2){
        label.enabled = YES;
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = SetColor(173, 173, 173, 1);
        NSString *merchantName = [NSString stringWithFormat:@"商家名称: %@", self.dataDic[@"merchant"][@"merchant_name"]];
        CGFloat width = [self calculateRowWidth:merchantName withFont:12];
        [label creatLeftView:FRAME(0, 0, width, view.bounds.size.height) AndTitle:merchantName TextAligment:NSTextAlignmentLeft Font:SetFont(12) Color:SetColor(63, 63, 63, 1)];
        label.text = @"更多项目";
        UIImageView *right = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 8, 13)];
        right.image = [UIImage imageNamed:@"right"];
        [label creatRightView:right.bounds AndControl:right];
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushInfo)];
        [label addGestureRecognizer:tap];
    }
    return view;
}

- (void)pushInfo {
    Commission_ProjectInfoViewController *info = [[Commission_ProjectInfoViewController alloc] init];
    info.merchant_id = self.dataDic[@"merchant_id"];
    [self.navigationController pushViewController:info animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0 && !self.isWharfGoVC) {
        SellHeaderView *view = [[SellHeaderView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 80.0)];
        [view layoutIfNeeded];
        view.topLabel.text = self.dataDic[@"serve_name"];//@"Marquis Yachts.LLC.USA";  //self.SellHeaderTopString;
        view.bottomTextF.text = [NSString stringWithFormat:@"定金：%@", self.dataDic[@"down_payment"]];//@"定金：100";
        NSString *price = [NSString stringWithFormat:@"¥%@", self.dataDic[@"price"]];
        CGFloat width = [self calculateRowWidth:price withFont:17];
        [view.bottomTextF creatLeftView:FRAME(0, 0, width + 10, view.bottomTextF.bounds.size.height) AndTitle:price TextAligment:NSTextAlignmentLeft Font:SetFont(17) Color:[UIColor redColor]];
        return view;
    }
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 10.0)];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}

@end
