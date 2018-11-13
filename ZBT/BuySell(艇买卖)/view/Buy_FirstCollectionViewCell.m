//
//  Buy_FirstCollectionViewCell.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/28.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Buy_FirstCollectionViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

@interface Buy_FirstCollectionViewCell()
{
    dispatch_source_t _timer;
}

@property (nonatomic, strong) UILabel *dayLabel;

@property (nonatomic, strong) UILabel *hourLabel;

@property (nonatomic, strong) UILabel *minuteLabel;

@property (nonatomic, strong) UILabel *secondLabel;

@end

@implementation Buy_FirstCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    CGFloat leftWidth = (self.contentView.bounds.size.width - 10) * 0.4;
    CGFloat rightHeight = (self.contentView.bounds.size.height - 10) / 2;
    
    self.leftView = [[UIView alloc] init];
//    self.leftView.backgroundColor = RandomColor;
    self.leftView.layer.contents = (id)[UIImage imageNamed:@"group1"].CGImage;
    
    self.rightTopView = [[UIView alloc] init];
//    self.rightTopView.backgroundColor = RandomColor;
    self.rightTopView.layer.contents = (id)[UIImage imageNamed:@"group2"].CGImage;
    
    self.rightBottomView = [[UIView alloc] init];
//    self.rightBottomView.backgroundColor = RandomColor;
    self.rightBottomView.layer.contents = (id)[UIImage imageNamed:@"group3"].CGImage;
    
    [self.contentView addSubview:self.leftView];
    [self.contentView addSubview:self.rightTopView];
    [self.contentView addSubview:self.rightBottomView];
    __weak typeof(self) weakSelf = self;
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.width.mas_equalTo(@(leftWidth));
    }];
    
    [self.rightTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftView.mas_right).offset(10);
        make.top.equalTo(weakSelf.leftView.mas_top);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(@(rightHeight));
    }];
    
    [self.rightBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftView.mas_right).offset(10);
        make.top.equalTo(weakSelf.rightTopView.mas_bottom).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(@(rightHeight));
    }];
    
//    [self setLeftView];
    [self setRightTopView];
    [self setRightBottomView];
    
}

- (void)setLeftView {
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = @"立刻抢购";
    [topLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    topLabel.numberOfLines = 0;
    topLabel.textColor = [UIColor redColor];
    
    UILabel *centerLabel = [[UILabel alloc] init];
    centerLabel.text = @"剩余时间";
    [centerLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    centerLabel.numberOfLines = 0;
    
    self.hourLabel = [[UILabel alloc] init];
    self.hourLabel.backgroundColor = [UIColor redColor];
    self.hourLabel.textColor = [UIColor whiteColor];
    //设置label文本
    [self setDataLabelText];
    [self.hourLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    self.hourLabel.numberOfLines = 0;
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @":";
    [label1 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    label1.numberOfLines = 0;
    
    self.minuteLabel = [[UILabel alloc] init];
    self.minuteLabel.backgroundColor = [UIColor redColor];
    self.minuteLabel.textColor = [UIColor whiteColor];
    [self.minuteLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    self.minuteLabel.numberOfLines = 0;
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @":";
    [label2 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    label2.numberOfLines = 0;
    
    self.secondLabel = [[UILabel alloc] init];
    self.secondLabel.backgroundColor = [UIColor redColor];
    self.secondLabel.textColor = [UIColor whiteColor];
    [self.secondLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    self.secondLabel.numberOfLines = 0;
    
    [self.leftView addSubview:topLabel];
    [self.leftView addSubview:centerLabel];
    [self.leftView addSubview:self.hourLabel];
    [self.leftView addSubview:label1];
    [self.leftView addSubview:self.minuteLabel];
    [self.leftView addSubview:label2];
    [self.leftView addSubview:self.secondLabel];
    
    __weak typeof(self) weakSelf = self;
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftView.mas_left).offset(10);
        make.top.equalTo(weakSelf.leftView.mas_top).offset(20);
    }];
    
    [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLabel.mas_bottom).offset(10);
        make.left.equalTo(topLabel.mas_left);
    }];
    
    [self.hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topLabel.mas_left);
        make.top.equalTo(centerLabel.mas_bottom).offset(10);
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.hourLabel.mas_right);
        make.top.equalTo(weakSelf.hourLabel.mas_top);
    }];
    
    [self.minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right);
        make.top.equalTo(weakSelf.hourLabel.mas_top);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.minuteLabel.mas_right);
        make.top.equalTo(weakSelf.hourLabel.mas_top);
    }];
    
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right);
        make.top.equalTo(weakSelf.hourLabel.mas_top);
    }];
}

- (void)setRightTopView {
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = @"游艇世界";
    [topLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    topLabel.numberOfLines = 0;
    
    UIView *centerV = [[UIView alloc] init];
    centerV.backgroundColor = SetColor(170, 182, 186, 1);
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.text = @"全场最低8.5折起";
    [bottomLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    bottomLabel.numberOfLines = 0;
    
    [self.rightTopView addSubview:topLabel];
    [self.rightTopView addSubview:centerV];
    [self.rightTopView addSubview:bottomLabel];
    
    __weak typeof(self) weakSelf = self;
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.rightTopView.mas_top).offset(15);
        make.left.equalTo(weakSelf.rightTopView.mas_left).offset(15);
    }];
    
    CGFloat rightWidth = (self.contentView.bounds.size.width - 10) * 0.6 / 2;
    [centerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLabel.mas_bottom).offset(5);
        make.left.equalTo(topLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(rightWidth, 2));
    }];
    
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerV.mas_bottom).offset(5);
        make.left.equalTo(topLabel.mas_left);
    }];
}

- (void)setRightBottomView {
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = @"游艇拼团";
    [topLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    topLabel.numberOfLines = 0;
    
    UIView *centerV = [[UIView alloc] init];
    centerV.backgroundColor = SetColor(170, 182, 186, 1);
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.text = @"好货一起拼";
    [bottomLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    bottomLabel.numberOfLines = 0;
    
    [self.rightBottomView addSubview:topLabel];
    [self.rightBottomView addSubview:centerV];
    [self.rightBottomView addSubview:bottomLabel];
    
    __weak typeof(self) weakSelf = self;
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.rightBottomView.mas_top).offset(15);
        make.left.equalTo(weakSelf.rightBottomView.mas_left).offset(15);
    }];
    
    CGFloat rightWidth = (self.contentView.bounds.size.width - 10) * 0.6 / 2;
    [centerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLabel.mas_bottom).offset(5);
        make.left.equalTo(topLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(rightWidth, 2));
    }];
    
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerV.mas_bottom).offset(5);
        make.left.equalTo(topLabel.mas_left);
    }];
}

/**
 *  获取当天的年月日的字符串
 *  这里测试用
 *  @return 格式为年-月-日
 */
-(NSString *)getyyyymmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
}

- (void)setDataLabelText {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *endDate = [dateFormatter dateFromString:[self getyyyymmdd]];
    NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate] + 24*3600)];
    NSDate *startDate = [NSDate date];
    NSTimeInterval timeInterval =[endDate_tomorrow timeIntervalSinceDate:startDate];
    
    if (_timer==nil) {
        __block int timeout = timeInterval; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            __weak typeof(self) weakSelf = self;
            dispatch_source_set_event_handler(_timer, ^{
                __strong typeof(weakSelf) StrongSelf = weakSelf;
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(StrongSelf->_timer);
                    StrongSelf->_timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.dayLabel.text = @"";
                        self.hourLabel.text = @"00";
                        self.minuteLabel.text = @"00";
                        self.secondLabel.text = @"00";
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    if (days==0) {
                        self.dayLabel.text = @"";
                    }
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days==0) {
                            self.dayLabel.text = @"0天";
                        }else{
                            self.dayLabel.text = [NSString stringWithFormat:@"%d天",days];
                        }
                        if (hours<10) {
                            self.hourLabel.text = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            self.hourLabel.text = [NSString stringWithFormat:@"%d",hours];
                        }
                        if (minute<10) {
                            self.minuteLabel.text = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            self.minuteLabel.text = [NSString stringWithFormat:@"%d",minute];
                        }
                        if (second<10) {
                            self.secondLabel.text = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            self.secondLabel.text = [NSString stringWithFormat:@"%d",second];
                        }
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
    
    
}

@end
