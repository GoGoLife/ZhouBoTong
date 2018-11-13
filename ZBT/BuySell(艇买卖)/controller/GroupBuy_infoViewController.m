//
//  GroupBuy_infoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/28.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "GroupBuy_infoViewController.h"
#import "Globefile.h"
#import "LoopView.h"
#import "callAcitonView.h"

@interface GroupBuy_infoViewController ()

@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation GroupBuy_infoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 44, 0));
    }];
    
    self.addV = [[AddCartsView alloc] init];
    self.addV.AddCartsButton.hidden = YES;
    self.addV.DPButton.hidden = YES;
    self.addV.KFButton.hidden = YES;
    [self.addV.PayButton setTitle:@"参团" forState:UIControlStateNormal];
    [self.view addSubview:self.addV];
    [self.addV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(44));
    }];
    
    [self getInfo];
}

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
            return 0;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

StringWidth();
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textF.enabled = NO;
    cell.textF.textAlignment = NSTextAlignmentLeft;
    cell.textF.font = SetFont(14);
    cell.textF.textColor = SetColor(69, 69, 69, 1);
    CGFloat width = [self calculateRowWidth:@"规格/数量：" withFont:14];
    
    if (indexPath.section == 1) {
        NSArray *leftArray = @[@"数量", @"配送范围：", @"运费："];
        [cell layoutIfNeeded];
        [cell.textF creatLeftView:FRAME(0, 0, width, 50.0) AndTitle:leftArray[indexPath.row] TextAligment:NSTextAlignmentLeft Font:SetFont(14) Color:SetColor(69, 69, 69, 1)];
        if (indexPath.row == 0) {
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textF.textAlignment = NSTextAlignmentRight;
            [cell.textF creatRightView:FRAME(0, 0, width, 50) AndTitle:@"1件" TextAligment:NSTextAlignmentRight Font:SetFont(14) Color:SetColor(69, 69, 69, 1)];
        }else if (indexPath.row == 1) {
            cell.textF.text = isNullClass(self.dataDic[@"merchant"][@"distribution_scope"]);
        }else {
            cell.textF.text = isNullClass(self.dataDic[@"merchant"][@"distribution_fee"]);
        }
    }else if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *leftImageV = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 20, 20)];
        leftImageV.image = [UIImage imageNamed:@"dianpu"];
        [cell.textF creatLeftView:leftImageV.bounds AndControl:leftImageV];
        cell.textF.text = [@"    " stringByAppendingString:isNullClass(self.dataDic[@"merchant"][@"merchant_name"])];
        [cell.textF creatRightView:FRAME(0, 0, width, 50) AndTitle:@"一键拨号" TextAligment:NSTextAlignmentRight Font:SetFont(14) Color:SetColor(69, 69, 69, 1)];
    }else {
        cell.textF.text = self.dataDic[@"info"];//@"详细信息";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 200.0;
    }else if (section == 1 || section == 2) {
        return 0.0;
    }else {
        return 40.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 120.0;
    }
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        LoopView *view = [[LoopView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 200)];
        view.imageArray = @[@"1", @"2", @"3", @"4"];
        return view;
    }else if (section == 1 || section == 2) {
        return [[UIView alloc] init];
    }else {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
        label.textColor = SetColor(69, 69, 69, 1);
        label.font = SetFont(13);
        label.text = @"详细信息";
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, 0));
        }];
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        self.GroupHeaderView = [[GroupBuyView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 120)];
        self.GroupHeaderView.collectBtn.hidden = YES;
        self.GroupHeaderView.backgroundColor = [UIColor whiteColor];
        self.GroupHeaderView.dateTextF.font = SetFont(12);
        self.GroupHeaderView.remarkLabel.font = SetFont(12);
        self.GroupHeaderView.dateTextF.textColor = [UIColor redColor];
        self.GroupHeaderView.remarkLabel.textColor = [UIColor redColor];
        self.GroupHeaderView.topTextF.text = self.dataDic[@"group_name"];
        self.GroupHeaderView.priceLeftString = [NSString stringWithFormat:@"参团价：￥%@", self.dataDic[@"group_price"]];//@"参团价：¥7000";
        self.GroupHeaderView.dateLeftString = @"团购时间：";
        self.GroupHeaderView.dateTextF.text = [NSString stringWithFormat:@"%@-%@", self.dataDic[@"start_time"], self.dataDic[@"end_time"]];//@"2018-3-12至2018-12-12";
        self.GroupHeaderView.dateRightString = @"";//[NSString stringWithFormat:@"当前团购人数：%@人", self.dataDic[@"current_number"]];//@"当前团购：2人";
        self.GroupHeaderView.remarkLabel.text = [NSString stringWithFormat:@"当前团购人数：%@人", self.dataDic[@"current_number"]];;//@"注：团购未成功，款会按照原路径返给用户。";
        return self.GroupHeaderView;
    }
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        [callAcitonView showCallActionWithTitle:self.dataDic[@"merchant"][@"shop_phone"] AndShowView:self];
    }
}

- (void)getInfo {
    if (!self.group_id) {
        return;
    }
    NSString *url = @"https://zbt.change-word.com/home/group/groupInfo";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"group_id" : self.group_id
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"groupListInfo === %@", responseObject);
        weakSelf.dataDic = (NSDictionary *)responseObject[@"data"];
        [weakSelf.tableView reloadData];
        if (![weakSelf judgeTimeByStartAndEnd:weakSelf.dataDic[@"start_time"] EndTime:weakSelf.dataDic[@"end_time"]]) {
            self.addV.PayButton.backgroundColor = BaseViewColor;
            [self.addV.PayButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.addV.PayButton setTitle:@"已结束" forState:UIControlStateNormal];
            self.addV.PayButton.enabled = NO;
        }
        [weakSelf isJoinGroup];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"groupList error === %@", error);
    }];
}

- (void)isJoinGroup {
    if ([self.dataDic[@"is_group"] integerValue]) {
        self.addV.PayButton.backgroundColor = BaseViewColor;
        [self.addV.PayButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.addV.PayButton setTitle:@"已参团" forState:UIControlStateNormal];
        self.addV.PayButton.enabled = NO;
    }else {
        [self.addV.PayButton addTarget:self action:@selector(joinGroup) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)joinGroup {
    NSString *url = @"https://zbt.change-word.com/index.php/home/group/joinGroup";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"group_id" : self.group_id
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"groupListInfo === %@", responseObject);
        weakSelf.addV.PayButton.backgroundColor = BaseViewColor;
        [weakSelf.addV.PayButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [weakSelf.addV.PayButton setTitle:@"已参团" forState:UIControlStateNormal];
        weakSelf.addV.PayButton.enabled = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"groupList error === %@", error);
    }];
}


//判断当前时间是否在团购时间限制内
-(BOOL)judgeTimeByStartAndEnd:(NSString *)startStr EndTime:(NSString *)endStr
{
    //获取当前时间
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,建议大写    HH 使用 24 小时制；hh 12小时制
    [dateFormat setDateFormat:@"yyyy:mm:dd:HH:mm:ss"];
    NSString * todayStr=[dateFormat stringFromDate:today];//将日期转换成字符串
    today=[ dateFormat dateFromString:todayStr];//转换成NSDate类型。日期置为方法默认日期
    //start end 格式 "2016-05-18 9:00:00"
    NSDate *start = [dateFormat dateFromString:startStr];
    NSDate *expire = [dateFormat dateFromString:endStr];
    
    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
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
