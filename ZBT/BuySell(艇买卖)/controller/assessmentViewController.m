//
//  assessmentViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/29.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "assessmentViewController.h"
#import "Buy_OneCollectionViewCell.h"
#import "Buy_TwoCollectionViewCell.h"
#import "Globefile.h"
#import "HXPhotoPicker.h"

@interface assessmentViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HXAlbumListViewControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) HXPhotoManager *imageManager;

//图片获取
@property (nonatomic, strong) HXDatePhotoToolManager *ttoolManager;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) UITextView *textV;

@end

@implementation assessmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArray = [NSMutableArray arrayWithCapacity:1];
    [self.imageArray addObject:[UIImage imageNamed:@"imageAdd"]];
    self.title = @"评估";
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[Buy_OneCollectionViewCell class] forCellWithReuseIdentifier:@"one"];
    [self.collectionView registerClass:[Buy_TwoCollectionViewCell class] forCellWithReuseIdentifier:@"two"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    //备注
    UILabel *remarkLabel = [[UILabel alloc] init];
    remarkLabel.backgroundColor = [UIColor whiteColor];
    remarkLabel.font = SetFont(15);
    remarkLabel.textColor = SetColor(164, 164, 164, 1);
    remarkLabel.textAlignment = NSTextAlignmentCenter;
    remarkLabel.text = @"您的爱艇每天约贬值0.03%";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"开始评估" forState:UIControlStateNormal];
    button.backgroundColor = SetColor(24, 147, 220, 1);
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:remarkLabel];
    [self.view addSubview:button];
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 75, 0));
    }];
    
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.collectionView.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(30));
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkLabel.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(45));
    }];
    
    [self setUpNav];
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
    if (section == 1) {
        return self.imageArray.count <= 8 ? self.imageArray.count : 8;
    }
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        Buy_OneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"one" forIndexPath:indexPath];
        cell.leftString = @[@"卖艇地点", @"类型", @"购买时间", @"发动机使用时间", @"接收手机"][indexPath.row];
        cell.TextF.placeholder = @[@"请输入卖艇地点", @"请输入", @"请输入购买日期", @"请输入", @"请输入手机号"][indexPath.row];
        return cell;
    }
    Buy_TwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"two" forIndexPath:indexPath];
    cell.isShowButton = YES;
    cell.imageV.image = self.imageArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 50);
    }
    CGFloat cellSize = (SCREENBOUNDS.width - 160) / 4;
    return CGSizeMake(cellSize, cellSize);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 1.0;
    }
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    }
    return 40.0;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(0, 20, 10, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(SCREENBOUNDS.width, 50);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 80);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        UILabel *lable = [[UILabel alloc] init];
        lable.text = @"上传图片";
        [view addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 20, 0, 20));
        }];
        return view;
    }
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    view.backgroundColor = self.view.backgroundColor;
    self.textV = [[UITextView alloc] init];
    self.textV.backgroundColor = [UIColor whiteColor];
    self.textV.font = SetFont(13);
    self.textV.textColor = SetColor(170, 170, 170, 1);
    self.textV.text = @"卖艇意向:描述100字以内";
    [view addSubview:self.textV];
    [self.textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self hx_presentAlbumListViewControllerWithManager:self.imageManager delegate:self];
    }
}

//点击取消
- (void)albumListViewControllerDidCancel:(HXAlbumListViewController *)albumListViewController {
    [self.imageManager clearSelectedList];
    [self.imageArray removeAllObjects];
    [self.imageArray addObject:[UIImage imageNamed:@"imageAdd"]];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
}

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    if (photoList.count > 0) {
        [self.imageArray removeAllObjects];
        __weak typeof(self) weakSelf = self;
        self.ttoolManager = [[HXDatePhotoToolManager alloc] init];
        [self.ttoolManager getSelectedImageList:photoList success:^(NSArray<UIImage *> *imageList) {
            weakSelf.imageArray = [imageList mutableCopy];
            [weakSelf.imageArray insertObject:[UIImage imageNamed:@"imageAdd"] atIndex:imageList.count];
            NSLog(@"============== %@", weakSelf.imageArray);
            [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        } failed:^{
            NSLog(@"errorerrorerror");
        }];
    }
}

- (void)submitInfo_service {
    [self.imageArray removeLastObject];
    NSString *address = [self getCellFromCollection:[NSIndexPath indexPathForRow:0 inSection:0]].TextF.text;
    NSString *buy_time = [self getCellFromCollection:[NSIndexPath indexPathForRow:2 inSection:0]].TextF.text;
    NSString *engine_user_time = [self getCellFromCollection:[NSIndexPath indexPathForRow:3 inSection:0]].TextF.text;
    NSString *phone = [self getCellFromCollection:[NSIndexPath indexPathForRow:4 inSection:0]].TextF.text;
    NSString *info = self.textV.text;
    NSString *type = [self getCellFromCollection:[NSIndexPath indexPathForRow:1 inSection:0]].TextF.text;
    
    if ([address isEqualToString:@""] || address == nil) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入卖艇地点"];
        return;
    }else if ([buy_time isEqualToString:@""] || buy_time == nil) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入购买时间"];
        return;
    }else if ([engine_user_time isEqualToString:@""] || engine_user_time == nil) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入发动机使用时间"];
        return;
    }else if ([phone isEqualToString:@""] || phone == nil) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入接收手机"];
        return;
    }else if ([info isEqualToString:@""] || info == nil) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入描述信息"];
        return;
    }else if ([type isEqualToString:@""] || type == nil) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入类型"];
        return;
    }else if (self.imageArray.count == 0) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请选择至少两张图片"];
        return;
    }
    
    [self show];
    NSString *url = @"https://zbt.change-word.com/index.php/home/join/releaseAssess";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager.operationQueue cancelAllOperations];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary *parme = @{
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"address" : address,//[self getCellFromCollection:[NSIndexPath indexPathForRow:0 inSection:0]].TextF.text,
                            @"buy_time" : buy_time,//[self getCellFromCollection:[NSIndexPath indexPathForRow:2 inSection:0]].TextF.text,
                            @"engine_user_time" : engine_user_time,//[self getCellFromCollection:[NSIndexPath indexPathForRow:3 inSection:0]].TextF.text,
                            @"phone" : phone,//[self getCellFromCollection:[NSIndexPath indexPathForRow:4 inSection:0]].TextF.text,
                            @"info" : info,//self.textV.text,
                            @"type" : type//[self getCellFromCollection:[NSIndexPath indexPathForRow:1 inSection:0]].TextF.text
                            };
    
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //        [weakSelf.imageArray removeLastObject];
        for (UIImage *image in weakSelf.imageArray) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
            [formData appendPartWithFileData:imageData name:@"photo[]" fileName:@"image.png" mimeType:@"image/jpg/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%lld--%lld",uploadProgress.totalUnitCount, uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject === %@", responseObject);
        [weakSelf hidden];
        [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"上传完成"];
        [weakSelf.imageArray removeAllObjects];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error === %@", error);
        
    }];
}

- (Buy_OneCollectionViewCell *)getCellFromCollection:(NSIndexPath *)indexPath {
    return (Buy_OneCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
}

//懒加载相册管理类
- (HXPhotoManager *)imageManager {
    if (_imageManager == nil) {
        _imageManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _imageManager.configuration.openCamera = NO;
        _imageManager.configuration.maxNum = 8;
        _imageManager.configuration.photoMaxNum = 8;
        _imageManager.configuration.saveSystemAblum = NO;
        _imageManager.configuration.themeColor = [UIColor blackColor];
    }
    return _imageManager;
}

@end
