//
//  Train_HomeViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Train_HomeViewController.h"
#import "Train_MarchantInfoViewController.h"
#import "ProjectInfoViewController.h"

@interface Train_HomeViewController ()

@end

@implementation Train_HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"驾照培训";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"home" forIndexPath:indexPath];
//        cell.topImageV.image = [UIImage imageNamed:@"public"];
//        cell.bottomLabel.text = @"培训分类";
//        cell.bottomLabel.font = SetFont(12);
//        return cell;
//    }else if (indexPath.section == 1) {
//        ProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"project" forIndexPath:indexPath];
//        [cell layoutIfNeeded];
//        cell.topLeftString = self.topLeftString;
//        cell.topTextF.text = self.topText;
//        cell.topRightString = self.topRightString;
//        cell.centerLeftString = self.centerLeftString;
//        cell.centerTextF.text = self.centerText;
//        cell.centerRightString = self.centerRightString;
//        cell.bottomLeftString = self.bottomLeftString;
//        cell.bottomTextF.text = self.bottomText;
//        cell.bottomRightString = self.bottomRightString;
//        return cell;
//    }
//    return nil;
//}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        Train_MarchantInfoViewController *list = [[Train_MarchantInfoViewController alloc] init];
//        list.isWharfGoVC = self.isWharfGoVC;
//        list.categoryID = self.categoryArray[indexPath.row][@"category_id"];
//        [self.navigationController pushViewController:list animated:YES];
//    }else {
//        ProjectInfoViewController *info = [[ProjectInfoViewController alloc] init];
//        info.isWharfGoVC = self.isWharfGoVC;
////        info.merchant_id = self.merchantArray[indexPath.row][@"merchant_id"];
//        [self.navigationController pushViewController:info animated:YES];
//    }
//}

////通过顶级分类ID获取商家列表
//- (void)getProjectFromMarchant {
//    __weak typeof(self) weakSelf = self;
//    NSString *url = @"https://zbt.change-word.com/index.php/home/merchant/topCategoryMerchant";
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    NSDictionary *parme = @{@"category_id" : self.category_id};
//    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        NSLog(@"顶级分类商家  === %@", responseObject);
//        weakSelf.merchantArray = (NSArray *)responseObject[@"data"];
//        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
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
