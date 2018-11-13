//
//  AfterServiceViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "AfterServiceViewController.h"
#import "HomeCollectionViewCell.h"
#import "ProjectCollectionViewCell.h"
#import "Globefile.h"

#import "LoopView.h"
#import "SecondCollectionReusableView.h"
#import "SecondSectionView.h"
#import "After_ProjectInfoViewController.h"
#import "HotYachtViewController.h"
#import "After_MarchantListViewController.h"
#import "AfterService_ShoppingListViewController.h"
#import "BrandListViewController.h"
#import "BrandStreetViewController.h"
#import "URLImageScroll.h"

@interface AfterServiceViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PushIndexDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *categoryArray;

@property (nonatomic, strong) NSArray *merchantArray;

@property (nonatomic, strong) NSArray *CWJArray;

@property (nonatomic, strong) NSArray *MTTArray;

@property (nonatomic, strong) NSArray *scrollData;

@end

@implementation AfterServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"售后服务";
    // Do any additional setup after loading the view.
    [self creatUI];
    
    [self setUpNav];
    
    [self getSecondCategory];
    [self getSecondCategory_CWJ];
    [self getSecondCategory_MTT];
    
    [self getProjectFromMarchant];
    
    [self getScrollData_after];
}
setBack();
pop();

- (void)creatUI {
    UISearchBar *searchView = [[UISearchBar alloc] initWithFrame:FRAME(0, 10, SCREENBOUNDS.width, 30)];
    searchView.searchBarStyle = UISearchBarStyleMinimal;
    UITextField *searchTextF = [searchView valueForKey:@"searchField"];
    searchTextF.font = SetFont(15);
    ViewRadius(searchTextF, 22.0);
    searchView.placeholder = @"可搜索各种游艇";
    [self.view addSubview:searchView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"first"];
    [self.collectionView registerClass:[ProjectCollectionViewCell class] forCellWithReuseIdentifier:@"second"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"one"];
    [self.collectionView registerClass:[SecondCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"two"];
    [self.view addSubview:self.collectionView];
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(50, 0, 0, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.categoryArray.count;
    }else if (section == 1) {
        return self.CWJArray.count >=5 ? 5 : self.CWJArray.count;
    }else if (section == 2) {
        return self.MTTArray.count >=5 ? 5 : self.MTTArray.count;
    }
    else {
        return self.merchantArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        NSDictionary *dic = self.merchantArray[indexPath.row];
        ProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
        [cell layoutIfNeeded];
        [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
        cell.topLeftString = dic[@"merchant_name"];//@"售后服务商家";
        cell.topTextF.text = @"";//@"0条评价";
        cell.topRightString = @"0条好评";
        cell.centerLeftString = @"已售0件";
//        cell.centerTextF.text = @"已售0件";
        cell.centerRightString = @"1588人浏览";
        cell.bottomLeftString = [NSString stringWithFormat:@"%@ - %@", dic[@"start_business_time"], dic[@"end_business_time"]];
        cell.bottomRightString = @"离我12km";
        return cell;
    }
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
    cell.isCircle = YES;
    cell.bottomLabel.font = SetFont(12);
    cell.bottomLabel.text = @"售后分类";
    if (indexPath.section == 0) {
        NSDictionary *dic = self.categoryArray[indexPath.row];
        [cell.topImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"logo"]] placeholderImage:[UIImage imageNamed:@"public"]];
        cell.bottomLabel.text = dic[@"category_name"];
    }else if (indexPath.section == 1) {
        NSDictionary *dic = self.CWJArray[indexPath.row];
        [cell.topImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"logo"]] placeholderImage:[UIImage imageNamed:@"public"]];
        cell.bottomLabel.text = dic[@"category_name"];
    }else if (indexPath.section == 2) {
        cell.isCircle = YES;
        NSDictionary *dic = self.MTTArray[indexPath.row];
        [cell.topImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"logo"]] placeholderImage:[UIImage imageNamed:@"public"]];
        cell.bottomLabel.text = dic[@"category_name"];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat width = (SCREENBOUNDS.width - 110.0) / 4;
        return CGSizeMake(width, width + 40);
    }else if (indexPath.section == 1 || indexPath.section == 2) {
        CGFloat width = (SCREENBOUNDS.width - 60.0) / 5;
        return CGSizeMake(width, width + 40);
    }else {
        return CGSizeMake(SCREENBOUNDS.width - 20, 110.0);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 30.0;
    }else if (section == 1 || section == 2) {
        return 10.0;
    }else {
        return 0.0;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 10.0;
    }else if (section == 1 || section == 2) {
        return 10.0;
    }else {
        return 10.0;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 200.0);
    }
    return CGSizeMake(SCREENBOUNDS.width, 44.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"one" forIndexPath:indexPath];
//        LoopView *loop = [[LoopView alloc] initWithFrame:view.bounds];
//        loop.imageArray = @[@"1", @"2"];
//        [view addSubview:loop];
        URLImageScroll *scroll = [[URLImageScroll alloc] initWithFrame:view.bounds withImageArray:self.scrollData];
        [view addSubview:scroll];
        return view;
    }else if(indexPath.section == 1 || indexPath.section == 2) {
        SecondCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"two" forIndexPath:indexPath];
        view.delegate = self;
        if (indexPath.section == 1) {
            view.indexPath = indexPath;
            view.textF.text = @"    船外机配件";
        }else {
            view.indexPath = indexPath;
            view.textF.text = @"    摩托艇配件";
        }
        return view;
    }else {
        UICollectionReusableView *view1 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"one" forIndexPath:indexPath];
        for (UIView *v in view1.subviews) {
            [v removeFromSuperview];
        }
        SecondSectionView *second = [[SecondSectionView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 44) ItemNumber:3 AndTitle:@[@"销量最高", @"距离最近", @"好评最高"]];
        [view1 addSubview:second];
        return view1;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AfterService_ShoppingListViewController *list = [[AfterService_ShoppingListViewController alloc] init];
        list.category_id = self.categoryArray[indexPath.row][@"category_id"];
        [self.navigationController pushViewController:list animated:YES];
    }else if (indexPath.section == 1) {
        BrandStreetViewController *list = [[BrandStreetViewController alloc] init];
        list.category_id = self.CWJArray[indexPath.row][@"category_id"];
        list.category_name = self.CWJArray[indexPath.row][@"category_name"];
        [self.navigationController pushViewController:list animated:YES];
    }else if (indexPath.section == 2) {
        BrandStreetViewController *list = [[BrandStreetViewController alloc] init];
        list.category_id = self.MTTArray[indexPath.row][@"category_id"];
        list.category_name = self.MTTArray[indexPath.row][@"category_name"];
        [self.navigationController pushViewController:list animated:YES];
    } else  {
        HotYachtViewController *list = [[HotYachtViewController alloc] init];
        list.merchant_id = self.merchantArray[indexPath.row][@"merchant_id"];
        [self.navigationController pushViewController:list animated:YES];
    }
}

- (void)pushIndexVC:(NSIndexPath *)indexPath {
    NSLog(@"121213121312");
    if (indexPath.section == 1) {
        NSLog(@"1111111111111111");
        BrandListViewController *list = [[BrandListViewController alloc] init];
        list.category_top_id = @"83";
        [self.navigationController pushViewController:list animated:YES];
    }else if (indexPath.section == 2) {
        NSLog(@"2222222222222");
        BrandListViewController *list1 = [[BrandListViewController alloc] init];
        list1.category_top_id = @"84";
        [self.navigationController pushViewController:list1 animated:YES];
    }
}

//通过顶级分类ID获取下级分类信息
- (void)getSecondCategory {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/index.php/home/goods/getSecond";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parame = @{@"category_id" : @"37"};
    [manager POST:url parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"售后服务 === %@", responseObject);
        weakSelf.categoryArray = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取船外机配件
- (void)getSecondCategory_CWJ {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/index.php/home/goods/getSecond";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parame = @{
                             @"category_id" : @"83",
                             @"limit" : @(5)
                             };
    [manager POST:url parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"CWJArray === %@", responseObject);
        weakSelf.CWJArray = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取摩托艇配件
- (void)getSecondCategory_MTT {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/index.php/home/goods/getSecond";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parame = @{
                             @"category_id" : @"84",
                             @"limit" : @(5)
                             };
    [manager POST:url parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"MTTArray === %@", responseObject);
        weakSelf.MTTArray = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//通过顶级分类ID获取商家列表
- (void)getProjectFromMarchant {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/index.php/home/merchant/playMerchant";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"category_id" : @(37)};
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"project  === %@", responseObject);
        weakSelf.merchantArray = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:3]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取轮播图数据
- (void)getScrollData_after {
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
