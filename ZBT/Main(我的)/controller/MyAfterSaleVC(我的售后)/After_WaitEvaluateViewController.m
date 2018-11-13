//
//  After_WaitEvaluateViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/11.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "After_WaitEvaluateViewController.h"
#import "Globefile.h"
#import "MineTableViewCell.h"
#import "After_infoViewController.h"

@interface After_WaitEvaluateViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong)NSArray *datatAry;

@end

@implementation After_WaitEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的定制";
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
//        DropView(_tableView);
        
        [self.tableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:@"order"];
    }
    return _tableView;
}

- (void)addRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self show];
        
        //数据请求 写这里
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hidden];
            [self.tableView.mj_header endRefreshing];
            //            self.datatAry = dataAry;
            [self.tableView reloadData];
        });
    }];
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController didViewDidLoad:(NSInteger)index{
    [self.view addSubview:self.tableView];
    //    [self addRefresh];
    [self getData];
}

- (void)getData {
    [self show];
    NSString *url = @"https://zbt.change-word.com/index.php/home/yuyue/getYuyueOrder";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"type" : @(4),
                            @"state" : @(3)
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hidden];
        [weakSelf.tableView.mj_header endRefreshing];
        NSLog(@"我的售后 ==== %@", responseObject);
        weakSelf.datatAry = [(NSArray *)responseObject[@"data"] mutableCopy];
        [weakSelf.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"我的售后 ==== %@", error);
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
    //    return self.datatAry.count;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"售后编号：%@", self.datatAry[section][@"yuyue_number"]];//@"售后编号：12847912749172476";
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 10, 0, 0));
    }];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"order"];
    if (!cell) {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    [self setCellContent:cell AtIndexPaht:indexPath];
    //    NSDictionary *dict = self.datatAry[indexPath.row];
    //    cell.textLabel.text = dict[@"name"];
    //    cell.detailTextLabel.text = dict[@"detail"];
    //    cell.textLabel.font = [UIFont systemFontOfSize:16];
    //    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}

- (void)setCellContent:(MineTableViewCell *)cell AtIndexPaht:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.datatAry[indexPath.section];
    cell.CellHeight = 110.0;
    [cell layoutIfNeeded];
    //    cell.leftImageV.image = [UIImage imageNamed:@"public"];
    [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
    cell.topTextF.text = dic[@"service_name"];//@"XX冲锋艇";
    CGFloat width = [self calculateRowWidth:@"发布价:¥20000" withFont:14];
    CGFloat height = cell.topTextF.bounds.size.height;
    [cell.topTextF creatRightView:FRAME(0, 0, width, height) AndTitle:@"发布价:¥20000" TextAligment:NSTextAlignmentRight Font:SetFont(14) Color:[UIColor redColor]];
    cell.bottomTextF.font = SetFont(13);
    cell.bottomTextF.text = @"2018-10-10 13:00";
    [cell.bottomTextF creatRightView:FRAME(0, 0, [self calculateRowWidth:dic[@"merchant_name"] withFont:13], height) AndTitle:dic[@"merchant_name"] TextAligment:NSTextAlignmentLeft Font:SetFont(13) Color:[UIColor blackColor]];
}
StringWidth();

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    After_infoViewController *info = [[After_infoViewController alloc] init];
    info.orderType = 3;
    info.yuyue_id = self.datatAry[indexPath.section][@"yuyue_id"];
    info.imageURL = self.datatAry[indexPath.section][@"photo"];
    [self.navigationController pushViewController:info animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//编辑的具体操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadData];
    NSString *url = @"https://zbt.change-word.com/index.php/home/order/orderDel";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"id" : [NSString stringWithFormat:@"%@", self.datatAry[indexPath.section][@"yuyue_id"]],
                            @"type" : @(2)
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf getData];
        NSLog(@"删除艇卖  ==== %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
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
