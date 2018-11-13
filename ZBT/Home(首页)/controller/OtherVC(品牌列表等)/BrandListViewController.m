//
//  BrandListViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BrandListViewController.h"
#import "Globefile.h"
#import <Masonry.h>
#import "BrandListInfoViewController.h"
#import "BrandStreetViewController.h"

@interface BrandListViewController ()

@end

@implementation BrandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"品牌列表";
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    DropView(self.tableView);
    [self.tableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self setUpNav];
    
    if (!self.category_top_id) {
        [self getData];
    }else {
        [self getTopCategory];
    }
}

- (void)getData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:@"https://zbt.change-word.com/index.php/Home/Brand/brandList" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response ==== %@", responseObject);
        self.dataArray = responseObject[@"data"];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error === %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.category_top_id) {
        MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        [cell layoutIfNeeded];
        NSString *urlString = self.dataArray[indexPath.row][@"logo"];
        [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"public"]];
        cell.topTextF.text = self.dataArray[indexPath.row][@"category_name"];
        cell.centerTextF.text = @"";//[NSString stringWithFormat:@"%@个合作商家", self.dataArray[indexPath.row][@"merchant_number"]];
        cell.bottomTextF.text = @"";//@"2039个好评";
        return cell;
    }
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell layoutIfNeeded];
    NSString *urlString = self.dataArray[indexPath.row][@"photo"];
    [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"public"]];
    cell.topTextF.text = self.dataArray[indexPath.row][@"brand_name"];
    cell.centerTextF.text = [NSString stringWithFormat:@"%@个合作商家", self.dataArray[indexPath.row][@"merchant_number"]];
    cell.bottomTextF.text = @"2039个好评";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MineCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.category_top_id) {
        BrandStreetViewController *list = [[BrandStreetViewController alloc] init];
        list.category_id = self.dataArray[indexPath.row][@"category_id"];
        list.category_name = self.dataArray[indexPath.row][@"category_name"];
        [self.navigationController pushViewController:list animated:YES];
    }else {
        BrandListInfoViewController *info = [[BrandListInfoViewController alloc] init];
        info.title = @"品牌商家";
        info.brand_id = self.dataArray[indexPath.row][@"brand_id"];
        info.imageUrl = self.dataArray[indexPath.row][@"photo"];
        [self.navigationController pushViewController:info animated:YES];
    }
}

- (void)getTopCategory {
    if (!self.category_top_id) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/index.php/home/goods/getSecond";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parame = @{
                             @"category_id" : self.category_top_id
                             };
    [manager POST:url parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"MTTArray === %@", responseObject);
        weakSelf.dataArray = responseObject[@"data"];
        [weakSelf.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
