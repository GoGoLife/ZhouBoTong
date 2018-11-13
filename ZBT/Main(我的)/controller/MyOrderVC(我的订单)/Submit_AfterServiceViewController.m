//
//  Submit_AfterServiceViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/28.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Submit_AfterServiceViewController.h"
#import "Globefile.h"
#import "UITextField+LeftRightView.h"
#import "HXPhotoPicker.h"

@interface Submit_AfterServiceViewController ()<HXAlbumListViewControllerDelegate>

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIView *firstView;

@property (nonatomic, strong) UIView *secondView;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) HXPhotoManager *imageManager;

@property (nonatomic, strong) HXDatePhotoToolManager *toolManager;

@property (nonatomic, strong) NSMutableArray *imageArr;

@property (nonatomic, strong) UIImageView *img;

@property (nonatomic, strong) UILabel *label;

//申请售后的类型  1：退款  2：退货
@property (nonatomic, assign) NSInteger after_type;

//售后服务描述
@property (nonatomic, strong) UITextView *textV;

@end

@implementation Submit_AfterServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请售后";
    self.after_type = 0;
    // Do any additional setup after loading the view.
    self.imageArr = [NSMutableArray arrayWithCapacity:1];
    [self.imageArr addObject:[UIImage imageNamed:@"imageAdd"]];
    
    [self setHeaderViewContent];
    [self setFirstViewContent];
    [self setSecondViewContent];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.backgroundColor = SetColor(24, 147, 220, 1);
    [self.button setTitle:@"提交申请" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(submitEvaluateInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    __weak typeof(self) weakSelf = self;
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(44));
    }];
    
    [self setUpNav];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setHeaderViewContent {
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerView];
    __weak typeof(self) weakSelf = self;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(100));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.text = @"售后类型";
    [self.headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerView.mas_top).offset(15);
        make.left.equalTo(weakSelf.headerView.mas_left).offset(20);
    }];
    
    NSArray *btnTitle = @[@"申请退款", @"申请退货"];
    NSInteger forIndex = self.isShowButton ? 1 : 2;
    NSLog(@"forIndex === %ld", forIndex);
    for (NSInteger index = 0; index < forIndex; ++index) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(14);
        ViewBorderRadius(button, 5.0, 1.0, SetColor(243, 243, 243, 1));
        [button setTitleColor:SetColor(170, 170, 170, 1) forState:UIControlStateNormal];
        [button setTitle:btnTitle[index] forState:UIControlStateNormal];
        button.tag = 100 + index;
        [button addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(10);
            make.left.equalTo(label.mas_left).offset(90 * index);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
    }
}

StringWidth();
- (void)setFirstViewContent {
    self.firstView = [[UIView alloc] init];
    self.firstView.backgroundColor = [UIColor whiteColor];
     [self.view addSubview:self.firstView];
    __weak typeof(self) weakSelf = self;
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerView.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(90 * self.goodsArr.count));
    }];
    
    for (NSInteger index = 0; index < self.goodsArr.count; index++) {
        UIImageView *leftImageV = [[UIImageView alloc] init];
        [leftImageV sd_setImageWithURL:[NSURL URLWithString:self.goodsArr[index][@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
        
        CGFloat width = [self calculateRowWidth:@"¥40000000000000" withFont:14];
        
        UITextField *topTextF = [[UITextField alloc] init];
        topTextF.enabled = NO;
        topTextF.font = SetFont(15);
        topTextF.text = self.goodsArr[index][@"goods_name"];//@"二手游艇";
        [topTextF creatRightView:FRAME(0, 0, width, 35) AndTitle:self.goodsArr[index][@"goods_price"] ?: self.goodsArr[index][@"order_price"] TextAligment:NSTextAlignmentRight Font:SetFont(14) Color:[UIColor blackColor]];
        
        UITextField *bottomTextF = [[UITextField alloc] init];
        bottomTextF.enabled = NO;
        bottomTextF.font = SetFont(12);
        bottomTextF.textColor = SetColor(69, 69, 69, 1);
        bottomTextF.text = @"规格：蓝色";
        NSString *goods_number = [NSString stringWithFormat:@"*%@", self.goodsArr[index][@"goods_number"] ?: @"1"];
        [bottomTextF creatRightView:FRAME(0, 0, width, 35) AndTitle:goods_number TextAligment:NSTextAlignmentRight Font:SetFont(12) Color:SetColor(69, 69, 69, 1)];
        
        [self.firstView addSubview:leftImageV];
        [self.firstView addSubview:topTextF];
        [self.firstView addSubview:bottomTextF];
        
        
        
        [leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.firstView.mas_top).offset(10 + 90 * index);
            make.left.equalTo(weakSelf.firstView.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        
        [topTextF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(leftImageV.mas_top);
            make.left.equalTo(leftImageV.mas_right).offset(10);
            make.right.equalTo(weakSelf.firstView.mas_right).offset(-5);
            make.height.mas_equalTo(@(35));
        }];
        
        [bottomTextF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topTextF.mas_bottom);
            make.left.equalTo(topTextF.mas_left);
            make.right.equalTo(topTextF.mas_right);
            make.height.equalTo(topTextF.mas_height);
        }];
    }
}

- (void)setSecondViewContent {
    self.secondView = [[UIView alloc] init];
    self.secondView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.secondView];
    __weak typeof(self) weakSelf = self;
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.firstView.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-44);
    }];
    
    UILabel *reason = [[UILabel alloc] init];
    reason.text = @"申请原因";
    [self.secondView addSubview:reason];
    [reason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.secondView.mas_top).offset(20);
        make.left.equalTo(weakSelf.secondView.mas_left).offset(10);
    }];
    
    self.textV = [[UITextView alloc] init];
    self.textV.text = @"请输入评价内容";
    self.textV.backgroundColor = BaseViewColor;
    [self.secondView addSubview:self.textV];
    
    [self.textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(reason.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.secondView.mas_left).offset(10);
        make.right.equalTo(weakSelf.secondView.mas_right).offset(-10);
        make.height.mas_equalTo(@(120));
    }];
    
    self.label = [[UILabel alloc] init];
    self.label.font = SetFont(14);
    self.label.text = @"图片上传";
    [self.secondView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.textV.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.textV.mas_left);
    }];
    
    [self setEvaluateImage];
}

//设置评论图片
- (void)setEvaluateImage {
    [self.img removeFromSuperview];
    NSInteger whileNumber = self.imageArr.count <= 4 ? self.imageArr.count : 4;
    for (NSInteger index = 0; index < whileNumber; index++) {
        self.img = [[UIImageView alloc] init];
        //        self.img.userInteractionEnabled = NO;
        self.img.tag = index;
        self.img.image =  self.imageArr[index];
        [self.secondView addSubview:self.img];
        __weak typeof(self) weakSelf = self;
        [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.label.mas_bottom).offset(15);
            make.left.equalTo(weakSelf.label.mas_left).offset(85 * index);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        if (self.img.tag == whileNumber - 1) {
            self.img.userInteractionEnabled = YES;
            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage)];
            [self.img addGestureRecognizer:ges];
        }
    }
}

- (void)selectImage {
    [self hx_presentAlbumListViewControllerWithManager:self.imageManager delegate:self];
}

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    __weak typeof(self) weakSelf = self;
    [self.toolManger getSelectedImageList:photoList success:^(NSArray<UIImage *> *imageList) {
        [weakSelf.imageArr removeAllObjects];
        weakSelf.imageArr = [imageList mutableCopy];
        [weakSelf.imageArr insertObject:[UIImage imageNamed:@"imageAdd"] atIndex:imageList.count];
        [weakSelf setEvaluateImage];
    } failed:^{
        
    }];
}

//上传订单评价信息
- (void)submitEvaluateInfo {
    if (!self.shopping_id || self.after_type == 0 || [self.textV.text isEqualToString:@"请输入评价内容"]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请完善售后信息再提交。"];
        return;
    }
    [self show];
    __weak typeof(self) weakSelf = self;
    //http://45.77.244.195/index.php/home/Member/changeMemberInfo
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary *parme = @{
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"shopping_id" : @([self.shopping_id integerValue]),
                            @"type" : @(self.after_type),
                            @"info" : self.textV.text
                            };
    [manager POST:@"https://zbt.change-word.com/index.php/home/order/afterSale" parameters:parme constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [weakSelf.imageArr removeLastObject];
        for (UIImage *image in weakSelf.imageArr) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
            [formData appendPartWithFileData:imageData name:@"photo[]" fileName:@"image.png" mimeType:@"image/jpg/png"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *strData = responseObject;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"aaaaaa ===== %@", dic);
        [self hidden];
        if ([dic[@"resultCode"] integerValue] == 1) {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"申请成功，请等待客服联系您。"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }else {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"申请售后服务失败。"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hidden];
        [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"申请售后服务失败。"];
        
    }];
}

//选择售后类型
- (void)changeType:(UIButton *)button {
    for (UIButton *btn in self.headerView.subviews) {
        if (btn.class != UIButton.class) {
            continue;
        }
        if (btn.tag == button.tag) {
            btn.backgroundColor = [UIColor redColor];
            if (btn.tag == 100) {
                self.after_type = 1;
            }else {
                self.after_type = 2;
            }
        }else {
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
}

#pragma mark --- 懒加载
//懒加载相册管理类
- (HXPhotoManager *)imageManager {
    if (_imageManager == nil) {
        _imageManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _imageManager.configuration.openCamera = NO;
        _imageManager.configuration.maxNum = 4;
        _imageManager.configuration.photoMaxNum = 4;
        _imageManager.configuration.saveSystemAblum = YES;
        _imageManager.configuration.themeColor = [UIColor blackColor];
    }
    return _imageManager;
}

- (HXDatePhotoToolManager *)toolManger {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}

@end
