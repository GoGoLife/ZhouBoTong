//
//  Boat_OrderInfoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/4.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Boat_OrderInfoViewController.h"
#import "Globefile.h"
#import "CustomTableViewCell.h"
#import <Masonry.h>
#import "SellSecondHeaderView.h"
#import "Boat_footerView.h"
#import "ShoppingListViewController.h"
#import "SelectAddressViewController.h"

@interface Boat_OrderInfoViewController ()<UITableViewDataSource, UITableViewDelegate, BoatFooterWayDelegate>
{
    NSInteger selectIndex;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) Boat_footerView *footView;

@property (nonatomic, strong) NSString *address;

@end

@implementation Boat_OrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    selectIndex = 4;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 44, 0));
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(44));
    }];
    [self setUpNav];
    
    
    NSLog(@"dataDic === %@", self.dataDic);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return selectIndex;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        SellSecondHeaderView *view = [[SellSecondHeaderView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 100.0)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        view.backgroundColor = [UIColor whiteColor];
        [view.leftImageV sd_setImageWithURL:[NSURL URLWithString:[self.dataDic[@"photo"] firstObject]] placeholderImage:[UIImage imageNamed:@"public"]];
        view.topLabel.text = self.dataDic[@"serve_name"] ?: self.dataDic[@"goods_name"] ?: self.dataDic[@"title"];//@"出海捕鱼";
        view.bottomLabel.textColor = [UIColor redColor];
        view.bottomLabel.text = [NSString stringWithFormat:@"¥%@", self.dataDic[@"price"] ?: self.dataDic[@"goods_price"]];//@"¥2100";
        view.numberLabel.text = [NSString stringWithFormat:@"* %@", self.number];
        [cell.contentView addSubview:view];
        return cell;
    }
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [self setCellContentView:cell AtIndexPath:indexPath];
    return cell;
}

StringWidth();
- (void)setCellContentView:(CustomTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath {
    if (selectIndex == 2) {
        cell.textF.textColor = [UIColor redColor];
        cell.textF.text = @[@"¥7000", @"¥200"][indexPath.row];
        NSArray *DataArr = @[@"商品金额", @"运费"];
        CGFloat width = [self calculateRowWidth:@"手机号码" withFont:15];
        CGFloat height = 50.0;
        [cell.textF creatLeftView:FRAME(0, 0, width, height) AndTitle:DataArr[indexPath.row] TextAligment:NSTextAlignmentLeft Font:SetFont(15) Color:SetColor(47, 47, 47, 1)];
    }else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textF.enabled = NO;
        if (indexPath.row == 2) {
            cell.textF.enabled = YES;
            cell.textF.placeholder = @"请填写";
        }
        cell.textF.textColor = SetColor(47, 47, 47, 1);
        cell.textF.font = SetFont(15);
        NSArray *DataArr = @[@"联系人", @"手机号码", @"备注", @"收货地址"];
        CGFloat width = [self calculateRowWidth:@"手机号码" withFont:15];
        CGFloat height = 50.0;
        [cell.textF creatLeftView:FRAME(0, 0, width, height) AndTitle:DataArr[indexPath.row] TextAligment:NSTextAlignmentLeft Font:SetFont(15) Color:SetColor(47, 47, 47, 1)];
        NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultName"] == nil ? @"请选择地址" : [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultName"];
        NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultPhone"] == nil ? @"请选择地址" : [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultPhone"];
        NSString *address = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAddress"] == nil ? @"请选择" : [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAddress"];
        cell.textF.text = @[name, phone, @"", address][indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100.0;
    }
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 35.0;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.isShowAway) {
        if (section == 0) {
            return 0.0;
        }
    }else {
        if (section == 0) {
            return 50.0;
        }
    }
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(13);
    label.textColor = SetColor(110, 110, 110, 1);
    label.text = @"店铺名称";
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, 0));
    }];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    if (section == 0) {
        self.footView = [[Boat_footerView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 40)];
        self.footView.backgroundColor = [UIColor whiteColor];
        self.footView.delegate = self;
        [view addSubview:self.footView];
        return view;
    }
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(13);
    label.textColor = SetColor(110, 110, 110, 1);
    label.text = @"支付10%，剩余90%到店支付。";
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, 0));
    }];
    return view;
}

- (void)getWayIndex:(NSInteger)index {
    if (index == 0) {
        selectIndex = 2;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }else {
        selectIndex = 4;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 3) {
        SelectAddressViewController *address = [[SelectAddressViewController alloc] init];
        __weak typeof(self) weakSelf = self;
        address.returnAddress = ^(NSString *string, NSString *name, NSString *phone) {
            weakSelf.address = string;
            NSLog(@"address === %@", string);
            [weakSelf getTableviewForCell:[NSIndexPath indexPathForRow:0 inSection:1]].textF.text = name;
            [weakSelf getTableviewForCell:[NSIndexPath indexPathForRow:1 inSection:1]].textF.text = phone;
            [weakSelf getTableviewForCell:[NSIndexPath indexPathForRow:3 inSection:1]].textF.text = string;
            //            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableView reloadData];
        };
        
//        address.returnAddress = ^(NSString *string) {
//            weakSelf.address = string;
//            NSLog(@"address === %@", string);
//            [weakSelf getTableviewForCell:[NSIndexPath indexPathForRow:3 inSection:1]].textF.text = string;
////            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
//            [weakSelf.tableView reloadData];
//        };
        [self.navigationController pushViewController:address animated:YES];
    }
}

//提交信息
- (void)submitInfo {
    NSString *name = [self getTableviewForCell:[NSIndexPath indexPathForRow:0 inSection:1]].textF.text;
    NSString *phone = [self getTableviewForCell:[NSIndexPath indexPathForRow:1 inSection:1]].textF.text;
    NSString *remark = [self getTableviewForCell:[NSIndexPath indexPathForRow:2 inSection:1]].textF.text;
    NSString *address = [self getTableviewForCell:[NSIndexPath indexPathForRow:3 inSection:1]].textF.text;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAddress"]) {
        address = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAddress"];
    }
    
    if (!self.dataDic) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"无数据"];
        return;
    }else if ([name isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入姓名"];
        return;
    }else if ([phone isEqualToString:@""] && ![self valiMobile:phone]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入电话或输入格式错误"];
        return;
    }else if ([address isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入地址"];
        return;
    }
    
    ShoppingListViewController *list = [[ShoppingListViewController alloc] init];
    list.firstShoppingArray = @[self.dataDic];
    list.order_type = self.order_type;
    list.after_type = self.after_type;
    list.number = self.number;
    list.sum_price = [NSString stringWithFormat:@"¥%@", self.dataDic[@"price"] ?: self.dataDic[@"goods_price"]];
    list.name = name;//[self getTableviewForCell:[NSIndexPath indexPathForRow:0 inSection:1]].textF.text;
    list.phone = phone;//[self getTableviewForCell:[NSIndexPath indexPathForRow:1 inSection:1]].textF.text;
    list.remark = remark;//[self getTableviewForCell:[NSIndexPath indexPathForRow:2 inSection:1]].textF.text;
    list.address = address;//[self getTableviewForCell:[NSIndexPath indexPathForRow:3 inSection:1]].textF.text;
    [self.navigationController pushViewController:list animated:YES];
}

- (CustomTableViewCell *)getTableviewForCell:(NSIndexPath *)indexPaht {
    return (CustomTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPaht];
}

//判断手机号码格式是否正确
- (BOOL)valiMobile:(NSString *)mobile {
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11) {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else {
            return NO;
        }
    }
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
