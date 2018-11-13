//
//  ProjectInfoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/23.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ProjectInfoViewController.h"
#import "Globefile.h"
#import "UITextField+LeftRightView.h"
#import "LoopView.h"

#import "ProjectTableViewCell.h"
#import "EvaluateTableViewCell.h"
#import "CustomTableViewCell.h"
#import "AppointmentViewController.h"
#import "SellProjectViewController.h"
#import "callAcitonView.h"

#import <MapKit/MapKit.h>

@interface ProjectInfoViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSMutableArray *heightArray;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary *data;

@end

@implementation ProjectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    heightArray = [NSMutableArray arrayWithCapacity:1];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[ProjectTableViewCell class] forCellReuseIdentifier:@"project"];
    [self.tableView registerClass:[EvaluateTableViewCell class] forCellReuseIdentifier:@"evaluate"];
    
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
        
    [self setUpNav];
    
    [self getMerchant_info];
}

setBack();
pop();

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return [self.data[@"service_data"] count] ?: [self.data[@"train_data"] count] ?: [self.data[@"commission_data"] count];
            break;
        case 3:
            return [self.data[@"comment"] count];
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.textF.enabled = NO;
            cell.textF.textAlignment = NSTextAlignmentLeft;
            cell.textF.text = self.data[@"merchant"][@"merchant_name"];//@"温州渔家乐园";
            return cell;
        }
            break;
        case 1:
        {
            NSDictionary *dic = self.data[@"merchant"];
            CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.textF.enabled = NO;
            cell.textF.textAlignment = NSTextAlignmentLeft;
            cell.textF.font = SetFont(14);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.isNewLayout = YES;
            if (indexPath.row == 0) {
                cell.textF.text = dic[@"shop_address"];//@"杭州市小码头";
                CGFloat width = [self calculateRowWidth:@"地址：" withFont:14];
                [cell.textF creatLeftView:FRAME(0, 0, width, cell.bounds.size.height) AndTitle:@"地址：" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:[UIColor blackColor]];
                [cell.textF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"导航" withFont:14], cell.bounds.size.height) AndTitle:@"导航" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:SetColor(162, 162, 162, 1)];
            }else {
                cell.textF.text = dic[@"shop_phone"];//@"18268865135";
                CGFloat width = [self calculateRowWidth:@"电话：" withFont:14];
                [cell.textF creatLeftView:FRAME(0, 0, width, cell.bounds.size.height) AndTitle:@"电话：" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:[UIColor blackColor]];
                [cell.textF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"一键拨号" withFont:14], cell.bounds.size.height) AndTitle:@"一键拨号" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:SetColor(162, 162, 162, 1)];
            }
            return cell;
        }
            break;
        case 2:
        {
            NSDictionary *dic = self.data[@"service_data"][indexPath.row] ?: self.data[@"train_data"][indexPath.row] ?: self.data[@"commission_data"][indexPath.row];
            ProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"project"];
            [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
            cell.topTextF.text = dic[@"service_name"] ?: dic[@"name"] ?: dic[@"serve_name"];
            cell.centerTextF.text = dic[@"info"];
            cell.bottomTextF.text = [NSString stringWithFormat:@"定金：￥%@", dic[@"down_payment"]];
            return cell;
        }
            break;
        case 3:
        {
            NSDictionary *dic = self.data[@"comment"][indexPath.row];
            EvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"evaluate"];
            CGFloat width = [self calculateRowWidth:dic[@"add_time"] withFont:12];
            [cell.topTextF creatRightView:FRAME(0, 0, width, 30) AndTitle:dic[@"add_time"] TextAligment:NSTextAlignmentCenter Font:SetFont(12) Color:[UIColor blackColor]];
            cell.remarkString = dic[@"content"];
            cell.imageArray = @[@"111", @"222", @"333"];
            CGFloat height = [cell cellHeight:dic[@"content"] WithFont:14];
            [heightArray addObject:[NSNumber numberWithFloat:height]];
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

StringWidth();

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 40;
            break;
        case 1:
            return 60;
            break;
        case 2:
            return 110;
            break;
        case 3:
        {
            CGFloat height = ((NSNumber *)heightArray[indexPath.row]).floatValue;
            return height;
        }
            break;
            
        default:
            break;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 200.0;
    }
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 200)];
        LoopView *loop = [[LoopView alloc] initWithFrame:view.bounds];
        loop.imageArray = @[@"1", @"2", @"3", @"4"];
        [view addSubview:loop];
        return view;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 50)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:FRAME(10, 0, SCREENBOUNDS.width - 20, view.bounds.size.height)];
    label.font = SetFont(12);
    label.textColor = SetColor(66, 66, 66, 1);
    [view addSubview:label];
    if (section == 1) {
        label.text = @"商户信息";
    }else if(section == 2) {
        label.text = @"项目服务";
    }else {
        label.text = @"评价（3）";
    }
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 60)];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (void)pushAppointmentVC {  //立即预约
    AppointmentViewController *ment = [[AppointmentViewController alloc] init];
    ment.isWharfGOVC = self.isWharfGoVC;
    ment.number = @"1";
    [self.navigationController pushViewController:ment animated:YES];
}

//解绑button绑定方法
- (void)removeTarget {
    [self.button removeTarget:self action:@selector(pushAppointmentVC) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self action];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        [callAcitonView showCallActionWithTitle:self.data[@"merchant"][@"shop_phone"] AndShowView:self];
    }
    if (indexPath.section == 2) {
        SellProjectViewController *sell = [[SellProjectViewController alloc] init];
        sell.isWharfGoVC = self.isWharfGoVC;
        sell.serve_id = self.data[@"service_data"][indexPath.row][@"id"];
        sell.train_type_id = self.data[@"train_data"][indexPath.row][@"train_type_id"];
        sell.commission_id = self.data[@"commission_data"][indexPath.row][@"serve_id"];
        [self.navigationController pushViewController:sell animated:YES];
    }
}

- (void)getMerchant_info {
    if (!self.merchant_id) {
        return;
    }
    NSLog(@"merchant_id === %@", self.merchant_id);
    NSString *url = @"https://zbt.change-word.com/index.php/home/merchant/shop";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"merchant_id" : self.merchant_id};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"shopInfo  === %@", responseObject);
        weakSelf.data = (NSDictionary *)responseObject[@"data"];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error === %@", error);
    }];
}

#pragma mark - 选择导航app
- (void)action {
//    NSString *url = @"http://api.map.baidu.com/cloudgc/v1/?address=杭州市&output=json&ak=G5D0r4BzFCPc2vQSQTMusvFjzFj6pEVP&mcode=com.zhong.phone";
    //获取商家所在地的经纬度
    NSString *url = [NSString stringWithFormat:@"http://api.map.baidu.com/cloudgc/v1/?address=%@&output=json&ak=%@&mcode=%@", self.data[@"merchant"][@"shop_address"], BAIDU_AK, BAIDU_MCODE];
    NSString *URLString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    __weak typeof(self) weakSelf = self;
    [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"merchantLocation  === %@", responseObject);
        NSDictionary *response = (NSDictionary *)[responseObject[@"result"] firstObject][@"location"];
        [weakSelf getLocation_MeWithOtherLocation:response];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error === %@", error);
    }];
    
}

//获取自己所在地的经纬度
- (void)getLocation_MeWithOtherLocation:(NSDictionary *)location {
    if (!location) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"未获取到商家地址信息"];
        return;
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"未获取到定位信息"];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://api.map.baidu.com/cloudgc/v1/?address=%@&output=json&ak=%@&mcode=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"Location_info"], BAIDU_AK, BAIDU_MCODE];
    NSString *URLString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    __weak typeof(self) weakSelf = self;
    [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"meLocation  === %@", responseObject);
        NSDictionary *response = (NSDictionary *)[responseObject[@"result"] firstObject][@"location"];
        [weakSelf startNavigationFirstLocation:response TwoLocation:location];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error === %@", error);
    }];
}

- (void)startNavigationFirstLocation:(NSDictionary *)one TwoLocation:(NSDictionary *)two {
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{%@}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02", [[NSUserDefaults standardUserDefaults] objectForKey:@"Location_info"], [two[@"lat"] floatValue], [two[@"lng"] floatValue], self.data[@"merchant"][@"shop_address"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}
@end
