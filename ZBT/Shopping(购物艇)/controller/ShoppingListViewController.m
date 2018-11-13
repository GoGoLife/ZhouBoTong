//
//  ShoppingListViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/7/26.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ShoppingListViewController.h"
#import "Globefile.h"
#import "CustomTableViewCell.h"
#import "SellSecondHeaderView.h"
#import "ShoppingModel.h"

#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

@interface ShoppingListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) SellSecondHeaderView *sellView;

@end

@implementation ShoppingListViewController

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
    [button setTitle:@"去支付" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushPayView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    __weak typeof(self) weakSelf = self;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(44));
    }];
    
    [self setUpNav];
    
    NSLog(@"data+++_+_+_+_+_+ %@", self.firstShoppingArray.firstObject);
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
    return 5;
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
            self.sellView.topLabel.text = dic[@"goods_name"] ?: dic[@"serve_name"] ?: dic[@"service_name"] ?: dic[@"title"] ?: dic[@"name"];
            self.sellView.bottomLabel.textColor = [UIColor redColor];
            self.sellView.bottomLabel.text = [NSString stringWithFormat:@"¥%@", dic[@"price"] ?: dic[@"goods_price"]];//@"¥2100";
            self.sellView.numberLabel.text = [NSString stringWithFormat:@"* %@", self.number];
            [cell.contentView addSubview:self.sellView];
        }
        return cell;
    }
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"second"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setCellContentView:cell AtIndexPath:indexPath];
    return cell;
}

StringWidth();
- (void)setCellContentView:(CustomTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        cell.textF.keyboardType = UIKeyboardTypeNumberPad;
    }
    cell.textF.enabled = NO;
    cell.textF.textColor = SetColor(47, 47, 47, 1);
    cell.textF.font = SetFont(15);
    NSArray *DataArr = @[@"联系人", @"手机号码", @"备注", @"收货地址", @"总价"];
    CGFloat width = [self calculateRowWidth:@"手机号码" withFont:15];
    CGFloat height = 50.0;
    [cell.textF creatLeftView:FRAME(0, 0, width, height) AndTitle:DataArr[indexPath.row] TextAligment:NSTextAlignmentLeft Font:SetFont(15) Color:SetColor(47, 47, 47, 1)];
    cell.textF.text = @[isNullClass(self.name), isNullClass(self.phone), isNullClass(self.remark), isNullClass(self.address), isNullClass(self.sum_price)][indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if (section == 1) {
        return 20.0;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *v = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        label.font = SetFont(14);
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor redColor];
        label.text = @"实际支付金额为总价的10%";
        [v addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(v).insets(UIEdgeInsetsMake(0, 0, 0, 10));
        }];
        return v;
    }
    return [[UIView alloc] init];
}

//选择支付方式
- (void)pushPayView {
    UIAlertController *sheetView = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    NSLog(@"orderType ====== %@", self.order_type);
    
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"银行卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __weak typeof(self) weakSelf = self;
        if (weakSelf.dataModel) {
            NSLog(@"购物车");
            [weakSelf submitInfo_goods:1];
        }else {
            if ([self.order_type isEqualToString:@"1"]) {   //订单类型
                NSLog(@"立即购买");
                [weakSelf submitInfo_buy:1];
            }else if([self.order_type isEqualToString:@"2"]) {
                NSLog(@"立即预约");
                [self submitInfoToService:1];
            }else {
                [self submitInfo_buy_person:1];
            }
        }
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __weak typeof(self) weakSelf = self;
        if (weakSelf.dataModel) {
            NSLog(@"购物车");
            [weakSelf submitInfo_goods:2];
        }else {
            if ([self.order_type isEqualToString:@"1"]) {   //订单类型
                NSLog(@"立即购买");
                [weakSelf submitInfo_buy:2];
            }else if([self.order_type isEqualToString:@"2"]) {
                NSLog(@"立即预约");
                [self submitInfoToService:2];
            }else {
                [self submitInfo_buy_person:2];
            }
        }
    }];

    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    
//    [sheetView addAction:action1];
    [sheetView addAction:action2];
    [sheetView addAction:action3];
    [sheetView addAction:action4];
    
    [self presentViewController:sheetView animated:YES completion:nil];
}

#pragma mark 微信支付方法
- (void)WechatPay:(NSDictionary *)dataDic{
    
    //需要创建这个支付对象
    PayReq *req   = [[PayReq alloc] init];
    //由用户微信号和AppID组成的唯一标识，用于校验微信用户
    req.openID = dataDic[@"appid"];//@"wxb1f7815161e4dbc1";//appid;
    // 商家id，在注册的时候给的
    req.partnerId = dataDic[@"partnerid"];//@"1487835342";//partnerid;
    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
    req.prepayId  = dataDic[@"prepayid"];//@"wx1310420642527219fae2a95f0278199680";//prepayid;
    // 根据财付通文档填写的数据和签名
    req.package  = dataDic[@"package"];//@"Sign=WXPay";//package;
    // 随机编码，为了防止重复的，在后台生成
    req.nonceStr  = dataDic[@"noncestr"];//@"O5yjDod1Vgu4R6KlTxeQZtzc8bvPNYqh";//noncestr;
    // 这个是时间戳，也是在后台生成的，为了验证支付的
    NSString * stamp = dataDic[@"timestamp"];//@"1536806527";
    req.timeStamp = stamp.intValue;
    // 这个签名也是后台做的
    req.sign = dataDic[@"sign"];//@"9684124C019B462D90F22E14A21F09DA";//sign;
    //发送请求到微信，等待微信返回onResp
    [WXApi sendReq:req];
    
    [self hidden];
    
}

//-(void)onResp:(BaseResp*)resp {
//    //启动微信支付的response
//    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
//    if([resp isKindOfClass:[PayResp class]]){
//        //支付返回结果，实际支付结果需要去微信服务器端查询
//        switch (resp.errCode) {
//            case 0:
//                payResoult = @"支付结果：成功！";
//                break;
//            case -1:
//                payResoult = @"支付结果：失败！";
//                break;
//            case -2:
//                payResoult = @"用户已经退出支付！";
//                break;
//            default:
//                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                break;
//        }
//    }
//    
//    
//}

//生成预约订单签名
- (void)submitInfoToService:(NSInteger)type {
    [self show];
    //获取当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSString *dateString = [formatter stringFromDate:date];
    
    NSDictionary *currentDataDic = [self.firstShoppingArray firstObject];
    
    NSString *url = @"https://zbt.change-word.com/index.php/home/Yuyue/saveYuyueOrder";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"merchant_id" : currentDataDic[@"merchant_id"],
                            @"service_id" : currentDataDic[@"id"] ?: currentDataDic[@"train_type_id"] ?: currentDataDic[@"serve_id"],
                            @"yuyue_name" : self.name,
                            @"phone" : self.phone,
                            @"people_number" : @(1),
                            @"sum_price" : @"100",//currentDataDic[@"price"],
                            @"appointment_time" : dateString,
                            @"type" : self.after_type == 4 ? @(4) : @(1),
                            @"sex" : self.sex == 1 ? @"男" : @"女",
                            @"info" : @"啊啊啊防辐射服",
                            @"pay_type" : @(type)
                            };
    NSLog(@"parme === %@", parme);
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"yuyueReturnString ==== %@", responseObject);
        if ([responseObject[@"type"] integerValue] == 1) {
            //支付宝支付
            NSString *sign = (NSString *)responseObject[@"data"];
            [[AlipaySDK defaultService] payOrder:sign fromScheme:@"zbtpay" callback:^(NSDictionary* resultDic) {
                NSLog(@" ==== %@",resultDic);
                [weakSelf hidden];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
        }else {
            //微信支付
            [self WechatPay:responseObject[@"data"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"yuyueReturnString Error ==== %@", error);
        [weakSelf hidden];
    }];
}

//生成实物订单详情   从购物车获取
- (void)submitInfo_goods:(NSInteger)type {
    [self show];
    NSMutableArray *firstArr = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *first_Goods = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index = 0; index < self.merchantArr.count; index++) {
        NSMutableArray *secondArr = [NSMutableArray arrayWithCapacity:1];
        NSMutableArray *goods = [NSMutableArray arrayWithCapacity:1];
        //每个商家的订单总金额
        float sum_price = 0.0;
        NSString *merchant_id = self.merchantArr[index];
        for (NSInteger j = 0; j < self.dataModel.count; j++) {
            ShoppingModel *model = ((ShoppingModel *)self.dataModel[j]);
            NSString *mer_id = model.merchantID;
            if (merchant_id == mer_id) {
                [secondArr addObject:self.dataModel[j]];
                [goods addObject:[NSString stringWithFormat:@"%@-%ld-%@", model.goodsID, model.number, model.goodsPrice]];
                sum_price += model.number * [model.goodsPrice floatValue];
            }
        }
        //将数组元素拼接成字符串
        NSString *result = [goods componentsJoinedByString:@","];
        NSDictionary *dic = @{
                              @"merchant_id" : self.merchantArr[index],
                              @"goods" : result,
                              @"order_money" : [NSString stringWithFormat:@"%.2f", sum_price],
                              @"remarks " : @""
                              };
        [firstArr addObject:secondArr];
        [first_Goods addObject:goods];
        [data addObject:dic];
    }
    
    NSDictionary *parme = @{
                            @"data" : [data mutableCopy],
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"username" : self.name,
                            @"user_phone" : self.phone,
                            @"user_address" : self.address,
                            @"total_payment" : self.sum_price,
                            @"pay_type" : @(type)
                            };
    
    NSString *url = @"https://zbt.change-word.com/index.php/home/order/orderAdd";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSLog(@"parme === %@", parme);
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"yuyueReturnString ==== %@", responseObject);
        if ([responseObject[@"type"] integerValue] == 1) {
            //支付宝支付
            NSString *sign = (NSString *)responseObject[@"data"];
            [[AlipaySDK defaultService] payOrder:sign fromScheme:@"zbtpay" callback:^(NSDictionary* resultDic) {
                NSLog(@" ==== %@",resultDic);
                [weakSelf hidden];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
        }else {
            //微信支付
            [self WechatPay:responseObject[@"data"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"yuyueReturnString Error ==== %@", error);
        [weakSelf hidden];
    }];
}

//生成实物类订单签名   点击立即购买
- (void)submitInfo_buy:(NSInteger)type {
    NSLog(@"shuju === %@", self.firstShoppingArray);
    [self show];
    NSDictionary *dic = [self.firstShoppingArray firstObject];
    NSDictionary *data = @{
                           @"merchant_id" : dic[@"merchant"][@"merchant_id"],
                           @"goods" : [NSString stringWithFormat:@"%@-%@-%@", dic[@"goods_id"], @"1", dic[@"goods_price"]],
                           @"order_money" : dic[@"goods_price"],
                           @"remarks" : @""//,
                           //@"deliver_money" : @"2.22"
                           };
    NSDictionary *parme = @{
                            @"data" : @[data],
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"username" : self.name,
                            @"user_phone" : self.phone,
                            @"user_address" : self.address,
                            @"total_payment" : self.sum_price,
                            @"pay_type" : @(type)
                            };
    NSLog(@"parme === %@", parme);
    NSString *url = @"https://zbt.change-word.com/index.php/home/order/orderAdd";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSLog(@"parme === %@", parme);
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"zhifushuju ==== %@", responseObject);
        if ([responseObject[@"type"] integerValue] == 1) {
            //支付宝支付
            NSString *sign = (NSString *)responseObject[@"data"];
            [[AlipaySDK defaultService] payOrder:sign fromScheme:@"zbtpay" callback:^(NSDictionary* resultDic) {
                NSLog(@" ==== %@",resultDic);
                [weakSelf hidden];
                
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                
                
            }];
        }else {
            //微信支付
            [self WechatPay:responseObject[@"data"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"yuyueReturnString Error ==== %@", error);
        [weakSelf hidden];
    }];
}

//生成实物类订单签名   点击立即购买 (个人)
- (void)submitInfo_buy_person:(NSInteger)type {
    [self show];
    NSDictionary *dic = self.firstShoppingArray.firstObject;
    NSLog(@"shiwu ==== dic ==== %@", dic);
    NSDictionary *parme = @{
                            @"buy_id" : dic[@"buy_id"],
                            @"order_price" : self.sum_price,
                            @"info" : @"",
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"username" : self.name,
                            @"user_phone" : self.phone,
                            @"user_address" : self.address,
                            @"pay_type" : @(type)
                            };
    
    NSString *url = @"https://zbt.change-word.com/index.php/home/order/personalOrder";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSLog(@"parme === %@", parme);
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"yuyueReturnString ==== %@", responseObject);
        if ([responseObject[@"type"] integerValue] == 1) {
            //支付宝支付
            NSString *sign = (NSString *)responseObject[@"data"];
            [[AlipaySDK defaultService] payOrder:sign fromScheme:@"zbtpay" callback:^(NSDictionary* resultDic) {
                NSLog(@" ==== %@",resultDic);
                [weakSelf hidden];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
        }else {
            //微信支付
            [self WechatPay:responseObject[@"data"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"yuyueReturnString Error ==== %@", error);
        [weakSelf hidden];
    }];
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
