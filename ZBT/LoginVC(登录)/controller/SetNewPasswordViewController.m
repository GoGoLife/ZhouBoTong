//
//  SetNewPasswordViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/4.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "SetNewPasswordViewController.h"
#import "RegisterTableViewCell.h"
#import "Globefile.h"
#import "ShowHUDView.h"

@interface SetNewPasswordViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tableView;
}

@end

@implementation SetNewPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"忘记密码";
    // Do any additional setup after loading the view.
    
    tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[RegisterTableViewCell class] forCellReuseIdentifier:@"cell"];
    DropView(tableView);
    [self.view addSubview:tableView];
    
    __weak typeof(self) weakSelf = self;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
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

#pragma mark ----- tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.titleString = @[@"设置新密码", @"确认新密码"][indexPath.row];
    cell.textFiled.placeholder = @[@"请输入新密码", @"确认新密码"][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELLHEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 60)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor blueColor]];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    ViewRadius(button, 5.0);
    [button addTarget:self action:@selector(submitNewPassword) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).with.insets(UIEdgeInsetsMake(20, 15, 0, 15));
    }];
    
    return view;
}

- (void)submitNewPassword {
    __weak typeof(self) weakSelf = self;
    NSString *password = [self getTableViewCell:[NSIndexPath indexPathForRow:0 inSection:0]].textFiled.text;
    NSString *password1 = [self getTableViewCell:[NSIndexPath indexPathForRow:1 inSection:0]].textFiled.text;
    if ([password isEqualToString:password1]) {
        NSString *url = @"https://zbt.change-word.com/index.php/home/login/resetPass";
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        NSDictionary *parme = @{@"phone" : self.phone,
                                @"password" : password,
                                @"password1" : password1
                                };
        [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"密码修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }else {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"两次密码输入不一致，请重新输入"];
    }
}

//获取cell
- (RegisterTableViewCell *)getTableViewCell:(NSIndexPath *)indexPath {
    return [tableView cellForRowAtIndexPath:indexPath];
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
