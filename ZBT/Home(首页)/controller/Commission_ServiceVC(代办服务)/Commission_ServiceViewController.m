//
//  Commission_ServiceViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/7.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Commission_ServiceViewController.h"
#import "HomeCollectionViewCell.h"
#import "ProjectCollectionViewCell.h"
#import "Globefile.h"
#import <Masonry.h>
#import "LoopView.h"

#import "Commission_ListViewController.h"
#import "Commission_ProjectInfoViewController.h"
#import "URLImageScroll.h"

@interface Commission_ServiceViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *categoryArray;

@property (nonatomic, strong) NSArray *merchantArray;

@property (nonatomic, strong) NSArray *scrollData;

@end

@implementation Commission_ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代办服务";
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"first"];
    [self.collectionView registerClass:[ProjectCollectionViewCell class] forCellWithReuseIdentifier:@"second"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectionView];
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self setUpNav];
    
    [self getSecondCategory];
    [self getProjectFromMarchant];
    [self getScrollData_Commission];
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
        return self.categoryArray.count;
    }
    return self.merchantArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSDictionary *dic = self.categoryArray[indexPath.row];
        HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
//        cell.topImageV.image = [UIImage imageNamed:@"public"];
        [cell.topImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"logo"]] placeholderImage:[UIImage imageNamed:@"public"]];
        cell.bottomLabel.font = SetFont(15);
        cell.bottomLabel.text = dic[@"category_name"];
        return cell;
    }
    ProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
    [self setSecondCell:cell AtIndexPath:indexPath];
    return cell;
}

- (void)setSecondCell:(ProjectCollectionViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.merchantArray[indexPath.row];
    [cell layoutIfNeeded];
    cell.topTextF.textAlignment = NSTextAlignmentLeft;
    cell.centerTextF.textColor = [UIColor redColor];
    cell.topTextF.font = SetFont(15);
    cell.centerTextF.font = SetFont(15);
    cell.bottomTextF.font = SetFont(12);
    cell.bottomTextF.textColor = SetColor(147, 147, 147, 1);
    [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
    cell.topTextF.text = dic[@"merchant_name"];//@"代办服务商家";
    cell.centerTextF.text = [NSString stringWithFormat:@"%@-%@", dic[@"start_business_time"], dic[@"end_business_time"]];//@"¥400";
    cell.bottomTextF.text = [NSString stringWithFormat:@"离我：%@m", dic[@"distance"]];//@"离我：12m";
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 20, 20)];
    imageV.image = [UIImage imageNamed:@"phone"];
    [cell.topTextF creatRightView:imageV.bounds AndControl:imageV];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat width = (SCREENBOUNDS.width - 110.0) / 4;
        return CGSizeMake(width, width + 40);
    }
    return CGSizeMake(SCREENBOUNDS.width - 20, 110.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 30.0;
    }
    return 0.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 200.0);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//    LoopView *loopV = [[LoopView alloc] initWithFrame:view.bounds];
//    loopV.imageArray = @[@"1", @"2", @"3", @"4"];
//    [view addSubview:loopV];
    URLImageScroll *scroll = [[URLImageScroll alloc] initWithFrame:view.bounds withImageArray:self.scrollData];
    [view addSubview:scroll];
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        Commission_ListViewController *list = [[Commission_ListViewController alloc] init];
        list.categoryID = self.categoryArray[indexPath.row][@"category_id"];
        [self.navigationController pushViewController:list animated:YES];
    }else {
        Commission_ProjectInfoViewController *info = [[Commission_ProjectInfoViewController alloc] init];
        info.merchant_id = self.merchantArray[indexPath.row][@"merchant_id"];
        [self.navigationController pushViewController:info animated:YES];
    }
}

//通过顶级分类ID获取下级分类信息
- (void)getSecondCategory {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/index.php/home/goods/getSecond";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parame = @{@"category_id" : @"36"};
    [manager POST:url parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"代办服务 === %@", responseObject);
        weakSelf.categoryArray = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//通过顶级分类ID获取商家列表
- (void)getProjectFromMarchant {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/index.php/home/merchant/topCategoryMerchant";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"category_id" : @"36"};
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"顶级分类商家  === %@", responseObject);
        weakSelf.merchantArray = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取轮播图数据
- (void)getScrollData_Commission {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/home/index/getSowingMap";
    NSDictionary *parme = @{@"type" : @(7)};
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"shuishangyule ----%@", responseObject);
        weakSelf.scrollData = [responseObject[@"data"] firstObject][@"photo"];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
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
