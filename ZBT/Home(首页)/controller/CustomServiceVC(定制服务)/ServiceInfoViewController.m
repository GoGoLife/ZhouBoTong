//
//  ServiceInfoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/31.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ServiceInfoViewController.h"
#import "CustomServiceTableViewCell.h"
#import "CustomTableViewCell.h"
#import <Masonry.h>
#import "Globefile.h"
#import "LoopView.h"
#import "ConsultViewController.h"
#import "UITextField+LeftRightView.h"
#import "callAcitonView.h"

#import <AlipaySDK/AlipaySDK.h>

@interface ServiceInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIView *backgroundView;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) UILabel *telLabel;

@property (nonatomic, strong) UIButton *button;

@end

@implementation ServiceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    [self.tableView registerClass:[CustomServiceTableViewCell class] forCellReuseIdentifier:@"one"];
//    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"two"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 44, 0));
    }];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.titleLabel.font = SetFont(12);
    [self.button setTitle:@"查看联系方式" forState:UIControlStateNormal];
    self.button.backgroundColor = [UIColor redColor];
    [self.button addTarget:self action:@selector(lookInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tableView.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    [self setUpNav];
    
    [self getServiceInfo];
    
}

- (void)lookInfo {
//    NSString *string = @"支付10元(信息服务费)";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付10元(信息服务费)" message:@"可查看发布者联系方式" preferredStyle:UIAlertControllerStyleAlert];
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"支付10元(信息服务费)"];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(2, 3)];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:Color176 range:NSMakeRange(5, 7)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(5, 7)];
    [alert setValue:alertControllerStr forKey:@"attributedTitle"];
    
    //修改message
    NSMutableAttributedString *MessageStr = [[NSMutableAttributedString alloc] initWithString:@"可查看发布者联系方式"];
    [MessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, MessageStr.length)];
    [alert setValue:MessageStr forKey:@"attributedMessage"];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        [callAcitonView showSheetView:self];
        [self showSheetView:self];
    }];
    
    [action1 setValue:Color176 forKey:@"titleTextColor"];
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showSheetView:(id)control {
    UIAlertController *sheetView = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"银行卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self payMoney:1];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self payMoney:2];
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
//    [sheetView addAction:action1];
    [sheetView addAction:action2];
    [sheetView addAction:action3];
    [sheetView addAction:action4];
    
    [control presentViewController:sheetView animated:YES completion:nil];
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

- (void)payMoney:(NSInteger)type {
    NSDictionary *parme = @{
                            @"order_price" : @"0.01",
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"serve_id" : self.dataDic[@"serve_id"],
                            @"serve_name" : self.dataDic[@"serve_name"],
                            @"pay_type" : @(type)
                            };
    
    NSString *url = @"https://zbt.change-word.com/index.php/home/order/customerOrder";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSLog(@"parme === %@", parme);
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"yuyueReturnString ==== %@", responseObject);
        [weakSelf hidden];
        if ([responseObject[@"type"] integerValue] == 1) {
            //支付宝支付
            NSString *sign = (NSString *)responseObject[@"data"];
            [[AlipaySDK defaultService] payOrder:sign fromScheme:@"zbtpay" callback:^(NSDictionary* resultDic) {
                NSLog(@" ==== %@",resultDic);
                weakSelf.telLabel.text = [NSString stringWithFormat:@"联系方式:%@", weakSelf.dataDic[@"phone"]];
                self.button.enabled = NO;
            }];
        }else {
            //微信支付
            [self WechatPay:responseObject[@"data"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"yuyueReturnString Error ==== %@", error);
    }];
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
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setCellContent:cell];
    return cell;
}

- (void)setCellContent:(UITableViewCell *)cell {
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = @"定制服务";
    
    NSString *string = self.dataDic[@"info"];
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = SetFont(12);
    contentLabel.numberOfLines = 0;
    contentLabel.text = string;
    
    
    
    [cell.contentView addSubview:textLabel];
    [cell.contentView addSubview:contentLabel];
    
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView.mas_top).offset(10);
        make.left.equalTo(cell.contentView.mas_left).offset(15);
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel.mas_bottom).offset(10);
        make.left.equalTo(textLabel.mas_left);
        make.right.equalTo(cell.contentView.mas_right).offset(-15);
    }];
    
    CGFloat width = (SCREENBOUNDS.width - 100) / 4;
    __weak typeof(self) weakSelf = self;
    for (NSInteger index = 0; index < [self.dataDic[@"photo"] count]; index++) {
        UIImageView *imageV = [[UIImageView alloc] init];
        [imageV sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"photo"][index]] placeholderImage:[UIImage imageNamed:@"public"]];
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage)];
        [imageV addGestureRecognizer:tap];
        [cell.contentView addSubview:imageV];
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel.mas_bottom).offset(10);
            make.left.equalTo(weakSelf.view.mas_left).offset(20 + (width + 20) * index);
            make.size.mas_equalTo(CGSizeMake(width, width));
        }];
    }
}

- (void)showBigImage {
    [ShowHUDView showBigImageAtView:self.view AndImageURL:self.dataDic[@"photo"]];
}

StringHeight();
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = self.dataDic[@"info"];
    CGFloat height = [self calculateRowHeight:string fontSize:12 withWidth:SCREENBOUNDS.width - 30];
    return height + 80 + 10 + 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    }
    return 130.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [[UIView alloc] init];
    }else{
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 130.0)];
        view.backgroundColor = [UIColor whiteColor];
        [self setHeaderAtView:view];
        return view;
    }
}
StringWidth();

- (void)setHeaderAtView:(UIView *)view {
    UITextField *textF = [[UITextField alloc] init];
    textF.text = self.dataDic[@"serve_name"];
    //分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = FRAME(0, 0, 20, 20);
    [textF creatRightView:shareBtn.frame AndControl:shareBtn];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = [UIColor redColor];
    priceLabel.text = [NSString stringWithFormat:@"￥%@", self.dataDic[@"price"]];
    
    UILabel *fbLabel = [[UILabel alloc] init];
    if ([self.dataDic[@"type"] integerValue] == 1) {
        fbLabel.text = @"商家发布";
    }else {
        fbLabel.text = @"个人发布";
    }
    
    self.telLabel = [[UILabel alloc] init];
    if (self.dataDic[@"phone"] != nil) {
        if ([self.dataDic[@"purchase"] integerValue]) {
            self.telLabel.text = [NSString stringWithFormat:@"联系方式:%@", self.dataDic[@"phone"]];
            self.button.enabled = NO;
        }else {
            NSString *phone = [NSString stringWithFormat:@"%@", self.dataDic[@"phone"]];
            NSString *result = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            self.telLabel.text = [NSString stringWithFormat:@"联系方式:%@", result];//@"联系方式  182****5135";
        }
    }
    
    [view addSubview:textF];
    [view addSubview:priceLabel];
    [view addSubview:fbLabel];
    [view addSubview:self.telLabel];
    
    CGFloat height = view.bounds.size.height / 4;
    [textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(5);
        make.left.equalTo(view.mas_left).offset(10);
        make.right.equalTo(view.mas_right).offset(-10);
        make.height.mas_equalTo(@(height));
    }];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textF.mas_bottom);
        make.left.equalTo(textF.mas_left);
        make.right.equalTo(textF.mas_right);
        make.height.equalTo(textF.mas_height);
    }];
    
    [fbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceLabel.mas_bottom);
        make.left.equalTo(textF.mas_left);
        make.right.equalTo(textF.mas_right);
        make.height.equalTo(textF.mas_height);
    }];
    
    [self.telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fbLabel.mas_bottom);
        make.left.equalTo(textF.mas_left);
        make.right.equalTo(textF.mas_right);
        make.height.equalTo(textF.mas_height);
    }];
}

- (void)getServiceInfo {
    if (!self.service_id) {
        return;
    }
    NSString *url = @"https://zbt.change-word.com/index.php/home/service/customerInfo";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"serve_id" : self.service_id,
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"]
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"定制服务详情 === %@", responseObject);
        weakSelf.dataDic = (NSDictionary *)responseObject[@"data"];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
