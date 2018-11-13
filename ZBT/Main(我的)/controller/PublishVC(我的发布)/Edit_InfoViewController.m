//
//  Edit_InfoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/8/28.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Edit_InfoViewController.h"
#import "Buy_OneCollectionViewCell.h"
#import "Buy_TwoCollectionViewCell.h"
#import "Globefile.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>
#import "HXPhotoPicker.h"

@interface Edit_InfoViewController ()<HXAlbumListViewControllerDelegate, UITextFieldDelegate>
{
    NSString *title;
    NSString *area;
    NSString *addressInfo;
    NSString *address;
    NSString *contacts;
    NSString *phone;
    NSString *price;
    NSString *info;
}

@property (nonatomic, strong) UITextField *label;

@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) HXPhotoManager *imageManager;

@property (nonatomic, strong) HXPhotoManager *videoManager;

//图片获取
@property (nonatomic, strong) HXDatePhotoToolManager *ttoolManager;

//视频获取
@property (nonatomic, strong) HXDatePhotoToolManager *videoTool;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSData *videoData;

@property (nonatomic, assign) BOOL isChooseNewImage;

@end

@implementation Edit_InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑";
    if ([self.dataDic[@"photo"] count] <= 0) {
        self.imageArray = [NSMutableArray arrayWithCapacity:1];
        [self.imageArray addObject:[UIImage imageNamed:@"imageAdd"]];
    }else {
        self.imageArray = [NSMutableArray arrayWithArray:self.dataDic[@"photo"]];
    }
    
//    [self.imageArray addObject:[UIImage imageNamed:@"imageAdd"]];
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[Buy_OneCollectionViewCell class] forCellWithReuseIdentifier:@"one"];
    [self.collectionView registerClass:[Buy_TwoCollectionViewCell class] forCellWithReuseIdentifier:@"two"];
    [self.collectionView registerClass:[Buy_TwoCollectionViewCell class] forCellWithReuseIdentifier:@"three"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitBtn setBackgroundColor:[UIColor blueColor]];
    [self.submitBtn addTarget:self action:@selector(submitInfo) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.submitBtn];
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 44, 0));
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(weakSelf.collectionView.mas_bottom);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    [self setUpNav];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.publish_type == 1) {
            return 5;
        }else {
            return 6;
        }
    }else if (section == 1) {
        return self.imageArray.count;
    }else {
        return 1;
    }
}

- (UITextField *)label {
    if (_label == nil) {
        _label = [[UITextField alloc] init];
    }
    return _label;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 4) {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
            [cell.contentView addSubview:self.label];
            _label.font = SetFont(14);
            [_label setText:isNullClass(self.dataDic[@"info"])];
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
            }];
            return cell;
        }else {
            Buy_OneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"one" forIndexPath:indexPath];
            cell.TextF.enabled = YES;
            cell.TextF.delegate = self;
            cell.TextF.tag = indexPath.row;
            cell.leftString = @[@"标题", @"联系人", @"手机号", @"详细地址", @"", @"价格"][indexPath.row];
            cell.TextF.text = @[isNullClass(self.dataDic[@"title"]),
                                isNullClass(self.dataDic[@"contacts"]),
                                isNullClass(self.dataDic[@"phone"]),
                                isNullClass(self.dataDic[@"address"]),
                                isNullClass(self.dataDic[@"info"]),
                                isNullClass(self.dataDic[@"price"])][indexPath.row];
            return cell;
        }
    }else {
        if (indexPath.section == 1) {
            Buy_TwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"two" forIndexPath:indexPath];
            cell.isShowButton = YES;
            if (self.imageArray.count > 0) {
                if (self.isChooseNewImage) {
                    cell.imageV.image = self.imageArray[indexPath.row];
                }else {
                    if ([self.dataDic[@"photo"] count] <= 0 ) {
                        cell.imageV.image = self.imageArray[indexPath.row];
                    }else {
                        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.imageArray[indexPath.row]]];
                    }
                }
            }else {
                cell.imageV.image = [UIImage imageNamed:@"imageAdd"];
            }
            return cell;
        }else if (indexPath.section == 2) {
            Buy_TwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"three" forIndexPath:indexPath];
            cell.isShowButton = YES;
            UIImage *videoImage;
            if (![isNullClass(self.dataDic[@"video"]) isEqualToString:@""]) {
                videoImage = [self getVideoPreViewImage:[NSURL URLWithString:self.dataDic[@"video"]]];
            }else {
                videoImage = [UIImage imageNamed:@"imageAdd"];
            }
            cell.imageV.image = videoImage;
            return cell;
        }
    }
    return nil;
}

//获取video的第一帧
- (UIImage*) getVideoPreViewImage:(NSURL *)videoPath {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    gen.requestedTimeToleranceAfter = kCMTimeZero;
    gen.requestedTimeToleranceBefore = kCMTimeZero;
    CMTime time = CMTimeMakeWithSeconds(1.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return img;
}

StringHeight();
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 4) {
            CGFloat height = [self calculateRowHeight:isNullClass(self.dataDic[@"info"]) fontSize:14 withWidth:SCREENBOUNDS.width - 30];
            return CGSizeMake(SCREENBOUNDS.width - 30, height);
        }
        return CGSizeMake(SCREENBOUNDS.width - 30, 60);
    }
    CGFloat cellSize = (SCREENBOUNDS.width - 160) / 4;
    return CGSizeMake(cellSize, cellSize);
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
    if (section == 0) {
        return UIEdgeInsetsMake(10, 15, 10, 15);
    }
    return UIEdgeInsetsMake(10, 20, 10, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(SCREENBOUNDS.width, 50);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    view.backgroundColor = [UIColor whiteColor];
    for (UIView *vv in view.subviews) {
        [vv removeFromSuperview];
    }
    UILabel *label = [[UILabel alloc] init];
    //    label.text = @[@"图片", @"视频(不超过10S)"][indexPath.section + 1];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, 0));
    }];
    if (indexPath.section == 1) {
        label.text =  @"图片";
    }else {
        label.text = @"视频(不超过10S)";
    }
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self hx_presentAlbumListViewControllerWithManager:self.imageManager delegate:self];
    }else if (indexPath.section == 2) {
        [self hx_presentAlbumListViewControllerWithManager:self.videoManager delegate:self];
    }
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

- (HXPhotoManager *)videoManager {
    if (_videoManager == nil) {
        _videoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypeVideo];
        _videoManager.configuration.openCamera = NO;
        _videoManager.configuration.maxNum = 1;
        _videoManager.configuration.videoMaxNum = 1;
        _videoManager.configuration.saveSystemAblum = NO;
        _videoManager.configuration.videoMaxDuration = 10.f;
        _videoManager.configuration.themeColor = [UIColor blackColor];
    }
    return _videoManager;
}

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    __weak typeof(self) weakSelf = self;
    if (photoList.count > 0) {
        self.isChooseNewImage = YES;
        [self.imageArray removeAllObjects];
        self.ttoolManager = [[HXDatePhotoToolManager alloc] init];
        [self.ttoolManager getSelectedImageList:photoList success:^(NSArray<UIImage *> *imageList) {
            weakSelf.imageArray = [imageList mutableCopy];
            NSLog(@"============== %@", weakSelf.imageArray);
            [weakSelf.collectionView reloadData];
        } failed:^{
            NSLog(@"errorerrorerror");
        }];
    }
    
    if (videoList.count > 0) {
        // 通个这个方法将视频压缩写入临时目录获取视频URL  或者 通过这个获取视频在手机里的原路径 model.fileURL  可自己压缩
        [weakSelf.view showLoadingHUDText:@"视频写入中"];
        self.videoTool = [[HXDatePhotoToolManager alloc] init];
        [self.videoTool writeSelectModelListToTempPathWithList:videoList success:^(NSArray<NSURL *> *allURL, NSArray<NSURL *> *photoURL, NSArray<NSURL *> *videoURL) {
            NSSLog(@"videoURL == %@",videoURL);
            UIImage *videoImage = [self getVideoPreViewImage:videoURL.firstObject];
            [weakSelf getTwoCellFromCollection:[NSIndexPath indexPathForRow:0 inSection:2]].imageV.image = videoImage;
            weakSelf.videoData = [NSData dataWithContentsOfURL:videoURL.firstObject];
            [weakSelf.view handleLoading];
        } failed:^{
            [weakSelf.view handleLoading];
            [weakSelf.view showImageHUDText:@"写入失败"];
            NSSLog(@"写入失败");
        }];
        NSSLog(@"%ld个视频",videoList.count);
    }
}

///压缩图片
- (NSData *)imageCompressToData:(UIImage *)image{
    NSData *data=UIImageJPEGRepresentation(image, 1.0);
    if (data.length>300*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(image, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(image, 0.5);
        }else if (data.length>300*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(image, 0.9);
        }
    }
    return data;
}

- (Buy_TwoCollectionViewCell *)getTwoCellFromCollection:(NSIndexPath *)indexPath {
    return (Buy_TwoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 0:
        {
            title = textField.text;
        }
            break;
        case 1:
        {
            contacts = textField.text;
        }
            break;
        case 2:
        {
            phone = textField.text;
        }
            break;
        case 3:
        {
            address = textField.text;
        }
            break;
        default:
            break;
    }
}

- (void)submitInfo {
    if (self.dataDic[@"sell_id"]) {
        [self submitInfo_buy];
    }else {
        [self submitInfo_sell];
    }
}

//编辑我要买信息
- (void)submitInfo_buy {
    title = title == nil ? self.dataDic[@"title"] : title;
    contacts = contacts == nil ? self.dataDic[@"contacts"] : contacts;
    phone = phone == nil ? self.dataDic[@"phone"] : phone;
    address = address == nil ? self.dataDic[@"address"] : address;
    info = self.label.text;
    NSString *price = ((Buy_OneCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]]).TextF.text;
    NSLog(@"title === %@", title );
    NSLog(@"contacts === %@", contacts );
    NSLog(@"phone === %@", phone );
    NSLog(@"address === %@", address );
    NSLog(@"info === %@", info );
    NSLog(@"price === %@", price );
    
    //买
    if ([title isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入标题"];
        return;
    }else if ([address isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入详细地址"];
        return;
    }else if ([contacts isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入联系人"];
        return;
    }else if ([phone isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入联系电话"];
        return;
    }
    [self show];
    NSString *url = @"https://zbt.change-word.com/index.php/home/goods/editSell";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager.operationQueue cancelAllOperations];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    NSDictionary *parme = @{
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"title" : title,
                            @"address" : address,
                            @"contacts" : contacts,
                            @"phone" : phone,
                            @"info" : info,
                            @"sell_id" : self.dataDic[@"sell_id"]
                            };
    NSLog(@"parme === %@", parme);
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (weakSelf.isChooseNewImage) {
//            [weakSelf.imageArray removeLastObject];
            for (UIImage *image in weakSelf.imageArray) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
                NSLog(@"data ==== %@", imageData);
                [formData appendPartWithFileData:imageData name:@"photo[]" fileName:@"image.png" mimeType:@"image/jpg/png"];
            }
        }

        if (weakSelf.videoData) {
            [formData appendPartWithFileData:weakSelf.videoData name:@"video[]" fileName:@"public.mp4" mimeType:@"video/*"];
        }

        NSLog(@"formData === %@", formData);
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%lld--%lld",uploadProgress.totalUnitCount, uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject === %@", responseObject);
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"string string string === %@", string);
        [weakSelf hidden];
        [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"上传完成"];
        [weakSelf.imageArray removeAllObjects];
        //清空已经上传到视频文件
        NSString *filePath = NSTemporaryDirectory();
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL result = [fileManager removeItemAtPath:filePath error:nil];
        NSLog(@"result === %d", result);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"error === %@", error);

    }];
}

//我要卖
- (void)submitInfo_sell {
    title = title == nil ? self.dataDic[@"title"] : title;
    contacts = contacts == nil ? self.dataDic[@"contacts"] : contacts;
    phone = phone == nil ? self.dataDic[@"phone"] : phone;
    address = address == nil ? self.dataDic[@"address"] : address;
    info = self.label.text;
    NSString *price = ((Buy_OneCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]]).TextF.text;
    NSLog(@"title === %@", title );
    NSLog(@"contacts === %@", contacts );
    NSLog(@"phone === %@", phone );
    NSLog(@"address === %@", address );
    NSLog(@"info === %@", info );
    NSLog(@"price === %@", price );
    
    if ([title isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入标题"];
        return;
    }else if ([address isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入地址"];
        return;
    }else if ([contacts isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入联系人"];
        return;
    }else if ([phone isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入联系电话"];
        return;
    }else if ([price isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入价格"];
        return;
    }
    
    NSLog(@"title == %@", title);
    NSLog(@"title == %@", area);
    NSLog(@"title == %@", addressInfo);
    NSLog(@"title == %@", contacts);
    NSLog(@"title == %@", phone);
    NSLog(@"title == %@", price);
    [self show];
    NSString *url = @"https://zbt.change-word.com/home/goods/editBuy";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager.operationQueue cancelAllOperations];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *parme = @{
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"title" : title,
                            @"address" : address,
                            @"contacts" : contacts,
                            @"phone" : phone,
                            @"price" : price,
                            @"info" : info,
                            @"buy_id" : self.dataDic[@"buy_id"]
                            };
    
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (weakSelf.isChooseNewImage) {
            [weakSelf.imageArray removeLastObject];
            for (UIImage *image in weakSelf.imageArray) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
                [formData appendPartWithFileData:imageData name:@"photo[]" fileName:@"image.png" mimeType:@"image/jpg/png"];
            }
        }
        if (weakSelf.videoData) {
            [formData appendPartWithFileData:weakSelf.videoData name:@"video[]" fileName:@"public.mp4" mimeType:@"video/*"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%lld--%lld",uploadProgress.totalUnitCount, uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject === %@", responseObject);
        [weakSelf hidden];
        [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"上传完成"];
        [weakSelf.imageArray removeAllObjects];
        //清空已经上传到视频文件
        NSString *string = NSTemporaryDirectory();
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL result = [fileManager removeItemAtPath:string error:nil];
        NSLog(@"result === %d", result);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error === %@", error);
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
