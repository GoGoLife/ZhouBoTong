//
//  CustomPickerView.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/17.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "CustomPickerView.h"
#import "Globefile.h"
#import <Masonry.h>

@interface CustomPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIToolbar *tool;

@property (nonatomic, strong) UIPickerView *pickerV;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSMutableArray *returnArr;

@end

@implementation CustomPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = BaseViewColor;
        [self creatUI];
        self.returnArr = [NSMutableArray arrayWithCapacity:1];
        [self.returnArr addObject:@"0"];
        [self.returnArr addObject:@"0"];
        [self.returnArr addObject:@"0"];
    }
    return self;
}

- (void)creatUI {
    [self addSubview:self.tool];
    [self addSubview:self.pickerV];
    
    __weak typeof(self) weakSelf = self;
    [self.tool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(@(44));
    }];
    
    [self.pickerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tool.mas_bottom);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.dataArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataArray[component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataArray[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.returnArr[component] = [NSString stringWithFormat:@"%ld", row];
    self.selectedIndex = row;
}


#pragma mark ----- 懒加载
- (UIToolbar *)tool {
    if (_tool == nil) {
        _tool = [[UIToolbar alloc] init];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
        
        UIBarButtonItem *centerItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
        
        _tool.items = @[leftItem, centerItem, rightItem];
        
    }
    return _tool;
}

- (UIPickerView *)pickerV {
    if (_pickerV == nil) {
        _pickerV = [[UIPickerView alloc] init];
        _pickerV.delegate = self;
        _pickerV.dataSource = self;
    }
    return _pickerV;
}

- (void)cancelAction {
    [self removeFromSuperview];
}

- (void)finishAction {
    NSLog(@"returnArr == %@", self.returnArr);
    self.returnSelectData(self.returnArr);
    [self cancelAction];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
