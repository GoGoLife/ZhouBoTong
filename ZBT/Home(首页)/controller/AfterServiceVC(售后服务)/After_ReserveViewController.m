//
//  After_ReserveViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/6.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "After_ReserveViewController.h"
#import "SellSecondHeaderView.h"
#import "CustomTableViewCell.h"
#import "Globefile.h"

@interface After_ReserveViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation After_ReserveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"立即预定";
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50.0;
    
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 74, 0));
    }];
    
    //高度20
    UILabel *remarkLabel = [[UILabel alloc] init];
    remarkLabel.font = SetFont(11);
    remarkLabel.textColor = Color176;
    remarkLabel.text = @"注：商家修改余幅定金金额（10% ~ 100%）需要向平台申请";
    
    //高度44
    UITextField *bottomF = [[UITextField alloc] init];
    bottomF.backgroundColor = [UIColor whiteColor];
    bottomF.textColor = [UIColor redColor];
    bottomF.text = [@"  " stringByAppendingString:@"¥1400"];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = FRAME(0, 0, 120, 44);
    [rightButton setTitle:@"去支付" forState:UIControlStateNormal];
    [rightButton setBackgroundColor:[UIColor redColor]];
    [rightButton addTarget:self action:@selector(choosePayWay) forControlEvents:UIControlEventTouchUpInside];
    [bottomF creatRightView:rightButton.frame AndControl:rightButton];
    
    [self.view addSubview:remarkLabel];
    [self.view addSubview:bottomF];
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textF.placeholder = @"请留下您的联系方式";
    CGFloat width = [self calculateRowWidth:@"手机号" withFont:14];
    [cell layoutIfNeeded];
    [cell.textF creatLeftView:FRAME(0, 0, width, cell.textF.bounds.size.height) AndTitle:@"手机号" TextAligment:NSTextAlignmentLeft Font:SetFont(14) Color:SetColor(57, 57, 57, 1)];
    return cell;
}
StringWidth();

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 100.0;
    }else if (section == 2) {
        return 50.0;
    }else {
        return 0.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 20.0;
    }
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        SellSecondHeaderView *sell = [[SellSecondHeaderView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 100.0)];
        sell.backgroundColor = [UIColor whiteColor];
        sell.topLabel.text = @"出海捕鱼";
        sell.bottomLabel.textColor = [UIColor redColor];
        sell.bottomLabel.text = @"¥2100";
        return sell;
    }else if(section == 2) {
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
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 20.0)];
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = SetFont(12);
        label.textColor = Color176;
        label.text = @"支付10%，剩余14000到店支付。";
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, 0));
        }];
        return view;
    }
    return nil;
}

- (void)choosePayWay {
    UIAlertController *sheetView = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"银行卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
//    [sheetView addAction:action1];
    [sheetView addAction:action2];
//    [sheetView addAction:action3];
    [sheetView addAction:action4];
    
    [self presentViewController:sheetView animated:YES completion:nil];
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
