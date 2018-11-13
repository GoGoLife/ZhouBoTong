//
//  CreatShoppingOrderViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/7/27.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "CreatShoppingOrderViewController.h"
#import "Globefile.h"
#import "CustomTableViewCell.h"
#import "SellSecondHeaderView.h"
#import "ShoppingModel.h"
#import "SelectAddressViewController.h"
#import "ShoppingListViewController.h"

@interface CreatShoppingOrderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) SellSecondHeaderView *sellView;

@end

@implementation CreatShoppingOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单明细";
    // Do any additional setup after loading the view.
    self.tableview = [[UITableView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, SCREENBOUNDS.height - 44 - 64) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"first"];
    [self.tableview registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"second"];
    
    [self.view addSubview:self.tableview];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    __weak typeof(self) weakSelf = self;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(44));
    }];
    
    
    [self setUpNav];
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
        return self.dataModel.count ?: self.firstShoppingArray.count;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"first"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataModel) {
            ShoppingModel *model = self.dataModel[indexPath.row];
            self.sellView = [[SellSecondHeaderView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 100.0)];
            self.sellView.backgroundColor = [UIColor whiteColor];
            [self.sellView.leftImageV sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage imageNamed:@"public"]];
            self.sellView.topLabel.text = model.goodsName;
            self.sellView.bottomLabel.textColor = [UIColor redColor];
            self.sellView.bottomLabel.text = [@"¥" stringByAppendingString:model.goodsPrice];
            self.sellView.numberLabel.text = [NSString stringWithFormat:@"* %ld", model.number];
            [cell.contentView addSubview:self.sellView];
        }else {
            NSDictionary *dic = self.firstShoppingArray.firstObject;
            self.sellView = [[SellSecondHeaderView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 100.0)];
            self.sellView.backgroundColor = [UIColor whiteColor];
            [self.sellView.leftImageV sd_setImageWithURL:[NSURL URLWithString:[dic[@"photo"] firstObject]] placeholderImage:[UIImage imageNamed:@"public"]];
            self.sellView.topLabel.text = dic[@"goods_name"] ?: dic[@"serve_name"];
            self.sellView.bottomLabel.textColor = [UIColor redColor];
            self.sellView.bottomLabel.text = [NSString stringWithFormat:@"¥%@", dic[@"price"] ?: dic[@"goods_price"]];//@"¥2100";
            [cell.contentView addSubview:self.sellView];
        }
        return cell;
    }
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"second"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 3) {
        cell.textF.enabled = NO;
    }
    [self setCellContentView:cell AtIndexPath:indexPath];
    return cell;
}

StringWidth();
- (void)setCellContentView:(CustomTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textF.textColor = SetColor(47, 47, 47, 1);
    cell.textF.font = SetFont(15);
    NSArray *DataArr = @[@"联系人", @"手机号码", @"备注", @"收货地址"];
    CGFloat width = [self calculateRowWidth:@"手机号码" withFont:15];
    CGFloat height = 50.0;
    [cell.textF creatLeftView:FRAME(0, 0, width, height) AndTitle:DataArr[indexPath.row] TextAligment:NSTextAlignmentLeft Font:SetFont(15) Color:SetColor(47, 47, 47, 1)];
    cell.textF.placeholder = @[@"请填写", @"请填写", @"请填写", @"请填写"][indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 3) {
        SelectAddressViewController *address = [[SelectAddressViewController alloc] init];
        __weak typeof(self) weakSelf = self;
//        address.returnAddress = ^(NSString *string) {
//            
//        };
        address.returnAddress = ^(NSString *string, NSString *name, NSString *phone) {
            ((CustomTableViewCell *)[weakSelf.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]]).textF.text = string;
            [weakSelf.tableview reloadData];
        };
        [self.navigationController pushViewController:address animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100.0;
    }
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)submitInfo {
    NSString *isRZ = [[NSUserDefaults standardUserDefaults] objectForKey:@"isRZ"];
    //判断用户是否认证
    if (![isRZ integerValue]) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前用户未实名认证，请去(个人中心)完成认证" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.tabBarController.selectedIndex = 4;
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSString *name = [self getTableviewForCell:[NSIndexPath indexPathForRow:0 inSection:1]].textF.text;
    NSString *phone = [self getTableviewForCell:[NSIndexPath indexPathForRow:1 inSection:1]].textF.text;
    NSString *remark = [self getTableviewForCell:[NSIndexPath indexPathForRow:2 inSection:1]].textF.text;
    NSString *address = [self getTableviewForCell:[NSIndexPath indexPathForRow:3 inSection:1]].textF.text;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAddress"]) {
        address = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAddress"];
    }
    
    if (!self.dataModel) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"无数据"];
        return;
    }else if ([name isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入姓名"];
        return;
    }else if ([phone isEqualToString:@""] && ![self valiMobile:phone]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入电话或输入格式不对"];
        return;
    }else if ([address isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入地址"];
        return;
    }
    
    ShoppingListViewController *list = [[ShoppingListViewController alloc] init];
    list.dataModel = self.dataModel;
    list.merchantArr = self.merchantArr;
    list.sum_price = self.sum_price;
    list.name = name;//[self getTableviewForCell:[NSIndexPath indexPathForRow:0 inSection:1]].textF.text;
    list.phone = phone;//[self getTableviewForCell:[NSIndexPath indexPathForRow:1 inSection:1]].textF.text;
    list.remark = remark;//[self getTableviewForCell:[NSIndexPath indexPathForRow:2 inSection:1]].textF.text;
    list.address = address;//[self getTableviewForCell:[NSIndexPath indexPathForRow:3 inSection:1]].textF.text;
    [self.navigationController pushViewController:list animated:YES];
}

- (CustomTableViewCell *)getTableviewForCell:(NSIndexPath *)indexPaht {
    return (CustomTableViewCell *)[self.tableview cellForRowAtIndexPath:indexPaht];
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
