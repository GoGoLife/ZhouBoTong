//
//  WaitPayViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/7.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "WaitPayViewController.h"
#import <Masonry.h>
#import "Globefile.h"

#import "OrderTableViewCell.h"
#import "OrderInfoViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface WaitPayViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong)NSArray *datatAry;

@end

@implementation WaitPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的订单";
}

- (UITableView *)tableView{
    if (!_tableView) {
        CGFloat insertTopHeight = 0.0;
        if (IS_IPHONE_X) {
            insertTopHeight = 64;
        }else {
            insertTopHeight = 22;
        }
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - insertTopHeight) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
//        DropView(_tableView);
        
        [self.tableView registerClass:[OrderTableViewCell class] forCellReuseIdentifier:@"order"];
    }
    return _tableView;
}

- (void)addRefresh{
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self show];
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self hidden];
//            [self.tableView.mj_header endRefreshing];
//            self.datatAry = dataAry;
//            [self.tableView reloadData];
//        });
//    }];
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController didViewDidLoad:(NSInteger)index{
    [self.view addSubview:self.tableView];
    //    [self addRefresh];
    [self getData];
}

- (void)getData {
    [self show];
    NSString *url = @"https://zbt.change-word.com/index.php/home/order/orderList";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"state" : @(1)        //待支付
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"waitPayOrder +_+_+_+_+_+ ----%@", responseObject);
        [self hidden];
        [self.tableView.mj_header endRefreshing];
        weakSelf.datatAry = responseObject[@"data"];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController viewWillDisappear:(NSInteger)index{
//    NSLog(@"将要消失---%ld",index);
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController viewDidDisappear:(NSInteger)index{
//    NSLog(@"已经消失---%ld",index);
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController viewWillAppear:(NSInteger)index{
//    NSLog(@"将要出现---%ld",index);
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController viewDidAppear:(NSInteger)index{
//    NSLog(@"已经出现---%ld",index);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datatAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.datatAry[section][@"goods"] count];
}

StringWidth();
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"order"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isShowTypeButton = YES;
    cell.type = TypeButtonWaitPay;
    if (!cell) {
        cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    NSDictionary *dict = self.datatAry[indexPath.section][@"goods"][indexPath.row];
    [cell.orderImg sd_setImageWithURL:[NSURL URLWithString:isNullClass(dict[@"photo"])] placeholderImage:[UIImage imageNamed:@"public"]];
    cell.nameTextF.text = [NSString stringWithFormat:@"*%@", isNullClass(dict[@"goods_price"])];
    CGFloat width = [self calculateRowWidth:isNullClass(dict[@"goods_name"]) withFont:17];
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, width, 40)];
    orderLabel.textAlignment = NSTextAlignmentLeft;
    orderLabel.text = isNullClass(dict[@"goods_name"]);
    cell.nameTextF.leftView = orderLabel;
    cell.nameTextF.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 50, 40)];
    rightLabel.font = SetFont(12);
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.text = [NSString stringWithFormat:@"*%@", isNullClass(dict[@"goods_number"])];
    cell.standerdTextF.rightView = rightLabel;
    cell.standerdTextF.rightViewMode = UITextFieldViewModeAlways;
    
    NSString *price = [isNullClass(dict[@"goods_price"]) isEqualToString:@""] ? @"0" : dict[@"goods_price"];
    CGFloat sum_price = [dict[@"goods_number"] integerValue] * [price integerValue];
    cell.totalLabel.text = [NSString stringWithFormat:@"%@件商品, 合计：￥%.2f", isNullClass(dict[@"goods_number"]), sum_price];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return OrderHeight - 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderInfoViewController *orderInfoVC = [[OrderInfoViewController alloc] init];
    orderInfoVC.cellType = 1;
    orderInfoVC.order_id = self.datatAry[indexPath.section][@"order_id"];
    [self.navigationController pushViewController:orderInfoVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor = [UIColor whiteColor];
    UITextField *textF = [[UITextField alloc] init];
    textF.enabled = NO;
    textF.text = [@"    " stringByAppendingString:isNullClass(self.datatAry[section][@"merchant_name"])];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 20, 20)];
    img.image = [UIImage imageNamed:@"dianpu"];
    textF.leftView = img;
    textF.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *right = [[UILabel alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width / 2, 40)];
    right.textAlignment = NSTextAlignmentRight;
    right.textColor = [UIColor redColor];
    right.font = SetFont(12);
    right.text = @"等待买家付款";
    textF.rightView = right;
    textF.rightViewMode = UITextFieldViewModeAlways;
    
    [headerV addSubview:textF];
    [textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerV).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor whiteColor];
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.titleLabel.font = SetFont(12);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    ViewBorderRadius(cancel, 10.0, 1.0, [UIColor redColor]);
    [cancel addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
    cancel.tag = section;
    [cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    UIButton *pay = [UIButton buttonWithType:UIButtonTypeCustom];
    pay.titleLabel.font = SetFont(12);
    [pay setTitle:@"付款" forState:UIControlStateNormal];
    ViewBorderRadius(pay, 10.0, 1.0, [UIColor redColor]);
    pay.tag = section;
    [pay addTarget:self action:@selector(payMoney:) forControlEvents:UIControlEventTouchUpInside];
    [pay setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [footer addSubview:pay];
    [footer addSubview:cancel];
    
    [pay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.centerY.equalTo(footer.mas_centerY);
        make.right.equalTo(footer.mas_right).offset(-15);
    }];
    
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.centerY.equalTo(footer.mas_centerY);
        make.right.equalTo(pay.mas_left).offset(-15);
    }];
    
    return footer;
}

- (void)cancelOrder:(UIButton *)sender {
    NSLog(@"tag === %ld", sender.tag);
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消订单" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *url = @"https://zbt.change-word.com/index.php/home/order/orderDel";
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        NSDictionary *parme = @{
                                @"id" : [NSString stringWithFormat:@"%@", self.datatAry[sender.tag][@"order_id"]],
                                @"type" : @(1)
                                };
        __weak typeof(self) weakSelf = self;
        [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf getData];
            NSLog(@"删除艇卖  ==== %@", responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }];
    
    [sheet addAction:action1];
    [sheet addAction:action2];
    
    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)payMoney:(UIButton *)sender {
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"选择付款方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getPayCode:sender.tag withType:1];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getPayCode:sender.tag withType:2];
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [sheet addAction:action];
    [sheet addAction:action2];
    [sheet addAction:action1];
    
    [self presentViewController:sheet animated:YES completion:nil];
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

- (void)getPayCode:(NSInteger)index withType:(NSInteger)type {
    NSString *url = @"https://zbt.change-word.com/index.php/home/order/orderPay";
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"order_id" : self.datatAry[index][@"order_id"],
                            @"order_money" : @"0.01",
                            @"pay_type" : @(type)
                            };
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"orderCode === %@", responseObject);
        if ([responseObject[@"resultCode"] integerValue] == 1) {
            if ([responseObject[@"type"] integerValue] == 1) {
                //支付宝支付
                NSString *sign = (NSString *)responseObject[@"data"];
                [[AlipaySDK defaultService] payOrder:sign fromScheme:@"zbtpay" callback:^(NSDictionary* resultDic) {
                    NSLog(@" ==== %@",resultDic);
                    [weakSelf hidden];
                }];
            }else {
                //微信支付
                [self WechatPay:responseObject[@"data"]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
