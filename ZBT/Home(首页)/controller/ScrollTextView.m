//
//  ScrollTextView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/8/29.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ScrollTextView.h"
#import "Globefile.h"

@interface ScrollTextView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSTimer *scrollTimer;

@property (nonatomic, assign) NSTimeInterval interval;

@end

@implementation ScrollTextView

- (instancetype)initWithFrame:(CGRect)frame whitTextArray:(NSArray *)array {
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
        self.titleArray = [tmpArray copy];
    } else {
        self.titleArray = dataArr;
    }
    return self.titleArray;
}

- (void)creatUI:(NSArray *)array {
    self.scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scroll.showsVerticalScrollIndicator = NO;
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.delegate = self;
    self.scroll.pagingEnabled = YES;
    [self addSubview:self.scroll];
    for (NSInteger index = 0 ; index < array.count; index++) {
        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(0, self.bounds.size.height * index, self.bounds.size.width, self.bounds.size.height)];
        label.text = array[index][@"title"];
        [self.scroll addSubview:label];
    }
    [self.scroll setContentSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height * array.count)];
    
    [self startAutoScroll];
}

- (void)makeInfiniteScrolling {
    CGFloat height = self.frame.size.height;
    NSInteger currentPage = (self.scroll.contentOffset.y + height / 2.0) / height;
    
    if (currentPage == self.titleArray.count - 1) {
        self.currentPage = 0;
        [self.scroll setContentOffset:CGPointMake(0, height) animated:NO];
    } else if (currentPage == 0) {
        self.currentPage = self.titleArray.count - 2;
        
        [self.scroll setContentOffset:CGPointMake(0, height * (self.titleArray.count - 2)) animated:NO];
    } else {
        self.currentPage = currentPage - 1;
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
    
    [self.scroll setContentOffset:CGPointMake(0, self.scroll.contentOffset.y + self.frame.size.height) animated:YES];
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
