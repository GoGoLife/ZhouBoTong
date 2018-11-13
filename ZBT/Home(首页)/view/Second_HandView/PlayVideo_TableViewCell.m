//
//  PlayVideo_TableViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/8/29.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "PlayVideo_TableViewCell.h"
#import "Globefile.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

@interface PlayVideo_TableViewCell()

//@property (nonatomic, strong) UIButton *playButton;

@property (strong, nonatomic)AVPlayer *myPlayer;//播放器

@property (strong, nonatomic)AVPlayerItem *item;//播放单元

@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面（layer）

@property (nonatomic, assign) BOOL isReadToPlay;

@property (nonatomic, strong) UIView *playView;

@property (nonatomic, strong) UIView *play_view;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIImageView *video_image;

@end

@implementation PlayVideo_TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    [self.contentView addSubview:self.info_label];
    [self.contentView addSubview:self.play_view];
    
    __weak typeof(self) weakSelf = self;
    [_play_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(5);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(5);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-5);
        make.height.mas_equalTo(@(200));
    }];
    
    [_info_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.play_view.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.play_view.mas_left);
        make.right.equalTo(weakSelf.play_view.mas_right);
    }];
    
    
    if (![self.video_URLString isEqualToString:@""]) {
        [self creatPlayView:self.video_URLString WithFrame:self.bounds];
    }else {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.play_view.bounds];
        imageV.image = [UIImage imageNamed:@"video_nil"];
        [self.play_view addSubview:imageV];
        
        //移除播放完成通知
        [self pv_playerItemRemoveNotification];
    }
}

- (void)layoutSubviews {
    [self creatUI];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark ---- 懒加载创建控件
- (UILabel *)info_label {
    if (!_info_label) {
        _info_label = [[UILabel alloc] init];
        _info_label.numberOfLines = 0;
        _info_label.font = SetFont(14);
    }
    return _info_label;
}

- (UIView *)play_view {
    if (!_play_view) {
        _play_view = [[UIView alloc] init];
    }
    return _play_view;
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

//- (UIButton *)playButton {
//    if (!_playButton) {
//        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal]; //设置button的背景图片
//        [_playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _playButton;
//}

- (void)creatPlayView:(NSString *)videoURL WithFrame:(CGRect)bounds {
    self.playView = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width - 10, 200)];
    [self.play_view addSubview:self.playView];
    
    NSURL *mediaURL = [NSURL URLWithString:self.video_URLString];
    self.item = [AVPlayerItem playerItemWithURL:mediaURL];
    self.myPlayer = [AVPlayer playerWithPlayerItem:self.item];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.myPlayer];
    self.playerLayer.frame = self.playView.bounds;
    self.playerLayer.backgroundColor = [UIColor grayColor].CGColor;
    [self.playView.layer addSublayer:self.playerLayer];
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    //注册播放完成通知
    [self pv_playerItemAddNotification];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:
(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        //取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
                NSLog(@"item 有误");
                self.isReadToPlay = NO;
//                [self removePlayView];
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准好播放了");
                self.isReadToPlay = YES;
                [self addPlayButton:self.playView];
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"视频资源出现未知错误");
                self.isReadToPlay = NO;
//                [self removePlayView];
                break;
            default:
                break;
        }
    }
    //移除监听（观察者）
    [object removeObserver:self forKeyPath:@"status"];
    
}

- (void)playAction{
//    [self creatPlayView:@"" WithFrame:self.view.frame];
}

- (void)addPlayButton:(UIView *)view {
    self.video_image = [[UIImageView alloc] initWithFrame:view.bounds];
    UIImage *image = [self getVideoPreViewImage:[NSURL URLWithString:self.video_URLString]];
    self.video_image.image = image;
    self.video_image.userInteractionEnabled = YES;
    [view addSubview:self.video_image];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setBackgroundImage:[UIImage imageNamed:@"play2"] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.video_image addSubview:self.button];
    
    __weak typeof(self) weakSelf = self;
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.video_image.mas_centerX);
        make.centerY.equalTo(weakSelf.video_image.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

- (void)play {
    // 如果已播放完毕，则重新从头开始播放
    [self.myPlayer seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.myPlayer play];
    [self.video_image removeFromSuperview];
}

- (void)removePlayView {
    [self.myPlayer pause];
    [self.playView removeFromSuperview];
}

- (void)pv_playerItemAddNotification {
    // 播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pv_playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.myPlayer.currentItem];
}

-(void)pv_playbackFinished:(NSNotification *)noti {
    [self addPlayButton:self.playView];
}

//移除播放完成通知
- (void)pv_playerItemRemoveNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.myPlayer.currentItem];
}

StringHeight();
//计算cell的高度
- (CGFloat)returnCellHeight {
    CGFloat info_height = [self calculateRowHeight:self.info_string fontSize:14 withWidth:SCREENBOUNDS.width - 10];
    return info_height + 200 + 10;
}

@end
