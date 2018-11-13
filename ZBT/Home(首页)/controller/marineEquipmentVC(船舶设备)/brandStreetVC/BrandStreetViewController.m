//
//  BrandStreetViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/10.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BrandStreetViewController.h"
#import "BrandStreetTableViewCell.h"

#import "Globefile.h"
#import <Masonry.h>

#import "AllArticleViewController.h"

@interface BrandStreetViewController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation BrandStreetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商家列表";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = BrandCellHeight;
//    DropView(tableView);
    [self.tableView registerClass:[BrandStreetTableViewCell class] forCellReuseIdentifier:@"brand"];
    
    [self.view addSubview:self.tableView];
    
    [self setUpNav];
    
    [self getEquipmentMerchantList];
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
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.row];
    BrandStreetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"brand"];
    cell.textF.text = dic[@"merchant_name"];
    cell.dateTextF.text = [NSString stringWithFormat:@"%@-%@", dic[@"start_business_time"], dic[@"end_business_time"]];
    cell.addresstextF.text = dic[@"shop_address"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 60.0;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 60)];
    view.backgroundColor = [UIColor whiteColor];
    
    UITextField *textF = [[UITextField alloc] init];
    textF.enabled = NO;
    textF.text = [@"     " stringByAppendingString:isNullClass(self.category_name)];//@"    铃木船外机";
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:FRAME(0, 0, view.bounds.size.height - 20, view.bounds.size.height - 20)];
//    imageV.backgroundColor = RandomColor;
    imageV.image = [UIImage imageNamed:@"public"];
    textF.leftView = imageV;
    textF.leftViewMode = UITextFieldViewModeAlways;
    
    [view addSubview:textF];
    
    [textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(10, 15, 10, 0));
    }];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    AllArticleViewController *all = [[AllArticleViewController alloc] init];
    all.merchant_id = self.dataArr[indexPath.row][@"merchant_id"];
    [self.navigationController pushViewController:all animated:YES];
}

- (void)getEquipmentMerchantList {
    if (!self.category_id) {
        return;
    }
    NSLog(@"category_id === %@", self.category_id);
    NSString *url = @"https://zbt.change-word.com/home/merchant/categoryMerchant";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"category_id" : self.category_id
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"categoryMerchant === %@", responseObject);
        weakSelf.dataArr = (NSArray *)responseObject[@"data"];
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
