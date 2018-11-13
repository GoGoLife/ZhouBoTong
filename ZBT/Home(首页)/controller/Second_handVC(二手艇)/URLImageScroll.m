//
//  URLImageScroll.m
//  ZBT
//
//  Created by 钟文斌 on 2018/8/28.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "URLImageScroll.h"
#import "Globefile.h"

@interface URLImageScroll()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollV;

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSTimer *scrollTimer;

@property (nonatomic, assign) NSTimeInterval interval;

@end

@implementation URLImageScroll

- (instancetype)initWithFrame:(CGRect)frame withImageArray:(NSArray *)array {
    if (self == [super initWithFrame:frame]) {
        self.interval = 2;
        [self creatUI:[self changeData:array]];
    }
    return self;
}

- (NSArray *)changeData:(NSArray *)dataArr {
    if ([dataArr count] > 1) {
        NSMutableArray *tmpArray = [dataArr mutableCopy];
        // 额外拷贝第一个和最后一个数据
        [tmpArray addObject:[dataArr firstObject]];
        [tmpArray insertObject:[dataArr lastObject] atIndex:0];
        self.URLImageArr = [tmpArray copy];
    } else {
        self.URLImageArr = dataArr;
    }
    return self.URLImageArr;
}

- (void)creatUI:(NSArray *)URLImageArr {
    NSLog(@"urlimagearr === %@", URLImageArr);
    self.scrollV = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollV.delegate = self;
    self.scrollV.pagingEnabled = YES;
    [self addSubview:self.scrollV];
    for (NSInteger index = 0; index < URLImageArr.count; index++) {
        self.imageV = [[UIImageView alloc] initWithFrame:FRAME(self.bounds.size.width * index, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:URLImageArr[index]] placeholderImage:[UIImage imageNamed:@"public"]];
        self.imageV.tag = index;
        self.imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImage:)];
        [self.imageV addGestureRecognizer:tap];
        
        [self.scrollV addSubview:self.imageV];
        self.scrollV.contentSize = CGSizeMake(self.bounds.size.width * URLImageArr.count, self.bounds.size.height);
    }
    
    if (URLImageArr.count == 1) {
        self.scrollV.scrollEnabled = NO;
    }else {
        self.scrollV.scrollEnabled = YES;
        [self startAutoScroll];
    }
}

- (void)touchImage:(UITapGestureRecognizer *)ges {
    NSInteger index = ges.view.tag;
    if ([_delegate respondsToSelector:@selector(TouchImageIndexWithAction:)]) {
        [_delegate TouchImageIndexWithAction:index];
    }
}

- (void)makeInfiniteScrolling {
    CGFloat width = self.frame.size.width;
    NSInteger currentPage = (self.scrollV.contentOffset.x + width / 2.0) / width;
    
    if (currentPage == self.URLImageArr.count - 1) {
        self.currentPage = 0;
        [self.scrollV setContentOffset:CGPointMake(width, 0) animated:NO];
    } else if (currentPage == 0) {
        self.currentPage = self.URLImageArr.count - 2;
        
        [self.scrollV setContentOffset:CGPointMake(width * (self.URLImageArr.count - 2), 0) animated:NO];
    } else {
        self.currentPage = currentPage - 1 ;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self makeInfiniteScrolling];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self makeInfiniteScrolling];
}

- (void)startAutoScroll {
    if (self.scrollTimer || self.interval == 0 ) {
        return;
    }
    self.scrollTimer = [NSTimer timerWithTimeInterval:self.interval target:self selector:@selector(doScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.scrollTimer forMode:NSDefaultRunLoopMode];
}

- (void)doScroll {
    [self.scrollV setContentOffset:CGPointMake(self.scrollV.contentOffset.x + self.frame.size.width, 0) animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopAutoScroll];
}

- (void)stopAutoScroll {
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startAutoScroll];
}

@end
