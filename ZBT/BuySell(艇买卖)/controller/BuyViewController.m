//
//  BuyViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/29.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BuyViewController.h"
#import "Globefile.h"
#import "HXPhotoPicker.h"
#import "ShowHUDView.h"
#import <MBProgressHUD.h>

@interface BuyViewController ()<UICollectionViewDelegateFlowLayout, HXAlbumListViewControllerDelegate, UITextFieldDelegate>
{
    MBProgressHUD *_hud;
    NSString *title;
    NSString *area;
    NSString *addressInfo;
    NSString *contacts;
    NSString *phone;
    NSString *price;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) HXPhotoManager *imageManager;

@property (nonatomic, strong) HXPhotoManager *videoManager;

//图片获取
@property (nonatomic, strong) HXDatePhotoToolManager *ttoolManager;

//视频获取
@property (nonatomic, strong) HXDatePhotoToolManager *videoTool;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSData *videoData;

@end

@implementation BuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArray = [NSMutableArray arrayWithCapacity:1];
    [self.imageArray addObject:[UIImage imageNamed:@"imageAdd"]];
    self.title = self.titleString;
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[Buy_TwoCollectionViewCell class] forCellWithReuseIdentifier:@"twoCell"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    //备注
    UILabel *remarkLabel = [[UILabel alloc] init];
    remarkLabel.backgroundColor = [UIColor whiteColor];
    remarkLabel.font = SetFont(11);
    remarkLabel.textColor = SetColor(164, 164, 164, 1);
    remarkLabel.textAlignment = NSTextAlignmentCenter;
    remarkLabel.text = @"注：个人信息即将锁定，只需填写一次";
    
    //    UISegmentedControl *ment = [[UISegmentedControl alloc] initWithItems:@[@"保存", @"发布"]];
    //    ment.backgroundColor = SetColor(24, 147, 220, 1);
    //    [ment setTintColor:[UIColor whiteColor]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = SetColor(24, 147, 220, 1);
    [button addTarget:self action:@selector(submitInfo_service) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"发布" forState:UIControlStateNormal];
    
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
        make.left.equalTo(remarkLabel.mas_left);
        make.right.equalTo(remarkLabel.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    [self setUpNav];
    
    NSLog(@"defaultAddress == %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAddress"]);
}
setBack();
pop();

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.isShowSecond) {
        return 4;
    }
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isShowSecond) {
        switch (section) {
            case 0:
                return 5;
                break;
            case 1:
                return 1;
                break;
            case 2:
                return self.imageArray.count <= 8 ? self.imageArray.count : 8;
                break;
            case 3:
                return 1;
                break;
                
            default:
                return 0;
                break;
        }
    }else {
        switch (section) {
            case 0:
                return 5;
                break;
            case 1:
                return self.imageArray.count <= 8 ? self.imageArray.count : 8;
                break;
            case 2:
                return 1;
                break;
                
            default:
                return 0;
                break;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *identifier=[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
        [self.collectionView registerClass:[Buy_OneCollectionViewCell class] forCellWithReuseIdentifier:identifier];
        Buy_OneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.TextF.delegate = self;
        cell.TextF.tag = indexPath.row;
        cell.leftString = @[@"标题", @"联系人", @"手机号", @"区域", @"详细地址"][indexPath.row];
        NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"sell_name"]  == nil ? @"请输入联系人" : [[NSUserDefaults standardUserDefaults] objectForKey:@"sell_name"];
        NSString *phone1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"sell_phone"] == nil ? @"请输入手机号" : [[NSUserDefaults standardUserDefaults] objectForKey:@"sell_phone"];
        cell.TextF.placeholder = @[@"请输入标题", name, phone1, @"请输入区域", @"请输入详细地址"][indexPath.row];
        if (indexPath.row == 1) {
            if (![name isEqualToString:@"请输入联系人"]) {
                cell.TextF.text = name;
                contacts = name;
            }
        }else if (indexPath.row == 2) {
            if (![phone1 isEqualToString:@"请输入手机号"]) {
                cell.TextF.text = phone1;
                phone = phone1;
            }
        }else if (indexPath.row == 3) {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAddress"] != nil) {
                NSString *address = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAddress"];
                NSArray *array = [address componentsSeparatedByString:@"-"];
                cell.TextF.text = [array firstObject];
                area = [array firstObject];
            }
        }else if (indexPath.row == 4) {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAddress"] != nil) {
                NSString *address = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAddress"];
                NSArray *array = [address componentsSeparatedByString:@"-"];
                cell.TextF.text = [array lastObject];
                addressInfo = [array lastObject];
            }
        }
        
        
        return cell;
    }
    if (self.isShowSecond && indexPath.section == 1) {
        NSString *identifier=[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
        [self.collectionView registerClass:[Buy_OneCollectionViewCell class] forCellWithReuseIdentifier:identifier];
        Buy_OneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.TextF.keyboardType = UIKeyboardTypeNumberPad;
        cell.leftString = @"价格";
        cell.TextF.placeholder = @"输入价格";
        return cell;
    }
    Buy_TwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"twoCell" forIndexPath:indexPath];
    cell.isShowButton = YES;
    if (self.isShowSecond) {
        if (indexPath.section == 2) {     //有价格的界面    图片section
            cell.imageV.image = self.imageArray[indexPath.row];
        }else if (indexPath.section == 3) {   //视频section
            cell.imageV.image = [UIImage imageNamed:@"imageAdd"];
        }
    }else {
        if (indexPath.section == 1) {   //没有价格的界面    图片section
            cell.imageV.image = self.imageArray[indexPath.row];
        }else if (indexPath.section == 2) {   //视频section
            cell.imageV.image = [UIImage imageNamed:@"imageAdd"];
        }
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 1, 0);
    }
    if (self.isShowSecond && section == 1) {
        return UIEdgeInsetsMake(0, 0, 1, 0);
    }
    return UIEdgeInsetsMake(10, 20, 10, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 50);
    }
    if (self.isShowSecond && indexPath.section == 1) {
        return CGSizeMake(SCREENBOUNDS.width, 50);
    }
    CGFloat cellSize = (SCREENBOUNDS.width - 160) / 4;
    return CGSizeMake(cellSize, cellSize);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 1.0;
    }
    if (self.isShowSecond && section == 1) {
        return 1.0;
    }
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    }
    if (self.isShowSecond && section == 1) {
        return 0.0;
    }
    return 40.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 30);
    }
    if (self.isShowSecond && section == 1) {
        return CGSizeZero;
    }
    return CGSizeMake(SCREENBOUNDS.width, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREENBOUNDS.width, 90);
    }
    if (self.isShowSecond && section == 1) {
        return CGSizeMake(SCREENBOUNDS.width, 10);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = self.isShowSecond ? 2 : 1;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        for (UIView *vv in view.subviews) {
            [vv removeFromSuperview];
        }
        UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
        label.font = SetFont(15);
        [view addSubview:label];
        if (indexPath.section == 0) {
            view.backgroundColor = SetColor(243, 242, 247, 1);
            label.font = SetFont(13);
            label.text = @"基本资料（必填）";
        }else if (indexPath.section == index) {
            [label setAttributedText:[self changeStringRangeColor:label allString:@"上传图片（图片最多上传八张）" rangeString:@"上传图片" color:SetColor(161, 161, 161, 1)]];
        }else {
            [label setAttributedText:[self changeStringRangeColor:label allString:@"视频（请上传不超过10S的视频）" rangeString:@"视频" color:SetColor(161, 161, 161, 1)]];
        }
        return view;
    }else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        if (self.isShowSecond && indexPath.section == 1) {
            footerView.backgroundColor = self.view.backgroundColor;
            return footerView;
        }
        footerView.backgroundColor = self.view.backgroundColor;
        UITextView *textV = [[UITextView alloc] init];
        textV.backgroundColor = [UIColor whiteColor];
        textV.font = SetFont(13);
        textV.textColor = SetColor(170, 170, 170, 1);
        if (!self.describeString) {
            textV.text = @"描述100字以内";
        }else {
            textV.text = self.describeString;
        }
        [footerView addSubview:textV];
        [textV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(footerView).insets(UIEdgeInsetsMake(0, 0, 10, 0));
        }];
        return footerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isShowSecond) {
        if (indexPath.section == 2) {
            [self hx_presentAlbumListViewControllerWithManager:self.imageManager delegate:self];
        }else if (indexPath.section == 3) {
            [self hx_presentAlbumListViewControllerWithManager:self.videoManager delegate:self];
        }
    }else {
        if (indexPath.section == 1) {
            [self hx_presentAlbumListViewControllerWithManager:self.imageManager delegate:self];
        }else if (indexPath.section == 2) {
            [self hx_presentAlbumListViewControllerWithManager:self.videoManager delegate:self];
        }
    }
}

#pragma mark --- 改变字符串的部分颜色
- (NSMutableAttributedString *)changeStringRangeColor:(UILabel *)label allString:(NSString *)allString rangeString:(NSString *)rangeString color:(UIColor *)color {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allString];
    NSString *nameStr = rangeString;
    NSInteger length = nameStr.length;
    label.textColor = color;
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, length)];
    return str;
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

//点击取消
- (void)albumListViewControllerDidCancel:(HXAlbumListViewController *)albumListViewController {
    [self.imageManager clearSelectedList];
    [self.imageArray removeAllObjects];
    [self.imageArray addObject:[UIImage imageNamed:@"imageAdd"]];
    if (self.isShowSecond) {
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
    }else {
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    }
}

//点击完成
- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    __weak typeof(self) weakSelf = self;
    if (photoList.count > 0) {
        [self.imageArray removeAllObjects];
        self.ttoolManager = [[HXDatePhotoToolManager alloc] init];
        [self.ttoolManager getSelectedImageList:photoList success:^(NSArray<UIImage *> *imageList) {
            weakSelf.imageArray = [imageList mutableCopy];
            [weakSelf.imageArray insertObject:[UIImage imageNamed:@"imageAdd"] atIndex:imageList.count];
            NSLog(@"============== %@", weakSelf.imageArray);
            if (weakSelf.isShowSecond) {
                [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
            }else {
                [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
            }
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
            if (weakSelf.isShowSecond) {    //有价格的界面    视频
                [weakSelf getTwoCellFromCollection:[NSIndexPath indexPathForRow:0 inSection:3]].imageV.image = videoImage;
            }else {
                [weakSelf getTwoCellFromCollection:[NSIndexPath indexPathForRow:0 inSection:2]].imageV.image = videoImage;
            }
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

- (void)submitInfo_service {
    if (self.isShowSecond) {   //卖
        NSString *price = [self getCellFromCollection:[NSIndexPath indexPathForRow:0 inSection:1]].TextF.text;
        [self.imageArray removeLastObject];
        if ([title isEqualToString:@""] || title == nil) {
            [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入标题"];
            return;
        }else if ([area isEqualToString:@""]) {
            [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入区域"];
            return;
        }else if ([addressInfo isEqualToString:@""]) {
            [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入详细地址"];
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
        }else if (self.imageArray.count == 0) {
            [ShowHUDView showHUDWithView:self.view AndTitle:@"请选择至少两张图片"];
            return;
        }
        
        NSLog(@"title == %@", title);
        NSLog(@"area == %@", area);
        NSLog(@"addressInfo == %@", addressInfo);
        NSLog(@"contacts == %@", contacts);
        NSLog(@"phone == %@", phone);
        NSLog(@"price == %@", price);
        [self show];
        NSString *url = @"https://zbt.change-word.com/index.php/home/goods/issueBuy";
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
        [manager.operationQueue cancelAllOperations];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        NSDictionary *parme = @{
                                @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                                @"title" : title,
                                @"address" : [NSString stringWithFormat:@"%@%@", area, addressInfo],
                                @"contacts" : contacts,
                                @"phone" : phone,
                                @"price" : price,
                                @"info" : @"666666666666"
                                };
        __weak typeof(self) weakSelf = self;
        [manager POST:url parameters:parme constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (UIImage *image in weakSelf.imageArray) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
                [formData appendPartWithFileData:imageData name:@"photo[]" fileName:@"image.png" mimeType:@"image/jpg/png"];
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
    }else {        //买
        if ([title isEqualToString:@""] || title == nil) {
            [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入标题"];
            return;
        }else if ([area isEqualToString:@""]) {
            [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入区域"];
            return;
        }else if ([addressInfo isEqualToString:@""]) {
            [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入详细地址"];
            return;
        }else if ([contacts isEqualToString:@""]) {
            [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入联系人"];
            return;
        }else if ([phone isEqualToString:@""]) {
            [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入联系电话"];
            return;
        }else if (self.imageArray.count == 0) {
            [ShowHUDView showHUDWithView:self.view AndTitle:@"请选择至少两张图片"];
            return;
        }
        [self show];
        NSString *url = @"https://zbt.change-word.com/index.php/home/goods/issueSell";
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
        [manager.operationQueue cancelAllOperations];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        NSDictionary *parme = @{
                                @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                                @"title" : title,//[self getCellFromCollection:[NSIndexPath indexPathForRow:0 inSection:0]].TextF.text,
                                @"address" : [NSString stringWithFormat:@"%@%@", area, addressInfo],//[self getCellFromCollection:[NSIndexPath indexPathForRow:4 inSection:0]].TextF.text,
                                @"contacts" : contacts,//[self getCellFromCollection:[NSIndexPath indexPathForRow:1 inSection:0]].TextF.text,
                                @"phone" : phone,//[self getCellFromCollection:[NSIndexPath indexPathForRow:2 inSection:0]].TextF.text,
                                @"info" : @"5555555"
                                };
        
        __weak typeof(self) weakSelf = self;
        [manager POST:url parameters:parme constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [weakSelf.imageArray removeLastObject];
            for (UIImage *image in weakSelf.imageArray) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
                NSLog(@"data ==== %@", imageData);
                [formData appendPartWithFileData:imageData name:@"photo[]" fileName:@"image.png" mimeType:@"image/jpg/png"];
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
}

- (Buy_OneCollectionViewCell *)getCellFromCollection:(NSIndexPath *)indexPath {
    return (Buy_OneCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
}

- (Buy_TwoCollectionViewCell *)getTwoCellFromCollection:(NSIndexPath *)indexPath {
    return (Buy_TwoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 0:
        {
            title = textField.text;
            NSLog(@"0000000000");
        }
            break;
        case 1:
        {
            contacts = textField.text;
            NSLog(@"1111111111");
        }
            break;
        case 2:
        {
            phone = textField.text;
            NSLog(@"2222222222222");
        }
            break;
        case 3:
        {
            area = textField.text;
            NSLog(@"333333333333");
        }
            break;
        case 4:
        {
            addressInfo = textField.text;
            NSLog(@"4444444444");
        }
            break;
            
        default:
            break;
    }
}
@end
