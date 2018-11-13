//
//  ForgotViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/4.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ForgotViewController.h"
#import "Globefile.h"
#import <Masonry.h>
#import "RegisterTableViewCell.h"
#import "SetNewPasswordViewController.h"
#import "ShowHUDView.h"

@interface ForgotViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tableView;
    UIButton *codeBtn;
    NSTimer *timer;
    NSInteger seconds;
}

@property (nonatomic, strong) NSString *codeString;

@end

@implementation ForgotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"忘记密码";
    seconds = 60;
    
    [self setUpNav];
    
    // Do any additional setup after loading the view.
    tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[RegisterTableViewCell class] forCellReuseIdentifier:@"cell"];
    DropView(tableView);
    [self.view addSubview:tableView];
    
    __weak typeof(self) weakSelf = self;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
setBack();
pop();

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------ tableView Delegate
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
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    ViewRadius(button, 5.0);
    
    [button addTarget:self action:@selector(pushNewPasswordVC) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).with.insets(UIEdgeInsetsMake(20, 15, 0, 15));
    }];
    
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.titleString = @[@"手机号", @"验证码"][indexPath.row];
    cell.textFiled.placeholder = @[@"请输入手机号", @"输入验证码"][indexPath.row];
    if (indexPath.row == 1) {
        codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        codeBtn.frame = FRAME(0, 0, (SCREENBOUNDS.width / 4), CELLHEIGHT);
        [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [codeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [codeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
        cell.textFiled.rightView = codeBtn;
        cell.textFiled.rightView.userInteractionEnabled = YES;
        cell.textFiled.rightViewMode = UITextFieldViewModeAlways;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELLHEIGHT;
}

//获取验证码  响应方法
- (void)getCode {
    codeBtn.enabled = NO;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFunction) userInfo:nil repeats:YES];
    [timer fire];
    
    NSString *phone = [self getTableViewCell:[NSIndexPath indexPathForRow:0 inSection:0]].textFiled.text;
    
    if ([self valiMobile:phone]) {
        [self getCodeString:phone];
    }else {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入正确的手机号码"];
        [[self getTableViewCell:[NSIndexPath indexPathForRow:0 inSection:0]].textFiled becomeFirstResponder];
    }
    
}

- (void)timerFunction {
    --seconds;
    NSString *string = [NSString stringWithFormat:@"%lds后重发", seconds];
    [codeBtn setTitle:string forState:UIControlStateNormal];
    if (seconds == 0) {
        [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        codeBtn.enabled = YES;
        [timer invalidate];
    }
}

//跳转修改确认新密码
- (void)pushNewPasswordVC {
    NSString *code = [self getTableViewCell:[NSIndexPath indexPathForRow:1 inSection:0]].textFiled.text;
    if ([code isEqualToString:self.codeString]) {
        NSString *phone = [self getTableViewCell:[NSIndexPath indexPathForRow:0 inSection:0]].textFiled.text;
        SetNewPasswordViewController *new = [[SetNewPasswordViewController alloc] init];
        new.phone = phone;
        [self.navigationController pushViewController:new animated:YES];
    }else {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"验证码输入不正确"];
        [[self getTableViewCell:[NSIndexPath indexPathForRow:1 inSection:0]].textFiled becomeFirstResponder];
    }
    
}

//通过短信获取验证码
- (void)getCodeString:(NSString *)phone {
    NSString *url = @"https://zbt.change-word.com/index.php/home/Login/loginMessage";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"phone" : phone};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        weakSelf.codeString = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取cell
- (RegisterTableViewCell *)getTableViewCell:(NSIndexPath *)indexPath {
    return [tableView cellForRowAtIndexPath:indexPath];
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
