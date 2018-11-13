//
//  Customzation_InfoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Customzation_InfoViewController.h"
#import "Buy_OneCollectionViewCell.h"
#import "Buy_TwoCollectionViewCell.h"
#import "Globefile.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

@interface Customzation_InfoViewController ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *playButton;

@property (strong, nonatomic)AVPlayer *myPlayer;//播放器

@property (strong, nonatomic)AVPlayerItem *item;//播放单元

@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面（layer）

@property (nonatomic, assign) BOOL isReadToPlay;

@property (nonatomic, strong) UIView *playView;

@end

@implementation Customzation_InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定制详情";
    
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
    
    [self.view addSubview:self.collectionView];
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 44, 0));
    }];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.backgroundColor = [UIColor redColor];
    [self.button setTitle:@"查看留言" forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.collectionView.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    [self setUpNav];
    
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getYeachInfo];
    
    [self getInfo_Sell];
    
    [self getInfo_CustomService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.serve_id) {
        return 2;
    }
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.isShowPrice) {
            return 6;
        }
        return 5;
    }else if (section == 1) {
        return [isNullClass(self.dataDic[@"photo"]) isEqualToString:@""] ? 0 : [self.dataDic[@"photo"] count];
    }else {
        return [isNullClass(self.dataDic[@"video"]) isEqualToString:@""] ? 0 : 1;
    }
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
    }
    return _label;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 4) {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
            [cell.contentView addSubview:self.label];
            _label.font = SetFont(14);
            _label.numberOfLines = 0;
            [_label setText:isNullClass(self.dataDic[@"info"])];
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
            }];
            return cell;
        }else {
            Buy_OneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"one" forIndexPath:indexPath];
            cell.TextF.enabled = NO;
            cell.leftString = @[@"标题", @"联系人", @"手机号", @"详细地址", @"", @"价格"][indexPath.row];
            if (self.buy_id || self.sell_id) {
                if (self.isShowPrice) {
                    cell.TextF.text = @[isNullClass(self.dataDic[@"title"]),
                                        isNullClass(self.dataDic[@"contacts"]),
                                        isNullClass(self.dataDic[@"phone"]),
                                        isNullClass(self.dataDic[@"address"]),
                                        isNullClass(self.dataDic[@"info"]),
                                        isNullClass(self.dataDic[@"price"])][indexPath.row];
                }else {
                    cell.TextF.text = @[isNullClass(self.dataDic[@"title"]),
                                        isNullClass(self.dataDic[@"contacts"]),
                                        isNullClass(self.dataDic[@"phone"]),
                                        isNullClass(self.dataDic[@"address"]),
                                        isNullClass(self.dataDic[@"info"])][indexPath.row];
                }
            }else if (self.serve_id) {
                cell.TextF.text = @[isNullClass(self.dataDic[@"serve_name"]),
                                    isNullClass(self.dataDic[@"username"]),
                                    isNullClass(self.dataDic[@"phone"]),
                                    isNullClass(self.dataDic[@"address"]),
                                    isNullClass(self.dataDic[@"info"]),
                                    isNullClass(self.dataDic[@"price"])][indexPath.row];
            }
            
            return cell;
        }
    }else {
        if (!self.serve_id) {
            if (indexPath.section == 1) {
                Buy_TwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"two" forIndexPath:indexPath];
                cell.isShowButton = YES;
                [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"photo"][indexPath.row]]];
                return cell;
            }else if (indexPath.section == 2) {
                Buy_TwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"three" forIndexPath:indexPath];
                cell.isShowButton = YES;
                UIImage *videoImage;
                if (![isNullClass(self.dataDic[@"video"]) isEqualToString:@""]) {
                    NSLog(@"11111111111");
                    videoImage = [self getVideoPreViewImage:[NSURL URLWithString:self.dataDic[@"video"]]];
                    [cell.contentView addSubview:self.playButton];
                    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
                    }];
                }else {
                    videoImage = [UIImage imageNamed:@"public"];
                    _playButton.enabled = NO;
                }
                cell.imageV.image = videoImage;
                return cell;
            }
        }else {
            Buy_TwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"two" forIndexPath:indexPath];
            cell.isShowButton = YES;
            [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"photo"][indexPath.row]]];
            return cell;
        }
    }
    return nil;
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
    CGFloat cellSize = (SCREENBOUNDS.width - 110) / 4;
    return CGSizeMake(cellSize, cellSize + 40);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    }
    return 30.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(10, 15, 10, 15);
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(SCREENBOUNDS.width, 50);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (self.serve_id) {
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
        }
        return view;
    }else {
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
            if ([isNullClass(self.dataDic[@"video"]) isEqualToString:@""]) {
                label.text = @"";
            }else {
                label.text = @"视频(不超过10S)";
            }
        }
        return view;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [ShowHUDView showBigImageAtView:self.view AndImageURL:self.dataDic[@"photo"]];
    }
}

//获取我要买的详情信息
- (void)getYeachInfo {
    NSString *url = @"https://zbt.change-word.com/index.php/home/Goods/sellInfo";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    if (!self.sell_id) {
        return;
    }
    NSDictionary *dic = @{@"sell_id" : self.sell_id};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"sell === %@", responseObject);
        weakSelf.dataDic = (NSDictionary *)responseObject[@"data"];
        [weakSelf.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取我要卖的详情信息
- (void)getInfo_Sell {
    NSString *url = @"https://zbt.change-word.com/index.php/home/Goods/buyInfo";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    if (!self.buy_id) {
        return;
    }
    NSDictionary *dic = @{@"buy_id" : self.buy_id};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"buy ===== %@", responseObject);
        weakSelf.dataDic = (NSDictionary *)responseObject[@"data"];
        [weakSelf.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取定制服务的详情信息
- (void)getInfo_CustomService {
    NSString *url = @"https://zbt.change-word.com/index.php/home/service/customerInfo";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    if (!self.serve_id) {
        return;
    }
    NSDictionary *dic = @{@"serve_id" : self.serve_id};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"serve ===== %@", responseObject);
        weakSelf.dataDic = (NSDictionary *)responseObject[@"data"];
        [weakSelf.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal]; //设置button的背景图片
        [_playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (void)creatPlayView:(NSString *)videoURL WithFrame:(CGRect)bounds {
    self.playView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.playView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePlayView)];
    [self.playView addGestureRecognizer:tap];
    [self.view addSubview:self.playView];
    
    NSURL *mediaURL = [NSURL URLWithString:self.dataDic[@"video"]];
    self.item = [AVPlayerItem playerItemWithURL:mediaURL];
    self.myPlayer = [AVPlayer playerWithPlayerItem:self.item];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.myPlayer];
    self.playerLayer.frame = self.playView.bounds;
    self.playerLayer.backgroundColor = [UIColor grayColor].CGColor;
    [self.playView.layer addSublayer:self.playerLayer];
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:
(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        //取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
                NSLog(@"item 有误");
                self.isReadToPlay = NO;
                [self removePlayView];
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准好播放了");
                self.isReadToPlay = YES;
                [self.myPlayer play];
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"视频资源出现未知错误");
                self.isReadToPlay = NO;
                [self removePlayView];
                break;
            default:
                break;
        }
    }
    //移除监听（观察者）
    [object removeObserver:self forKeyPath:@"status"];
}

- (void)playAction{
    [self creatPlayView:@"" WithFrame:self.view.frame];
}

- (void)removePlayView {
    [self.myPlayer pause];
    [self.playView removeFromSuperview];
}

@end
