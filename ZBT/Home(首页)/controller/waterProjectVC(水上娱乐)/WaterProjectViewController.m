//
//  WaterProjectViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/23.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "WaterProjectViewController.h"

#import "LoopView.h"
#import "SecondSectionView.h"
#import "ProjectInfoViewController.h"
#import "MarchantListViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "URLImageScroll.h"

@interface WaterProjectViewController ()<UICollectionViewDelegateFlowLayout, UISearchBarDelegate, SecondButtonDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

//顶级分类下的商家
@property (nonatomic, strong) NSArray *merchantArray;

@property (nonatomic, strong) NSArray *scrollData;

@end

@implementation WaterProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isWharfGoVC) {
        self.title = @"码头出行";
    }else {
        self.title = @"水上娱乐";
    }
    // Do any additional setup after loading the view.
    UISearchBar *searchView = [[UISearchBar alloc] initWithFrame:FRAME(0, 10, SCREENBOUNDS.width, 30)];
    searchView.delegate = self;
    searchView.returnKeyType = UIReturnKeySearch;
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
    
    [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"home"];
    [self.collectionView registerClass:[ProjectCollectionViewCell class] forCellWithReuseIdentifier:@"project"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"first"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"second"];
    
    [self.view addSubview:self.collectionView];
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(50, 0, 0, 0));
    }];
    
    [self setUpNav];
    
    [self getSecondCategory:self.category_id];
    
    [self getProjectFromMarchant];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getScrollData_Service];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchbar");
    [searchBar resignFirstResponder];
    [self getProjectFromMarchantFormSearch:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchText === %@", searchText);
    if ([searchText isEqualToString:@""]) {
        [searchBar resignFirstResponder];
        [self getProjectFromMarchant];
    }
}

//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    [searchBar resignFirstResponder];
//}

setBack();
pop();

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
        HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"home" forIndexPath:indexPath];
        if (self.isWharfGoVC) {
            NSDictionary *dic = self.categoryArray[indexPath.row];
            [cell.topImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"logo"]] placeholderImage:[UIImage imageNamed:@"public"]];
            cell.bottomLabel.text = dic[@"category_name"];
            //            cell.bottomLabel.text = @"出行分类";
        }else {
            NSDictionary *dic = self.categoryArray[indexPath.row];
            [cell.topImageV sd_setImageWithURL:[NSURL URLWithString:isNullClass(dic[@"logo"])] placeholderImage:[UIImage imageNamed:@"public"]];
            cell.bottomLabel.text = dic[@"category_name"];
        }
        
        cell.bottomLabel.font = SetFont(12);
        return cell;
    }else if (indexPath.section == 1) {
        NSDictionary *dic = self.merchantArray[indexPath.row];
        ProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"project" forIndexPath:indexPath];
        [cell layoutIfNeeded];
        [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
        cell.topLeftString = dic[@"merchant_name"];
        //        cell.topTextF.text = self.topText;
        cell.topRightString = @"";//[NSString stringWithFormat:@"好评%@%%", dic[@"praise"]];//self.topRightString;
        cell.centerLeftString = [NSString stringWithFormat:@"已售%@件", dic[@"sales"]];//self.centerLeftString;
        //        cell.centerTextF.text = self.centerText;
        cell.centerRightString = [NSString stringWithFormat:@"%d人浏览", arc4random() % 500];//self.centerRightString;
        cell.bottomLeftString = [NSString stringWithFormat:@"好评%@%%", dic[@"praise"]];//@"【舟博通-游艇】";
        //        cell.bottomTextF.text = self.bottomText;
        cell.bottomRightString = [NSString stringWithFormat:@"离我%@km", dic[@"distance"]];//self.bottomRightString;
        return cell;
    }
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return UIEdgeInsetsMake(20, 10, 20, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 30.0;
    }
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 10.0;
    }
    return 10.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat width = (SCREENBOUNDS.width - 110) / 4;
        return CGSizeMake(width, width + 40);
    }
    return CGSizeMake(SCREENBOUNDS.width - 40, 120);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 200);
    }
    return CGSizeMake(SCREENBOUNDS.width, 44);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    if (kind == UICollectionElementKindSectionHeader) {
//        for (UIView *vv in view.subviews) {
//            [vv removeFromSuperview];
//        }
        if (indexPath.section == 0) {
//            LoopView *loopV = [[LoopView alloc] initWithFrame:view.bounds];
//            loopV.imageArray = @[@"1", @"2", @"3", @"4"];
//            [view addSubview:loopV];
            UICollectionReusableView *view_V = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"first" forIndexPath:indexPath];
            URLImageScroll *scroll = [[URLImageScroll alloc] initWithFrame:view_V.bounds withImageArray:self.scrollData];
            [view_V addSubview:scroll];
            return view_V;
        }
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"first" forIndexPath:indexPath];
        SecondSectionView *secondV = [[SecondSectionView alloc] initWithFrame:view.bounds ItemNumber:3 AndTitle:@[@"销售最高", @"距离最近", @"好评最高"]];
        secondV.delegate = self;
        [view addSubview:secondV];
        return view;
//    }
}

- (void)touchButton:(UIButton *)button withIndex:(NSInteger)index {
    //tag 从500开始
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.merchantArray];
    if (index == 500) { //销量
        [self sortArrayContainsDictionary:array AndConditions:@"sales"];
    }else if (index == 501) { //距离
        [self sortArrayContainsDictionary:array AndConditions:@"distance"];
    }else {                 //好评
        [self sortArrayContainsDictionary:array AndConditions:@"praise"];
    }
    
}

- (void)sortArrayContainsDictionary:(NSMutableArray *)myMutableArr AndConditions:(NSString *)key {
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:NO]];
    [myMutableArr sortUsingDescriptors:sortDescriptors];
    NSLog(@"CategoryGoods SORT === %@",myMutableArr);
    self.merchantArray = [myMutableArr mutableCopy];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ProjectInfoViewController *info = [[ProjectInfoViewController alloc] init];
        info.isWharfGoVC = self.isWharfGoVC;
        info.merchant_id = self.merchantArray[indexPath.row][@"merchant_id"];
        [self.navigationController pushViewController:info animated:YES];
    }else {
        MarchantListViewController *list = [[MarchantListViewController alloc] init];
        list.isWharfGoVC = self.isWharfGoVC;
        list.categoryID = self.categoryArray[indexPath.row][@"category_id"];
        [self.navigationController pushViewController:list animated:YES];
    }
}

//通过顶级分类ID获取下级分类信息    水上娱乐
- (void)getSecondCategory:(NSString *)topCategoryID {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/index.php/home/goods/getSecond";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parame = @{
                             @"category_id" : topCategoryID,
                             @"limit" : @(8)
                             };
    [manager POST:url parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"topCategoryID %@ === %@", topCategoryID, responseObject);
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
    NSDictionary *parme = @{@"category_id" : self.category_id};
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"2222222222  === %@", responseObject);
        weakSelf.merchantArray = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//通过顶级分类ID获取商家列表      搜索
- (void)getProjectFromMarchantFormSearch:(NSString *)searchString {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/index.php/home/merchant/topCategoryMerchant";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"category_id" : self.category_id,
                            @"key_word" : searchString
                            };
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"11111111  === %@", responseObject);
        weakSelf.merchantArray = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取自己所在地的经纬度
- (void)getLocationWithMe {
    //获取商家所在地的经纬度
    NSString *url = [NSString stringWithFormat:@"http://api.map.baidu.com/cloudgc/v1/?address=%@&output=json&ak=%@&mcode=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"Location_info"], BAIDU_AK, BAIDU_MCODE];
    NSString *URLString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    __weak typeof(self) weakSelf = self;
    [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"MeLocation  === %@", responseObject);
        NSDictionary *response = (NSDictionary *)[responseObject[@"result"] firstObject][@"location"];
//        [weakSelf getLocation_MeWithOtherLocation:response];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error === %@", error);
    }];
}

//获取轮播图数据
- (void)getScrollData_Service {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/home/index/getSowingMap";
    NSDictionary *parme = @{@"type" : @(self.type)};
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"shuishangyule ----%@", responseObject);
        weakSelf.scrollData = [responseObject[@"data"] firstObject][@"photo"];
//        [weakSelf.collectionView reloadData];
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
