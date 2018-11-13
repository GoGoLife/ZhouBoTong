//
//  MarchantInfoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/4.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "MarchantInfoViewController.h"
#import "BrandHeaderView.h"
#import "CustomTableViewCell.h"
#import "Globefile.h"
#import "callAcitonView.h"

@interface MarchantInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *titleArr;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation MarchantInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商户详情";
    titleArr = @[@"门店时间", @"营业电话", @"营业地址"];
    // Do any additional setup after loading the view.
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50.0;
    
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
//    [headV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.view.mas_top).offset(0);
//        make.left.equalTo(weakSelf.view.mas_left);
//        make.right.equalTo(weakSelf.view.mas_right);
//        make.height.mas_equalTo(@(100));
//    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(0);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
    [self setUpNav];
    
    [self getInfo_Merchant];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textF.enabled = NO;
    CGFloat width = [self calculateRowWidth:@"营业时间" withFont:15];
    [cell.textF creatLeftView:FRAME(0, 0, width + 15, 50.0) AndTitle:titleArr[indexPath.row] TextAligment:NSTextAlignmentLeft Font:SetFont(15) Color:SetColor(164, 164, 164, 1)];
    if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.textF creatRightView:FRAME(0, 0, width, 50.0) AndTitle:@"一键拨号" TextAligment:NSTextAlignmentRight Font:SetFont(12) Color:SetColor(164, 164, 164, 1)];
    }else if (indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.textF creatRightView:FRAME(0, 0, width, 50.0) AndTitle:@"一键导航" TextAligment:NSTextAlignmentRight Font:SetFont(12) Color:SetColor(164, 164, 164, 1)];
    }
    [self setCellText:cell AtIndexPath:indexPath];
    return cell;
}
StringWidth();

- (void)setCellText:(CustomTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath {
    cell.textF.font = SetFont(15);
    cell.textF.textAlignment = NSTextAlignmentLeft;
    switch (indexPath.row) {
        case 0:
        {
            cell.textF.text = [NSString stringWithFormat:@"%@ - %@", self.dataDic[@"start_business_time"], self.dataDic[@"end_business_time"]];//@"周一至周日 09:00-20:00";
        }
            break;
        case 1:
        {
            cell.textF.text = self.dataDic[@"phone"];//@"18268865135";
        }
            break;
        case 2:
        {
            cell.textF.text = self.dataDic[@"shop_address"];//@"浙江省温州市乐清市水上乐园";
        }
            break;
            
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1 && indexPath.section == 1) {
        [callAcitonView showCallActionWithTitle:self.dataDic[@"phone"] AndShowView:self];
    }else if (indexPath.row == 2 && indexPath.section == 1) {
        [self action];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 100.0;
    }
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        BrandHeaderView *headV = [[BrandHeaderView alloc] init];
        headV.collectButton.hidden = YES;
        [headV.leftV sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
        headV.nameLabel.text = self.dataDic[@"merchant_name"];
        return headV;
    }
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 50.0)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"店铺信息";
    label.textColor = [UIColor blackColor];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 10, 0, 0));
    }];
    return view;
}

- (void)getInfo_Merchant {
    if (!self.merchant_id) {
        return;
    }
    NSString *url = @"https://zbt.change-word.com/index.php/home/merchant/merchantDetail";
    AFHTTPSessionManager *manger = [[AFHTTPSessionManager alloc] init];
    manger.responseSerializer.acceptableContentTypes = [manger.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"merchant_id" : self.merchant_id};
    __weak typeof(self) weakSelf = self;
    [manger POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"商家详情信息 === %@", responseObject);
        weakSelf.dataDic = (NSDictionary *)responseObject[@"data"];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 选择导航app
- (void)action {
    //    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=%@&destination=latlng:%@|name=%@&mode=driving&coord_type=gcj02", [[NSUserDefaults standardUserDefaults] objectForKey:@"Location_info"], self.data[@"merchant"][@"shop_address"], @"zzz"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
    
    //    NSString *url = @"http://api.map.baidu.com/cloudgc/v1/?address=杭州市&output=json&ak=G5D0r4BzFCPc2vQSQTMusvFjzFj6pEVP&mcode=com.zhong.phone";
    //获取商家所在地的经纬度
    NSString *url = [NSString stringWithFormat:@"http://api.map.baidu.com/cloudgc/v1/?address=%@&output=json&ak=%@&mcode=%@", self.dataDic[@"shop_address"], BAIDU_AK, BAIDU_MCODE];
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
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{%@}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02", [[NSUserDefaults standardUserDefaults] objectForKey:@"Location_info"], [two[@"lat"] floatValue], [two[@"lng"] floatValue], self.dataDic[@"merchant"][@"shop_address"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
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
