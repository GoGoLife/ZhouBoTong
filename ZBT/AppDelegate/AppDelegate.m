//
//  AppDelegate.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/3.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "AppDelegate.h"
#import "LBTabBarController.h"
#import <BMKLocationKit/BMKLocationAuth.h>
#import "AppDelegate+UShare.h"
#import "BuySellViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import <IQKeyboardManager.h>
#import <AFNetworking.h>
#import "BindPhoneViewController.h"
#import <BMKLocationKit/BMKLocationComponent.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "AppDelegate+HuanXin.h"
#import <WXApi.h>

#define WX_ACCESS_TOKEN @"wx_token"
#define WX_OPEN_ID @"open_id"
#define WX_REFRESH_TOKEN @"wx_refresh_token"
#define WX_APPID @"wxb1f7815161e4dbc1"
#define WX_APPSECRET @"ebdc6e9172354f0eaf5f97df16925e6d"


//舟博通微信
//APPID：
// appsecret: ebdc6e9172354f0eaf5f97df16925e6d



@interface AppDelegate ()<UITabBarControllerDelegate, BMKLocationAuthDelegate, BMKLocationManagerDelegate, QQApiInterfaceDelegate>

@property (nonatomic, strong) BMKLocationManager *manager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"account"] || [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"]) {
        [self setHomeVC];
    }else {
        [self setLoginVC];
    }
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    
    //注册百度地图API        gqVj3EM4A0sH1dMhQMKxbGucZMgbCjhA     G5D0r4BzFCPc2vQSQTMusvFjzFj6pEVP
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"pZPRpwNvRg3G9icE4vvDYI4tTHw90ITZ" authDelegate:self];
    
    //友盟分享
    [self UMengShareApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    //微信注册
//    [self WXLoginApplication:application didFinishLaunchingWithOptions:launchOptions];
    [WXApi registerApp:@"wxb1f7815161e4dbc1"];
    
    //环信
    [self HuanXin_application:application didFinishLaunchingWithOptions:launchOptions];
    [self Huanxin_Register];
    
    //获取定位
    [self.manager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        NSLog(@"location === %@", location);
        NSLog(@"state === %d", state);
        NSLog(@"error === %@", error);
        NSLog(@"city === %@", location.rgcData.city);
        NSString *Location_info = [NSString stringWithFormat:@"%@%@%@%@", location.rgcData.province, location.rgcData.city, location.rgcData.district, location.rgcData.street];
        [[NSUserDefaults standardUserDefaults] setObject:location.rgcData.city forKey:@"currentCity"];
        [[NSUserDefaults standardUserDefaults] setObject:Location_info forKey:@"Location_info"];
    }];
    
    
    
//    NSLog(@"viewControllers ==== %@", )
    
    
    return YES;
}

- (void)setHomeVC {
    LBTabBarController *tabBarVc = [[LBTabBarController alloc] init];
    tabBarVc.delegate = self;
    self.window.rootViewController = tabBarVc;
    [self.window makeKeyAndVisible];
}

- (void)setLoginVC {
    LoginViewController *login = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}


-(void)showLoginController:(BOOL)shouldAnimation {
    LoginViewController *loginController=[[LoginViewController alloc]init];

    loginController.requestForUserInfoBlock = ^() {

        [self wechatLoginByRequestForUserInfo];
    };
    

//    BaseNavigationController *baseNavController=[[BaseNavigationController alloc]initWithRootViewController:loginController];
//    [kAppDelegate.window.rootViewController presentViewController:baseNavController animated:shouldAnimation completion:NULL];
}

// AppDelegate.m
// 获取用户个人信息（UnionID机制）
- (void)wechatLoginByRequestForUserInfo {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    NSString *userUrlStr = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", @"https://api.weixin.qq.com/sns", accessToken, openID];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:userUrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求用户信息的response = %@", responseObject);
        [self validationBindPhone:responseObject[@"openid"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取用户信息时出错 = %@", error);
    }];
}

//验证是否已经绑定过手机号    微信登录
- (void)validationBindPhone:(NSString *)open_id {
    NSString *url = @"https://zbt.change-word.com/index.php/home/login/bindingPhone";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"weixin_id" : open_id};
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
            bind.WX_id = open_id;
            bind.type = 1;
            [self.window.rootViewController.childViewControllers.firstObject.navigationController pushViewController:bind animated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self HuanXin_applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [self HuanXin_applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    if ([TencentOAuth HandleOpenURL:url]) {
//        return [TencentOAuth HandleOpenURL:url];
//    }
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    if ([TencentOAuth HandleOpenURL:url]) {
//        return [TencentOAuth HandleOpenURL:url];
//    }
//    return [WXApi handleOpenURL:url delegate:self];
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }else if ([url.host isEqualToString:@"pay"]) {
        // 处理微信的支付结果
        [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options {
    
    NSLog(@"url ==== %@", url.host);

    //支付宝回调
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }else if ([url.host isEqualToString:@"pay"]) {
        // 处理微信的支付结果
        [WXApi handleOpenURL:url delegate:self];
        return YES;
    }
    
    /**
     处理由手Q唤起的跳转请求
     \param url 待处理的url跳转请求
     \param delegate 第三方应用用于处理来至QQ请求及响应的委托对象
     \return 跳转请求处理结果，YES表示成功处理，NO表示不支持的请求协议或处理失败
     */
    if ([TencentOAuth HandleOpenURL:url]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    
    //微信回调
    if ([url.host isEqualToString:@"oauth"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    //友盟回调
    return [self UMengApplication:app openURL:url options:options];
    
    return NO;
}

#pragma mark ---- tabbarcontrollerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController.childViewControllers.firstObject.class isEqual:BuySellViewController.class]) {
        static NSString *tabBarDidSelectedNotification = @"tabBarDidSelectedNotification";
        //当tabBar被点击时发出一个通知
        [[NSNotificationCenter defaultCenter] postNotificationName:tabBarDidSelectedNotification object:nil userInfo:nil];
    }
}

// 授权后回调
// AppDelegate.m
- (void)onResp:(BaseResp *)resp {
    NSLog(@"afadfsdfsfadsfdsfa");
    // 向微信请求授权后,得到响应结果
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
        NSLog(@"code ==== %@", temp.code);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        NSDictionary *parme = @{
                                @"appid" : WX_APPID,
                                @"secret" : WX_APPSECRET,
                                @"code" : temp.code,
                                @"grant_type" : @"authorization_code"
                                };

//        NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", @"https://api.weixin.qq.com/sns", WX_APPID, WX_APPSECRET, temp.code];
        [manager POST:@"https://api.weixin.qq.com/sns/oauth2/access_token" parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"请求access的response = %@", responseObject);
            NSDictionary *accessDict = [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *accessToken = [accessDict objectForKey:@"access_token"];
            NSString *openID = [accessDict objectForKey:@"openid"];
            NSString *refreshToken = [accessDict objectForKey:@"refresh_token"];
            //本地持久化，以便access_token的使用、刷新或者持续
            if (accessToken && ![accessToken isEqualToString:@""] && openID && ![openID isEqualToString:@""]) {
                [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:WX_ACCESS_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:openID forKey:WX_OPEN_ID];
                [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:WX_REFRESH_TOKEN];
                [[NSUserDefaults standardUserDefaults] synchronize]; // 命令直接同步到文件里，来避免数据的丢失
            }
            [self wechatLoginByRequestForUserInfo];
//            [self validationBindPhone:responseObject[@"openid"]];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"获取access_token时出错 = %@", error);
        }];
    }
    
    
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付结果：成功！";
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                break;
            case -2:
                payResoult = @"用户已经退出支付！";
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
        NSLog(@"payResoult === %@", payResoult);
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:payResoult preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[weakSelf getCurrentVC].navigationController popToRootViewControllerAnimated:YES];
        }];
        
        [alert addAction:action];
        [alert addAction:action1];
        
        [[self getCurrentVC] presentViewController:alert animated:YES completion:nil];
        
    }
    
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    
    UIViewController *result = nil;
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    do {
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)rootVC;
            UIViewController *vc = [navi.viewControllers lastObject];
            result = vc;
            rootVC = vc.presentedViewController;
            continue;
        } else if([rootVC isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)rootVC;
            result = tab;
            rootVC = [tab.viewControllers objectAtIndex:tab.selectedIndex];
            continue;
        } else if([rootVC isKindOfClass:[UIViewController class]]) {
            result = rootVC;
            rootVC = nil;
        }
    } while (rootVC != nil);
    
    return result;
}

- (void)onReq:(BaseReq *)req {

}

// 懒加载    用于获取定位
- (BMKLocationManager *)manager {
    if (!_manager) {
        _manager = [[BMKLocationManager alloc] init];
        //设置delegate
        _manager.delegate = self;
        //设置返回位置的坐标系类型
        _manager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _manager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _manager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        //        _manager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
        //        _manager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        _manager.locationTimeout = 10;
        //设置获取地址信息超时时间
        _manager.reGeocodeTimeout = 10;
    }
    return _manager;
}
@end
