//
//  BrandListInfoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BrandListInfoViewController.h"
#import "HomeOtherTableViewCell.h"
#import "Globefile.h"
#import "LoopView.h"
#import "AllArticleViewController.h"
#import "callAcitonView.h"


@interface BrandListInfoViewController ()<UITableViewDelegate, UITableViewDataSource, callPhoneDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *brandsArray;

@end

@implementation BrandListInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"品牌商家";
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[HomeOtherTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self getBrand_ID_Detail];
    
    [self setUpNav];
}

- (void)getBrand_ID_Detail {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    if (!self.brand_id) {
        return;
    }
    NSDictionary *parame = @{@"brand_id" : self.brand_id};
    
    [manager POST:@"https://zbt.change-word.com/index.php/home/merchant/brandMerchant" parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject === %@", responseObject);
        self.brandsArray = (NSArray *)responseObject[@"data"];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    //http://45.77.244.195/index.php/home/brand/brandDetail
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.brandsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate = self;
    cell.indexPath = indexPath;
    //    cell.CellHeight = 110.0;
    [cell layoutIfNeeded];
    NSDictionary *dataDic = self.brandsArray[indexPath.row];
    cell.centerLabel.font = SetFont(13);
    cell.bottomLabel.font = SetFont(13);
    cell.topLabel.text = dataDic[@"merchant_name"];
    cell.centerLabel.text = dataDic[@"shop_address"];
    cell.bottomLabel.text = [NSString stringWithFormat:@"营业时间 周一到周五 %@-%@", dataDic[@"start_business_time"], dataDic[@"end_business_time"]];
    return cell;
}

//拨打电话
- (void)callPhoneWithPhoneTitle:(NSIndexPath *)indexPath {
    [callAcitonView showCallActionWithTitle:self.brandsArray[indexPath.row][@"shop_phone"] AndShowView:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return OtherCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AllArticleViewController *article = [[AllArticleViewController alloc] init];
    article.merchant_id = self.brandsArray[indexPath.row][@"merchant_id"];
    [self.navigationController pushViewController:article animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor whiteColor];
//    UIImageView *imageV = [[UIImageView alloc] init];
//    [imageV sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
//    [view addSubview:imageV];
//    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(view.mas_top).offset(5);
//        make.bottom.equalTo(view.mas_bottom).offset(-5);
//        make.centerX.equalTo(view.mas_centerX);
//        make.width.mas_equalTo(@(150));
//    }];
//    return view;
    LoopView *loop = [[LoopView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 200.0)];
    loop.imageArray = @[@"1", @"2", @"3", @"4"];
    return loop;
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
