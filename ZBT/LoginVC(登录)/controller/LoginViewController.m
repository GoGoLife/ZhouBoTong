//
//  LoginViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/4.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "LoginViewController.h"
#import <Masonry.h>
#import "Globefile.h"
#import "RegisterViewController.h"
#import "ForgotViewController.h"
#import "BindPhoneViewController.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#define WX_ACCESS_TOKEN @"wx_token"
#define WX_OPEN_ID @"open_id"
#define WX_REFRESH_TOKEN @"wx_refresh_token"
#define WX_APPID @"wxb1f7815161e4dbc1"

#define QQ_APP_ID @"1107050640"

@interface LoginViewController ()<TencentSessionDelegate>
{
    NSMutableArray *_permissionArray;   //权限列表
}

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UITextField *account;

@property (nonatomic, strong) UITextField *password;

@property (nonatomic, strong) NSString *QQ_OPEN_ID;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    [self creatUI];
    
    if (![WXApi isWXAppInstalled]) {
        self.WXLoginBtn.hidden = YES;
    }
    
    if (![QQApiInterface isQQInstalled]) {
        self.QQLoginBtn.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated {
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

- (void)creatUI {
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:@"logo"];
    
    UILabel *label = [[UILabel alloc] init];
    
    [self.view addSubview:imgV];
    [self.view addSubview:label];
    
    CGFloat insertTopHeight = 0.0;
    if (IS_IPHONE_X) {
        insertTopHeight = 96 + 80;
    }else {
        insertTopHeight = 80;
    }
    
    __weak typeof(self) weakSelf = self;
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(insertTopHeight);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREENBOUNDS.width / 4, SCREENBOUNDS.width / 4 + 50));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(imgV.mas_bottom).offset(10);
//        make.left.equalTo(imgV.mas_left);
//        make.right.equalTo(imgV.mas_right);
    }];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(30);
        make.right.equalTo(weakSelf.view.mas_right).offset(-30);
        make.top.equalTo(imgV.mas_bottom).offset(40);
        make.height.mas_equalTo(@(120));
    }];
    
    
    //账号 密码
    
    UIImageView *shouji = [[UIImageView alloc] init];
    shouji.image = [UIImage imageNamed:@"shouji"];
    
    
    self.account = [[UITextField alloc] init];
    self.account.placeholder = @"请输入账号";
    
    UIImageView *mima = [[UIImageView alloc] init];
    mima.image = [UIImage imageNamed:@"mima"];
    
    self.password = [[UITextField alloc] init];
    self.password.placeholder = @"请输入密码";
    self.password.secureTextEntry = YES;
    
    [self.contentView addSubview:shouji];
    [self.contentView addSubview:self.account];
    [self.contentView addSubview:mima];
    [self.contentView addSubview:self.password];
    
    //账号  密码
    [shouji mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shouji.mas_right).offset(10);
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(@(60));
    }];
    
    [mima mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shouji.mas_left);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.account.mas_left).offset(0);
        make.top.equalTo(weakSelf.account.mas_bottom);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(@(60));
//        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(45, 0, 0, 0));
    }];
    
    //用户协议
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundColor:[UIColor redColor]];
    
    [button setImage:[UIImage imageNamed:@"xuanquhou"] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"xuanquqian"] forState:UIControlStateNormal];
    
    [button setTitle:@"用户协议" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.top.equalTo(weakSelf.contentView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    //忘记密码
    UIButton *forgetPass = [UIButton buttonWithType:UIButtonTypeCustom];
//    forgetPass.backgroundColor = [UIColor redColor];
    [forgetPass setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPass setTitleColor:SetColor(22, 129, 192, 1) forState:UIControlStateNormal];
    forgetPass.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [forgetPass addTarget:self action:@selector(pushForgotVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:forgetPass];
    
    [forgetPass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.top.equalTo(weakSelf.contentView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    //登录
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.layer.cornerRadius = 5.0;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn setBackgroundColor:SetColor(24, 147, 219, 1)];
    [loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(pushHomeVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginBtn];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(30);
        make.right.equalTo(weakSelf.view.mas_right).offset(-30);
        make.top.equalTo(forgetPass.mas_bottom).offset(40);
        make.height.mas_equalTo(@(44));
    }];
    
    //立即注册
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:SetColor(22, 129, 192, 1) forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(pushRegisterVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:registerBtn];
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(80, 30));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    NSArray *titleArray = @[@"qq", @"weixin"];
    
    self.QQLoginBtn = [[UIButton alloc] init];
    self.QQLoginBtn.layer.masksToBounds = YES;
    self.QQLoginBtn.layer.cornerRadius = 30.0;
    [self.QQLoginBtn setBackgroundImage:[UIImage imageNamed:titleArray[0]] forState:UIControlStateNormal];
    self.QQLoginBtn.tag = 200;
    [self.QQLoginBtn addTarget:self action:@selector(LoginForOther:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.QQLoginBtn];
    
    [self.QQLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registerBtn.mas_bottom).offset(25);
        make.left.equalTo(weakSelf.view.mas_left).offset(SCREENBOUNDS.width / 3 - 10 );
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    self.WXLoginBtn = [[UIButton alloc] init];
    self.WXLoginBtn.layer.masksToBounds = YES;
    self.WXLoginBtn.layer.cornerRadius = 30.0;
    [self.WXLoginBtn setBackgroundImage:[UIImage imageNamed:titleArray[1]] forState:UIControlStateNormal];
    self.WXLoginBtn.tag = 201;
    [self.WXLoginBtn addTarget:self action:@selector(LoginForOther:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.WXLoginBtn];
    
    [self.WXLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registerBtn.mas_bottom).offset(25);
        make.left.equalTo(weakSelf.QQLoginBtn.mas_right).offset(30 );
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}
    
    
    
//    //微信  扣扣  三方登录
//    for (int index = 0; index < 2; index++) {
//        UIButton *imgBtn = [[UIButton alloc] init];
//        imgBtn.layer.masksToBounds = YES;
//        imgBtn.layer.cornerRadius = 30.0;
//        [imgBtn setBackgroundImage:[UIImage imageNamed:titleArray[index]] forState:UIControlStateNormal];
//        [imgBtn addTarget:self action:@selector(LoginForOther:) forControlEvents:UIControlEventTouchUpInside];
//        imgBtn.tag = index + 200;
//        [self.view addSubview:imgBtn];
//
//        [imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(registerBtn.mas_bottom).offset(30);
//            make.left.equalTo(weakSelf.view.mas_left).offset(SCREENBOUNDS.width / 3 - 10 + (30 + 60) * index);
//            make.size.mas_equalTo(CGSizeMake(60, 60));
//        }];
//    }
//}

//切换用户协议按钮的图片方法
- (void)touchButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}

//跳转立即注册
- (void)pushRegisterVC {
    RegisterViewController *regis = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:regis animated:YES];
}

//跳转忘记密码
- (void) pushForgotVC {
    ForgotViewController *forgot = [[ForgotViewController alloc] init];
    [self.navigationController pushViewController:forgot animated:YES];
}

//跳转到已经登录的界面
- (void)pushHomeVC {
    [self login];
}

- (void)login {
    NSString *url = @"https://zbt.change-word.com/index.php/home/login/login";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"phone" : self.account.text,
                            @"password" : self.password.text,
                            @"type" : @"2"
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"loginMessage === %@", responseObject);
        if ([responseObject[@"resultCode"] integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", responseObject[@"member_id"]] forKey:@"account_id"];
            [[NSUserDefaults standardUserDefaults] setObject:self.account.text forKey:@"account"];
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate setHomeVC];
        }else {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:responseObject[@"resultMsg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)LoginForOther:(UIButton *)sender {
    NSLog(@"2222222222222211111111111");
    if (sender.tag == 200) {
        NSLog(@"QQQQQQQQQQQQQQQ");
        [self QQ_LoginAction];
    }else {
        NSLog(@"WXWXWXWXWXWXWXWX");
//        [self WXLogin];
        [self wechatLoginClick:sender];
    }
}

- (void) wechatLoginClick:(id)sender {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    // 如果已经请求过微信授权登录，那么考虑用已经得到的access_token
    if (accessToken && openID) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_REFRESH_TOKEN];
        NSString *refreshUrlStr = [NSString stringWithFormat:@"%@/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@", @"https://api.weixin.qq.com/sns", WX_APPID, refreshToken];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        [manager GET:refreshUrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"请求reAccess的response```````` = %@", responseObject);
            NSDictionary *refreshDict = [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *reAccessToken = [refreshDict objectForKey:@"refresh_token"];
            // 如果reAccessToken为空,说明reAccessToken也过期了,反之则没有过期
            if (reAccessToken && [[NSUserDefaults standardUserDefaults] objectForKey:@"account"]) {
                // 更新access_token、refresh_token、open_id
                [[NSUserDefaults standardUserDefaults] setObject:reAccessToken forKey:@"refresh_token"];
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:WX_OPEN_ID] forKey:WX_OPEN_ID];
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:WX_REFRESH_TOKEN] forKey:WX_REFRESH_TOKEN];
                [[NSUserDefaults standardUserDefaults] synchronize];
                // 当存在reAccessToken不为空时直接执行AppDelegate中的wechatLoginByRequestForUserInfo方法
//                !self.requestForUserInfoBlock ? : self.requestForUserInfoBlock();
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [delegate wechatLoginByRequestForUserInfo];
            }
            else {
                [self wechatLogin];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"用refresh_token来更新accessToken时出错 = %@", error);
        }];
    }else {
        [self wechatLogin];
    }
}
- (void)wechatLogin {
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"GSTDoctorApp";
        [WXApi sendReq:req];
    }
    else {
        [self setupAlertController];
    }
}
#pragma mark - 设置弹出提示语
- (void)setupAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark ------- QQ三方登录
- (void)QQ_LoginAction {
    
    self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQ_APP_ID andDelegate:self];
    
    //设置权限数据 ， 具体的权限名，在sdkdef.h 文件中查看。
    _permissionArray = [NSMutableArray arrayWithObjects: kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, nil];
    
    //登录操作
    [self.tencentOAuth authorize:_permissionArray inSafari:NO];
    //调起QQ登录
//    [_tencentOAuth authorize:_permissionArray localAppId:QQ_APP_ID inSafari:NO];
}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    /** Access Token凭证，用于后续访问各开放接口 */
    if (_tencentOAuth.accessToken) {
        //获取用户信息。 调用这个方法后，qq的sdk会自动调用
        //- (void)getUserInfoResponse:(APIResponse*) response
        //这个方法就是 用户信息的回调方法。
        [self.tencentOAuth getUserInfo];
        self.QQ_OPEN_ID = _tencentOAuth.openId;
    }else{
        NSLog(@"accessToken 没有获取成功");
    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled) {
        NSLog(@" 用户点击取消按键,主动退出登录");
    }else{
        NSLog(@"其他原因， 导致登录失败");
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    NSLog(@"没有网络了， 怎么登录成功呢");
}


/**
 * 因用户未授予相应权限而需要执行增量授权。在用户调用某个api接口时，如果服务器返回操作未被授权，则触发该回调协议接口，由第三方决定是否跳转到增量授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \param permissions 需增量授权的权限列表。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启增量授权流程。若需要增量授权请调用\ref TencentOAuth#incrAuthWithPermissions: \n注意：增量授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions{
    
    // incrAuthWithPermissions是增量授权时需要调用的登录接口
    // permissions是需要增量授权的权限列表
    [tencentOAuth incrAuthWithPermissions:permissions];
    return NO; // 返回NO表明不需要再回传未授权API接口的原始请求结果；
    // 否则可以返回YES
}

/**
 * [该逻辑未实现]因token失效而需要执行重新登录授权。在用户调用某个api接口时，如果服务器返回token失效，则触发该回调协议接口，由第三方决定是否跳转到登录授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启重新登录授权流程。若需要重新登录授权请调用\ref TencentOAuth#reauthorizeWithPermissions: \n注意：重新登录授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth{
    return YES;
}

/**
 * 用户通过增量授权流程重新授权登录，token及有效期限等信息已被更新。
 * \param tencentOAuth token及有效期限等信息更新后的授权实例对象
 * \note 第三方应用需更新已保存的token及有效期限等信息。
 */
- (void)tencentDidUpdate:(TencentOAuth *)tencentOAuth{
    NSLog(@"增量授权完成");
    if (tencentOAuth.accessToken
        && 0 != [tencentOAuth.accessToken length])
    { // 在这里第三方应用需要更新自己维护的token及有效期限等信息
        // **务必在这里检查用户的openid是否有变更，变更需重新拉取用户的资料等信息** _labelAccessToken.text = tencentOAuth.accessToken;
    }
    else
    {
        NSLog(@"增量授权不成功，没有获取accesstoken");
    }
    
}

/**
 * 用户增量授权过程中因取消或网络问题导致授权失败
 * \param reason 授权失败原因，具体失败原因参见sdkdef.h文件中\ref UpdateFailType
 */
- (void)tencentFailedUpdate:(UpdateFailType)reason{
    
    switch (reason)
    {
        case kUpdateFailNetwork:
        {
            //            _labelTitle.text=@"增量授权失败，无网络连接，请设置网络";
            NSLog(@"增量授权失败，无网络连接，请设置网络");
            break;
        }
        case kUpdateFailUserCancel:
        {
            //            _labelTitle.text=@"增量授权失败，用户取消授权";
            NSLog(@"增量授权失败，用户取消授权");
            break;
        }
        case kUpdateFailUnknown:
        default:
        {
            NSLog(@"增量授权失败，未知错误");
            break;
        }
    }
    
    
}

/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response{
    NSLog(@" info ==  response111 %@",response.jsonResponse);
    [self validationBindPhone];
}

//验证是否已经绑定过手机号    QQ登录
- (void)validationBindPhone {
    NSString *url = @"https://zbt.change-word.com/index.php/home/login/bindingPhone";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"qq_id" : self.QQ_OPEN_ID};
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"loginMessage === %@", responseObject);
        if ([responseObject[@"resultCode"] integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", responseObject[@"data"][@"member_id"]] forKey:@"account_id"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"phone"] forKey:@"account"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"LoginWay"];
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate setHomeVC];
        }else {
            BindPhoneViewController *bind = [[BindPhoneViewController alloc] init];
            bind.QQ_id = self.QQ_OPEN_ID;
            bind.type = 2;
            [self.navigationController pushViewController:bind animated:YES];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



@end
