//
//  CustomServiceViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/31.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "CustomServiceViewController.h"
#import "HomeCollectionViewCell.h"
#import "CustomCollectionViewCell.h"
#import <Masonry.h>
#import "Globefile.h"
#import "CustomSearchView.h"
#import "LoopView.h"
#import "ServiceInfoViewController.h"
#import "GoodReputationViewController.h"
#import "URLImageScroll.h"

@interface CustomServiceViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, LeaveMessageDelegate>
@property (nonatomic, strong) UISearchBar *searchView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *scrollData;

@end

@implementation CustomServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定制服务";
    // Do any additional setup after loading the view.
//    self.searchView = [[UISearchBar alloc] initWithFrame:FRAME(0, 10, SCREENBOUNDS.width, 30)];
//    self.searchView.searchBarStyle = UISearchBarStyleMinimal;
//    UITextField *searchTextF = [self.searchView valueForKey:@"searchField"];
//    searchTextF.font = SetFont(15);
//    ViewRadius(searchTextF, 22.0);
//    self.searchView.placeholder = @"可搜索各种游艇";
//    [self.view addSubview:self.searchView];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"one"];
    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"two"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.view addSubview:self.collectionView];
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self setUpNav];
    
    [self getSecondCategory];
    
    [self getScrollData_Custom];
}
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
        return 0;
    }
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"one" forIndexPath:indexPath];
        cell.topImageV.image = [UIImage imageNamed:@"public"];
        cell.bottomLabel.font = SetFont(15);
        return cell;
    }
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"two" forIndexPath:indexPath];
    cell.delegate = self;
    cell.bottomTextF.delegate = self;
    NSDictionary *dic = self.dataArray[indexPath.row];
    [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
    cell.topTextF.text = dic[@"serve_name"];
    cell.bottomTextF.text = [NSString stringWithFormat:@"¥%@", dic[@"price"]];
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (void)touchLeaveMessageButton {
    NSLog(@"leaveMessage!!!!!!!!");
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    }else {
        NSDictionary *dic = self.dataArray[indexPath.row];
        ServiceInfoViewController *info = [[ServiceInfoViewController alloc] init];
        info.service_id = [NSString stringWithFormat:@"%@", dic[@"serve_id"]];
        [self.navigationController pushViewController:info animated:YES];
//        GoodReputationViewController *good = [[GoodReputationViewController alloc] init];
//        [self.navigationController pushViewController:good animated:YES];
    }
    
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat width = (SCREENBOUNDS.width - 125) / 4;
        return CGSizeMake(width, width + 40);
    }
    return CGSizeMake(SCREENBOUNDS.width, 110.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 35.0;
    }
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 10.0;
    }
    return 0.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 200.0);
    }
    return CGSizeMake(SCREENBOUNDS.width, 0.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        if (indexPath.section == 0) {
//            LoopView *loop = [[LoopView alloc] initWithFrame:view.bounds];
//            loop.imageArray = @[@"1", @"2", @"3"];
//            [view addSubview:loop];
            URLImageScroll *scroll = [[URLImageScroll alloc] initWithFrame:view.bounds withImageArray:self.scrollData];
            [view addSubview:scroll];
        }else {
//            [self setContentV:view];
        }
        return view;
    }
    return nil;
}

//获取定制服务列表信息
- (void)getSecondCategory {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/index.php/home/service/customerList";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    NSDictionary *parame = @{@"category_id" : @"33"};
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"定制服务分类 === %@", responseObject);
        weakSelf.dataArray = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)setContentV:(UIView *)view {
    UIView *contentV = [[UIView alloc] init];
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
    gengduo.titleLabel.font = SetFont(17);
    [gengduo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gengduo setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
    [gengduo setTitle:@"更多" forState:UIControlStateNormal];
    
    [contentV addSubview:fire];
    [contentV addSubview:ershou];
    [contentV addSubview:textLabel];
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
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentV.mas_centerY);
        make.left.equalTo(ershou.mas_right).offset(10);
        make.right.equalTo(gengduo.mas_left).offset(-10);
        make.height.mas_equalTo(@(40));
    }];
}

//获取轮播图数据
- (void)getScrollData_Custom {
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
