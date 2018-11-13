//
//  SureRealNameViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/22.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "SureRealNameViewController.h"
#import "Globefile.h"
#import "UITextField+LeftRightView.h"
#import <AFNetworking.h>
#import "HXPhotoPicker.h"
#import "ShowHUDView.h"

@interface SureRealNameViewController ()<HXAlbumListViewControllerDelegate>

@property (nonatomic, strong) UITextField *nameTextF;

@property (nonatomic, strong) UITextField *idNumberTextF;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UILabel *label1;

@property (nonatomic, strong) UILabel *label2;

@property (nonatomic, strong) UIImageView *imageV1;

@property (nonatomic, strong) UILabel *label3;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) HXPhotoManager *manager;

//图片获取
@property (nonatomic, strong) HXDatePhotoToolManager *toolManager;

//保存选取的身份证图片
@property (nonatomic, strong) UIImage *IDCardImage;

@property (nonatomic, assign) NSInteger chooseTag;

@end

@implementation SureRealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    [self setUpNav];
}

StringWidth();
- (void)creatUI {
    self.nameTextF = [[UITextField alloc] init];
    self.nameTextF.textAlignment = NSTextAlignmentRight;
    self.nameTextF.placeholder = @"请输入真实姓名";
//    self.nameTextF.text = @"油纸伞";
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SetColor(238, 238, 238, 1);
    
    self.idNumberTextF = [[UITextField alloc] init];
    self.idNumberTextF.textAlignment = NSTextAlignmentRight;
    self.idNumberTextF.placeholder = @"请输入身份证号码";
//    self.idNumberTextF.text = @"4728174899178192842";
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = SetColor(238, 238, 238, 1);
    
    self.label = [[UILabel alloc] init];
    self.label.text = @"上传手持身份证（正面）";
    
    self.imageV = [[UIImageView alloc] init];
    self.imageV.image = [UIImage imageNamed:@"RZAdd"];
    self.imageV.tag = 100;
    self.imageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage:)];
    [self.imageV addGestureRecognizer:tap];
    
    self.label1 = [[UILabel alloc] init];
    self.label1.text = @"选填";
    
    self.label2 = [[UILabel alloc] init];
    self.label2.text = @"上传手持身份证（反面）";
    
    self.imageV1 = [[UIImageView alloc] init];
    self.imageV1.image = [UIImage imageNamed:@"RZAdd"];
    self.imageV1.tag = 101;
    self.imageV1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage:)];
    [self.imageV1 addGestureRecognizer:tap1];
    
    self.label3 = [[UILabel alloc] init];
    self.label3.text = @"选填";
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.backgroundColor = SetColor(24, 148, 220, 1);
    [self.button setTitle:@"确定" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(commitInformation) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.nameTextF];
    [self.view addSubview:line];
    [self.view addSubview:self.idNumberTextF];
    [self.view addSubview:line1];
    [self.view addSubview:self.label];
    [self.view addSubview:self.imageV];
    [self.view addSubview:self.label1];
    [self.view addSubview:self.label2];
    [self.view addSubview:self.imageV1];
    [self.view addSubview:self.label3];
    [self.view addSubview:self.button];
    
    CGFloat width = [self calculateRowWidth:@"身份证号" withFont:17];
    [self.nameTextF creatLeftView:FRAME(0, 0, width, 50) AndTitle:@"姓名" TextAligment:NSTextAlignmentLeft Font:SetFont(17) Color:[UIColor blackColor]];
    
    [self.idNumberTextF creatLeftView:FRAME(0, 0, width, 50) AndTitle:@"身份证号" TextAligment:NSTextAlignmentLeft Font:SetFont(17) Color:[UIColor blackColor]];
    
    __weak typeof(self) weakSelf = self;
    [self.nameTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
        make.right.equalTo(weakSelf.view.mas_right).offset(-15);
        make.height.mas_equalTo(@(50));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameTextF.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(1));
    }];
    
    [self.idNumberTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(weakSelf.nameTextF.mas_left);
        make.size.equalTo(weakSelf.nameTextF);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.idNumberTextF.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(1));
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(35);
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
    }];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.label.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.label.mas_left).offset(30);
        make.size.mas_equalTo(CGSizeMake(200, 100));
    }];
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imageV.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.imageV.mas_centerX);
    }];
    
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.label1.mas_bottom).offset(30);
        make.left.equalTo(weakSelf.label.mas_left);
    }];
    
    [self.imageV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.label2.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.imageV.mas_left);
        make.size.mas_equalTo(CGSizeMake(200, 100));
    }];
    
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imageV1.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.imageV1.mas_centerX);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(44));
    }];
    
}

//选择图片
- (void)chooseImage:(UITapGestureRecognizer *)tap {
    self.chooseTag = tap.view.tag;
    [self hx_presentAlbumListViewControllerWithManager:self.manager delegate:self];
}

//”确定“按钮绑定方法
- (void)commitInformation {
    [self submitPersonInfoToService];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//懒加载相册管理类
- (HXPhotoManager *)manager {
    if (_manager == nil) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = NO;
        _manager.configuration.maxNum = 1;
        _manager.configuration.photoMaxNum = 1;
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

#pragma mark ---- HXDelegate
- (void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model {
    NSLog(@"done-------------------------------");
    
}

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    NSLog(@"++++++++++++++++++++++++++++++++++++ %ld", self.chooseTag);
    __weak typeof(self) weakSelf = self;
    //获取图片
    [self.toolManger getSelectedImageList:photoList success:^(NSArray<UIImage *> *imageList) {
        if (weakSelf.chooseTag == 100) {
            weakSelf.imageV.image = imageList.firstObject;
            weakSelf.IDCardImage = imageList.firstObject;
        }else {
            weakSelf.imageV1.image = imageList.firstObject;
        }
        [self.manager clearSelectedList];
    } failed:^{
        
    }];
}

- (void)submitPersonInfoToService {
    if (!self.nameTextF || !self.idNumberTextF || ![self checkUserID:self.idNumberTextF.text]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入完整信息"];
        return;
    }
    NSString *url = @"https://zbt.change-word.com/index.php/home/member/rz";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"id_card" : self.idNumberTextF.text,
                            @"real_name" : self.nameTextF.text
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(weakSelf.IDCardImage, 0.1);
        [formData appendPartWithFileData:imageData name:@"id_photo[]" fileName:@"image.png" mimeType:@"image/jpg/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject === %@", responseObject);
        if ([responseObject[@"resultCode"] integerValue] == 1) {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"认证成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"认证失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"认证失败"];
    }];
}

- (BOOL)checkUserID:(NSString *)userID
{
    //长度不为18的都排除掉
    if (userID.length!=18) {
        return NO;
    }
    
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL flag = [identityCardPredicate evaluateWithObject:userID];
    
    if (!flag) {
        return flag;    //格式错误
    }else {
        //格式正确在判断是否合法
        
        //将前17位加权因子保存在数组里
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++)
        {
            NSInteger subStrIndex = [[userID substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            
            idCardWiSum+= subStrIndex * idCardWiIndex;
            
        }
        
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        
        //得到最后一位身份证号码
        NSString * idCardLast= [userID substringWithRange:NSMakeRange(17, 1)];
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2)
        {
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
            {
                return YES;
            }else
            {
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
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
