//
//  AllArticleViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/11.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "AllArticleViewController.h"
#import "Globefile.h"
#import <Masonry.h>

#import "BrandHeaderView.h"
#import "FirstBrandCollectionViewCell.h"
#import "SecondBarndCollectionViewCell.h"

#import "SectionView.h"
#import "EquipmentInfoViewController.h"
#import "MarchantInfoViewController.h"

#import "ShowHUDView.h"

@interface AllArticleViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ButtonDelegate>
{
    BOOL              isChangeCellType;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) SectionView *sectionV;

@property (nonatomic, strong) NSDictionary *merchantDic;

@property (nonatomic, strong) NSArray *merchantGoods;

@end

@implementation AllArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商铺品牌";
    isChangeCellType = NO;
    
    [self creatUI];
    
    [self setUpNav];
    
    [self getGoodsForMerchant];
    
    [self getInfo_Merchant];
}
setBack();
pop();

- (void)pushAction {
    MarchantInfoViewController *info = [[MarchantInfoViewController alloc] init];
    info.merchant_id = self.merchant_id;
    [self.navigationController pushViewController:info animated:YES];
}

- (void)creatUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[FirstBrandCollectionViewCell class] forCellWithReuseIdentifier:@"first"];
    [self.collectionView registerClass:[SecondBarndCollectionViewCell class] forCellWithReuseIdentifier:@"second"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectionView];
    
    __weak typeof(self) weakSelf = self;
//    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.view.mas_top).offset(0);
//        make.left.equalTo(weakSelf.view.mas_left);
//        make.right.equalTo(weakSelf.view.mas_right);
//        make.height.mas_equalTo(@(100));
//    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(0);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return self.merchantGoods.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.merchantGoods[indexPath.row];
    if (isChangeCellType) {
        SecondBarndCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
        cell.centerLabel.textColor = [UIColor redColor];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
        cell.topLabel.text = dic[@"goods_name"];
        cell.centerLabel.text = [NSString stringWithFormat:@"￥%@", dic[@"goods_price"]];
        cell.bottomLeft.text = @"";
        cell.bottomCenter.text = [NSString stringWithFormat:@"已售：%d", arc4random() % 50];
        cell.bottomRight.text = [NSString stringWithFormat:@"好评:%@%%", dic[@"praise"]];
        return cell;
    }else {
        FirstBrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
        cell.topLabel.text = dic[@"goods_name"];
        cell.centerLabel.text = [NSString stringWithFormat:@"￥%@", dic[@"goods_price"]];
        cell.bottomLeft.text = [NSString stringWithFormat:@"已售：%d", arc4random() % 50];
        cell.bottomCenter.text = @"";
        cell.bottomRight.text = [NSString stringWithFormat:@"好评:%@%%", dic[@"praise"]];
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (isChangeCellType) {
        return CGSizeMake(SCREENBOUNDS.width - 30, 60);
    }else {
        CGFloat width = (SCREENBOUNDS.width - 30) / 2;
        return CGSizeMake(width, width + 80);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (isChangeCellType) {
        return 0.0;
    }
    return 10.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 100);
    }
    return CGSizeMake(SCREENBOUNDS.width, 60);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    for (UIView *vv in view.subviews) {
        [vv removeFromSuperview];
    }
    if (indexPath.section == 0) {
        BrandHeaderView *headerView = [[BrandHeaderView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 100.0)];
        if ([self.merchantDic[@"is_collection"] integerValue]) {
            headerView.collectButton.backgroundColor = BaseViewColor;
            [headerView.collectButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [headerView.collectButton setTitle:@"已收藏" forState:UIControlStateNormal];
        }
        [headerView.leftV sd_setImageWithURL:[NSURL URLWithString:self.merchantDic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
        headerView.nameLabel.text = self.merchantDic[@"merchant_name"];
        //收藏功能
        [headerView.collectButton addTarget:self action:@selector(collectMerchant) forControlEvents:UIControlEventTouchUpInside];
        //添加手势   点击进入详情页
        headerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAction)];
        [headerView addGestureRecognizer:tap];
        [view addSubview:headerView];
        
    }else {
        [view addSubview:self.sectionV];
    }
    return view;
}

- (void)changeCellType:(UIButton *)sender {
    UIButton *button = (UIButton *)[self.view viewWithTag:100];
    button.selected = !button.isSelected;
    if (button.selected) {
        isChangeCellType = YES;
        [self.collectionView reloadData];
    }else {
        isChangeCellType = NO;
        [self.collectionView reloadData];
    }
}

- (SectionView *)sectionV {
    if (_sectionV == nil) {
        _sectionV = [[SectionView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 60) ItemNumber:3 AndTitle:@[@"销量", @"好评", @"价格"]];
        _sectionV.delegate = self;
        _sectionV.changeBtn.tag = 100;
        [_sectionV.changeBtn addTarget:self action:@selector(changeCellType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sectionV;
}

- (void)touchButton:(UIButton *)button withTag:(NSInteger)tag {
    //tag 从200开始
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.merchantGoods];
    if (tag == 200) { //销量
        [self sortArrayContainsDictionary:array AndConditions:@"sales"];
    }else if (tag == 201) { //好评
        [self sortArrayContainsDictionary:array AndConditions:@"praise"];
    }else {                 //价格
        [self sortArrayContainsDictionary:array AndConditions:@"goods_price"];
    }
    
}

- (void)sortArrayContainsDictionary:(NSMutableArray *)myMutableArr AndConditions:(NSString *)key {
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:NO]];
    [myMutableArr sortUsingDescriptors:sortDescriptors];
    NSLog(@"CategoryGoods SORT === %@",myMutableArr);
    self.merchantGoods = [myMutableArr mutableCopy];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    EquipmentInfoViewController *equip = [[EquipmentInfoViewController alloc] init];
    equip.goods_id = self.merchantGoods[indexPath.row][@"goods_id"];
    equip.type = 1;
    [self.navigationController pushViewController:equip animated:YES];
}

//收藏功能  商家
- (void)collectMerchant {
    NSString *url = @"https://zbt.change-word.com/index.php/home/Collection/addMerchantCollection";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"phone" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account"],
                            @"merchant_id" : self.merchant_id
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"收藏成功"];
        [self getInfo_Merchant];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取商家信息
- (void)getInfo_Merchant {
    if (!self.merchant_id) {
        return;
    }
    NSString *url = @"https://zbt.change-word.com/index.php/home/merchant/merchantDetail";
    AFHTTPSessionManager *manger = [[AFHTTPSessionManager alloc] init];
    manger.responseSerializer.acceptableContentTypes = [manger.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"phone" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account"],
                            @"merchant_id" : self.merchant_id
                            };
    __weak typeof(self) weakSelf = self;
    [manger POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"merchant_info === %@", responseObject);
        weakSelf.merchantDic = (NSDictionary *)responseObject[@"data"];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取商家商品
- (void)getGoodsForMerchant {
    NSLog(@"merchant_id === %@", self.merchant_id);
    if (!self.merchant_id) {
        return;
    }
    NSString *url = @"https://zbt.change-word.com/index.php/home/goods/goodsList";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"merchant_id" : self.merchant_id
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"merchantGoods === %@", responseObject);
        weakSelf.merchantGoods = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
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
