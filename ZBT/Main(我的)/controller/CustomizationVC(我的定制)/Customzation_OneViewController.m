//
//  Customzation_OneViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/7.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Customzation_OneViewController.h"
#import "Globefile.h"
#import "MineTableViewCell.h"
#import "Customzation_InfoViewController.h"

@interface Customzation_OneViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong)NSArray *datatAry;

@end

@implementation Customzation_OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的定制";
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30) style:(UITableViewStyleGrouped)];
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
    [self getData];
}

- (void)getData {
    [self show];
    NSString *url = @"https://zbt.change-word.com/index.php/home/service/myCustomer";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"]
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hidden];
        [weakSelf.tableView.mj_header endRefreshing];
        NSLog(@"Pay  CustomAfter  ==== %@", responseObject);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datatAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"order"];
    if (!cell) {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    [self setCellContent:cell AtIndexPaht:indexPath];
    return cell;
}

- (void)setCellContent:(MineTableViewCell *)cell AtIndexPaht:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.datatAry[indexPath.row];
    cell.CellHeight = 110.0;
    [cell layoutIfNeeded];
    [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"serve"][@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
    cell.topTextF.text = dic[@"serve_name"];//@"XX冲锋艇";
    NSString *price = [NSString stringWithFormat:@"发布价:¥%@", dic[@"serve"][@"price"]];
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
    Customzation_InfoViewController *info = [[Customzation_InfoViewController alloc] init];
    info.isShowPrice = YES;
    info.serve_id = self.datatAry[indexPath.row][@"serve_id"];
    [self.navigationController pushViewController:info animated:YES];
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

