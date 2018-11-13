//
//  SelectAddressViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "SelectAddressViewController.h"
#import "Globefile.h"
#import <Masonry.h>

#import "AddressTableViewCell.h"
#import "AddAddressViewController.h"

#import "ShowHUDView.h"


@interface SelectAddressViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation SelectAddressViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //获取数据
    [self getAddressData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收货地址";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    DropView(self.tableView);
    
    [self.tableView registerClass:[AddressTableViewCell class] forCellReuseIdentifier:@"address"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:SetColor(251, 70, 74, 1)];
    [button setTitle:@"新建收货地址" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:button];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 44, 0));
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(44));
    }];
    
    [self setUpNav];
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
    NSDictionary *dataDic = self.dataArr[indexPath.row];
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"address"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameString = dataDic[@"name"];
    cell.nameTextF.text = dataDic[@"addressee_phone"];
    NSArray *array = [dataDic[@"address"] componentsSeparatedByString:@" "];
    cell.cityTextF.text = array.firstObject;
    cell.infoLabel.text = [array.lastObject isEqualToString:array.firstObject] ? @"" : array.lastObject ;
    if ([dataDic[@"default_address"] integerValue]) {
        cell.isDefultAddress = YES;
    }else {
        cell.isDefultAddress = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AddressCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = self.dataArr[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.returnAddress(dataDic[@"address"], dataDic[@"name"], dataDic[@"addressee_phone"]);
    [self.navigationController popViewControllerAnimated:YES];
}

//左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *delData = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        AddAddressViewController *add = [[AddAddressViewController alloc] init];
        add.dataDic = delData;
        add.isChange = YES;
        add.Address_id = self.dataArr[indexPath.row][@"id"];
        [weakSelf.navigationController pushViewController:add animated:YES];
    }];
    
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //http://45.77.244.195/index.php/home/Member/delAddress
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        NSDictionary *parme = @{
                                @"id" : delData[@"id"]
                                };
        [manager POST:@"https://zbt.change-word.com/index.php/home/Member/delAddress" parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"rrrrr  ====== %@", responseObject);
            if ([responseObject[@"resultCode"] intValue] == 1) {
                [weakSelf getAddressData];
                [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"删除成功"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"删除失败"];
        }];
    }];
    action2.backgroundColor = [UIColor redColor];
    
    return @[action2, action1];
}

- (void)addAddress {
    AddAddressViewController *add = [[AddAddressViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)getAddressData {
    //http://45.77.244.195/index.php/home/Member/getAddress
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSDictionary *parme = @{
                            @"phone" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account"]
                            };
    
    __weak typeof(self) weakSelf = self;
    [manager POST:@"https://zbt.change-word.com/index.php/home/Member/getAddress" parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"address === %@", responseObject);
        weakSelf.dataArr = (NSArray *)responseObject[@"data"];
        [weakSelf.tableView reloadData];
        [weakSelf saveDefaultAddress:weakSelf.dataArr];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//保存默认地址
- (void)saveDefaultAddress:(NSArray *)addressArray {
    for (NSDictionary *dic in addressArray) {
        if ([dic[@"default_address"] isEqualToString:@"1"]) {
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"address"] forKey:@"defaultAddress"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"name"] forKey:@"defaultName"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"addressee_phone"] forKey:@"defaultPhone"];
        }
    }
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
