//
//  ShoppingViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ShoppingViewController.h"
#import "Globefile.h"
#import "Shopping_OrderTableViewCell.h"
#import "ShoppingModel.h"
#import "MarchantModel.h"
#import "GoPaymentView.h"
#import "ShowHUDView.h"
#import "CreatShoppingOrderViewController.h"

#import "EquipmentInfoViewController.h"
#import "AllArticleViewController.h"
#import "GoLogin_backGroundView.h"

@interface ShoppingViewController ()<UITableViewDelegate, UITableViewDataSource, SelectCellDelegate>
{
    NSMutableArray *selectedArray;
    NSInteger chooseNumber;
    UIButton *all;
    NSIndexPath *lastIndexPath;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) float sum_price;

@property (nonatomic, strong) GoPaymentView *payView;

@property (nonatomic, assign) BOOL isTableEdit;

@end

@implementation ShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sum_price = 0.0;
    self.title = @"购物舟";
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    selectedArray = [NSMutableArray arrayWithCapacity:1];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[Shopping_OrderTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self getShoppingCarInfo];
    
    NSLog(@"2222222222222");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(changeCellLayout)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [[self.view viewWithTag:100] removeFromSuperview];
    [[self.view viewWithTag:101] removeFromSuperview];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    for (MarchantModel *marModel in self.dataArray) {
        for (ShoppingModel *model in marModel.shoppingArray) {
            NSLog(@"isSelect === %d", model.isSelect);
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
//    self.tabBarController.tabBar.hidden = NO;
    self.isTableEdit = NO;
    for (MarchantModel *marModel in self.dataArray) {
        for (ShoppingModel *model in marModel.shoppingArray) {
            model.isMoved = NO;
            model.isSelect = NO;
        }
    }
    self.sum_price = 0.0;
    self.payView.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.sum_price];
    [self.tableView reloadData];
    [selectedArray removeAllObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count == 0 ? 0 : self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MarchantModel *model = self.dataArray[section];
    return model.shoppingArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count == 0) {
        return nil;
    }
    MarchantModel *merModel = self.dataArray[indexPath.section];
    ShoppingModel *model = merModel.shoppingArray[indexPath.row];
    Shopping_OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage imageNamed:@"public"]];
    cell.selectButton.selected = NO;
    cell.number = model.number;
    cell.delegate = self;
    cell.isMoved = model.isMoved;
    cell.isSelect = model.isSelect;
    cell.indexPath = indexPath;
    cell.nameLabel.text = model.goodsName;
    cell.countLabel.text = [NSString stringWithFormat:@"%ld", model.number];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.goodsPrice];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MarchantModel *model = self.dataArray[section];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushMerchantInfo:)];
    tap.view.tag = section;
    [view addGestureRecognizer:tap];
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.text = isNullClass(model.marchantName);
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, 0));
    }];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isTableEdit) {
        return;
    }
    MarchantModel *marModel = self.dataArray[indexPath.section];
    ShoppingModel *model = marModel.shoppingArray[indexPath.row];
    EquipmentInfoViewController *info = [[EquipmentInfoViewController alloc] init];
    info.goods_id = model.goodsID;
    [self.navigationController pushViewController:info animated:YES];
}

//跳转商家详情
- (void)pushMerchantInfo:(UITapGestureRecognizer *)ges {
    if (self.isTableEdit) {
        return;
    }
    MarchantModel *model = self.dataArray[ges.view.tag];
    AllArticleViewController *article = [[AllArticleViewController alloc] init];
    article.merchant_id = model.marchantID;
    [self.navigationController pushViewController:article animated:YES];
    
}

//改变cell布局
- (void)changeCellLayout {
    self.isTableEdit = YES;
    for (MarchantModel *marModel in self.dataArray) {
        for (ShoppingModel *model in marModel.shoppingArray) {
            model.isMoved = YES;
        }
    }
    [self.tableView reloadData];
    UIBarButtonItem *newItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(updateCellLayout)];
    self.navigationItem.rightBarButtonItem = newItem;
    self.tabBarController.tabBar.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(40, 0, 45, 0));
    }];
    
    UIView *view = [[UIView alloc] init];
    view.tag = 100;
    [self setDeleteView:view];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(40));
    }];
    
    self.payView = [[GoPaymentView alloc] init];
    [self.payView.paymentButton addTarget:self action:@selector(orderInfoShow) forControlEvents:UIControlEventTouchUpInside];
    self.payView.tag = 101;
    [self.view addSubview:self.payView];
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(@(45));
    }];
}

//全选  删除  页面
- (void)setDeleteView:(UIView *)view {
    all = [UIButton buttonWithType:UIButtonTypeCustom];
    all.titleLabel.font = SetFont(17);
    [all setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [all setImage:[UIImage imageNamed:@"weixuanze"] forState:UIControlStateNormal];
    [all setTitle:@"全选 (已选0件)" forState:UIControlStateNormal];
    [all setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [all addTarget:self action:@selector(chooseAllAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    [delete setTitleColor:SetColor(163, 163, 163, 1) forState:UIControlStateNormal];
    delete.titleLabel.font = SetFont(14);
    [delete setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [delete setTitle:@"删除" forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchUpInside];
    [delete setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    [view addSubview:all];
    [view addSubview:delete];
    
    [all mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(150, 40));
                              
    }];
    
    [delete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-15);
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
}

//全选
- (void)chooseAllAction:(UIButton *)button {
    //获取所有商品数量
    NSInteger shoppingCount = 0;
    for (MarchantModel *marModel in self.dataArray) {
        shoppingCount += marModel.shoppingArray.count;
    }
    button.selected = !button.isSelected;
    if (button.selected) {
        [all setImage:[UIImage imageNamed:@"yixuanze"] forState:UIControlStateNormal];
        [all setTitle:[NSString stringWithFormat:@"全选 (已选%ld件)", shoppingCount] forState:UIControlStateNormal];
        for (MarchantModel *marModel in self.dataArray) {
            for (ShoppingModel *model in marModel.shoppingArray) {
                model.isSelect = YES;
            }
        }
        [self.tableView reloadData];
        self.sum_price = 0.0;
        for (MarchantModel *marModel in self.dataArray) {
            for (ShoppingModel *model in marModel.shoppingArray) {
                self.sum_price += model.number * [model.goodsPrice floatValue];
            }
        }
        self.payView.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", self.sum_price];
    }else {
        [all setImage:[UIImage imageNamed:@"weixuanze"] forState:UIControlStateNormal];
        [all setTitle:@"全选 (已选0件)" forState:UIControlStateNormal];
        for (MarchantModel *marModel in self.dataArray) {
            for (ShoppingModel *model in marModel.shoppingArray) {
                model.isSelect = NO;
            }
        }
        [self.tableView reloadData];
        self.payView.priceLabel.text = @"¥0.0";
    }
}

- (void)deleteAllData {
    
//    NSArray *array = [[selectedArray mutableCopy] sortedArrayUsingSelector:@selector(compare:)];
    //存储购物车ID  每个购物车ID对应一个商家
    NSMutableArray *shoppingsID = [NSMutableArray arrayWithCapacity:1];
    //存储商品ID
    NSMutableArray *goodsID = [NSMutableArray arrayWithCapacity:1];
    for (MarchantModel *marModel in self.dataArray) {
        [shoppingsID addObject:marModel.shopping_id];
        for (ShoppingModel *model in marModel.shoppingArray) {
            [goodsID addObject:model.goodsID];
        }
    }
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    self.payView.priceLabel.text = @"¥0.0";
    
    //去掉购物车ID中的重复元素
    NSArray *result = [shoppingsID valueForKeyPath:@"@distinctUnionOfObjects.self"];
    [self deleteDataFromService:[[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"] AndShopping_id:[result componentsJoinedByString:@","] AndGoods_id:[goodsID componentsJoinedByString:@","]];
}

//删除数据
- (void)deleteData {
    if (all.selected) {
        [self deleteAllData];
        return;
    }
    
    NSArray *array = [[selectedArray mutableCopy] sortedArrayUsingSelector:@selector(compare:)];
    //存储购物车ID  每个购物车ID对应一个商家
    NSMutableArray *shoppingsID = [NSMutableArray arrayWithCapacity:1];
    //存储商品ID
    NSMutableArray *goodsID = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger i = array.count - 1; i >= 0; i--) {
        NSIndexPath *indexPath = array[i];
        MarchantModel *marModel = self.dataArray[indexPath.section];
        [shoppingsID addObject:marModel.shopping_id];
        ShoppingModel *model = marModel.shoppingArray[indexPath.row];
        [goodsID addObject:model.goodsID];
        [marModel.shoppingArray removeObject:model];
        if (marModel.shoppingArray.count == 0) {
            [self.dataArray removeObject:self.dataArray[indexPath.section]];
        }
    }
    [selectedArray removeAllObjects];
    [self.tableView reloadData];
    self.payView.priceLabel.text = @"¥0.0";
    
    //去掉购物车ID中的重复元素
    NSArray *result = [shoppingsID valueForKeyPath:@"@distinctUnionOfObjects.self"];
    [self deleteDataFromService:[[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"] AndShopping_id:[result componentsJoinedByString:@","] AndGoods_id:[goodsID componentsJoinedByString:@","]];
}

- (void)updateCellLayout {
    self.isTableEdit = NO;
    [selectedArray removeAllObjects];
    for (MarchantModel *marModel in self.dataArray) {
        for (ShoppingModel *model in marModel.shoppingArray) {
            model.isMoved = NO;
            model.isSelect = NO;
        }
    }
    self.sum_price = 0.0;
    self.payView.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.sum_price];
    [self.tableView reloadData];
    UIBarButtonItem *newItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(changeCellLayout)];
    self.navigationItem.rightBarButtonItem = newItem;
    [[self.view viewWithTag:100] removeFromSuperview];
    [[self.view viewWithTag:101] removeFromSuperview];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.tabBarController.tabBar.hidden = NO;
}

//记录选中的cell
- (void)selectedCellIndexPath:(NSIndexPath *)indexPath AndChoose:(BOOL)isChoose {
    if (!isChoose) {
        NSLog(@"cancel");
        MarchantModel *marModel = self.dataArray[indexPath.section];
        ShoppingModel *model = marModel.shoppingArray[indexPath.row];
        model.isSelect = NO;
        self.sum_price -= model.number * [model.goodsPrice floatValue];
        self.payView.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.sum_price];
        [selectedArray removeObject:indexPath];
        [all setTitle:[NSString stringWithFormat:@"全选 (已选%ld件)", selectedArray.count] forState:UIControlStateNormal];
    }else {
        NSLog(@"suresure");
        //确认所选的商品
        MarchantModel *marModel = self.dataArray[indexPath.section];
        ShoppingModel *model = marModel.shoppingArray[indexPath.row];
        model.isSelect = YES;
        self.sum_price += model.number * [model.goodsPrice floatValue];
        self.payView.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.sum_price];
        [selectedArray addObject:indexPath];
        chooseNumber = selectedArray.count;
        [all setTitle:[NSString stringWithFormat:@"全选 (已选%ld件)", chooseNumber] forState:UIControlStateNormal];
    }
}

- (void)addNumber:(NSIndexPath *)indexPath {
    MarchantModel *marModel = self.dataArray[indexPath.section];
    ShoppingModel *model = marModel.shoppingArray[indexPath.row];
    model.number++;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    if (model.isSelect) {
        NSLog(@"+++++++++++++++++");
        self.sum_price += [model.goodsPrice floatValue];
        self.payView.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.sum_price];
    }
}

- (void)lessNumber:(NSIndexPath *)indexPath {
    MarchantModel *marModel = self.dataArray[indexPath.section];
    ShoppingModel *model = marModel.shoppingArray[indexPath.row];
    if (model.number <= 0) {
        model.number = 0;
        return;
    }
    model.number--;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    if (model.isSelect) {
        NSLog(@"-----------------");
        self.sum_price -= [model.goodsPrice floatValue];
        self.payView.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.sum_price];
    }
}

//跳转订单展示界面
- (void)orderInfoShow {
    NSString *isRZ = [[NSUserDefaults standardUserDefaults] objectForKey:@"isRZ"];
    //判断用户是否认证
    if (![isRZ integerValue]) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前用户未实名认证，请去(个人中心)完成认证" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.tabBarController.tabBar.hidden = NO;
            weakSelf.tabBarController.selectedIndex = 4;
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    //记录商品数据
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
    //记录商家ID
    NSMutableArray *merchantArr  = [NSMutableArray arrayWithCapacity:1];
    for (NSIndexPath *indexPath in selectedArray) {
        ShoppingModel *model = ((MarchantModel *)self.dataArray[indexPath.section]).shoppingArray[indexPath.row];
        [merchantArr addObject:model.merchantID];
        [data addObject:model];
    }
    NSLog(@"merchant ==== %@", merchantArr);
    NSLog(@"model === %@", data);
    
    CreatShoppingOrderViewController *order = [[CreatShoppingOrderViewController alloc] init];
    order.dataModel = [data mutableCopy];
    order.merchantArr = [merchantArr valueForKeyPath:@"@distinctUnionOfObjects.self"];
    order.sum_price = [NSString stringWithFormat:@"%.2f", self.sum_price];
    [self.navigationController pushViewController:order animated:YES];
}

- (void)getShoppingCarInfo {
    [self.dataArray removeAllObjects];
    NSString *url = @"https://zbt.change-word.com/index.php/home/Shopping/getShoppingCart";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"]};//[[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"]};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject === %@", responseObject);
        NSArray *array = (NSArray *)responseObject[@"data"];
        for (NSInteger i = 0; i < array.count; ++i) {
            NSMutableArray *shoppingArr = [NSMutableArray arrayWithCapacity:1];
            MarchantModel *marchantModel = [[MarchantModel alloc] init];
            marchantModel.marchantID = array[i][@"merchant_id"];
            marchantModel.marchantName = array[i][@"merchant_name"];
            marchantModel.member_id = array[i][@"member_id"];
            marchantModel.shopping_id = array[i][@"shopping_id"];
            
            NSArray *goodsArr = (NSArray *)array[i][@"goods"];
            for (NSInteger j = 0; j < goodsArr.count; ++j) {
                ShoppingModel *model = [[ShoppingModel alloc] init];
                model.isSelect = NO;
                model.isMoved = NO;
                model.number = [goodsArr[j][@"goods_number"] integerValue];
                model.goodsID = isNullClass(goodsArr[j][@"goods_id"]);
                model.imageURL = isNullClass(goodsArr[j][@"photo"]);
                model.goodsName = isNullClass(goodsArr[j][@"goods_name"]);
                model.goodsPrice = isNullClass(goodsArr[j][@"goods_price"]);
                model.merchantID = marchantModel.marchantID;
                [shoppingArr addObject:model];
            }
            marchantModel.shoppingArray = shoppingArr;
            [weakSelf.dataArray addObject:marchantModel];
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)deleteDataFromService:(NSString *)member_id AndShopping_id:(NSString *)shopping_id AndGoods_id:(NSString *)goods_id {
    NSString *url = @"https://zbt.change-word.com/index.php/home/Shopping/delShoppingCart";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"member_id" : member_id,
                            @"shopping_id" : shopping_id,
                            @"goods_id" : goods_id
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"删除商品 ==== %@", responseObject);
        if ([responseObject[@"resultCode"] integerValue] == 1) {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"删除成功"];
        }else {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:responseObject[@"resultMsg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
@end
