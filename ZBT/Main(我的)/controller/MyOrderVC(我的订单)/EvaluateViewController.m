//
//  EvaluateViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/28.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "EvaluateViewController.h"
#import "Globefile.h"
#import "UITextField+LeftRightView.h"
#import "HXPhotoPicker.h"

@interface EvaluateViewController ()<HXAlbumListViewControllerDelegate>

@property (nonatomic, strong) UIView *firstView;

@property (nonatomic, strong) UIView *secondView;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIButton *typeButton;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) HXPhotoManager *manager;

//图片获取
@property (nonatomic, strong) HXDatePhotoToolManager *toolManager;

@property (nonatomic, strong) NSMutableArray *imageArr;

@property (nonatomic, strong) UIImageView *img;

@property (nonatomic, strong) UITextView *textV;

@property (nonatomic, assign) NSInteger state;

@end

@implementation EvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    self.imageArr = [NSMutableArray arrayWithCapacity:1];
    [self.imageArr addObject:[UIImage imageNamed:@"imageAdd"]];
    self.state = 1;
    
    // Do any additional setup after loading the view.
    [self setFirstViewContent];
    [self setSecondViewContent];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.backgroundColor = SetColor(24, 147, 220, 1);
    [self.button addTarget:self action:@selector(submitEvaluateInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitle:@"发布" forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    __weak typeof(self) weakSelf = self;
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(44));
    }];
    
    [self setUpNav];
    
    NSLog(@"dddddd ==== %@", self.dataDic);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    
}

StringWidth();
- (void)setFirstViewContent {
    self.firstView = [[UIView alloc] init];
    self.firstView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.firstView];
    NSInteger forCount = self.dataDic[@"goods"] ? [self.dataDic[@"goods"] count] : 1;
    __weak typeof(self) weakSelf = self;
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(90 * forCount));
    }];
    
    for (NSInteger index = 0; index < forCount; index++) {
        UIImageView *leftImageV = [[UIImageView alloc] init];
        [leftImageV sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"goods"][index][@"photo"] ?: self.imageURL] placeholderImage:[UIImage imageNamed:@"public"]];
        
        CGFloat width = [self calculateRowWidth:@"¥40000000000000000" withFont:14];
        
        UITextField *topTextF = [[UITextField alloc] init];
        topTextF.enabled = NO;
        topTextF.font = SetFont(15);
        topTextF.text = self.dataDic[@"goods"][index][@"goods_name"] ?: self.dataDic[@"yuyue_name"];//@"二手游艇";
        NSString *goods_price = [NSString stringWithFormat:@"￥%@", self.dataDic[@"goods"][index][@"goods_price"] ?: self.dataDic[@"sum_price"]];
        [topTextF creatRightView:FRAME(0, 0, width, 35) AndTitle:goods_price TextAligment:NSTextAlignmentRight Font:SetFont(14) Color:[UIColor blackColor]];
        
        UITextField *bottomTextF = [[UITextField alloc] init];
        bottomTextF.enabled = NO;
        bottomTextF.font = SetFont(12);
        bottomTextF.textColor = SetColor(69, 69, 69, 1);
        bottomTextF.text = self.orderType == 2 ? @"人数：" : @"数量：";
        [bottomTextF creatRightView:FRAME(0, 0, width, 35) AndTitle:[NSString stringWithFormat:@"x%@", self.dataDic[@"goods"][index][@"goods_number"] ?: self.dataDic[@"people_number"]] TextAligment:NSTextAlignmentRight Font:SetFont(12) Color:SetColor(69, 69, 69, 1)];
        
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
    
    NSArray *btnTitle = @[@"好评", @"中评", @"差评"];
    for (NSInteger index = 0; index < 3; index++) {
        self.typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.typeButton setTitleColor:SetColor(69, 69, 69, 1) forState:UIControlStateNormal];
        self.typeButton.titleLabel.font = SetFont(12);
        [self.typeButton setImage:[UIImage imageNamed:@"weixuanze"] forState:UIControlStateNormal];
        [self.typeButton setTitle:btnTitle[index] forState:UIControlStateNormal];
        [self.typeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        self.typeButton.tag = 100 + index;
        [self.typeButton addTarget:self action:@selector(changeButtonType:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.image = [UIImage imageNamed:@[@"evaluate1", @"evaluate2", @"evaluate3"][index]];
        
        [self.secondView addSubview:self.typeButton];
        [self.secondView addSubview:imageV];
        
        CGFloat width = (SCREENBOUNDS.width - 100) / 3;
        [self.typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.secondView.mas_top).offset(20);
            make.left.equalTo(weakSelf.secondView.mas_left).offset(20 + (width + 30) * index);
            make.size.mas_equalTo(CGSizeMake(width - 30, 40));
        }];
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.typeButton.mas_centerY);
            make.left.equalTo(weakSelf.typeButton.mas_right);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }
    
    self.textV = [[UITextView alloc] init];
    self.textV.text = @"请输入评价内容";
    self.textV.backgroundColor = BaseViewColor;
    [self.secondView addSubview:self.textV];
    
    [self.textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.secondView.mas_top).offset(70);
        make.left.equalTo(weakSelf.secondView.mas_left).offset(10);
        make.right.equalTo(weakSelf.secondView.mas_right).offset(-10);
        make.height.mas_equalTo(@(120));
    }];
    
    self.label = [[UILabel alloc] init];
    self.label.font = SetFont(14);
    self.label.text = @"图片上传 (最多选取四张)";
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
    [self hx_presentAlbumListViewControllerWithManager:self.manager delegate:self];
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

- (void)changeButtonType:(UIButton *)sender {
    for (UIButton *typeButton in self.secondView.subviews) {
        if (typeButton.class != UIButton.class) {
            continue;
        }
        if (typeButton.tag == sender.tag) {
            [typeButton setImage:[UIImage imageNamed:@"yixuanze"] forState:UIControlStateNormal];
            self.state = sender.tag - 100 + 1;
        }else {
            [typeButton setImage:[UIImage imageNamed:@"weixuanze"] forState:UIControlStateNormal];
        }
    }
}

//懒加载相册管理类
- (HXPhotoManager *)manager {
    if (_manager == nil) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = NO;
        _manager.configuration.maxNum = 4;
        _manager.configuration.photoMaxNum = 4;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.themeColor = [UIColor blackColor];
    }
    return _manager;
}

- (HXDatePhotoToolManager *)toolManger {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}

//上传订单评价信息
- (void)submitEvaluateInfo {
    [self show];
    __weak typeof(self) weakSelf = self;
    //http://45.77.244.195/index.php/home/Member/changeMemberInfo
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *parme;
    if (self.orderType == 1) {   //实物类评价
        parme = @{
                    @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                    @"order_id" : @([self.dataDic[@"order_id"] integerValue]),
                    @"type" : @(self.orderType),
                    @"content" : self.textV.text,
                    @"state" : @(self.state)
                    };
        NSLog(@"parme === %@", parme);
    }else {
        //预约类评价
        parme = @{
                    @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                    //                            @"order_id" : @([self.dataDic[@"goods_id"] integerValue]),
                    @"yuyue_id" : @([self.dataDic[@"yuyue_id"] integerValue]),
                    @"type" : @(self.orderType),
                    @"content" : self.textV.text,
                    @"state" : @(self.state)
                    };
        NSLog(@"parme === %@", parme);
    }
   
    [manager POST:@"https://zbt.change-word.com/index.php/home/comment/addComment" parameters:parme constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [weakSelf.imageArr removeLastObject];
        for (UIImage *image in weakSelf.imageArr) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
            [formData appendPartWithFileData:imageData name:@"photo[]" fileName:@"image.png" mimeType:@"image/jpg/png"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *strData = responseObject;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic ===== %@", dic);
        [weakSelf hidden];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hidden];
        NSLog(@"error === %@", error);
        
    }];
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
