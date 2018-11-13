//
//  SecondHandViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/25.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "SecondHandViewController.h"
#import "Globefile.h"
#import <Masonry.h>
#import "LoopView.h"
#import "CustomSearchView.h"

#import "First_usedCollectionViewCell.h"
#import "InfoCollectionViewCell.h"
//#import "MarchantHomeViewController.h"
#import "HomeCollectionViewCell.h"
#import "Boat_InfoViewController.h"
#import "InformationViewController.h"
#import "Publish_infoViewController.h"
#import "BuyViewController.h"
#import "assessmentViewController.h"
#import "SecondYachtModel.h"
#import "PersonSecondYeach_InfoViewController.h"

@interface SecondHandViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>
{
    NSArray          *firstDataArray;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIView *sellBuyView;

@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) NSInteger row1;

@property (nonatomic, assign) NSInteger row2;

@property (nonatomic, assign) NSInteger row3;

@property (nonatomic, assign) NSInteger row4;

@property (nonatomic, assign) NSInteger ship_type;

@property (nonatomic, strong) NSArray *merchantArray;

@property (nonatomic, strong) NSArray *memberArray;

@end

@implementation SecondHandViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CustomSearchView *searchView = [[CustomSearchView alloc] initWithFrame:FRAME(40, 7, SCREENBOUNDS.width - 60, 30) isShowAdd:YES];
    searchView.search.delegate = self;
    searchView.tag = 112;
    searchView.button.titleLabel.font = SetFont(12);
    [searchView.button setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"] forState:UIControlStateNormal];
    [searchView.addBtn addTarget:self action:@selector(pushSellBuyView) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:searchView];
    
    self.row = -1;
    self.row1 = -1;
    self.row2 = -1;
    self.row3 = -1;
    self.row4 = -1;
    self.ship_type = -1;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchbar");
    [searchBar resignFirstResponder];
    [self getSecondYeactInfoFromSearchString:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchText === %@", searchText);
    if ([searchText isEqualToString:@""]) {
        [searchBar resignFirstResponder];
        [self getSecondYeactInfo];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二手艇";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[First_usedCollectionViewCell class] forCellWithReuseIdentifier:@"first_used"];
    [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"info"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    
    [self.view addSubview:self.collectionView];
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    NSArray *dataArr = @[@[@"30万以下", @"30-80万", @"80-100万", @"300万以上"], @[@"8米以下", @"8-15米", @"15-28米", @"28米以上"], @[@"小艇", @"钓鱼艇", @"摩托艇", @"飞桥游艇", @"休闲艇", @"船外机", @"冲锋艇", @"公务艇"], @[@"1年", @"3年", @"3-6年", @"6年以上"], @[@"本国", @"进口", @"无三证", @"三证齐全"]];
    
    //设置二手艇分类数据
    NSMutableArray *firstArr = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index = 0; index < dataArr.count; index++) {
        NSArray *itemArr = dataArr[index];
        NSMutableArray *secondArr = [NSMutableArray arrayWithCapacity:1];
        for (NSInteger i = 0; i < itemArr.count; i++) {
            SecondYachtModel *model = [[SecondYachtModel alloc] init];
            model.textString = itemArr[i];
            model.isSelect = NO;
            model.index = i;
            [secondArr addObject:model];
        }
        [firstArr addObject:secondArr];
    }
    firstDataArray = [firstArr mutableCopy];
    
    [self setUpNav];
    
    [self getSecondYeactInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [(UIView *)[self.navigationController.navigationBar viewWithTag:112] removeFromSuperview];
}

setBack();
pop();

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 7;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 6) {
        return self.dataArray.count;
    }
    if (section == 5) {
        return 2;
    }
    return [firstDataArray[section] count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 6) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"info" forIndexPath:indexPath];
        [cell.topImageV sd_setImageWithURL:dic[@"photo"] placeholderImage:[UIImage imageNamed:@"public"]];
        cell.isNewLayout = YES;
        cell.bottomLabel.font = SetFont(12);
        
        if ([dic[@"type"] integerValue] == 1) {
            cell.bottomLabel.text = dic[@"title"];
            cell.infoLabel.text = @"个人";
        }else {
            cell.bottomLabel.text = [NSString stringWithFormat:@"%@",  dic[@"goods_name"]];
            cell.infoLabel.text = @"商家";
        }
        return cell;
    }
    if (indexPath.section == 5) {
        NSString *idenfier = [NSString stringWithFormat:@"register%ld", indexPath.row];
        [self.collectionView registerClass:[First_usedCollectionViewCell class] forCellWithReuseIdentifier:idenfier];
        First_usedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idenfier forIndexPath:indexPath];
        cell.label.text = @[@"商家", @"个人"][indexPath.row];
        return cell;
    }
    First_usedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first_used" forIndexPath:indexPath];
    SecondYachtModel *model = firstDataArray[indexPath.section][indexPath.row];
    cell.label.text = model.textString;//firstDataArray[indexPath.section][indexPath.row];
    cell.isSelect = model.isSelect;
    cell.indexPath = indexPath;
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 6) {
        CGFloat width = (SCREENBOUNDS.width - 30) / 2;
        return CGSizeMake(width, width + 40);
    }
    
    if (indexPath.section == 5) {
        CGFloat width = (SCREENBOUNDS.width - 30) / 2;
        return CGSizeMake(width, 30);
    }
    return CGSizeMake((SCREENBOUNDS.width - 50) / 4, 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 200);
    }
    if (section == 6) {
        return CGSizeMake(SCREENBOUNDS.width, 60);
    }
    return CGSizeMake(SCREENBOUNDS.width, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 5) {
        return CGSizeMake(SCREENBOUNDS.width, 10.0);
    }
    return CGSizeMake(SCREENBOUNDS.width, 0.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        for (UIView *vv in view.subviews) {
            [vv removeFromSuperview];
        }
        if (indexPath.section == 0) {
            LoopView *loop = [[LoopView alloc] initWithFrame:view.bounds];
            loop.imageArray = @[@"1", @"2", @"3", @"4",];
            [view addSubview:loop];
        }else {
            view.backgroundColor = self.view.backgroundColor;
            [self setContentV:view];
        }
        return view;
    }else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        for (UIView *vv in view.subviews) {
            [vv removeFromSuperview];
        }
        view.backgroundColor = self.view.backgroundColor;
        return view;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 6) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        if ([dic[@"type"] integerValue] == 1) {
//            Publish_infoViewController *publish = [[Publish_infoViewController alloc] init];
//            publish.buy_id = dic[@"buy_id"];
//            publish.isShowBottomView = YES;
//            publish.isShowPrice = YES;
//            [self.navigationController pushViewController:publish animated:YES];
            PersonSecondYeach_InfoViewController *person_info = [[PersonSecondYeach_InfoViewController alloc] init];
            person_info.buy_id = dic[@"buy_id"];
            person_info.type = 3;
            [self.navigationController pushViewController:person_info animated:YES];
        }else {
            Boat_InfoViewController *info = [[Boat_InfoViewController alloc] init];
            info.goods_id = dic[@"goods_id"];
            info.type = 1;
            [self.navigationController pushViewController:info animated:YES];
        }
    }else if (indexPath.section == 5){
        if (indexPath.row == 0) {
            First_usedCollectionViewCell *cell = (First_usedCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:5]];
            cell.isSelect = YES;
            self.dataArray = self.merchantArray;
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:6]];
        }else if (indexPath.row == 1) {
            First_usedCollectionViewCell *cell = (First_usedCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:5]];
            cell.isSelect = YES;
//            ViewRadius(cell.contentView, cell.contentView.bounds.size.height / 2);
//            cell.backgroundColor = SetColor(67, 165, 249, 1);
            self.dataArray = self.memberArray;
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:6]];
        }
    }else {
        if (indexPath.section == 0) {
            for (SecondYachtModel *model in firstDataArray[indexPath.section]) {
                if (model.index == indexPath.row) {
                    if (model.isSelect) {
                        model.isSelect = NO;
                        self.row = -1;
                    }else {
                        model.isSelect = YES;
                        self.row = model.index;
                    }
                } else {
                    model.isSelect = NO;
                }
            }
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }else if (indexPath.section == 1) {
            for (SecondYachtModel *model in firstDataArray[indexPath.section]) {
                if (model.index == indexPath.row) {
                    if (model.isSelect) {
                        model.isSelect = NO;
                        self.row1 = -1;
                    }else {
                        model.isSelect = YES;
                        self.row1 = model.index;
                    }
                } else {
                    model.isSelect = NO;
                }
            }
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }else if (indexPath.section == 2) {
            for (SecondYachtModel *model in firstDataArray[indexPath.section]) {
                if (model.index == indexPath.row) {
                    if (model.isSelect) {
                        model.isSelect = NO;
                        self.row2 = -1;
                    }else {
                        model.isSelect = YES;
                        self.row2 = model.index;
                    }
                } else {
                    model.isSelect = NO;
                }
            }
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
        }else if (indexPath.section == 3) {
            for (SecondYachtModel *model in firstDataArray[indexPath.section]) {
                if (model.index == indexPath.row) {
                    if (model.isSelect) {
                        model.isSelect = NO;
                        self.row3 = -1;
                    }else {
                        model.isSelect = YES;
                        self.row3 = model.index;
                    }
                } else {
                    model.isSelect = NO;
                }
            }
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:3]];
        }else if (indexPath.section == 4) {
            for (SecondYachtModel *model in firstDataArray[indexPath.section]) {
                if (model.index == indexPath.row) {
                    if (model.isSelect) {
                        model.isSelect = NO;
                        self.row4 = -1;
                    }else {
                        model.isSelect = YES;
                        self.row4 = model.index;
                    }
                } else {
                    model.isSelect = NO;
                }
            }
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:4]];
        }
        
        if (self.row2 == -1) {
            self.ship_type = -1;
        }else if (self.row2 >= 5) {
            self.ship_type = self.row2 - 1;
        }else {
            self.ship_type = self.row2;
        }
        
        //整理搜索数据
        NSDictionary *parme = @{
                                @"goods_price" : self.row == -1 ? @(-1) : @(self.row + 1),
                                @"ship_length" : self.row1 == -1 ? @(-1) : @(self.row1 + 1),
                                @"ship_type" : self.ship_type == -1 ? @(-1) : @(self.ship_type + 1),
                                @"warranty" : self.row3 == -1 ? @(-1) : @(self.row3 +  1),
                                @"certificate" : self.row4 == -1 ? @(-1) : @(self.row4 + 1)
                                };
        NSArray *dataValue = [parme allValues];
        BOOL result = false;
        for (NSString *string in dataValue) {
            result = [string intValue] == -1 ? YES : NO;
            if (result) {
                //表示全是-1
            }else {
                //表示并不是全部都是-1
                [self getSearchResult:parme];
                return;
            }
        }
        if (result) {
            [self getSecondYeactInfo];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 5) {
        if (indexPath.row == 0) {
            First_usedCollectionViewCell *cell = (First_usedCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:5]];
            cell.isSelect = NO;
        }else if (indexPath.row == 1) {
            First_usedCollectionViewCell *cell = (First_usedCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:5]];
            cell.isSelect = NO;
        }
    }
}

//获取通过分类获取的二手艇信息
- (void)getSearchResult:(NSDictionary *)parme {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/index.php/home/goods/secondScreen";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"HomeInfo ----%@", responseObject);
        weakSelf.dataArray = (NSArray *)responseObject[@"data"];//[member arrayByAddingObjectsFromArray:merchant];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:6]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}

- (void)touchFooter {
    InformationViewController *information = [[InformationViewController alloc] init];
    information.dataArr = self.consultData;
    [self.navigationController pushViewController:information animated:YES];
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
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = SetFont(15);
    textLabel.text = @"温州万豪游艇俱乐部温州万豪游艇俱乐部温州万豪游艇俱乐部";
    
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
    [contentV addSubview:textLabel];
    [contentV addSubview:gengduo];
    
    [view addSubview:contentV];
    
    [contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 0, 10, 0));
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
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentV.mas_centerY);
        make.left.equalTo(ershou.mas_right).offset(10);
        make.right.equalTo(gengduo.mas_left).offset(-10);
        make.height.mas_equalTo(@(40));
    }];
}

//获取二手艇商品列表
- (void)getSecondYeactInfo {
    NSString *url = @"https://zbt.change-word.com/index.php/home/Goods/secondHand";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"secondYeact === %@", responseObject);
        NSDictionary *dic = responseObject[@"data"];
        weakSelf.memberArray = dic[@"member"];
        weakSelf.merchantArray = dic[@"merchant"];
        weakSelf.dataArray = [weakSelf.merchantArray arrayByAddingObjectsFromArray:weakSelf.memberArray];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:6]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取二手艇商品列表  顶部搜索
- (void)getSecondYeactInfoFromSearchString:(NSString *)string {
    NSString *url = @"https://zbt.change-word.com/index.php/home/Goods/secondHand";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"key_word" : string};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"secondYeact === %@", responseObject);
        NSDictionary *dic = responseObject[@"data"];
        NSArray *member = dic[@"member"];
        NSArray *merchant = dic[@"merchant"];
        weakSelf.dataArray = [member arrayByAddingObjectsFromArray:merchant];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:6]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)hiddenView {
    [[self.view viewWithTag:111] removeFromSuperview];
}

//展示我要买   我要卖   免费评估
- (void)pushSellBuyView {
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.tag = 111;
    view.backgroundColor = [UIColor clearColor];
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
    [view addGestureRecognizer:ges];
    [self.view addSubview:view];
    self.sellBuyView = [[UIView alloc] initWithFrame:FRAME(SCREENBOUNDS.width - 240 - 20, 0, 240, 140)];
    self.sellBuyView.layer.contents = (id)[UIImage imageNamed:@"sellBuyView"].CGImage;
    [self setPrepositionView:self.sellBuyView];
    [view addSubview:self.sellBuyView];
}

//设置前置view
- (void)setPrepositionView:(UIView *)backGroundView {
    NSArray *imageNamedArr = @[@"buy_small", @"sell_small", @"pinggu_small"];
    NSArray *titleArr = @[@"我要买", @"我要卖", @"免费评估"];
    
    CGFloat width = (240 - 40) / 3;
    for (NSInteger index = 0; index < 3; ++index) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(15);
        [button setTitleColor:SetColor(58, 52, 52, 1) forState:UIControlStateNormal];
        button.tag = index + 500;
        [button setImage:[UIImage imageNamed:imageNamedArr[index]] forState:UIControlStateNormal];
        [button setTitle:titleArr[index] forState:UIControlStateNormal];
        [self initButton:button];
        [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [backGroundView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backGroundView.mas_left).offset(10 + (width + 10) * index);
            make.top.equalTo(backGroundView.mas_top).offset(30);
            make.size.mas_equalTo(CGSizeMake(width, 100));
        }];
    }
}

//将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    float  spacing = 10;//图片和文字的上下间距
    CGSize imageSize = [UIImage imageNamed:@"buy_small"].size;
    UILabel *label = [[UILabel alloc] init];
    label.text = btn.titleLabel.text;
    label.font = SetFont(15);
    label.numberOfLines = 0;
    [label sizeToFit];
    CGSize titleSize = label.bounds.size;
    //    CGSize imageSize = btn.imageView.frame.size;
    //    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
}

//买卖评估
- (void)selectButton:(UIButton *)button {
    NSInteger index = button.tag - 500;
    if (index == 0) {
        BuyViewController *buyVC = [[BuyViewController alloc] init];
        buyVC.titleString = @"我要买";
        [self.navigationController pushViewController:buyVC animated:YES];
    }else if (index == 1) {
        BuyViewController *buyVC = [[BuyViewController alloc] init];
        buyVC.titleString = @"我要卖";
        buyVC.isShowSecond = YES;
        [self.navigationController pushViewController:buyVC animated:YES];
    }else {
        assessmentViewController *assessment = [[assessmentViewController alloc] init];
        [self.navigationController pushViewController:assessment animated:YES];
    }
    [self.sellBuyView removeFromSuperview];
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
