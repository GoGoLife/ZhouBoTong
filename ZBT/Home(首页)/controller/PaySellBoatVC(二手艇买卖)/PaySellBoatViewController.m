//
//  PaySellBoatViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/2.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "PaySellBoatViewController.h"
#import "PaySellBoatTableViewCell.h"
#import "Globefile.h"
#import <Masonry.h>
#import "UITextField+LeftRightView.h"
#import "SecondSectionView.h"
#import "EquipmentInfoViewController.h"
#import "Boat_InfoViewController.h"


@interface PaySellBoatViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SecondSectionView *sectionV;

@end

@implementation PaySellBoatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"游艇买卖";
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[PaySellBoatTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

StringWidth();
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaySellBoatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isType = YES;
    cell.bottomTextF.textColor = SetColor(142, 142, 142, 1);
    [cell.bottomTextF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"已售：2" withFont:12], 20) AndTitle:@"已售：2" TextAligment:NSTextAlignmentRight Font:SetFont(12) Color:SetColor(142, 142, 142, 1)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:self.sectionV];
    return view;
}

- (SecondSectionView *)sectionV {
    if (_sectionV == nil) {
        _sectionV = [[SecondSectionView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 40) ItemNumber:3 AndTitle:@[@"全国", @"类型", @"全部分类"]];
    }
    return _sectionV;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
