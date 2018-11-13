//
//  Publish_SellViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/12.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Publish_SellViewController.h"
#import "Globefile.h"
#import "MineTableViewCell.h"
#import "Publish_infoViewController.h"

@interface Publish_SellViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *datatAry;

@end

@implementation Publish_SellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        DropView(_tableView);
        
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
    [self show];
    NSString *url = @"https://zbt.change-word.com/index.php/home/goods/buyList";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"]};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hidden];
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.datatAry = [(NSArray *)responseObject[@"data"] mutableCopy];
//        NSLog(@"dataAry === %@", [responseObject allValues]);
//        NSLog(@"dataAry === %@", [responseObject allObjects]);
        [weakSelf.tableView reloadData];
        NSLog(@"艇卖列表 ==== %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    //
    //    NSArray *dataAry = @[@{
    //                             @"name": @"数码产品",
    //                             @"detail": @"手机,电脑等",
    //                             },
    //                         @{
    //                             @"name": @"数码产品",
    //                             @"detail": @"手机,电脑等",
    //                             },
    //                         @{
    //                             @"name": @"数码产品",
    //                             @"detail": @"手机,电脑等",
    //                             },
    //                         @{
    //                             @"name": @"数码产品",
    //                             @"detail": @"手机,电脑等",
    //                             }];
    //
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self hidden];
    //        [self.tableView.mj_header endRefreshing];
    //        self.datatAry = dataAry;
    //        [self.tableView reloadData];
    //    });
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datatAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"order"];
    if (!cell) {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    [self setCellContent:cell AtIndexPaht:indexPath];
//    NSDictionary *dict = self.datatAry[indexPath.row];
//    cell.topTextF.
    //    cell.textLabel.text = dict[@"name"];
    //    cell.detailTextLabel.text = dict[@"detail"];
    //    cell.textLabel.font = [UIFont systemFontOfSize:16];
    //    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}

- (void)setCellContent:(MineTableViewCell *)cell AtIndexPaht:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.datatAry[indexPath.row];
    cell.CellHeight = 110.0;
    [cell layoutIfNeeded];
//    cell.leftImageV.image = [UIImage imageNamed:@"public"];
    [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:dict[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
    cell.centerTextF.textAlignment = NSTextAlignmentRight;
    cell.bottomTextF.textAlignment = NSTextAlignmentRight;
    cell.topTextF.text = dict[@"title"];
    cell.centerTextF.text = @"x1";
    NSString *price = [NSString stringWithFormat:@"发布价:¥%@", dict[@"price"]];
    CGFloat width = [self calculateRowWidth:price withFont:14];
    CGFloat height = cell.topTextF.bounds.size.height;
    [cell.topTextF creatRightView:FRAME(0, 0, width, height) AndTitle:price TextAligment:NSTextAlignmentRight Font:SetFont(14) Color:[UIColor redColor]];
    cell.bottomTextF.text = @"2018-10-10 13:00";
}
StringWidth();

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Publish_infoViewController *info = [[Publish_infoViewController alloc] init];
    info.isShowPrice = YES;
    info.buy_id = [NSString stringWithFormat:@"%@", self.datatAry[indexPath.row][@"buy_id"]];
    info.publish_type = 2;
    info.isEdit = YES;
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
    [self.datatAry removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    NSString *url = @"https://zbt.change-word.com/index.php/home/goods/delBuySell";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"buy_id" : [NSString stringWithFormat:@"%@", self.datatAry[indexPath.row][@"buy_id"]]};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        weakSelf.datatAry = (NSArray *)[responseObject allValues];
        //        NSLog(@"dataAry === %@", [responseObject allValues]);
        //        NSLog(@"dataAry === %@", [responseObject allObjects]);
        //        [weakSelf.tableView reloadData];
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
