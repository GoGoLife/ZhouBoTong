//
//  LocationViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/14.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "LocationViewController.h"
#import "Globefile.h"
#import <BMKLocationKit/BMKLocationComponent.h>

@interface LocationViewController ()<UITableViewDelegate, UITableViewDataSource, BMKLocationManagerDelegate>
{
    NSArray *dataArray;
    NSArray *sectionArray;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) BMKLocationManager *manager;

@property (nonatomic, strong) UIButton *locationButton;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定位";
    [self setUpNav];
    UIView *titleV = [[UIView alloc] initWithFrame:FRAME(30, 0, SCREENBOUNDS.width - 60, 40)];
    titleV.backgroundColor = [UIColor colorWithRed:233/255.0 green:240/255.0 blue:245/255.0 alpha:1.0];
    self.navigationItem.titleView = titleV;
    
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:FRAME(5, 5, titleV.bounds.size.width - 60, 30)];
//    UITextField *searchTextF = [searchBar valueForKey:@"searchField"];
//    searchTextF.font = SetFont(14);
//    ViewRadius(searchTextF, 20);
//    searchBar.placeholder = @"搜索当前城市";
//    [self.navigationItem.titleView addSubview:searchBar];
//
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = FRAME(CGRectGetMaxX(searchBar.frame), 5, 60, 30);
//    button.titleLabel.font = SetFont(14);
//    [button setTitleColor:SetColor(0, 141, 218, 1) forState:UIControlStateNormal];
//    [button setTitle:@"搜索" forState:UIControlStateNormal];
////    [button addTarget:self action:@selector(touchSearch:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationItem.titleView addSubview:button];
    
    self.locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locationButton.titleLabel.font = SetFont(14);
    [self.locationButton setTitleColor:SetColor(161, 161, 161, 1) forState:UIControlStateNormal];
    [self.locationButton setImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
    [self.locationButton setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"] ?: @"点击定位当前位置" forState:UIControlStateNormal];
    [self.locationButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    self.locationButton.backgroundColor = [UIColor whiteColor];
    [self.locationButton addTarget:self action:@selector(dingwei) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.locationButton];
    __weak typeof(self) weakSelf = self;
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(40));
    }];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //右侧索引相关设置
    self.tableView.sectionIndexColor = [UIColor blueColor];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(40, 0, 0, 0));
    }];
    
    dataArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle]  pathForResource:@"city" ofType:@"plist"]];
//    NSLog(@"data === %@", dataArray);
    sectionArray = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"J", @"K", @"L", @"M", @"N", @"P", @"Q", @"R", @"S", @"T", @"W", @"X", @"Y", @"Z"];
    
    
    
}

- (void)dingwei {
    [self.manager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        NSLog(@"location === %@", location);
        NSLog(@"state === %d", state);
        NSLog(@"error === %@", error);
        NSLog(@"city === %@", location.rgcData.city);
        [[NSUserDefaults standardUserDefaults] setObject:location.rgcData.city forKey:@"currentCity"];
        [self.locationButton setTitle:location.rgcData.city forState:UIControlStateNormal];
        self.returnCityName(location.rgcData.city);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = SetColor(243, 242, 247, 1);
    for (UIView *vv in view.subviews) {
        [vv removeFromSuperview];
    }
    UILabel *label = [[UILabel alloc] init];
    label.text = sectionArray[section];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, 0));
    }];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    return view;
}

//右侧索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return sectionArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return sectionArray[section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController popViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setObject:dataArray[indexPath.section][indexPath.row] forKey:@"currentCity"];
    [self.locationButton setTitle:dataArray[indexPath.section][indexPath.row] forState:UIControlStateNormal];
    self.returnCityName(dataArray[indexPath.section][indexPath.row]);
}

// 懒加载
- (BMKLocationManager *)manager {
    if (!_manager) {
        _manager = [[BMKLocationManager alloc] init];
        //设置delegate
        _manager.delegate = self;
        //设置返回位置的坐标系类型
        _manager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _manager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _manager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
//        _manager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
//        _manager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        _manager.locationTimeout = 10;
        //设置获取地址信息超时时间
        _manager.reGeocodeTimeout = 10;
    }
    return _manager;
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
