//
//  AddCustomzationViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/11.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "AddCustomzationViewController.h"
#import "Buy_OneCollectionViewCell.h"
#import "Buy_TwoCollectionViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

#import "HXPhotoPicker.h"

@interface AddCustomzationViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HXCustomCameraViewControllerDelegate,HXAlbumListViewControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) HXPhotoManager *manager;

@property (nonatomic, strong) HXDatePhotoToolManager *tool;

@property (nonatomic, strong) NSMutableArray *imageArr;

@end

@implementation AddCustomzationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加定制";
    self.imageArr = [NSMutableArray arrayWithCapacity:1];
    [self.imageArr addObject:[UIImage imageNamed:@"imageAdd"]];
    
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[Buy_OneCollectionViewCell class] forCellWithReuseIdentifier:@"one"];
    [self.collectionView registerClass:[Buy_TwoCollectionViewCell class] forCellWithReuseIdentifier:@"two"];
    
    [self.view addSubview:self.collectionView];
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 44, 0));
    }];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.backgroundColor = [UIColor redColor];
    [self.button addTarget:self action:@selector(submitCustomDZToService) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitle:@"发布" forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.collectionView.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    [self setUpNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    }
    return self.imageArr.count >= 4 ? 4 : self.imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        Buy_OneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"one" forIndexPath:indexPath];
        cell.leftString = @[@"标题", @"联系人", @"手机号", @"地址", @"发布价格", @"内容描述"][indexPath.row];
        //        cell.TextF.leftView.alignmentRectInsets =
        return cell;
    }
    Buy_TwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"two" forIndexPath:indexPath];
    cell.isShowButton = YES;
    cell.imageV.image = self.imageArr[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(SCREENBOUNDS.width - 30, 50);
    }
    CGFloat width = (SCREENBOUNDS.width - 160) / 4;
    return CGSizeMake(width, width);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    }
    return 40.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == self.imageArr.count - 1) {
        [self hx_presentAlbumListViewControllerWithManager:self.manager delegate:self];
        
    }
}

//点击取消
- (void)albumListViewControllerDidCancel:(HXAlbumListViewController *)albumListViewController {
    [self.manager clearSelectedList];
    [self.imageArr removeAllObjects];
    [self.imageArr addObject:[UIImage imageNamed:@"imageAdd"]];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
}

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    [self.imageArr removeAllObjects];
    __weak typeof(self) weakSelf = self;
    self.tool = [[HXDatePhotoToolManager alloc] init];
    NSLog(@"+_+_+_+_+_+__tool%@", self.tool);
    [self.tool getSelectedImageList:photoList success:^(NSArray<UIImage *> *imageList) {
        weakSelf.imageArr = [imageList mutableCopy];
        [weakSelf.imageArr insertObject:[UIImage imageNamed:@"imageAdd"] atIndex:imageList.count];
        NSLog(@"+_+_+_+_+_+__%@", weakSelf.imageArr);
        NSLog(@"+_+_+_+_+_+__count%ld", weakSelf.imageArr.count);
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    } failed:^{
        
    }];
}

//懒加载相册管理类
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        //        _manager.configuration.openCamera = YES;
        _manager.configuration.maxNum = 4;
        _manager.configuration.photoMaxNum = 4;
        //        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.themeColor = [UIColor blackColor];
    }
    return _manager;
}

- (Buy_OneCollectionViewCell *)getCollectionViewCellFromIndexPath:(NSIndexPath *)indexPath {
    return (Buy_OneCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
}

- (void)submitCustomDZToService {
    NSString *serve_name = [self getCollectionViewCellFromIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].TextF.text;
    NSString *username = [self getCollectionViewCellFromIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].TextF.text;
    NSString *address = [self getCollectionViewCellFromIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]].TextF.text;
    NSString *price = [self getCollectionViewCellFromIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]].TextF.text;
    NSString *phone = [self getCollectionViewCellFromIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]].TextF.text;
    
    if ([serve_name isEqualToString:@""] || [username isEqualToString:@""] || [address isEqualToString:@""] || [price isEqualToString:@""] || [phone isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请完善信息之后提交"];
        return;
    }
    
    NSString *url = @"https://zbt.change-word.com/index.php/home/yuyue/addCustomer";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager.operationQueue cancelAllOperations];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary *parme = @{
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"serve_name" : serve_name,
                            @"username" : username,
                            @"address" : address,
                            @"price" : price,
                            @"phone" : phone,
                            @"info" : @"666666"
                            };
    
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [weakSelf.imageArr removeLastObject];
        for (UIImage *image in weakSelf.imageArr) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
            [formData appendPartWithFileData:imageData name:@"photo[]" fileName:@"image.png" mimeType:@"image/jpg/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%lld--%lld",uploadProgress.totalUnitCount, uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject === %@", responseObject);
        NSData *strData = responseObject;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"-------%@", dic);
        if ([dic[@"resultCode"] integerValue] == 1) {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"发布成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:responseObject[@"resultMsg"]];
        }
        
        [weakSelf.imageArr removeAllObjects];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"发布失败"];
        NSLog(@"error === %@", error);
        
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
