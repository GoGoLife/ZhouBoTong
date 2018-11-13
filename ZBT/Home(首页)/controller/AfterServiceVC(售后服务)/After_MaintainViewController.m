//
//  After_MaintainViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/6.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "After_MaintainViewController.h"
#import "CustomTableViewCell.h"
#import "AfterService_TableViewCell.h"
#import "Globefile.h"
#import <Masonry.h>
#import "BrandHeaderView.h"

@interface After_MaintainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation After_MaintainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线维修";
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"first"];
    [self.tableView registerClass:[AfterService_TableViewCell class] forCellReuseIdentifier:@"second"];
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self setUpNav];
}
setBack();
pop();

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"first"];
        [self setCellContent:cell AtIndexPath:indexPath];
        return cell;
    }
    AfterService_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"second"];
    [self setCellContent:cell AtIndexPath:indexPath];
    return cell;
}

StringWidth();
- (void)setCellContent:(id)cell AtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            CustomTableViewCell *cusCell = (CustomTableViewCell *)cell;
            cusCell.textF.enabled = NO;
            cusCell.textF.textAlignment = NSTextAlignmentLeft;
            cusCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cusCell layoutIfNeeded];
            CGFloat width = [self calculateRowWidth:@"电话" withFont:15] + 15;
            CGFloat height = cusCell.textF.bounds.size.height;
            if (indexPath.row == 0) {
                [cusCell.textF creatLeftView:FRAME(0, 0, width, height) AndTitle:@"地址" TextAligment:NSTextAlignmentLeft Font:SetFont(15) Color:SetColor(147, 147, 147, 1)];
                cusCell.textF.text = @"广州市荔枝湾沿海地区码头";
            }else if (indexPath.row == 1) {
                [cusCell.textF creatLeftView:FRAME(0, 0, width, height) AndTitle:@"电话" TextAligment:NSTextAlignmentLeft Font:SetFont(15) Color:SetColor(147, 147, 147, 1)];
                cusCell.textF.text = @"18268865135";
                [cusCell.textF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"一键拨号" withFont:15], height) AndTitle:@"一键拨号" TextAligment:NSTextAlignmentRight Font:SetFont(15) Color:SetColor(147, 147, 147, 1)];
            }else {
                UIImageView *left = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 20, 20)];
                left.image = [UIImage imageNamed:@"ding"];
                [cusCell.textF creatLeftView:left.bounds AndControl:left];
                cusCell.textF.text = [@"   " stringByAppendingString:@"立刻预定"];
            }
            
        }
            break;
        case 1:
        {
            AfterService_TableViewCell *afterCell = (AfterService_TableViewCell *)cell;
            [afterCell layoutIfNeeded];
            afterCell.topTextF.text = @"上海A1级游艇培训驾驶";
            CGFloat width = [self calculateRowWidth:@"报名条件：" withFont:14];
            CGFloat height = afterCell.centerTextF.bounds.size.height;
            [afterCell.centerTextF creatLeftView:FRAME(0, 0, width, height) AndTitle:@"报名条件：" TextAligment:NSTextAlignmentLeft Font:SetFont(14) Color:SetColor(147, 147, 147, 1)];
            afterCell.centerTextF.font = SetFont(14);
            afterCell.centerTextF.textColor = SetColor(147, 147, 147, 1);
            afterCell.centerTextF.text = @"身高120";
            
            [afterCell.bottomTextF creatLeftView:FRAME(0, 0, width + 10, height) AndTitle:@"¥7000" TextAligment:NSTextAlignmentLeft Font:SetFont(17) Color:[UIColor redColor]];
            afterCell.bottomTextF.font = SetFont(14);
            afterCell.bottomTextF.textColor = SetColor(147, 147, 147, 1);
            afterCell.bottomTextF.text = @"¥10000";
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50.0;
    }
    return 110.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 110.0;
    }
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    if (section == 0) {
        BrandHeaderView *brand = [[BrandHeaderView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 100)];
        brand.numberLabel.textColor = SetColor(107, 107, 107, 1);
        brand.numberLabel.text = @"0人订过 | 0人收藏";
        brand.priceLabel.textColor = [UIColor redColor];
        brand.priceLabel.font = SetFont(17);
        brand.priceLabel.text = @"配送费：¥2000";
        [view addSubview:brand];
    }else {
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        label.textColor = SetColor(147, 147, 147, 1);
        label.font = SetFont(14);
        label.text = @"服务项目";
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, 0));
        }];
    }
    
    return view;
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
