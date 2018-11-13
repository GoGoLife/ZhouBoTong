//
//  EquipmentViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/15.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "EquipmentViewController.h"
#import "Globefile.h"
#import <Masonry.h>

#import "LoopView.h"
#import "SecondCollectionReusableView.h"
#import "SectionView.h"
#import "HomeCollectionViewCell.h"
#import "FirstBrandCollectionViewCell.h"
#import "SecondBarndCollectionViewCell.h"

#import "EquipmentInfoViewController.h"
#import "BrandStreetViewController.h"
#import "BrandViewController.h"
#import "BrandListViewController.h"
#import "BrandListInfoViewController.h"
#import "Equipment_ListViewController.h"
#import "URLImageScroll.h"

@interface EquipmentViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ButtonDelegate, PushIndexDelegate, UISearchBarDelegate>
{
    BOOL              isChangeCellType;
}

@property (nonatomic, strong) UISearchBar *searchView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) SectionView *sectionV;

@property (nonatomic, strong) LoopView *loopV;

@property (nonatomic, strong) NSArray *categoryArray;

@property (nonatomic, strong) NSArray *categoryGoodsArray;

@property (nonatomic, strong) NSArray *fiveStreetArray;

@property (nonatomic, strong) NSArray *scrollData;

@end

@implementation EquipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"船舶设备";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.searchView = [[UISearchBar alloc] initWithFrame:FRAME(0, 10, SCREENBOUNDS.width, 30)];
    self.searchView.delegate = self;
    self.searchView.searchBarStyle = UISearchBarStyleMinimal;
    UITextField *searchTextF = [self.searchView valueForKey:@"searchField"];
    searchTextF.font = SetFont(15);
    ViewRadius(searchTextF, 22.0);
    self.searchView.placeholder = @"可搜索各种游艇";
    [self.view addSubview:self.searchView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"first"];
    [self.collectionView registerClass:[SecondCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"second"];
    
    [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"homeCell"];
    [self.collectionView registerClass:[FirstBrandCollectionViewCell class] forCellWithReuseIdentifier:@"firstCell"];
    [self.collectionView registerClass:[SecondBarndCollectionViewCell class] forCellWithReuseIdentifier:@"secondCell"];
    
    [self.view addSubview:self.collectionView];
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.searchView.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    [self setUpNav];
    
    [self getSecondCategoryFromEquipMent];
    
    [self getCategoryGoods];
    
    [self getStreetForFive];
    
    [self getScrollData_Equiment];
}

#pragma mark ----- searchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchbar");
    [searchBar resignFirstResponder];
    [self getCategoryGoodsFromSearchText:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchText === %@", searchText);
    if ([searchText isEqualToString:@""]) {
        [searchBar resignFirstResponder];
        [self getCategoryGoods];
    }
}

setBack();
pop();

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.categoryArray.count;
            break;
        case 1:
            return 5;
            break;
        case 2:
            return self.categoryGoodsArray.count;
            break;
        default:
            break;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        NSDictionary *dic = self.categoryGoodsArray[indexPath.row];
        if (!isChangeCellType) {
            FirstBrandCollectionViewCell *firstCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"firstCell" forIndexPath:indexPath];
            [firstCell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
            firstCell.topLabel.text = dic[@"goods_name"];
            firstCell.centerLabel.text = [NSString stringWithFormat:@"￥%@", dic[@"goods_price"]];
            firstCell.bottomLeft.text = [NSString stringWithFormat:@"已售：%@件", dic[@"sales"]];
            firstCell.bottomCenter.text = @"";
            firstCell.bottomRight.text = [NSString stringWithFormat:@"好评:%@%%", dic[@"praise"]];
            return firstCell;
        }else {
            SecondBarndCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"secondCell" forIndexPath:indexPath];
            [cell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
            cell.topLabel.text = dic[@"goods_name"];
            cell.bottomLeft.text = [NSString stringWithFormat:@"￥%@", dic[@"goods_price"]];
            cell.bottomCenter.text = [NSString stringWithFormat:@"已售：%@件", dic[@"sales"]];
            cell.bottomRight.text = [NSString stringWithFormat:@"好评:%@%%", dic[@"praise"]];
            return cell;
        }
    }
    HomeCollectionViewCell *homeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeCell" forIndexPath:indexPath];
    homeCell.topImageV.image = [UIImage imageNamed:@"public"];
    homeCell.bottomLabel.font = SetFont(12);
    if (indexPath.section == 0) {
        homeCell.bottomLabel.text = self.categoryArray[indexPath.row][@"category_name"];
        [homeCell.topImageV sd_setImageWithURL:[NSURL URLWithString:self.categoryArray[indexPath.row][@"logo"]] placeholderImage:[UIImage imageNamed:@"public"]];
    }else {
        NSDictionary *dic = self.fiveStreetArray[indexPath.row];
        homeCell.bottomLabel.text = dic[@"brand_name"];
        [homeCell.topImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
    }
    return homeCell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 20.0;
    }else if (section == 2) {
        if (isChangeCellType) {
            return 0.0;
        }
    }
    return 10.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            CGFloat width = (SCREENBOUNDS.width - 80) / 4;
            return CGSizeMake(width, width + 40);
        }
            break;
        case 1:
        {
            CGFloat width = (SCREENBOUNDS.width - 60) / 5;
            return CGSizeMake(width, width + 40);
        }
            break;
        case 2:
        {
            if (isChangeCellType) {
                return CGSizeMake(SCREENBOUNDS.width - 30, 90);
            }else {
                CGFloat width = (SCREENBOUNDS.width - 30) / 2;
                return CGSizeMake(width, width + 80);
            }
        }
            break;
            
        default:
            return CGSizeMake(0, 0);
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 200.0);
    }if (section == 1) {
        return CGSizeMake(SCREENBOUNDS.width, 40);
    }else {
        return CGSizeMake(SCREENBOUNDS.width, 60.0);
    }
    return CGSizeZero;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"first" forIndexPath:indexPath];
//            [view addSubview:self.loopV];
            URLImageScroll *scroll = [[URLImageScroll alloc] initWithFrame:view.bounds withImageArray:self.scrollData];
            [view addSubview:scroll];
            return view;
        }else if (indexPath.section == 1){
            SecondCollectionReusableView *second = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"second" forIndexPath:indexPath];
            second.textF.text = @"    品牌街";
            second.indexPath = indexPath;
            second.delegate = self;
            return second;
        }else if (indexPath.section == 2) {
            UICollectionReusableView *three = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"first" forIndexPath:indexPath];
            for (UIView *v in three.subviews) {
                [v removeFromSuperview];
            }
            [three addSubview:self.sectionV];
            return three;
        }
    }
    return nil;
}

//跳转品牌街
- (void)pushIndexVC:(NSIndexPath *)indexPath {
//    Equipment_ListViewController *list = [[Equipment_ListViewController alloc] init];
//    [self.navigationController pushViewController:list animated:YES];
    BrandListViewController *list = [[BrandListViewController alloc] init];
    [self.navigationController pushViewController:list animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BrandStreetViewController *brand = [[BrandStreetViewController alloc] init];
        brand.category_id = self.categoryArray[indexPath.row][@"category_id"];
        brand.category_name = self.categoryArray[indexPath.row][@"category_name"];
        [self.navigationController pushViewController:brand animated:YES];
    }else if (indexPath.section == 1) {
        //跳转无品牌商ID
        BrandListInfoViewController *info = [[BrandListInfoViewController alloc] init];
        info.brand_id = self.fiveStreetArray[indexPath.row][@"brand_id"];
        [self.navigationController pushViewController:info animated:YES];
    }else {
        EquipmentInfoViewController *info = [[EquipmentInfoViewController alloc] init];
        info.goods_id = self.categoryGoodsArray[indexPath.row][@"goods_id"];
        info.type = 1;
        [self.navigationController pushViewController:info animated:YES];
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

- (void)changeCellType:(UIButton *)sender {
    UIButton *button = (UIButton *)[self.view viewWithTag:100];
    button.selected = !button.isSelected;
    __weak typeof(self) weakSelf = self;
    if (button.selected) {
        isChangeCellType = YES;
        [button setImage:[UIImage imageNamed:@"liebiao"] forState:UIControlStateNormal];
        [UIView performWithoutAnimation:^{
            //刷新界面
            [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
        }];
        
    }else {
        isChangeCellType = NO;
        [button setImage:[UIImage imageNamed:@"pic"] forState:UIControlStateNormal];
        [UIView performWithoutAnimation:^{
            //刷新界面
            [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
        }];
        
    }
}

- (void)touchButton:(UIButton *)button withTag:(NSInteger)tag {
    //tag 从200开始
    if (tag == 200) { //销量
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.categoryGoodsArray];
        [self sortArrayContainsDictionary:array AndConditions:@"sales"];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
    }else if (tag == 201) { //好评
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.categoryGoodsArray];
        [self sortArrayContainsDictionary:array AndConditions:@"praise"];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
    }else {                 //价格
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.categoryGoodsArray];
        [self sortArrayContainsDictionary:array AndConditions:@"goods_price"];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
    }
   
}

- (void)sortArrayContainsDictionary:(NSMutableArray *)myMutableArr AndConditions:(NSString *)key {
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:NO]];
    [myMutableArr sortUsingDescriptors:sortDescriptors];
    NSLog(@"CategoryGoods SORT === %@",myMutableArr);
    self.categoryGoodsArray = [myMutableArr mutableCopy];
}

- (LoopView *)loopV {
    if (_loopV == nil) {
        _loopV = [[LoopView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 200)];
        _loopV.imageArray = @[@"1", @"2", @"3", @"4"];
    }
    return _loopV;
}

//通过顶级分类ID获取下级分类信息
- (void)getSecondCategoryFromEquipMent {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/index.php/home/goods/getSecond";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parame = @{
                             @"category_id" : @"34",
                             @"limit" : @(8)
                             };
    [manager POST:url parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"CategoryGoods === %@", responseObject);
        weakSelf.categoryArray = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取五个品牌街
- (void)getStreetForFive {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/index.php/home/brand/brandLimit";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"fiveStreet === %@", responseObject);
        weakSelf.fiveStreetArray = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取商品
- (void)getCategoryGoods {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/home/goods/goodsList";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"category_id" : @"34"};
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"CategoryGoods === %@", responseObject);
        weakSelf.categoryGoodsArray = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//搜索
- (void)getCategoryGoodsFromSearchText:(NSString *)string {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/home/goods/goodsList";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"key_word" : string};
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"CategoryGoods search === %@", responseObject);
        weakSelf.categoryGoodsArray = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取轮播图数据
- (void)getScrollData_Equiment {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/home/index/getSowingMap";
    NSDictionary *parme = @{@"type" : @(5)};
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
