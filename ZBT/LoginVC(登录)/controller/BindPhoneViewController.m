//
//  BindPhoneViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/7/23.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "Globefile.h"
#import "RegisterTableViewCell.h"
#import "ShowHUDView.h"

@interface BindPhoneViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UIButton *codeBtn;
    NSTimer *timer;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger seconds;

//两次验证码是否一样  结果
@property (nonatomic, strong) UILabel     *isSameLabel;

//保存后台返回的验证码
@property (nonatomic, strong) NSString *codeString;

@property (nonatomic, strong) NSString *phone;

@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"绑定手机号";
    
    // Do any additional setup after loading the view.
    [self setUpNav];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[RegisterTableViewCell class] forCellReuseIdentifier:@"cell"];
    DropView(self.tableView);
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.seconds = 60;
    
}
setBack();
pop();

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ----- tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 80)];
    
    self.isSameLabel = [[UILabel alloc] init];
    self.isSameLabel.font = [UIFont systemFontOfSize:14];
    self.isSameLabel.textColor = [UIColor redColor];
    //    self.isSameLabel.text = @"两次密码输入不一致  请重新输入";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor blueColor]];
    [button setTitle:@"确认绑定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitResgisterInfo) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(button, 5.0);
    
    [view addSubview:self.isSameLabel];
    [view addSubview:button];
    
    [self.isSameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).with.insets(UIEdgeInsetsMake(0, 15, 30, 0));
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).with.insets(UIEdgeInsetsMake(40, 15, 0, 15));
    }];
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textFiled.tag = indexPath.row;
    cell.textFiled.delegate = self;
    cell.titleString = @[@"手机号", @"验证码", @"设置密码", @"确认密码"][indexPath.row];
    cell.textFiled.placeholder = @[@"请输入手机号", @"输入验证码", @"请输入密码", @"再次确认密码"][indexPath.row];
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
        {
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
            break;
        case 2:
            cell.textFiled.secureTextEntry = YES;
            break;
        case 3:
            cell.textFiled.secureTextEntry = YES;
            break;
        default:
            break;
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
    //发送短信
    RegisterTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([self valiMobile:cell.textFiled.text]) {
        [self registerAndSendMessage:cell.textFiled.text];
    }else {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入正确的手机号码"];
    }
}

- (void)timerFunction {
    --self.seconds;
    NSString *string = [NSString stringWithFormat:@"%lds后重发", self.seconds];
    [codeBtn setTitle:string forState:UIControlStateNormal];
    if (self.seconds == 0) {
        [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        codeBtn.enabled = YES;
        [timer invalidate];
    }
}

//提交注册信息
- (void)submitResgisterInfo  {
    NSString *current_Phone = [self getTableViewCell:[NSIndexPath indexPathForRow:0 inSection:0]].textFiled.text;
    NSString *password = [self getTableViewCell:[NSIndexPath indexPathForRow:2 inSection:0]].textFiled.text;
    NSString *password1 = [self getTableViewCell:[NSIndexPath indexPathForRow:3 inSection:0]].textFiled.text;
    if ([password isEqualToString:password1] && [current_Phone isEqualToString:self.phone]) {
        NSString *url = @"https://zbt.change-word.com/index.php/home/login/threeParty";
        NSDictionary *prame = @{
                                @"phone" : self.phone,
                                @"weixin_id" : self.WX_id ?: @"",
                                @"qq_id" : self.QQ_id ?: @"",
                                @"password" : password
                                };
        NSLog(@"sss == %@", prame);
        __weak typeof(self) weakSelf = self;
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [manager POST:url parameters:prame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"submitMessage === %@", responseObject);
            if ([responseObject[@"resultCode"] integerValue] == 1) {
                [[NSUserDefaults standardUserDefaults] setObject:self.phone forKey:@"account"];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"LoginWay"];
                [self getPersonInfo_first];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate setHomeVC];
            }else {
                [ShowHUDView showHUDWithView:weakSelf.view AndTitle:responseObject[@"resultMsg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }else {
        //        [ShowHUDView showHUDWithView:self.view AndTitle:@"两次密码输入不一致，请重新输入"];
        self.isSameLabel.text = @"两次密码输入不一致，请重新输入";
        [[self getTableViewCell:[NSIndexPath indexPathForRow:3 inSection:0]].textFiled becomeFirstResponder];
    }
}

//获取个人信息
- (void)getPersonInfo_first {
//    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/index.php/home/Member/showInfo";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"phone" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account"]};
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"personInfo === %@", responseObject);
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"member_id"] forKey:@"account_id"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark ------- textFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        NSString *string = [self getTableViewCell:[NSIndexPath indexPathForRow:1 inSection:0]].textFiled.text;
        BOOL result = [string isEqualToString:[NSString stringWithFormat:@"%@", self.codeString]];
        if (!result) {
            [ShowHUDView showHUDWithView:self.view AndTitle:@"验证码错误,请重新输入"];
        }
    }
}

//注册发送验证码接口
- (void)registerAndSendMessage:(NSString *)phone {
    //    NSLog(@"phone === %@", phone);
    NSString *url = @"https://zbt.change-word.com/index.php/home/login/yzPhone";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *dic = @{
                          @"phone" : phone,
                          @"type" : @(self.type)
                          };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"message === %@", responseObject);
        if ([responseObject[@"resultCode"] integerValue] == -1) {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:responseObject[@"resultMsg"]];
        }else {
            weakSelf.phone = phone;
            weakSelf.codeString = (NSString *)responseObject[@"code"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error === %@", error);
    }];
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

- (RegisterTableViewCell *)getTableViewCell:(NSIndexPath *)indexPath {
    return [self.tableView cellForRowAtIndexPath:indexPath];
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
