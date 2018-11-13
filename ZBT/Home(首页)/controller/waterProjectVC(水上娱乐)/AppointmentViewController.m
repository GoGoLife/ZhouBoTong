//
//  AppointmentViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/24.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "AppointmentViewController.h"
#import "SellSecondHeaderView.h"
#import "CustomTableViewCell.h"
#import "Globefile.h"
#import "ChangeSexView.h"
#import "ShowHUDView.h"
#import "ShoppingListViewController.h"

#import <AlipaySDK/AlipaySDK.h>

@interface AppointmentViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ChangSexDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger sexIndex;

@end

@implementation AppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"立即预约";
    // Do any additional setup after loading the view.
    [self creatUI];
}

- (void)creatUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //高度20
    UILabel *remarkLabel = [[UILabel alloc] init];
    remarkLabel.font = SetFont(11);
    remarkLabel.textColor = Color176;
    remarkLabel.text = @"注：商家修改余幅定金金额（10% ~ 100%）需要向平台申请";
    
    //高度44
    UITextField *bottomF = [[UITextField alloc] init];
    bottomF.backgroundColor = [UIColor whiteColor];
    bottomF.textColor = [UIColor redColor];
//    bottomF.text = [@"  " stringByAppendingString:@"¥1400"];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = FRAME(0, 0, 120, 44);
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightButton setBackgroundColor:[UIColor redColor]];
    [rightButton addTarget:self action:@selector(choosePayWay) forControlEvents:UIControlEventTouchUpInside];
    [bottomF creatRightView:rightButton.frame AndControl:rightButton];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:remarkLabel];
    [self.view addSubview:bottomF];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.top.equalTo(weakSelf.view.mas_top);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(SCREENBOUNDS.height - 44 - 10 - 20));
    }];
    
    [bottomF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(@(44));
    }];
    
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(25);
        make.right.equalTo(weakSelf.view.mas_right).offset(-25);
        make.bottom.equalTo(bottomF.mas_top).offset(-10);
        make.height.mas_equalTo(@(20));
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}
StringWidth();
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textF.textAlignment = NSTextAlignmentRight;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat width = [self calculateRowWidth:@"手机号" withFont:14];
    [cell layoutIfNeeded];
    switch (indexPath.row) {
        case 0:
        {
            cell.textF.placeholder = @"请留下您的联系方式";
            [cell.textF creatLeftView:FRAME(0, 0, width, cell.textF.bounds.size.height) AndTitle:@"手机号" TextAligment:NSTextAlignmentLeft Font:SetFont(14) Color:SetColor(57, 57, 57, 1)];
        }
            break;
        case 1:
        {
            cell.textF.placeholder = @"请留下您的姓名";
            [cell.textF creatLeftView:FRAME(0, 0, width, cell.textF.bounds.size.height) AndTitle:@"姓名" TextAligment:NSTextAlignmentLeft Font:SetFont(14) Color:SetColor(57, 57, 57, 1)];
        }
            break;
        case 2:
        {
            cell.textF.delegate = self;
            [cell.textF creatLeftView:FRAME(0, 0, width, cell.textF.bounds.size.height) AndTitle:@"姓别" TextAligment:NSTextAlignmentLeft Font:SetFont(14) Color:SetColor(57, 57, 57, 1)];
            ChangeSexView *view = [[ChangeSexView alloc] initWithFrame:FRAME(0, 0, 120, cell.textF.bounds.size.height) withNumber:2 titleArray:@[@"先生", @"女士"]];
            view.delegate = self;
            [cell.textF creatRightView:view.frame AndControl:view];
        }
            break;
        case 3:
        {
            cell.textF.placeholder = @"请输入备注";
            [cell.textF creatLeftView:FRAME(0, 0, width, cell.textF.bounds.size.height) AndTitle:@"备注" TextAligment:NSTextAlignmentLeft Font:SetFont(14) Color:SetColor(57, 57, 57, 1)];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 100.0;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        if (self.isWharfGOVC) {
            return 50.0;
        }
        return 20.0;
    }
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        SellSecondHeaderView *sell = [[SellSecondHeaderView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 100.0)];
        [sell.leftImageV sd_setImageWithURL:[NSURL URLWithString:[self.currentDataDic[@"photo"] firstObject]] placeholderImage:[UIImage imageNamed:@"public"]];
        sell.backgroundColor = [UIColor whiteColor];
        sell.topLabel.text = self.currentDataDic[@"service_name"] ?: self.currentDataDic[@"serve_name"] ?: self.currentDataDic[@"name"];//@"出海捕鱼";
        sell.bottomLabel.textColor = [UIColor redColor];
        sell.bottomLabel.text = [NSString stringWithFormat:@"￥%@", self.currentDataDic[@"price"]];//@"¥2100";
        sell.numberLabel.text = [NSString stringWithFormat:@"* %@", self.number];
        return sell;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        if (self.isWharfGOVC) {
            UIView *view = [[UIView alloc] init];//WithFrame:FRAME(0, 0, SCREENBOUNDS.width, 50.0)];
            view.backgroundColor = [UIColor whiteColor];
            UILabel *label = [[UILabel alloc] init];
            label.font = SetFont(15);
            label.text = @"支付方式";
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitleColor:Color176 forState:UIControlStateNormal];
            button.titleLabel.font = SetFont(14);
            [button setImage:[UIImage imageNamed:@"xingbie2"] forState:UIControlStateNormal];
            [button setTitle:@"在线支付" forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            
            [view addSubview:label];
            [view addSubview:button];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left).offset(10);
                make.top.equalTo(view.mas_top);
                make.centerY.equalTo(view.mas_centerY);
            }];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view.mas_right).offset(-10);
                make.top.equalTo(view.mas_top);
                make.size.mas_equalTo(CGSizeMake(70, 50.0));
            }];
            return view;
        }else {
            UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 20.0)];
            UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
            label.font = SetFont(12);
            label.textColor = Color176;
            label.textAlignment = NSTextAlignmentRight;
            label.text = @"支付10%，剩余14000到店支付。";
            [view addSubview:label];
            return view;
        }
    }
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 10.0)];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}

- (void)choosePayWay {
    NSString *name = [self getTableviewForCell:[NSIndexPath indexPathForRow:1 inSection:1]].textF.text;
    NSString *phone = [self getTableviewForCell:[NSIndexPath indexPathForRow:0 inSection:1]].textF.text;
    NSString *remark = [self getTableviewForCell:[NSIndexPath indexPathForRow:3 inSection:1]].textF.text;
    
    if (!self.currentDataDic) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"无数据"];
        return;
    }else if ([name isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入姓名"];
        return;
    }else if ([phone isEqualToString:@""] && ![self valiMobile:phone]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入电话或输入格式错误"];
        return;
    }
    
    ShoppingListViewController *list = [[ShoppingListViewController alloc] init];
    list.order_type = @"2";
    list.number = @"1";
    list.firstShoppingArray = @[self.currentDataDic];
    list.sum_price = self.currentDataDic[@"price"];
    list.name = name;//[self getTableviewForCell:[NSIndexPath indexPathForRow:1 inSection:1]].textF.text;
    list.phone = phone;//[self getTableviewForCell:[NSIndexPath indexPathForRow:0 inSection:1]].textF.text;
    list.remark = remark;//[self getTableviewForCell:[NSIndexPath indexPathForRow:3 inSection:1]].textF.text;
    list.address = @"无需地址";
    list.sex = self.sexIndex ?: 1;
    [self.navigationController pushViewController:list animated:YES];
}


#pragma mark --- textDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (CustomTableViewCell *)getTableviewForCell:(NSIndexPath *)indexPath {
    return (CustomTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
}

//返回选择的性别
- (void)returnSexIndex:(NSInteger)index {
    self.sexIndex = index + 1;
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
