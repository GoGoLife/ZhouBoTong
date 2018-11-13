//
//  SearchViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/13.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "SearchViewController.h"
#import "Globefile.h"
#import "CustomCollectionViewCell.h"
#import "HistoryCollectionViewCell.h"
#import "SearchResultCollectionViewCell.h"
#import "SecondCollectionReusableView.h"
#import "EquipmentInfoViewController.h"
#import "AllArticleViewController.h"

@interface SearchViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>
{
    NSArray *firstDataArray;
    UISearchBar *searchBar;
}

@property (nonatomic, assign) BOOL isShowResult;

@property (nonatomic, strong) UICollectionView *collectionView;

//热搜词
@property (nonatomic, strong) NSArray *HotSearchArray;

//相关店铺
@property (nonatomic, strong) NSArray *marchantArray;

//相关商品
@property (nonatomic, strong) NSArray *goodsArray;

//记录商品所属商家的店铺名称
@property (nonatomic, strong) NSString *marchant_name;

@end

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [(UIView *)[self.navigationController.navigationBar viewWithTag:111] removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *titleV = [[UIView alloc] initWithFrame:FRAME(30, 0, SCREENBOUNDS.width - 60, 40)];
    titleV.backgroundColor = [UIColor colorWithRed:233/255.0 green:240/255.0 blue:245/255.0 alpha:1.0];
    self.navigationItem.titleView = titleV;
    
    searchBar = [[UISearchBar alloc] initWithFrame:FRAME(5, 5, titleV.bounds.size.width - 60, 30)];
    searchBar.delegate = self;
    UITextField *searchTextF = [searchBar valueForKey:@"searchField"];
    searchTextF.font = SetFont(14);
    ViewRadius(searchTextF, 20);
    searchBar.placeholder = @"支持关键词所搜商品和店铺";
    [self.navigationItem.titleView addSubview:searchBar];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = FRAME(CGRectGetMaxX(searchBar.frame), 5, 60, 30);
    button.titleLabel.font = SetFont(14);
    [button setTitleColor:SetColor(0, 141, 218, 1) forState:UIControlStateNormal];
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:button];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"first"];
    [self.collectionView registerClass:[HistoryCollectionViewCell class] forCellWithReuseIdentifier:@"second"];
    [self.collectionView registerClass:[SearchResultCollectionViewCell class] forCellWithReuseIdentifier:@"result"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[SecondCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"second"];
    
    [self.view addSubview:self.collectionView];
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    firstDataArray = @[@"JS-730CC高速艇", @"JS-730CC高速艇", @"高速艇", @"JS-高速艇", @"JS-730CC高速艇", @"高速艇"];
    
    [self setUpNav];
    
    [self getHotSearch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isShowResult) {
        if (section == 0) {
            return self.marchantArray.count;
        }
        return self.goodsArray.count;
    }else {
        if (section == 0) {
            return 6;
        }
        return self.HotSearchArray.count;
    }
}

StringWidth();
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isShowResult) {
        SearchResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"result" forIndexPath:indexPath];
        cell.bottomTextF.font = SetFont(12);
        if (indexPath.section == 0) {
            NSDictionary *marchantDic = self.marchantArray[indexPath.row];
            NSString *date = [NSString stringWithFormat:@"营业时间:%@ - %@", marchantDic[@"start_business_time"], marchantDic[@"end_business_time"]];
            [cell.leftImageV sd_setImageWithURL:marchantDic[@"photo"]];
            cell.topTextF.text = marchantDic[@"merchant_name"];
            cell.bottomTextF.text = date;
        }else {
            NSDictionary *goodDic = self.goodsArray[indexPath.row];
//            [self getMarchantInfoForMarchantID:goodDic[@"merchant_id"]];
            [cell.leftImageV sd_setImageWithURL:goodDic[@"photo"] placeholderImage:[UIImage imageNamed:@"public"]];
            cell.topTextF.text = goodDic[@"goods_name"];
            cell.bottomTextF.text = isNullClass(goodDic[@"merchant_name"]);
            CGFloat width = [self calculateRowWidth:@"模拟宽度" withFont:15];
            NSString *sales = [NSString stringWithFormat:@"已售：%ld", [goodDic[@"sales"] integerValue]];
            NSString *price = [NSString stringWithFormat:@"¥%ld", [goodDic[@"goods_price"] integerValue]];
            [cell.topTextF creatRightView:FRAME(0, 0, width * 2, 30) AndTitle:price TextAligment:NSTextAlignmentRight Font:SetFont(15) Color:[UIColor redColor]];
            [cell.bottomTextF creatRightView:FRAME(0, 0, width, 30) AndTitle:sales TextAligment:NSTextAlignmentRight Font:SetFont(12) Color:SetColor(166, 166, 166, 1)];
            [cell layoutIfNeeded];
        }
        return cell;
    }else {
        if (indexPath.section == 0) {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
            UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
            ViewRadius(label, 5.0);
            label.font = SetFont(14);
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = SetColor(216, 216, 216, 1);
            label.textColor = SetColor(108, 108, 108, 1);
            label.text = firstDataArray[indexPath.row];
            [cell.contentView addSubview:label];
            return cell;
        }
        HistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
        cell.textString = self.HotSearchArray[indexPath.row];
        UIImageView *left = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 15, 15)];
        left.image = [UIImage imageNamed:@"searchIcon"];
        [cell.textF creatLeftView:left.bounds AndControl:left];
        
        UIImageView *right = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 15, 15)];
        right.image = [UIImage imageNamed:@"zhixiang"];
        [cell.textF creatRightView:right.bounds AndControl:right];
        [cell layoutIfNeeded];
        return cell;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.isShowResult) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else {
        if (section == 1) {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
        return UIEdgeInsetsMake(10, 15, 10, 15);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isShowResult) {
        return CGSizeMake(SCREENBOUNDS.width - 20, ResultCellHeight);
    }else {
        if (indexPath.section == 0) {
            CGFloat width = [self calculateRowWidth:firstDataArray[indexPath.row] withFont:14];
            return CGSizeMake(width + 20, 30.0);
        }
        return CGSizeMake(SCREENBOUNDS.width - 30, 50.0);
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.isShowResult) {
        return CGSizeMake(SCREENBOUNDS.width, 40.0);
    }else {
        if (section == 0) {
            return CGSizeMake(SCREENBOUNDS.width, 40.0);
        }
        return CGSizeMake(SCREENBOUNDS.width, 0.0);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (!self.isShowResult) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        for (UIView *vv in view.subviews) {
            [vv removeFromSuperview];
        }
        UILabel *label = [[UILabel alloc] init];
        label.font = SetFont(12);
        label.textColor = SetColor(145, 145, 145, 1);
        label.text = @"热门搜索";
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, 0));
        }];
        return view;
    }else {
        SecondCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"second" forIndexPath:indexPath];
        view.textF.text = @[@"  相关店铺", @"   相关商品"][indexPath.section];
        return view;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isShowResult) {
        if (indexPath.section == 0) {
            AllArticleViewController *article = [[AllArticleViewController alloc] init];
            article.merchant_id = self.marchantArray[indexPath.row][@"merchant_id"];
            [self.navigationController pushViewController:article animated:YES];
        }else {
            EquipmentInfoViewController *info = [[EquipmentInfoViewController alloc] init];
            info.goods_id = self.goodsArray[indexPath.row][@"goods_id"];
            [self.navigationController pushViewController:info animated:YES];
        }
    }else {
        [self searchContentForText:self.HotSearchArray[indexPath.row]];
    }
}

//右上角搜索按钮
- (void)touchSearch:(UIButton *)button {
    [self saveHotSearch:searchBar.text];
    [self searchContentForText:searchBar.text];
}

- (void)getHotSearch {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/index.php/home/HotSearch/getWordName";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"hot Search ----%@", responseObject);
        NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dic in (NSArray *)responseObject[@"data"]) {
            [mutableArr addObject:dic[@"word_name"]];
        }
        weakSelf.HotSearchArray = [mutableArr mutableCopy];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)saveHotSearch:(NSString *)string {
    NSString *url = @"https://zbt.change-word.com/index.php/home/HotSearch/addHotName";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"word_name" : string};
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"response == %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//关键字搜索商品和店铺
- (void)searchContentForText:(NSString *)string {
    NSString *url = @"https://zbt.change-word.com/index.php/home/HotSearch/search";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"word_name" : string};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"SearchResponse+++++++ == %@", responseObject);
        NSDictionary *data = (NSDictionary *)responseObject[@"data"];
        weakSelf.goodsArray = data[@"goods"];
        weakSelf.marchantArray = data[@"merchant"];
        weakSelf.isShowResult = YES;
        [weakSelf.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"shopping And merchant === %@", error);
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
