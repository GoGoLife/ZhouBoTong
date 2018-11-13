//
//  RightViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/9.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "RightViewController.h"
#import <Masonry.h>
#import "Globefile.h"
#import "Classify_ListViewController.h"

@interface RightViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) NSArray *dataArray;

//CollectionView     Header
@property (nonatomic, strong) UILabel *headerLabel;

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view = [[UIView alloc] initWithFrame:FRAME(SCREENBOUNDS.width / 3, 0, SCREENBOUNDS.width / 3 * 2, self.view.bounds.size.height)];
    
    self.view = [[UIView alloc] initWithFrame:FRAME(self.view.bounds.size.width / 3, 0, self.view.bounds.size.width / 3 * 2, self.view.bounds.size.height)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (SCREENBOUNDS.width / 3 * 2 - 70) / 2;
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 30);
    layout.itemSize = CGSizeMake(width - 1, 30);
    layout.minimumInteritemSpacing = 20;
    layout.minimumLineSpacing = 10.0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.view addSubview:self.collectionView];
    
    CGFloat height = 0.0;
    if (IS_IPHONE_X) {
        height =  self.view.bounds.size.height - 96 - 50 - 20;
    }else {
        height = self.view.bounds.size.height - 64 - 50 - 20;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(height));
    }];
    
//    self.dataArray = @[@[@"运动艇", @"工作艇", @"游钓艇", @"帆艇", @"手划艇", @"充气艇", @"公务艇"],
//                  @[@"防汛救援类", @"旅游观光类", @"钓鱼娱乐类", @"公务执法类"],
//                  @[@"观光艇", @"钓鱼艇", @"公务艇", @"冲锋舟", @"游艇", @"快艇", @"休闲艇"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    if (section == 0 || section == 2) {
//        return 7;
//    }
//    return 4;
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
    ViewRadius(label, label.bounds.size.height / 2);
    label.backgroundColor = SetColor(204, 204, 204, 1);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = SetFont(12);
    label.text = self.dataArray[indexPath.row][@"category_name"];
    [cell.contentView addSubview:label];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.bounds.size.width, 44);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    for (UIView *view1 in view.subviews) {
        [view1 removeFromSuperview];
    }
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = SetFont(14);
    label.textColor = SetColor(180, 180, 180, 1);
    label.text = [isNullClass(self.category_name) stringByAppendingString:@"分类"];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SetColor(180, 180, 180, 1);
    
    [view addSubview:label];
    [view addSubview:line];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 1, 0));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.left.equalTo(label.mas_left);
        make.right.equalTo(label.mas_right);
        make.height.mas_equalTo(@(1));
    }];
    
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Classify_ListViewController *list = [[Classify_ListViewController alloc] init];
    list.secondCategory_id = self.dataArray[indexPath.row][@"category_id"];
    list.title = self.dataArray[indexPath.row][@"category_name"];
    [self.navigationController pushViewController:list animated:YES];
}

- (void)getSecondCategoryFromTopCategory:(NSString *)category_id {
    if (!category_id) {
        return;
    }
    NSString *url = @"https://zbt.change-word.com/home/goods/getSecond";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"category_id" : category_id};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"secondResponse === %@", responseObject);
//        weakSelf.topArray = (NSArray *)responseObject[@"data"];
//        [weakSelf.tableView reloadData];
        weakSelf.dataArray = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark ----
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
