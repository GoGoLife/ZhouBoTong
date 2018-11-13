//
//  ClassifyViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ClassifyViewController.h"
#import "Globefile.h"

#import "LeftTableViewCell.h"

//本VC作为左视图    RightVC作为右视图
#import "RightViewController.h"

@interface ClassifyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) RightViewController *rightVC;

@property (nonatomic, strong) NSArray *topArray;

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分类";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = LeftCellHeight;
    DropView(self.tableView);
    
    [self.tableView registerClass:[LeftTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
    
    _rightVC = [[RightViewController alloc] init];
    [self addChildViewController:_rightVC];
    [self.view addSubview:_rightVC.view];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.top.equalTo(weakSelf.view.mas_top);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.width.mas_equalTo(@(SCREENBOUNDS.width / 3));
    }];
    
    [self getTopCategoryList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.rightLabel.text = self.topArray[indexPath.row][@"category_name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _rightVC.category_name = self.topArray[indexPath.row][@"category_name"];
    [_rightVC getSecondCategoryFromTopCategory:self.topArray[indexPath.row][@"category_id"]];
}

- (void)getTopCategoryList {
    NSString *url = @"https://zbt.change-word.com/home/goods/topCategory";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"class" : @(1)};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response === %@", responseObject);
        weakSelf.topArray = (NSArray *)responseObject[@"data"];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        weakSelf.rightVC.category_name = weakSelf.topArray[0][@"category_name"];
        [weakSelf.rightVC getSecondCategoryFromTopCategory:weakSelf.topArray[0][@"category_id"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
