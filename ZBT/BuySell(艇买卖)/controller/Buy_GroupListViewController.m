//
//  Buy_GroupListViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/27.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Buy_GroupListViewController.h"
#import "GroupBuy_infoViewController.h"
#import "Globefile.h"

@interface Buy_GroupListViewController ()

@property (nonatomic, strong) NSArray *groupListArray;

@end

@implementation Buy_GroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团购列表";
    self.sectionV.hidden = YES;
    // Do any additional setup after loading the view.
    [self getGroupInfoList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.groupListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isChangeCellType) {
        SecondBarndCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
        return cell;
    }else {
        NSDictionary *dic = self.groupListArray[indexPath.row];
        NSString *date = [NSString stringWithFormat:@"时间: %@至%@", dic[@"start_time"], dic[@"end_time"]];
        FirstBrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
        cell.centerLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.centerLabel.numberOfLines = 0;
        cell.centerLabel.textColor = [UIColor blackColor];
        cell.centerLabel.font = SetFont(12);
        cell.bottomLeft.textColor = [UIColor redColor];
        cell.bottomLeft.font = SetFont(17);
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
        cell.topLabel.text = dic[@"group_name"];
        cell.centerLabel.text = date;
        cell.bottomLeft.text = [NSString stringWithFormat:@"¥%@", dic[@"group_price"]];
        cell.bottomCenter.text = @"";
        cell.bottomRight.text = [NSString stringWithFormat:@"团购数量:%@", dic[@"group_number"]];
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREENBOUNDS.width, 0.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GroupBuy_infoViewController *info = [[GroupBuy_infoViewController alloc] init];
    info.group_id = self.groupListArray[indexPath.row][@"group_id"];
    [self.navigationController pushViewController:info animated:YES];
}

//获取团购信息
- (void)getGroupInfoList {
    NSString *url = @"https://zbt.change-word.com/home/group/groupList";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"groupList === %@", responseObject);
        weakSelf.groupListArray = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"groupList error === %@", error);
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
