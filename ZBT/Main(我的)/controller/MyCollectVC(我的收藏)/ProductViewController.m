//
//  ProductViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ProductViewController.h"
#import "Globefile.h"

#import "CollectTableViewCell.h"
#import "SellProjectViewController.h"
#import "EquipmentInfoViewController.h"

@interface ProductViewController ()<UITableViewDelegate, UITableViewDataSource, DismissCollectDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong)NSArray *datatAry;

@end

@implementation ProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        DropView(_tableView);
        
        [self.tableView registerClass:[CollectTableViewCell class] forCellReuseIdentifier:@"order"];
    }
    return _tableView;
}

- (void)addRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self show];
        
        
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self hidden];
//            [self.tableView.mj_header endRefreshing];
////            self.datatAry = dataAry;
//            [self.tableView reloadData];
//        });
    }];
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController didViewDidLoad:(NSInteger)index{
    [self.view addSubview:self.tableView];
//    [self addRefresh];
    [self show];
    [self getCollectProduct_me];
}

- (void)getCollectProduct_me {
    NSString *url = @"https://zbt.change-word.com/home/Collection/goodsCollectionList";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"phone" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account"]};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hidden];
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.datatAry = (NSArray *)responseObject[@"data"];
        [weakSelf.tableView reloadData];
        NSLog(@"商品收藏列表 ==== %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error === %@", error);
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
    CollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"order"];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.type = CollectCellTypeProduct;
    if (!cell) {
        cell = [[CollectTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    NSDictionary *dic = self.datatAry[indexPath.row];
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
    cell.label.text = dic[@"goods_name"];
    cell.typeLabel.text = dic[@"goods_price"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CollectCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EquipmentInfoViewController *info = [[EquipmentInfoViewController alloc] init];
    info.goods_id = self.datatAry[indexPath.row][@"goods_id"];
    [self.navigationController pushViewController:info animated:YES];
    
}

- (void)dismissCollect:(NSIndexPath *)indexPath {
    NSString *url = @"https://zbt.change-word.com/index.php/home/Collection/cancelCollection";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"goods_collection_id" : self.datatAry[indexPath.row][@"goods_collection_id"]};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"取消收藏 ==== %@", responseObject);
        [weakSelf getCollectProduct_me];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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
