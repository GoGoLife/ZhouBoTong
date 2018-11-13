//
//  SellProjectViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/24.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "SellProjectViewController.h"
#import "AppointmentViewController.h"
#import "BottimView.h"
#import "ProjectInfoViewController.h"
#import "callAcitonView.h"
#import "PlayVideo_TableViewCell.h"
#import <UShareUI/UShareUI.h>
#import "URLImageScroll.h"

@interface SellProjectViewController ()<SelectNumberDelegate, UITextFieldDelegate>
{
    UIView *backgroundView;
}

//记录选取的规格      同时表示是否选取了规格
@property (nonatomic, strong) NSString *isChooseStandards;

@end

@implementation SellProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.view.userInteractionEnabled = YES;
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction_sell)];
    self.navigationItem.rightBarButtonItem = right;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerClass:[PlayVideo_TableViewCell class] forCellReuseIdentifier:@"playCell"];
    
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 45, 0));
    }];
    
    //立刻预约
    
    UITextField *bottom = [[UITextField alloc] init];
    bottom.backgroundColor = [UIColor whiteColor];
    bottom.enabled = YES;
    bottom.delegate = self;
    bottom.textAlignment = NSTextAlignmentLeft;
    bottom.textColor = [UIColor redColor];
//    bottom.font =
//    bottom.text = @"  ¥12000";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = FRAME(0, 0, 110, 45);
    button.titleLabel.font = SetFont(12);
    [button setTitle:@"立即预约" forState:UIControlStateNormal];
    [button setBackgroundColor:SetColor(252, 174, 79, 1)];
    [button addTarget:self action:@selector(pushAppointmentVC) forControlEvents:UIControlEventTouchUpInside];
    [bottom creatRightView:button.frame AndControl:button];
    
    [self.view addSubview:bottom];
    
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(@(45));
    }];
    
    [self setUpNav];
    
    [self getServeInfo_serveID];
    [self getServeInfo_commissionID];
    [self getServeInfo_trainID];
}
setBack();
pop();

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableViewr {
    if (self.isWharfGoVC) {
        return 5;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isWharfGoVC) {
        switch (section) {
            case 0:
                return 0;
                break;
            case 1:
                return 1;
                break;
            case 2:
                return 1;
                break;
            case 3:
                return 1;
                break;
            case 4:
                return 2;
                break;
                
            default:
                break;
        }
    }else {
        switch (section) {
            case 0:
                return 0;
                break;
            case 1:
                return 1;
                break;
            case 2:
                return 1;
                break;
            case 3:
                return 2;
                break;
                
            default:
                break;
        }
    }
    return 0;
}

StringWidth();
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isWharfGoVC) {
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textF.textAlignment = NSTextAlignmentLeft;
        cell.textF.enabled = NO;
        switch (indexPath.section) {
            case 0:break;
            case 1:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.isNewLayout = YES;
                cell.textF.enabled = NO;
                CGFloat width = [self calculateRowWidth:@"规格/人数" withFont:14];
                [cell.textF creatLeftView:FRAME(0, 0, width, cell.bounds.size.height) AndTitle:@"规格/人数" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:[UIColor blackColor]];
                [cell.textF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"选择规格" withFont:14], cell.bounds.size.height) AndTitle:@"选择规格" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:SetColor(162, 162, 162, 1)];
            }
                break;
            case 2:
            {
                cell.textF.font = SetFont(14);
                cell.textF.text = self.dataDic[@"title"];//@"Marquis yachts.LLC.USA";
            }
                break;
            case 3:
            {
//                cell.textF.text = @"Marquis yachts.LLC.USA(播放视频)";
                PlayVideo_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.info_string = self.dataDic[@"info"];
                cell.info_label.text = self.dataDic[@"info"];
                cell.video_URLString = isNullClass(self.dataDic[@"video"]);
                return cell;
            }
                break;
            case 4:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.isNewLayout = YES;
                if (indexPath.row == 0) {
                    cell.textF.text = self.dataDic[@"merchant"][@"shop_address"];//@"杭州市小码头";
                    CGFloat width = [self calculateRowWidth:@"地址：" withFont:14];
                    [cell.textF creatLeftView:FRAME(0, 0, width, cell.bounds.size.height) AndTitle:@"地址：" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:[UIColor blackColor]];
                    [cell.textF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"导航" withFont:14], cell.bounds.size.height) AndTitle:@"导航" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:SetColor(162, 162, 162, 1)];
                }else if(indexPath.row == 1){
                    cell.textF.text = self.dataDic[@"merchant"][@"shop_phone"];//@"18268865135";
                    CGFloat width = [self calculateRowWidth:@"电话：" withFont:14];
                    [cell.textF creatLeftView:FRAME(0, 0, width, cell.bounds.size.height) AndTitle:@"电话：" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:[UIColor blackColor]];
                    [cell.textF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"一键拨号" withFont:14], cell.bounds.size.height) AndTitle:@"一键拨号" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:SetColor(162, 162, 162, 1)];
                }
            }
                break;
                
            default:
                break;
        }
        return cell;
    }else {
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textF.textAlignment = NSTextAlignmentLeft;
        cell.textF.enabled = NO;
        switch (indexPath.section) {
            case 0:break;
            case 1:
            {
                cell.textF.font = SetFont(14);
                cell.textF.text = self.dataDic[@"title"];//@"Marquis yachts.LLC.USA";
            }
                break;
            case 2:
            {
//                cell.textF.text = @"Marquis yachts.LLC.USA(播放视频)";
                PlayVideo_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.info_string = self.dataDic[@"info"];
                cell.info_label.text = self.dataDic[@"info"];
                cell.video_URLString = isNullClass(self.dataDic[@"video"]);
                return cell;
            }
                break;
            case 3:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.isNewLayout = YES;
                if (indexPath.row == 0) {
                    cell.textF.text = self.dataDic[@"merchant"][@"shop_address"];//@"杭州市小码头";
                    CGFloat width = [self calculateRowWidth:@"地址：" withFont:14];
                    [cell.textF creatLeftView:FRAME(0, 0, width, cell.bounds.size.height) AndTitle:@"地址：" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:[UIColor blackColor]];
                    [cell.textF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"导航" withFont:14], cell.bounds.size.height) AndTitle:@"导航" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:SetColor(162, 162, 162, 1)];
                }else {
                    cell.textF.text = self.dataDic[@"merchant"][@"shop_phone"];//@"18268865135";
                    CGFloat width = [self calculateRowWidth:@"电话：" withFont:14];
                    [cell.textF creatLeftView:FRAME(0, 0, width, cell.bounds.size.height) AndTitle:@"电话：" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:[UIColor blackColor]];
                    [cell.textF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"一键拨号" withFont:14], cell.bounds.size.height) AndTitle:@"一键拨号" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:SetColor(162, 162, 162, 1)];
                }
            }
                break;
                
            default:
                break;
        }
        return cell;
    }
    
}

StringHeight()
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isWharfGoVC) {
        if (indexPath.section == 3) {
            CGFloat height = [self calculateRowHeight:self.dataDic[@"info"] fontSize:14 withWidth:SCREENBOUNDS.width - 10];
            return 220 + height;
        }
    }else {
        if (indexPath.section == 2) {
            CGFloat height = [self calculateRowHeight:self.dataDic[@"info"] fontSize:14 withWidth:SCREENBOUNDS.width - 10];
            return 220 + height;
        }
    }
    
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isWharfGoVC) {
        if (section == 0) {
            return 200.0;
        }
        if (section == 1) {
            return 80.0;
        }
    }else {
        if (section == 0) {
            return 200.0;
        }
    }
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.isWharfGoVC) {
        if (section == 0) {
            return 0.0;
        }
        if (section == 1) {
            return 10.0;
        }
        return 10.0;
    }else {
        if (section == 0) {
            return 80.0;
        }
    }
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isWharfGoVC) {
        if (section == 0) {
//            LoopView *loopV = [[LoopView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 200.0)];
//            loopV.imageArray = @[@"1", @"2", @"3", @"4"];
//            return loopV;
            URLImageScroll *scroll = [[URLImageScroll alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 200) withImageArray:self.dataDic[@"photo"]];
            return scroll;
            
        }
        if (section == 1) {
            self.SellView = [[SellHeaderView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 80.0)];
            [self.SellView layoutIfNeeded];
            self.SellView.topLabel.text = self.dataDic[@"service_name"];//@"Marquis Yachts.LLC.USA";
            self.SellView.bottomTextF.text = [NSString stringWithFormat:@"定金：%@", self.dataDic[@"sort"]];//@"定金：100";
            NSString *price = [NSString stringWithFormat:@"¥%@", self.dataDic[@"price"]];
            CGFloat width = [self calculateRowWidth:price withFont:17];
            [self.SellView.bottomTextF creatLeftView:FRAME(0, 0, width + 10, self.SellView.bottomTextF.bounds.size.height) AndTitle:price TextAligment:NSTextAlignmentLeft Font:SetFont(17) Color:[UIColor redColor]];
            return self.SellView;
        }
    }else {
        if (section == 0) {
//            LoopView *loopV = [[LoopView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 200.0)];
//            loopV.imageArray = @[@"1", @"2", @"3", @"4"];
//            return loopV;
            URLImageScroll *scroll = [[URLImageScroll alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 200) withImageArray:self.dataDic[@"photo"]];
            return scroll;
        }
    }
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 44.0)];
    view.backgroundColor = [UIColor whiteColor];
    UITextField *label = [[UITextField alloc] initWithFrame:FRAME(10, 0, view.bounds.size.width - 20, view.bounds.size.height)];
    label.textAlignment = NSTextAlignmentLeft;
    label.enabled = NO;
    [view addSubview:label];
    label.font = SetFont(12);
    NSInteger sectionIndex = 1;
    if (self.isWharfGoVC) {
        sectionIndex = 2;
    }
    if (section == sectionIndex) {
        label.textColor = SetColor(63, 63, 63, 1);
        label.text = @"项目介绍";
    }else if (section == sectionIndex + 1) {
        label.textColor = SetColor(63, 63, 63, 1);
        label.text = @"项目详情";
    }else if (section == sectionIndex + 2){
        label.enabled = YES;
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = SetColor(173, 173, 173, 1);
        NSString *merchantName = [NSString stringWithFormat:@"商家名称: %@", self.dataDic[@"merchant"][@"merchant_name"]];
        CGFloat width = [self calculateRowWidth:merchantName withFont:12];
        [label creatLeftView:FRAME(0, 0, width, view.bounds.size.height) AndTitle:merchantName TextAligment:NSTextAlignmentLeft Font:SetFont(12) Color:SetColor(63, 63, 63, 1)];
        label.text = @"更多项目";
        UIImageView *right = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 8, 13)];
        right.image = [UIImage imageNamed:@"right"];
        [label creatRightView:right.bounds AndControl:right];
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushInfo)];
        [label addGestureRecognizer:tap];
    }
    return view;
}

- (void)pushInfo {
    ProjectInfoViewController *info = [[ProjectInfoViewController alloc] init];
    info.merchant_id = self.dataDic[@"merchant_id"];
    [self.navigationController pushViewController:info animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0 && !self.isWharfGoVC) {
        SellHeaderView *view = [[SellHeaderView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 80.0)];
        [view layoutIfNeeded];
        view.topLabel.text = self.dataDic[@"service_name"] ?: self.dataDic[@"name"] ?: self.dataDic[@"serve_name"];//@"Marquis Yachts.LLC.USA";  
        view.bottomTextF.text = [NSString stringWithFormat:@"定金：%@", self.dataDic[@"down_payment"]?:self.dataDic[@"down_payment"]];//@"定金：100";
        NSString *price = [NSString stringWithFormat:@"¥%@", self.dataDic[@"price"]];
        CGFloat width = [self calculateRowWidth:price withFont:17];
        [view.bottomTextF creatLeftView:FRAME(0, 0, width + 10, view.bottomTextF.bounds.size.height) AndTitle:price TextAligment:NSTextAlignmentLeft Font:SetFont(17) Color:[UIColor redColor]];
        return view;
    }
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 10.0)];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}

- (void)pushAppointmentVC {  //立即预约
    NSLog(@"isChoose === %@", self.isChooseStandards);
    if (self.isChooseStandards == nil && self.isWharfGoVC) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请选取规格之后进行预约"];
        return;
    }
    AppointmentViewController *ment = [[AppointmentViewController alloc] init];
    ment.isWharfGOVC = self.isWharfGoVC;
    ment.currentDataDic = self.dataDic;
    ment.number = @"1";
    [self.navigationController pushViewController:ment animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isWharfGoVC && indexPath.section == 1) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        backgroundView = [[UIView alloc] initWithFrame:delegate.window.bounds];
        backgroundView.backgroundColor = SetColor(204, 204, 204, 0.5);
        [delegate.window addSubview:backgroundView];
        
        BottimView *view = [[BottimView alloc] init];
        view.delegate = self;
        [view.sureButton addTarget:self action:@selector(cancelView) forControlEvents:UIControlEventTouchUpInside];
        view.backgroundColor = [UIColor whiteColor];
        [backgroundView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(delegate.window.mas_bottom);
            make.left.equalTo(delegate.window.mas_left);
            make.right.equalTo(delegate.window.mas_right);
            make.height.mas_equalTo(@(280));
        }];
    }
    if (self.isWharfGoVC) {
        if (indexPath.section == 4 && indexPath.row == 1) {
            [callAcitonView showCallActionWithTitle:self.dataDic[@"merchant"][@"shop_phone"] AndShowView:self];
        }else if (indexPath.section == 4 && indexPath.row == 0) {
            [self action];
        }
    }else {
        if (indexPath.section == 3 && indexPath.row == 1) {
            [callAcitonView showCallActionWithTitle:self.dataDic[@"merchant"][@"shop_phone"] AndShowView:self];
        }else if (indexPath.section == 3 && indexPath.row == 0) {
            [self action];
        }
    }
}

- (void)cancelView {
    [backgroundView removeFromSuperview];
}

//选择人数
- (void)selectNumber:(NSInteger)number {
    NSLog(@"number ===== %ld", number);
    self.isChooseStandards = [NSString stringWithFormat:@"%ld", number];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

//水上娱乐   码头出行
- (void)getServeInfo_serveID {
    if (!self.serve_id) {
        return;
    }
    NSString *url = @"https://zbt.change-word.com/home/service/serviceInfo";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"service_id" : self.serve_id};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"ServeInfo === %@", responseObject);
        weakSelf.dataDic = (NSDictionary *)responseObject[@"data"];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//代办服务
- (void)getServeInfo_commissionID {
    if (!self.commission_id) {
        return;
    }
    NSString *url = @"https://zbt.change-word.com/home/service/serviceInfo";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"commission_id" : self.commission_id};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"commissionInfo === %@", responseObject);
        weakSelf.dataDic = (NSDictionary *)responseObject[@"data"];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//驾照培训
- (void)getServeInfo_trainID {
    if (!self.train_type_id) {
        return;
    }
    NSString *url = @"https://zbt.change-word.com/home/service/serviceInfo";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"train_type_id" : self.train_type_id};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"train_type_id === %@", responseObject);
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
    NSString *url = [NSString stringWithFormat:@"http://api.map.baidu.com/cloudgc/v1/?address=%@&output=json&ak=%@&mcode=%@", self.dataDic[@"merchant"][@"shop_address"], BAIDU_AK, BAIDU_MCODE];
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
    //@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02", [one[@"lat"] floatValue], [one[@"lng"] floatValue], [two[@"lat"] floatValue], [two[@"lng"] floatValue], @"zzz"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{%@}}&destination=latlng:%f,%f|name={{%@}}&mode=driving&coord_type=gcj02", [[NSUserDefaults standardUserDefaults] objectForKey:@"Location_info"], [two[@"lat"] floatValue], [two[@"lng"] floatValue], self.dataDic[@"merchant"][@"shop_address"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)shareAction_sell {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        switch (platformType) {
            case UMSocialPlatformType_QQ:
            {
                NSLog(@"分享到QQ!!");
                [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
                //                                [self shareTextToPlatformType:UMSocialPlatformType_QQ];
            }
                break;
            case UMSocialPlatformType_Qzone:
            {
                NSLog(@"分享到QQ空间!!");
                //                                [self shareTextToPlatformType:UMSocialPlatformType_Qzone];
                [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
            }
                break;
            case UMSocialPlatformType_WechatSession:
            {
                NSLog(@"分享到微信!!");
                //                                [self shareTextToPlatformType:UMSocialPlatformType_WechatSession];
                [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
            }
                break;
            case UMSocialPlatformType_WechatTimeLine:
            {
                NSLog(@"分享到朋友圈!!");
                //                                [self shareTextToPlatformType:UMSocialPlatformType_WechatTimeLine];
                [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
            }
                break;
                
                
            default:
                break;
        }
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    //    if (platformType == UMSocialPlatformType_WechatSession) {
    //        WXMiniProgramObject *miniObject = [WXMiniProgramObject object];
    //        miniObject.webpageUrl = @"https://zbt.change-word.com/home/index/login";
    //        miniObject.userName = @"wx8fa1d3305bb95168";
    //        miniObject.path = @"pages/index/index";
    //        miniObject.hdImageData = UIImagePNGRepresentation([UIImage imageNamed:@"wx.png"]);
    //
    //        WXMediaMessage *message = [WXMediaMessage message];
    //        message.title = @"舟博通";
    //        message.description = @"跳转舟博通小程序";
    //        message.mediaObject = miniObject;
    //        message.thumbData = nil;
    //
    //        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    //        req.message = message;
    //        req.scene = WXSceneSession;
    //        [WXApi sendReq:req];
    //    }else {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL =  [self.dataDic[@"photo"] firstObject];//@"https://zbt.change-word.com/Public/20180830101912.png";
    NSString *title = self.dataDic[@"service_name"] ?: self.dataDic[@"title"] ?: self.dataDic[@"serve_name"] ?: self.dataDic[@"name"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:self.dataDic[@"info"] thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = [@"https://itunes.apple.com/us/app/舟博通/id1237486832?l=zh&ls=1&mt=8" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
    //    }
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
