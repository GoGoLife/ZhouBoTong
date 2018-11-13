//
//  HomeViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "HomeViewController.h"
#import "Globefile.h"

#import "HomeCollectionViewCell.h"
#import "HomeSecondCollectionViewCell.h"
#import "FirstCollectionReusableView.h"
#import "SecondCollectionReusableView.h"
#import "BrandStreetViewController.h"
#import "HotYachtViewController.h"
#import "EquipmentViewController.h"
#import "WaterProjectViewController.h"
#import "SecondHandViewController.h"
#import "CustomServiceViewController.h"
#import "MarchantHomeViewController.h"
#import "Train_HomeViewController.h"
#import "AfterServiceViewController.h"
#import "Commission_ServiceViewController.h"
#import "After_MaintainViewController.h"

#import "LoopView.h"
#import "CustomSearchView.h"

#import "BrandListViewController.h"
#import "AllineceViewController.h"
#import "BrandListInfoViewController.h"

#import "MarchantHomeViewController.h"
#import "Boat_InfoViewController.h"
#import "InformationViewController.h"
#import "Publish_infoViewController.h"
#import "PersonSecondYeach_InfoViewController.h"

#import "SearchViewController.h"
#import "LocationViewController.h"

#import "WheelViewController.h"

#import "SellProjectViewController.h"

#import "SaoYiSaoViewController.h"

#import <Hyphenate/Hyphenate.h>
#import "AppDelegate+HuanXin.h"

#import "Buy_GroupListViewController.h"

#import "ScrollTextView.h"
#import "URLImageScroll.h"


@interface HomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PushIndexDelegate, CustomSearchViewDelegate, LoopViewDelegate, URLImageTouchIndexDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

//保存分类ID
@property (nonatomic, strong) NSString *category_id;

@property (nonatomic, strong) NSArray *allTopCategoryArray;

@property (nonatomic, strong) CustomSearchView *searchView;

@property (nonatomic, strong) NSDictionary *homeData;

@property (nonatomic, strong) NSArray *scrollData;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *titleV = [[UIView alloc] initWithFrame:FRAME(20, 40, SCREENBOUNDS.width - 100, 40)];
    titleV.backgroundColor = [UIColor colorWithRed:233/255.0 green:240/255.0 blue:245/255.0 alpha:1.0];
    self.navigationItem.titleView = titleV;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"saoyisao"] style:UIBarButtonItemStylePlain target:self action:@selector(saoyisao)];
    self.navigationItem.leftBarButtonItem = left;
    
    self.searchView = [[CustomSearchView alloc] initWithFrame:FRAME(0, 7, SCREENBOUNDS.width / 6 * 5, 30) isShowAdd:NO];
    self.searchView.delegate = self;
    self.searchView.tag = 111;
    [self.searchView.button setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"]?:@"未定位" forState:UIControlStateNormal];
    [self.searchView.button addTarget:self action:@selector(pushAddressVC) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:self.searchView];
    
    [self creatCollectionView];
    
    [self getHomeInfo];
    
    [self getScrollData];
    
//    if ([[EMClient sharedClient] isLoggedIn]) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate Huanxin_Register];
//    }
}

- (void)saoyisao {
    SaoYiSaoViewController *sao = [[SaoYiSaoViewController alloc] init];
    [self.navigationController pushViewController:sao animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //获取个人信息    判断是否认证
    [self getPersonInfo];
}

//获取个人信息
- (void)getPersonInfo {
//    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/index.php/home/Member/showInfo";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"phone" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account"]};
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject === %@", responseObject);
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"rz"] forKey:@"isRZ"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [(UIView *)[self.navigationController.navigationBar viewWithTag:111] removeFromSuperview];
}

- (void)creatCollectionView {
    UICollectionViewFlowLayout *layou = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layou];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"first"];
    [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"second"];
    [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"three"];
    [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"four"];
    [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"five"];
    
    [self.collectionView registerClass:[FirstCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"firstHeader"];
    
    [self.collectionView registerClass:[SecondCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"secondHeader"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"secondFooter"];
    
    [self.view addSubview:self.collectionView];
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 20, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 8;
            break;
        case 1:
            return [self.homeData[@"hot"] count];
            break;
        case 2:
            return [self.homeData[@"brand_data"] count];
            break;
        case 3:
            return [self.homeData[@"ship_model"] count];
            break;
        case 4:
        {
            NSArray *dataArr = [self.homeData[@"second"][@"member"] arrayByAddingObjectsFromArray:self.homeData[@"second"][@"merchant"]];
            return dataArr.count >= 20 ? 20 : dataArr.count;
        }
            break;
        default:
            return 0;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
            cell.bottomLabel.font = SetFont(12);
            cell.isCircle = YES;
            cell.topImageV.image = [UIImage imageNamed:@[@"home_ting", @"home_ssyl", @"home_jzpx", @"home_dzfw", @"home_cbsb", @"home_mtcx", @"home_dbfw", @"home_ssfw"][indexPath.row]];
            cell.bottomLabel.text = @[@"艇买/卖", @"水上娱乐", @"驾照培训", @"定制服务", @"船舶设备", @"码头出行", @"代办服务", @"售后服务"][indexPath.row];
            return cell;
        }
            break;
        case 1:
        {
            NSDictionary *dic = self.homeData[@"hot"][indexPath.row];
            HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
            [cell.topImageV sd_setImageWithURL:[NSURL URLWithString:isNullClass(dic[@"logo"])] placeholderImage:[UIImage imageNamed:@"home_1"]];
            cell.bottomLabel.font = SetFont(16);
            cell.bottomLabel.text = dic[@"category_name"];//@[@"游艇", @"钓鱼艇", @"公务艇", @"通用艇", @"摩托艇", @"帆船艇"][indexPath.row];
//            cell.isNewLayout = YES;
            return cell;
        }
            break;
        case 2:             //品牌街
        {
            NSDictionary *dic = self.homeData[@"brand_data"][indexPath.row];
            HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"three" forIndexPath:indexPath];
            cell.topImageV.image = [UIImage imageNamed:@"home_2"];
            [cell.topImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
            cell.bottomLabel.font = SetFont(12);
            cell.bottomLabel.text = dic[@"brand_name"];
//            cell.isCircle = YES;
            return cell;
        }
            break;
        case 3:             //船厂联盟
        {
            NSDictionary *dic = self.homeData[@"ship_model"][indexPath.row];
            HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"four" forIndexPath:indexPath];
            [cell.topImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
            cell.bottomLabel.font = SetFont(12);
            cell.isCircle = YES;
            cell.bottomLabel.text = dic[@"brand_name"];
            return cell;
        }
            break;
        case 4:             //二手艇
        {
            NSArray *dataArr = [self.homeData[@"second"][@"merchant"] arrayByAddingObjectsFromArray:self.homeData[@"second"][@"member"]];
            HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"five" forIndexPath:indexPath];
            if ([dataArr[indexPath.row][@"type"] integerValue] == 1) {
                [cell.topImageV sd_setImageWithURL:[NSURL URLWithString:dataArr[indexPath.row][@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
                cell.isNewLayout = YES;
                cell.bottomLabel.font = SetFont(12);
                cell.bottomLabel.text = dataArr[indexPath.row][@"title"];
                cell.infoLabel.text = @"个人";
            }else {
                [cell.topImageV sd_setImageWithURL:[NSURL URLWithString:dataArr[indexPath.row][@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
                cell.isNewLayout = YES;
                cell.bottomLabel.font = SetFont(12);
                cell.bottomLabel.text = dataArr[indexPath.row][@"goods_name"];
                cell.infoLabel.text = @"商家";
            }
            
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            return CGSizeMake((self.view.bounds.size.width - 110) / 4, (SCREENBOUNDS.width - 110) / 4 + 40);
        }
            break;
        case 1:
        {
            NSInteger width = (SCREENBOUNDS.width - 40 - 1) / 3;
            return CGSizeMake(width, width + 20);
        }
            break;
        case 2:
        {
            NSInteger width = (SCREENBOUNDS.width - 60) / 5;
            return CGSizeMake(width, width + 40);
        }
            break;
        case 3:
        {
            NSInteger width = (SCREENBOUNDS.width - 60) / 5;
            return CGSizeMake(width, width + 40);
        }
            break;
        case 4:
        {
            NSInteger width = (SCREENBOUNDS.width - 50) / 2;
            return CGSizeMake(width, width + 40);
        }
            break;
        default:
            return CGSizeZero;
            break;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    switch (section) {
        case 0:
            return 30.0;
            break;
        case 1:
            return 10.0;
            break;
        case 2:
            return 10.0;
            break;
        case 3:
            return 10.0;
            break;
        case 4:
            return 30.0;
            break;
        default:
            return 0.0;
            break;
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//Header
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 200);
    }else {
        return CGSizeMake(SCREENBOUNDS.width, 30);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 70);
    }
    return CGSizeMake(SCREENBOUNDS.width, 10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            UICollectionReusableView *first = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"firstHeader" forIndexPath:indexPath];
            URLImageScroll *scroll = [[URLImageScroll alloc] initWithFrame:first.bounds withImageArray:self.scrollData];
            scroll.delegate = self;
            [first addSubview:scroll];
            return first;
        }else {
            SecondCollectionReusableView *second = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"secondHeader" forIndexPath:indexPath];
            second.textF.text = @[@"    热门艇", @"    品牌街", @"    船厂联盟", @"   二手艇"][indexPath.section - 1];
            second.delegate = self;
            second.indexPath = indexPath;
            if (indexPath.section == 1 || indexPath.section == 4) {
                second.label.hidden = YES;
            }
            return second;
        }
    }else if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 0) {
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
            view.backgroundColor = SetColor(243, 242, 247, 1);
            [self setContentV:view];
            return view;
        }else {
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"secondFooter" forIndexPath:indexPath];
            view.backgroundColor = SetColor(243, 242, 247, 1);
            return view;
        }
    }
    return nil;
}

//item跳转方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self selectItem:indexPath.row];
    }else if (indexPath.section == 1) {        //热门艇item跳转
        NSString *secondCategory_id;
        switch (indexPath.row) {
            case 0:
                secondCategory_id = @"65";
                break;
            case 1:
                secondCategory_id = @"66";
                break;
            case 2:
                secondCategory_id = @"67";
                break;
            case 3:
                secondCategory_id = @"68";
                break;
            case 4:
                secondCategory_id = @"69";
                break;
            case 5:
                secondCategory_id = @"70";
                break;
            default:
                break;
        }
        HotYachtViewController *hot = [[HotYachtViewController alloc] init];
        hot.title = @[@"游艇", @"钓鱼艇", @"公务艇", @"通用艇", @"摩托艇", @"船外机"][indexPath.row];
        hot.secondCategory_id = secondCategory_id;
        [self.navigationController pushViewController:hot animated:YES];
    }else if (indexPath.section == 2) {
        NSDictionary *dic = self.homeData[@"brand_data"][indexPath.row];
        BrandListInfoViewController *info = [[BrandListInfoViewController alloc] init];
        info.title = @"品牌商家";
        info.brand_id = dic[@"brand_id"];
        [self.navigationController pushViewController:info animated:YES];
    }else if (indexPath.section == 3) {
        NSDictionary *dic = self.homeData[@"ship_model"][indexPath.row];
        BrandListInfoViewController *info = [[BrandListInfoViewController alloc] init];
        info.title = @"船厂商家";
        info.brand_id = dic[@"brand_id"];
        [self.navigationController pushViewController:info animated:YES];
    }else {
        NSArray *dataArr = [self.homeData[@"second"][@"merchant"] arrayByAddingObjectsFromArray:self.homeData[@"second"][@"member"]];
        if ([dataArr[indexPath.row][@"type"] integerValue] == 1) {
            NSLog(@"1111111111111111111111   member");
            PersonSecondYeach_InfoViewController *person_info = [[PersonSecondYeach_InfoViewController alloc] init];
            person_info.buy_id = dataArr[indexPath.row][@"buy_id"];
            person_info.type = 3;
            [self.navigationController pushViewController:person_info animated:YES];
        }else {
            NSLog(@"2222222222222222222 merchant");
            Boat_InfoViewController *info = [[Boat_InfoViewController alloc] init];
            info.goods_id = dataArr[indexPath.row][@"goods_id"];
            info.type = 1;
            NSLog(@"goods_id === %@", dataArr[indexPath.row][@"goods_id"]);
            [self.navigationController pushViewController:info animated:YES];
        }
    }
}

- (void)selectItem:(NSInteger)row {         //八大分类点击事件
    switch (row) {
        case 0:                          //二手艇
        {
            SecondHandViewController *hand = [[SecondHandViewController alloc] init];
            hand.consultData = self.homeData[@"notice_data"];
            [self.navigationController pushViewController:hand animated:YES];
        }
            break;
        case 1:                         //水上娱乐
        {
            WaterProjectViewController *water = [[WaterProjectViewController alloc] init];
            water.category_id = @"12";
            water.type = 2;
            [self.navigationController pushViewController:water animated:YES];
        }
            break;
        case 2:                     //驾照培训
        {
            Train_HomeViewController *train = [[Train_HomeViewController alloc] init];
            train.category_id = @"32";
            train.type = 3;
            [self.navigationController pushViewController:train animated:YES];
        }
            break;
        case 3:                        //定制服务
        {
            CustomServiceViewController *custom = [[CustomServiceViewController alloc] init];
            [self.navigationController pushViewController:custom animated:YES];
        }
            break;
        case 4:                        //船舶设备
        {
            EquipmentViewController *equipmentVC = [[EquipmentViewController alloc] init];
            [self.navigationController pushViewController:equipmentVC animated:YES];
        }
            break;
        case 5:                        // 码头出行   类似水上娱乐   重用
        {
            WaterProjectViewController *water = [[WaterProjectViewController alloc] init];
            water.isWharfGoVC = YES;
            water.category_id = @"38";
            water.type = 6;
            [self.navigationController pushViewController:water animated:YES];
        }
            break;
        case 6:                        // 代办服务
        {
            Commission_ServiceViewController *commission = [[Commission_ServiceViewController alloc] init];
            [self.navigationController pushViewController:commission animated:YES];
        }
            break;
        case 7:                        // 售后服务
        {
            AfterServiceViewController *after = [[AfterServiceViewController alloc] init];
            [self.navigationController pushViewController:after animated:YES];
        }
            break;
            
        default:
            break;
    }
}

//点击section方法
- (void)pushIndexVC:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            
            break;
        case 1:          //热门艇
        {
//            HotYachtViewController *hot = [[HotYachtViewController alloc] init];
//            [self.navigationController pushViewController:hot animated:YES];
        }
            
            break;
        case 2:       //品牌街
        {
            BrandListViewController *list = [[BrandListViewController alloc] init];
            [self.navigationController pushViewController:list animated:YES];
        }
            break;
        case 3:       //船厂联盟
        {
            AllineceViewController *list = [[AllineceViewController alloc] init];
            [self.navigationController pushViewController:list animated:YES];
        }
            break;
        case 4:       //二手艇
        {
//            HotYachtViewController *hot = [[HotYachtViewController alloc] init];
//            [self.navigationController pushViewController:hot animated:YES];
        }
            break;
        default:
            break;
    }
}

//资讯列表
- (void)touchFooter {
    InformationViewController *information = [[InformationViewController alloc] init];
    information.dataArr = self.homeData[@"notice_data"];
    [self.navigationController pushViewController:information animated:YES];
}

//跳转搜索页面
- (void)touchSearchBar {
    SearchViewController *search = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

//跳转定位页面
- (void)pushAddressVC {
    LocationViewController *location = [[LocationViewController alloc] init];
    location.returnCityName = ^(NSString *city) {
        [self.searchView.button setTitle:city forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:location animated:YES];
}

//轮播跳转
#pragma mark --- loopDelegate
- (void)didSelected:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HotYachtViewController *yacht = [[HotYachtViewController alloc] init];
        yacht.sectionV.hidden = YES;
        yacht.isSelectWheel = YES;
        [self.navigationController pushViewController:yacht animated:YES];
    }else if (indexPath.row == 1) {
        Buy_GroupListViewController *list = [[Buy_GroupListViewController alloc] init];
        [self.navigationController pushViewController:list animated:YES];
    }
}

- (void)TouchImageIndexWithAction:(NSInteger)index {
    if (index == 1) {
        HotYachtViewController *yacht = [[HotYachtViewController alloc] init];
        yacht.sectionV.hidden = YES;
        yacht.isSelectWheel = YES;
        [self.navigationController pushViewController:yacht animated:YES];
    }else if (index == 2) {
        Buy_GroupListViewController *list = [[Buy_GroupListViewController alloc] init];
        [self.navigationController pushViewController:list animated:YES];
    }
}

- (void)setContentV:(UIView *)view {
    UIView *contentV = [[UIView alloc] init];
    contentV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchFooter)];
    [contentV addGestureRecognizer:tap];
    contentV.backgroundColor = [UIColor whiteColor];
    
    UIImageView *fire = [[UIImageView alloc] init];
    fire.image = [UIImage imageNamed:@"fire"];
    
    UIImageView *ershou = [[UIImageView alloc] init];
    ershou.image = [UIImage imageNamed:@"ershouting"];
    
//    UILabel *textLabel = [[UILabel alloc] init];
//    textLabel.font = SetFont(15);
//    textLabel.text = [self.homeData[@"notice_data"] firstObject][@"title"];//@"温州万豪游艇俱乐部温州万豪游艇俱乐部温州万豪游艇俱乐部";
    ScrollTextView *textV = [[ScrollTextView alloc] initWithFrame:FRAME(120, 5, 150, 40) whitTextArray:self.homeData[@"notice_data"]];
    
    UIButton *gengduo = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGSize imageSize = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gengduo"]].bounds.size;
    UILabel *label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 0, 20)];
    label.text = @"更多";
    [label sizeToFit];
    CGSize titleSize = label.bounds.size;
    
    gengduo.imageEdgeInsets = UIEdgeInsetsMake(7, titleSize.width + 5, 7, -titleSize.width - 5);
    gengduo.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width);
    gengduo.titleLabel.font = SetFont(14);
    [gengduo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gengduo setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
    [gengduo setTitle:@"更多" forState:UIControlStateNormal];
    
    [contentV addSubview:fire];
    [contentV addSubview:ershou];
    [contentV addSubview:textV];
    [contentV addSubview:gengduo];
    
    [view addSubview:contentV];
    
    [contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(10, 0, 10, 0));
    }];
    
    [fire mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentV.mas_left).offset(15);
        make.centerY.equalTo(contentV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [ershou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fire.mas_right).offset(15);
        make.centerY.equalTo(contentV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [gengduo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentV.mas_right).offset(-15);
        make.centerY.equalTo(contentV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
//    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(contentV.mas_centerY);
//        make.left.equalTo(ershou.mas_right).offset(10);
//        make.right.equalTo(gengduo.mas_left).offset(-10);
//        make.height.mas_equalTo(@(40));
//    }];
}

//根据分类名称确定分类ID
- (void)getTopCategoryList {
//    __weak typeof(self) weakSelf = self;
//    NSString *url = @"http://45.77.244.195/index.php/home/goods/topCategory";
    NSString *url = @"https://zbt.change-word.com/index.php/home/goods/goodsList";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"https +_+_+_+_+_+ ----%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSString *)getSecondCategoryID:(NSString *)categoryName {
    for (NSDictionary *dic in self.allTopCategoryArray) {
        if ([dic[@"category_name"] isEqualToString:categoryName]) {
            self.category_id = dic[@"category_id"];
            NSLog(@"%@ === %@", categoryName, dic[@"category_id"]);
        }
    }
    return self.category_id;
}

- (void)getHomeInfo {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/index.php/home/index/homePage";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"HomeInfo ----%@", responseObject);
        weakSelf.homeData = (NSDictionary *)responseObject[@"data"];
        [weakSelf.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取首页轮播图数据
- (void)getScrollData {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/home/index/getSowingMap";
    NSDictionary *parme = @{@"type" : @(1)};
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"ScrollData ----%@", responseObject);
        weakSelf.scrollData = [responseObject[@"data"] firstObject][@"photo"];
        [weakSelf.collectionView reloadData];
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
