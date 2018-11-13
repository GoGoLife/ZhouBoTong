//
//  MarchantHomeViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/4.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "MarchantHomeViewController.h"
#import "BrandHeaderView.h"
#import "SecondSectionView.h"
#import "FirstBrandCollectionViewCell.h"
#import <Masonry.h>
#import "Globefile.h"
#import "PaySellBoatViewController.h"
#import "MarchantInfoViewController.h"
#import "Boat_InfoViewController.h"

@interface MarchantHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectinView;

@property (nonatomic, strong) SecondSectionView *sectionV;

@end

@implementation MarchantHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商户主页";
    // Do any additional setup after loading the view.
    [self creatUI];
    [self setUpNav];
}
setBack();
pop();

- (void)creatUI {
    BrandHeaderView *headV = [[BrandHeaderView alloc] init];
    headV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchHeader:)];
    [headV addGestureRecognizer:tap];
    [self.view addSubview:headV];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (SCREENBOUNDS.width - 60) / 2;
    layout.itemSize = CGSizeMake(width, width + 80);
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 20.0;
    layout.headerReferenceSize = CGSizeMake(SCREENBOUNDS.width, 40);
    
    self.collectinView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectinView.backgroundColor = [UIColor whiteColor];
    self.collectinView.delegate = self;
    self.collectinView.dataSource = self;
    [self.collectinView registerClass:[FirstBrandCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectinView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectinView];
    
    __weak typeof(self) weakSelf = self;
    [headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(0);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(100));
    }];
    
    [self.collectinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headV.mas_bottom).offset(10);
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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FirstBrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    if (kind == UICollectionElementKindSectionHeader) {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    [view addSubview:self.sectionV];
    return view;
//    }
}

- (SecondSectionView *)sectionV {
    if (_sectionV == nil) {
        _sectionV = [[SecondSectionView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 40) ItemNumber:3 AndTitle:@[@"销量", @"新品", @"价格"]];
    }
    return _sectionV;
}

- (void)touchHeader:(UITapGestureRecognizer *)tap {
    MarchantInfoViewController *info = [[MarchantInfoViewController alloc] init];
    [self.navigationController pushViewController:info animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    PaySellBoatViewController *paysell = [[PaySellBoatViewController alloc] init];
//    [self.navigationController pushViewController:paysell animated:YES];
    Boat_InfoViewController *info = [[Boat_InfoViewController alloc] init];
    [self.navigationController pushViewController:info animated:YES];
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
