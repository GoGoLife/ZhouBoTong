//
//  OrderInfoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/7.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "Globefile.h"

#import "OrderInfoTableViewCell.h"
#import "OrderTableViewCell.h"

@interface OrderInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *footView;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation OrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[OrderInfoTableViewCell class] forCellReuseIdentifier:@"info"];
    [self.tableView registerClass:[OrderTableViewCell class] forCellReuseIdentifier:@"order"];
    
//    DropView(tableView);
    
    [self.view addSubview:self.tableView];
    
    [self setUpNav];
    
    [self getOrderInfo];
}

setBack();
pop();

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return [self.orderInfoDic[@"goods"] count] ?: 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            OrderInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
            switch (indexPath.row) {
                case 0:
                {
                    cell.imgV.image = [UIImage imageNamed:@"fahuo"];
                    cell.topInfoTextF.textColor = [UIColor redColor];
                    switch (self.cellType) {
                        case 1:
                        {
                            cell.topInfoTextF.text = @"待付款";
                        }
                            break;
                        case 2:
                        {
                            cell.topInfoTextF.text = @"等待卖家发货";
                        }
                            break;
                        case 3:
                        {
                            cell.topInfoTextF.text = @"等待买家收货";
                        }
                            break;
                        case 4:
                        {
                            cell.topInfoTextF.text = @"等待买家评价";
                        }
                            break;
                        case 5:
                        {
                            cell.topInfoTextF.text = @"已完成";
                        }
                            break;
                        case 6:
                        {
                            cell.topInfoTextF.text = @"个人订单";
                        }
                            break;
                        case 7:
                        {
                            cell.topInfoTextF.text = @"个人订单";
                        }
                            break;
                            
                        default:
                            break;
                    }
                    cell.bottomInfoTextF.text = @"2018-9-12 12:00";
                }
                    break;
                case 1:
                {
                    cell.imgV.image = [UIImage imageNamed:@"dizhi"];
                    cell.topLeftStr = self.cellType == 7 ? @"买方:" : @"收件人:";
                    cell.topInfoTextF.text = isNullClass(self.orderInfoDic[@"username"]);
                    cell.topRightStr = isNullClass(self.orderInfoDic[@"user_phone"]);
                    cell.bottomLeftStr = @"收货地址:";
                    cell.bottomInfoTextF.text = isNullClass(self.orderInfoDic[@"user_address"]);
                }
                    break;
                default:
                    break;
            }
            return cell;
        }
            break;
        case 1:
        {
            OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"order"];
            if (self.order_id) {
                NSDictionary *dict = self.orderInfoDic[@"goods"][indexPath.row];
                [cell.orderImg sd_setImageWithURL:[NSURL URLWithString:isNullClass(dict[@"photo"])] placeholderImage:[UIImage imageNamed:@"public"]];
                cell.nameTextF.text = isNullClass(dict[@"goods_price"]);
                UILabel *orderLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 200, 40)];
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
                
                CGFloat sum_price = [dict[@"goods_number"] integerValue] * [dict[@"goods_price"] integerValue];
                cell.totalLabel.text = [NSString stringWithFormat:@"%@件商品, 合计：￥%.2f", isNullClass(dict[@"goods_number"]), sum_price];
            }else {
                NSDictionary *dict = self.orderInfoDic;
                [cell.orderImg sd_setImageWithURL:[NSURL URLWithString:isNullClass(dict[@"photo"])] placeholderImage:[UIImage imageNamed:@"public"]];
                cell.nameTextF.text = isNullClass(dict[@"order_price"]);
                UILabel *orderLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 200, 40)];
                orderLabel.textAlignment = NSTextAlignmentLeft;
                orderLabel.text = isNullClass(dict[@"goods_name"]);
                cell.nameTextF.leftView = orderLabel;
                cell.nameTextF.leftViewMode = UITextFieldViewModeAlways;
                
                UILabel *rightLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 50, 40)];
                rightLabel.font = SetFont(12);
                rightLabel.textAlignment = NSTextAlignmentRight;
                rightLabel.text = [NSString stringWithFormat:@"*%@", @"1"];
                cell.standerdTextF.rightView = rightLabel;
                cell.standerdTextF.rightViewMode = UITextFieldViewModeAlways;
                
                CGFloat sum_price = 1 * [dict[@"order_price"] integerValue];
                cell.totalLabel.text = [NSString stringWithFormat:@"%@件商品, 合计：￥%.2f", @"1", sum_price];
            }
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return OrderInfoCellHeight;
            break;
        case 1:
            return OrderHeight - 40;
            break;
            
        default:
            return 0.0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 70.0;
            break;
        case 1:
            return 10.0;
            break;
            
        default:
            break;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    }
    return 150.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 70.0)];
            view.backgroundColor = SetColor(27, 166, 226, 1);
            
            UITextField *textF = [[UITextField alloc] initWithFrame:FRAME(15, 10, view.bounds.size.width - 30, view.bounds.size.height - 20)];
            textF.enabled = NO;
            switch (self.cellType) {
                case 1:
                {
                    textF.text = @"待付款";
                }
                    break;
                case 2:
                {
                    textF.text = @"等待卖家发货";
                }
                    break;
                case 3:
                {
                    textF.text = @"等待买家收货";
                }
                    break;
                case 4:
                {
                    textF.text = @"等待买家评价";
                }
                    break;
                case 5:
                {
                    textF.text = @"已完成";
                }
                    break;
                case 6:
                {
                    textF.text = @"个人订单";
                }
                    break;
                case 7:
                {
                    textF.text = @"个人订单";
                }
                    break;
                    
                default:
                    break;
            }
            textF.font = SetFont(16);
            textF.textColor = [UIColor whiteColor];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME(0, 0, CGRectGetHeight(textF.bounds), CGRectGetHeight(textF.bounds))];
            switch (self.cellType) {
                case 1:
                {
                    img.image = [UIImage imageNamed:@"type1"];
                }
                    break;
                case 2:
                {
                    img.image = [UIImage imageNamed:@"type2"];
                }
                    break;
                case 3:
                {
                    img.image = [UIImage imageNamed:@"type3"];
                }
                    break;
                case 4:
                {
                    img.image = [UIImage imageNamed:@"type4"];
                }
                    break;
                case 5:
                {
                    img.image = [UIImage imageNamed:@"type5"];
                }
                    break;
                    
                default:
                {
                    img.image = [UIImage imageNamed:@"public"];
                }
                    break;
            }
            
            textF.rightView = img;
            textF.rightViewMode = UITextFieldViewModeAlways;
            
            [view addSubview:textF];
            
            return view;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        label.font = SetFont(17);
        label.text = [NSString stringWithFormat:@"订单编号：%@", self.orderInfoDic[@"order_number"]];//@"订单编号：2018319230912032013";
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.font = SetFont(14);
        label1.text = [NSString stringWithFormat:@"订单创建时间：%@", self.orderInfoDic[@"create_time"] ?: self.orderInfoDic[@"add_time"]];//@"订单创建时间：2018-6-25 13:00";
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.font = SetFont(14);
        label2.text = [NSString stringWithFormat:@"订单付款时间：%@", self.orderInfoDic[@"create_time"] ?: self.orderInfoDic[@"add_time"]];//@"订单付款时间：2018-6-25 13:00";
        
        UILabel *label3 = [[UILabel alloc] init];
        label3.font = SetFont(14);
        label3.text = [NSString stringWithFormat:@"订单成交时间：%@", self.orderInfoDic[@"create_time"] ?: self.orderInfoDic[@"add_time"]];//@"订单成交时间：2018-6-28 18:00";
        
        UILabel *label4 = [[UILabel alloc] init];
        label4.font = SetFont(14);
        label4.text = [NSString stringWithFormat:@"商家所在地址：%@", self.orderInfoDic[@"shop_address"] ?: @"无"];//@"商家所在地址：浙江省舟山市朱家尖码头1009号";
        
        [view addSubview:label];
        [view addSubview:label1];
        [view addSubview:label2];
        [view addSubview:label3];
        [view addSubview:label4];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).offset(10);
            make.left.equalTo(view.mas_left).offset(5);
            make.right.equalTo(view.mas_right).offset(-5);
            make.height.mas_equalTo(@(30));
        }];
        
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(5);
            make.left.equalTo(view.mas_left).offset(5);
            make.right.equalTo(view.mas_right).offset(-5);
            make.height.mas_equalTo(@(20));
        }];
        
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label1.mas_bottom).offset(5);
            make.left.equalTo(view.mas_left).offset(5);
            make.right.equalTo(view.mas_right).offset(-5);
            make.height.mas_equalTo(@(20));
        }];
        
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label2.mas_bottom).offset(5);
            make.left.equalTo(view.mas_left).offset(5);
            make.right.equalTo(view.mas_right).offset(-5);
            make.height.mas_equalTo(@(20));
        }];
        
        [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label3.mas_bottom).offset(5);
            make.left.equalTo(view.mas_left).offset(5);
            make.right.equalTo(view.mas_right).offset(-5);
            make.height.mas_equalTo(@(20));
        }];
        return view;
    }
    return [[UIView alloc] init];
    
}

- (void)getOrderInfo {
    if (!self.order_id) {
        return;
    }
    NSString *url = @"https://zbt.change-word.com/index.php/home/order/orderInfo";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"order_id" : self.order_id
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"orderInfo +_+_+_+_+_+ ----%@", responseObject);
        if ([responseObject[@"resultCode"] integerValue] == 1) {
            weakSelf.orderInfoDic = responseObject[@"data"];
            [weakSelf.tableView reloadData];
        }
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
