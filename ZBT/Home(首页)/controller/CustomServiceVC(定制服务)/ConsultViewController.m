//
//  ConsultViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/31.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ConsultViewController.h"
#import "CustomTableViewCell.h"
#import "Globefile.h"
#import <Masonry.h>
#import "ChangeSexView.h"
//#import "uite"

@interface ConsultViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSArray *titleArray;
    NSArray *placeholderArr;
    
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ConsultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"立刻咨询";
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    DropView(self.tableView);
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 44, 0));
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tableView.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    titleArray = @[@"手机号", @"姓名", @"性别", @"qq/微信"];
    placeholderArr = @[@"请输入手机号", @"请输入姓名", @"", @"请输入联系方式"];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell layoutIfNeeded];
    CGFloat width = [self calculateRowWidth:@"qq/微信" withFont:14];
    if (indexPath.row == 2) {
        cell.textF.delegate = self;
        [cell.textF creatLeftView:FRAME(0, 0, width, cell.textF.bounds.size.height) AndTitle:titleArray[indexPath.row] TextAligment:NSTextAlignmentLeft Font:SetFont(14) Color:SetColor(57, 57, 57, 1)];
        ChangeSexView *view = [[ChangeSexView alloc] initWithFrame:FRAME(0, 0, 120, cell.textF.bounds.size.height) withNumber:2 titleArray:@[@"先生", @"女士"]];
        [cell.textF creatRightView:view.frame AndControl:view];
    }else {
        cell.textF.placeholder = placeholderArr[indexPath.row];
        [cell.textF creatLeftView:FRAME(0, 0, width, cell.textF.bounds.size.height) AndTitle:titleArray[indexPath.row] TextAligment:NSTextAlignmentLeft Font:SetFont(14) Color:SetColor(57, 57, 57, 1)];
    }
    return cell;
}
StringWidth();

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 100.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 100.0)];
    UITextView *textV = [[UITextView alloc] init];
    textV.font = SetFont(15);
    textV.textColor = SetColor(87, 87, 87, 1);
    textV.text = @"请输入咨询信息";
    [view addSubview:textV];
    [textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(10, 0, 0, 0));
    }];
    return view;
}

#pragma mark --- textDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    [textField resignFirstResponder];
    return NO;
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
