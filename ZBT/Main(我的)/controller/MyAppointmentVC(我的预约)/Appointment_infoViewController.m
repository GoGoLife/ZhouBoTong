//
//  Appointment_infoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/12.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Appointment_infoViewController.h"
#import "UITextField+LeftRightView.h"
#import "Globefile.h"
#import "EvaluateViewController.h"

@interface Appointment_infoViewController ()

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) UIView *firstV;

@property (nonatomic, strong) UIView *secondV;

@end

@implementation Appointment_infoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约详情";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.firstV = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 245)];
    
    [self.view addSubview:self.firstV];
    
    self.secondV = [[UIView alloc] init];
    
    [self.view addSubview:self.secondV];
    __weak typeof(self) weakSelf = self;
    [self.secondV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.firstV.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(220));
    }];
    
    [self setUpNav];
    
    [self getInfo_Yuyue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFirstView:(UIView *)view {
    UITextField *textF = [[UITextField alloc] init];
    textF.enabled = NO;
    textF.text = @"售后编号：1918391893183";
    
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.textColor = [UIColor redColor];
    [self setTypeLabelTitle:self.orderType AndLabel:typeLabel];
    [textF creatRightView:typeLabel.bounds AndControl:typeLabel];
    
    UIImageView *leftImageV = [[UIImageView alloc] init];
//    leftImageV.backgroundColor = RandomColor;
//    leftImageV.image = [UIImage imageNamed:@"public"];
    [leftImageV sd_setImageWithURL:[NSURL URLWithString:self.imageURL] placeholderImage:[UIImage imageNamed:@"public"]];
    
    //上门维修
    UILabel *label = [[UILabel alloc] init];
    label.text = @"";//@"上门维修";
    
    //价格
    UILabel *label1 = [[UILabel alloc] init];
    label1.textColor = [UIColor redColor];
    label1.text = [NSString stringWithFormat:@"￥%@", self.dataDic[@"sum_price"]];//@"¥20000";
    
    //下单时间
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = [NSString stringWithFormat:@"下单时间：%@", self.dataDic[@"appointment_time"]];//@"下单时间：2018-10-10 13:00";
    
    //联系人
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = [NSString stringWithFormat:@"出行人数：%@", self.dataDic[@"yuyue_number"]];//@"出行人数：2人";
    
    //联系电话
    UILabel *label4 = [[UILabel alloc] init];
    label4.text = [NSString stringWithFormat:@"联系人：%@", self.dataDic[@"yuyue_name"]];//@"联系人：小明";
    
    UILabel *label5 = [[UILabel alloc] init];
    label5.text = [NSString stringWithFormat:@"联系电话：%@", self.dataDic[@"phone"]];//@"联系电话：18268865135";
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = BaseViewColor;
    
    [view addSubview:textF];
    [view addSubview:leftImageV];
    [view addSubview:label];
    [view addSubview:label1];
    [view addSubview:label2];
    [view addSubview:label3];
    [view addSubview:label4];
    [view addSubview:label5];
    [view addSubview:line];
    
    [textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top);
        make.left.equalTo(view.mas_left).offset(15);
        make.right.equalTo(view.mas_right).offset(-15);
        make.height.mas_equalTo(@(40));
    }];
    
    [leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textF.mas_bottom).offset(10);
        make.left.equalTo(view.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftImageV.mas_top);
        make.right.equalTo(view.mas_right).offset(-10);
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(leftImageV.mas_bottom);
        make.right.equalTo(label.mas_right);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftImageV.mas_bottom).offset(10);
        make.left.equalTo(leftImageV.mas_left);
        make.right.equalTo(label1.mas_right);
        make.height.mas_equalTo(@(20));
    }];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(5);
        make.left.equalTo(label2.mas_left);
        make.right.equalTo(label2.mas_right);
        make.height.equalTo(label2.mas_height);
    }];
    
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label3.mas_bottom).offset(5);
        make.left.equalTo(label2.mas_left);
        make.right.equalTo(label2.mas_right);
        make.height.equalTo(label2.mas_height);
    }];
    
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label4.mas_bottom).offset(5);
        make.left.equalTo(label2.mas_left);
        make.right.equalTo(label2.mas_right);
        make.height.equalTo(label2.mas_height);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom);
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.height.mas_equalTo(@(1));
    }];
}

- (void)setSecondView:(UIView *)view {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"商家信息";
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = [NSString stringWithFormat:@"商家名称：%@", self.dataDic[@"merchant"][@"merchant_name"]];//@"商家名称：xx维修公司";
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = [NSString stringWithFormat:@"商家电话：%@", self.dataDic[@"merchant"][@"shop_phone"]];//@"商家电话：0871-264894";
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = [NSString stringWithFormat:@"商家接单时间：%@", self.dataDic[@"order_time"]];//@"商家接单时间：2018-10-10 13：00";
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.text = [NSString stringWithFormat:@"商家营业时间：%@-%@", self.dataDic[@"merchant"][@"start_business_time"], self.dataDic[@"merchant"][@"end_business_time"]];//@"商家营业时间：09：00 - 17：00";
    
    UILabel *label5 = [[UILabel alloc] init];
    label5.text = [NSString stringWithFormat:@"商家地址：%@", self.dataDic[@"merchant"][@"shop_address"]];//@"商家地址：浙江省舟山市朱家尖码头路100号";
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = BaseViewColor;
    
    [view addSubview:label];
    [view addSubview:label1];
    [view addSubview:label2];
    [view addSubview:label3];
    [view addSubview:label4];
    [view addSubview:label5];
    [view addSubview:line];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(10);
        make.left.equalTo(view.mas_left).offset(10);
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(label.mas_left);
        make.right.equalTo(view.mas_right);
        make.height.mas_equalTo(@(20));
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(10);
        make.left.equalTo(label.mas_left);
        make.right.equalTo(view.mas_right);
        make.height.mas_equalTo(@(20));
    }];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(10);
        make.left.equalTo(label.mas_left);
        make.right.equalTo(view.mas_right);
        make.height.mas_equalTo(@(20));
    }];
    
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label3.mas_bottom).offset(10);
        make.left.equalTo(label.mas_left);
        make.right.equalTo(view.mas_right);
        make.height.mas_equalTo(@(20));
    }];
    
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label4.mas_bottom).offset(10);
        make.left.equalTo(label.mas_left);
        make.right.equalTo(view.mas_right);
        make.height.mas_equalTo(@(20));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.bottom.equalTo(view.mas_bottom);
        make.height.mas_equalTo(@(1));
    }];
}

- (void)setTypeLabelTitle:(NSInteger)type AndLabel:(UILabel *)label {
    switch (type) {
        case 0:
        {
            label.text = @"未完成";
            [label sizeToFit];
        }
            break;
        case 1:
        {
            label.text = @"已完成";
            [label sizeToFit];
        }
            break;
        case 2:
        {
            label.text = @"待评价";
            [label sizeToFit];
            UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"评价" style:UIBarButtonItemStylePlain target:self action:@selector(evaluateYuyueOrder)];
            self.navigationItem.rightBarButtonItem = right;
        }
            break;
        default:
        {
            label.text = @"全部";
            [label sizeToFit];
        }
            break;
    }
}

- (void)getInfo_Yuyue {
    if (!self.yuyue_id) {
        return;
    }
    NSString *url = @"https://zbt.change-word.com/index.php/home/yuyue/yuyueOrderInfo";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];    
    NSDictionary *parme = @{@"yuyue_id" : self.yuyue_id};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"我的预约详情 ==== %@", responseObject);
        weakSelf.dataDic = (NSDictionary *)responseObject[@"data"];
        [self setFirstView:weakSelf.firstV];
        [self setSecondView:weakSelf.secondV];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"我的预约 ==== %@", error);
    }];
}

//评价预约订单
- (void)evaluateYuyueOrder {
    EvaluateViewController *evaluate = [[EvaluateViewController alloc] init];
    evaluate.dataDic = self.dataDic;
    evaluate.imageURL = self.imageURL;
    evaluate.orderType = 2;
    [self.navigationController pushViewController:evaluate animated:YES];
}

@end
