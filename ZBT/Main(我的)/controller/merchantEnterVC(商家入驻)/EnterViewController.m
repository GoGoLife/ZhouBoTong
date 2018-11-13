//
//  EnterViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/30.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "EnterViewController.h"
#import "CustomTableViewCell.h"
#import <Masonry.h>
#import "Globefile.h"
#import "Enter_infoViewController.h"
#import "Info_WartfViewController.h"

@interface EnterViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSArray *buttonTitleArr;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation EnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家入驻";
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    DropView(self.tableView);
    
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    buttonTitleArr = @[@"水上玩乐", @"码头出行", @"船用设备", @"驾照培训", @"代办服务", @"售后服务"];
    
    [self setUpNav];
}
setBack();
pop();

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textF.enabled = NO;
    [cell layoutIfNeeded];
    cell.textF.delegate = self;
    cell.textF.textColor = SetColor(54, 54, 54, 1);
    cell.textF.textAlignment = NSTextAlignmentLeft;
    cell.textF.text = [@"  " stringByAppendingString:buttonTitleArr[indexPath.row]];

    CGFloat heigit = 40;
    UIImageView *leftImageV = [[UIImageView alloc] initWithFrame:FRAME(0, 0, heigit, heigit)];
    leftImageV.image = [UIImage imageNamed:@[@"wanle", @"mtcx", @"cysb", @"jzpx", @"dbfw", @"shfw"][indexPath.row]];
    [cell.textF creatLeftView:leftImageV.bounds AndControl:leftImageV];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    ViewRadius(button, 5.0);
    button.backgroundColor = SetColor(24, 148, 220, 1);
    button.titleLabel.font = SetFont(15);
    button.frame = FRAME(0, 0, 80, heigit-10);
    [button setTitle:@[@"开店申请", @"立即加盟", @"立即申请", @"立即申请", @"立即申请", @"立即加盟"][indexPath.row] forState:UIControlStateNormal];
    [cell.textF creatRightView:button.bounds AndControl:button];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)pushInfoVC {
    Enter_infoViewController *info = [[Enter_infoViewController alloc] init];
    info.leftTitleArray = @[@"联系人", @"联系电话", @"电子邮件", @"地址"];
    info.placeholderArray = @[@"请输入联系人(必填)", @"请输入姓名(必填)", @"请输入电子邮件(必填)", @"请输入地址(必填)"];
    [self.navigationController pushViewController:info animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:             //水上娱乐
        {
            Enter_infoViewController *info = [[Enter_infoViewController alloc] init];
            info.title = @"水上娱乐";
            info.type = 1;
            info.leftTitleArray = @[@"联系人", @"联系电话", @"电子邮件", @"地址"];
            info.placeholderArray = @[@"请输入联系人(必填)", @"请输入联系电话(必填)", @"请输入电子邮件(必填)", @"请输入地址(必填)"];
            [self.navigationController pushViewController:info animated:YES];
        }
            break;
        case 1:             //码头出行
        {
            Info_WartfViewController *info = [[Info_WartfViewController alloc] init];
            info.title = @"码头出行";
            info.type = 2;
            info.leftTitleArray = @[@"联系人", @"联系电话", @"电子邮件", @"船舶类型", @"码头地址"];
            info.placeholderArray = @[@"请输入负责人(必填)", @"请输入联系电话(必填)", @"请输入电子邮件(必填)", @"请选择", @"请输入码头地址(必填)"];
            [self.navigationController pushViewController:info animated:YES];
        }
            break;
        case 2:             //船用设备
        {
            Enter_infoViewController *info = [[Enter_infoViewController alloc] init];
            info.title = @"船用设备";
            info.type = 3;
            info.leftTitleArray = @[@"联系人", @"联系电话", @"电子邮件", @"码头地址"];
            info.placeholderArray = @[@"请输入商家名称(必填)", @"请输入联系电话(必填)", @"请输入电子邮件(必填)", @"请输入码头地址(必填)"];
            [self.navigationController pushViewController:info animated:YES];
        }
            break;
        case 3:             //驾照培训
        {
            Enter_infoViewController *info = [[Enter_infoViewController alloc] init];
            info.title = @"驾照培训";
            info.type = 4;
            info.leftTitleArray = @[@"联系人", @"联系电话", @"电子邮件", @"地址"];
            info.placeholderArray = @[@"请输入联系人(必填)", @"请输入姓名(必填)", @"请输入电子邮件(必填)", @"请输入地址(必填)"];
            [self.navigationController pushViewController:info animated:YES];
        }
            break;
        case 4:             //代办服务
        {
            Enter_infoViewController *info = [[Enter_infoViewController alloc] init];
            info.title = @"代办服务";
            info.type = 5;
            info.leftTitleArray = @[@"联系人", @"联系电话", @"电子邮件", @"地址"];
            info.placeholderArray = @[@"请输入联系人(必填)", @"请输入姓名(必填)", @"请输入电子邮件(必填)", @"请输入地址(必填)"];
            [self.navigationController pushViewController:info animated:YES];
        }
            break;
        case 5:             //售后服务
        {
            Enter_infoViewController *info = [[Enter_infoViewController alloc] init];
            info.title = @"售后服务";
            info.leftTitleArray = @[@"联系人", @"联系电话", @"电子邮件", @"地址"];
            info.placeholderArray = @[@"请输入联系人(必填)", @"请输入姓名(必填)", @"请输入电子邮件(必填)", @"请输入地址(必填)"];
            [self.navigationController pushViewController:info animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}
@end
