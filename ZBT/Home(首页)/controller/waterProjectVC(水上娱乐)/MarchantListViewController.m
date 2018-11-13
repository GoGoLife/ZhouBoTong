//
//  MarchantListViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/4.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "MarchantListViewController.h"
#import "SellProjectViewController.h"

@interface MarchantListViewController ()

@end

@implementation MarchantListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家列表";
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = MARCHANTLISTCELLHEIGHT;
    DropView(self.tableView);
    [self.tableView registerClass:[MarchantListTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self setUpNav];
    
    if (self.categoryID) {
        [self getMerchantFromCategoryID];
    }
    
}

setBack();
pop();

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    MarchantListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
    cell.nameLabel.text = dic[@"service_name"] ?: dic[@"name"];
    cell.marchantLabel.text = [NSString stringWithFormat:@"【%@】", dic[@"merchant"][@"merchant_name"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@", dic[@"price"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SellProjectViewController *sell = [[SellProjectViewController alloc] init];
    sell.isWharfGoVC = self.isWharfGoVC;
    sell.serve_id = self.dataArray[indexPath.row][@"id"];
    sell.train_type_id = self.dataArray[indexPath.row][@"train_type_id"];
    [self.navigationController pushViewController:sell animated:YES];
}

- (void)getMerchantFromCategoryID {
    if (!self.categoryID) {
        return;
    }
    NSLog(@"%@", self.categoryID);
    NSString *url = @"https://zbt.change-word.com/index.php/home/service/categoryService";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"category_id" : self.categoryID};
    
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"merchantList  === %@", responseObject);
        weakSelf.dataArray = (NSArray *)responseObject[@"data"];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error === %@", error);
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
