//
//  HotYachtViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/14.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "HotYachtViewController.h"
#import "Globefile.h"
#import <Masonry.h>
#import "EquipmentInfoViewController.h"
#import "AfterService_infoViewController.h"
#import "HomeCollectionViewCell.h"
#import "Publish_infoViewController.h"
#import "Boat_InfoViewController.h"

@interface HotYachtViewController ()<ButtonDelegate>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *afterServiceArray;

@end

@implementation HotYachtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"热门艇";
    // Do any additional setup after loading the view.
    [self creatUI];
    
    [self setUpNav];
    
    if (self.isSelectWheel) {
        [self getSecondYeactInfo];
    }
    
    [self getSecondCategory_Goods];
    
    [self getServiceListWithMerchantID];
    
}
setBack();
pop();

- (void)creatUI {
    
//    UISearchBar *searchView = [[UISearchBar alloc] initWithFrame:FRAME(0, 10, SCREENBOUNDS.width, 30)];
//    searchView.searchBarStyle = UISearchBarStyleMinimal;
//    UITextField *searchTextF = [searchView valueForKey:@"searchField"];
//    searchTextF.font = SetFont(15);
//    ViewRadius(searchTextF, 22.0);
//    searchView.placeholder = @"搜索商品";
//    [self.view addSubview:searchView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[FirstBrandCollectionViewCell class] forCellWithReuseIdentifier:@"first"];
    [self.collectionView registerClass:[SecondBarndCollectionViewCell class] forCellWithReuseIdentifier:@"second"];
    [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"info"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectionView];
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(0);
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
    return self.dataArray.count ?: self.secondCategoryGoodsArray.count ?: self.serviceList.count ?: self.afterServiceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isChangeCellType) {
        SecondBarndCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
        
        return cell;
    }else {
        if (self.secondCategoryGoodsArray) {
            NSDictionary *dic = self.secondCategoryGoodsArray[indexPath.row];
            NSLog(@"_+_+_+_+_+_+_+_+__+%@", dic[@"goods_name"]);
            FirstBrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
            [cell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
            cell.topLabel.text = dic[@"goods_name"];
            cell.centerLabel.text = [NSString stringWithFormat:@"¥%@", dic[@"goods_price"]];//[NSString stringWithFormat:@"【%@】", dic[@"merchant"][@"merchant_name"]?:@"名称"];
            cell.bottomLeft.text = [NSString stringWithFormat:@"已售%@件", dic[@"sales"]];//[NSString stringWithFormat:@"¥%@", dic[@"goods_price"]];
            cell.bottomCenter.text = @"";
            cell.bottomRight.text = [NSString stringWithFormat:@"好评%@%%", dic[@"praise"]];
            return cell;
        }else if (self.dataArray) {
            NSDictionary *dic = self.dataArray[indexPath.row];
            HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"info" forIndexPath:indexPath];
            [cell.topImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
            cell.isNewLayout = YES;
            cell.bottomLabel.font = SetFont(12);

            if ([dic[@"type"] integerValue] == 1) {
                cell.bottomLabel.text = dic[@"title"];
                cell.infoLabel.text = @"个人";
            }else {
                cell.bottomLabel.text = [isNullClass(dic[@"merchant"]) isEqualToString:@""] ? @"" : dic[@"merchant"][@"merchant_name"];
                cell.infoLabel.text = @"商家";
            }
            return cell;
        }else if(self.serviceList) {
            NSDictionary *dic = self.serviceList[indexPath.row];
            FirstBrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
            cell.centerLabel.font = SetFont(12);
            [cell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
            cell.topLabel.text = dic[@"serve_name"];
            cell.centerLabel.text = [NSString stringWithFormat:@"【%@】", [isNullClass(dic[@"merchant"]) isEqualToString:@""] ? @"" : dic[@"merchant"][@"merchant_name"]];
            cell.bottomLeft.text = [NSString stringWithFormat:@"¥%@", dic[@"price"]];
            cell.bottomCenter.text = [NSString stringWithFormat:@"已售%@件", @"4"];
            cell.bottomRight.text = [NSString stringWithFormat:@"好评%d%%", arc4random() % 20 + 80];
            return cell;
        }else {
            NSDictionary *dic = self.afterServiceArray[indexPath.row];
            FirstBrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
            [cell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
            cell.topLabel.text = dic[@"serve_name"];
//            cell.centerLabel.text = [NSString stringWithFormat:@"【%@】", dic[@"merchant"][@"merchant_name"]?:@"名称"];
            cell.centerLabel.text = [NSString stringWithFormat:@"¥%@", dic[@"price"]];
            cell.bottomLeft.text = [NSString stringWithFormat:@"已售%d件", arc4random() % 50];
            cell.bottomRight.text = [NSString stringWithFormat:@"好评%d", 80 + arc4random() % 20];
            return cell;
        }
        
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isChangeCellType) {
        return CGSizeMake(SCREENBOUNDS.width - 30, 60);
    }else {
        if (self.dataArray) {
            CGFloat width = (SCREENBOUNDS.width - 30) / 2;
            return CGSizeMake(width, width + 40);
        }
        CGFloat width = (SCREENBOUNDS.width - 30) / 2;
        return CGSizeMake(width, width + 80);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (self.isChangeCellType) {
        return 0.0;
    }
    return 10.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.sectionV.hidden) {
        return CGSizeMake(SCREENBOUNDS.width, 0);
    }
    return CGSizeMake(SCREENBOUNDS.width, 60);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    [view addSubview:self.sectionV];
    return view;
}

- (void)changeCellType:(UIButton *)sender {
    UIButton *button = (UIButton *)[self.view viewWithTag:100];
    button.selected = !button.isSelected;
    if (button.selected) {
        self.isChangeCellType = YES;
        [self.collectionView reloadData];
    }else {
        self.isChangeCellType = NO;
        [self.collectionView reloadData];
    }
}

- (SectionView *)sectionV {
    if (_sectionV == nil) {
        _sectionV = [[SectionView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 60) ItemNumber:3 AndTitle:@[@"销量", @"好评", @"价格"]];
        _sectionV.delegate = self;
        _sectionV.changeBtn.hidden = YES;
        _sectionV.changeBtn.tag = 100;
        [_sectionV.changeBtn addTarget:self action:@selector(changeCellType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sectionV;
}

- (void)touchButton:(UIButton *)button withTag:(NSInteger)tag {
    //tag 从200开始
    if (self.secondCategoryGoodsArray) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.secondCategoryGoodsArray];
        if (tag == 200) { //销量
            [self sortArrayContainsDictionary:array AndConditions:@"sales"];
        }else if (tag == 201) { //好评
            [self sortArrayContainsDictionary:array AndConditions:@"praise"];
        }else {                 //价格
            [self sortArrayContainsDictionary:array AndConditions:@"goods_price"];
        }
    }
}

- (void)sortArrayContainsDictionary:(NSMutableArray *)myMutableArr AndConditions:(NSString *)key {
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:NO]];
    [myMutableArr sortUsingDescriptors:sortDescriptors];
    NSLog(@"CategoryGoods SORT === %@",myMutableArr);
    self.secondCategoryGoodsArray = [myMutableArr mutableCopy];
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"8989898080808080");
    if (self.dataArray) {
        NSLog(@"urowejflksajfijasf");
        NSDictionary *dic = self.dataArray[indexPath.row];
        if ([dic[@"type"] integerValue] == 1) {
            Publish_infoViewController *publish = [[Publish_infoViewController alloc] init];
            publish.buy_id = dic[@"buy_id"];
            publish.isShowBottomView = YES;
            publish.isShowPrice = YES;
            [self.navigationController pushViewController:publish animated:YES];
        }else {
            Boat_InfoViewController *info = [[Boat_InfoViewController alloc] init];
            info.goods_id = dic[@"goods_id"];
            [self.navigationController pushViewController:info animated:YES];
        }
    }else if (self.afterServiceArray.count > 0) {
        NSLog(@"23232323232423eewr");
        NSLog(@"--=-=-=---= %@", self.afterServiceArray[indexPath.row][@"serve_id"]);
        AfterService_infoViewController *info = [[AfterService_infoViewController alloc] init];
        info.after_id = [NSString stringWithFormat:@"%@", self.afterServiceArray[indexPath.row][@"serve_id"]];
        [self.navigationController pushViewController:info animated:YES];
    }else if (self.secondCategoryGoodsArray) {
        EquipmentInfoViewController *info = [[EquipmentInfoViewController alloc] init];
        info.goods_id = self.secondCategoryGoodsArray[indexPath.row][@"goods_id"];
        [self.navigationController pushViewController:info animated:YES];
    }
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
        NSArray *member = dic[@"member"];
        NSArray *merchant = dic[@"merchant"];
        weakSelf.dataArray = [merchant arrayByAddingObjectsFromArray:member];
        weakSelf.title = @"二手艇列表";
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)getSecondCategory_Goods {
    NSLog(@"secondId === %@", self.secondCategory_id);
    if (!self.secondCategory_id) {
        return;
    }
    NSString *url = @"https://zbt.change-word.com/home/goods/goodsList";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"category_id" : self.secondCategory_id};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"secondYeact+_+_+_+_+_+_+_+_+_ === %@", responseObject);
//        NSDictionary *dic = responseObject[@"data"];
//        NSArray *member = dic[@"member"];
//        NSArray *merchant = dic[@"merchant"];
//        weakSelf.serviceList = [member arrayByAddingObjectsFromArray:merchant];
//        weakSelf.title = @"二手艇列表";
//        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        weakSelf.secondCategoryGoodsArray = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)getServiceListWithMerchantID {
    if (!self.merchant_id) {
        return;
    }
    NSString *url = @"https://zbt.change-word.com/index.php/home/service/merchantAfterList";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"merchant_id" : self.merchant_id};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"afterServiceList+_+_+_+_+_+_+_+_+_ === %@", responseObject);
        weakSelf.afterServiceArray = (NSArray *)responseObject[@"data"];
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
