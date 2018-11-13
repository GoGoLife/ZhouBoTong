//
//  ChangeInfoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ChangeInfoViewController.h"
#import "CustomTableViewCell.h"
#import "Globefile.h"
#import <Masonry.h>

#import "ChangeNameViewController.h"
#import "SelectAddressViewController.h"
#import "CustomPickerView.h"
#import "HXPhotoPicker.h"

#import "ShowHUDView.h"

@interface ChangeInfoViewController ()<UITableViewDelegate, UITableViewDataSource, HXAlbumListViewControllerDelegate, HXCustomCameraViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HXPhotoManager *manager;

//图片获取
@property (nonatomic, strong) HXDatePhotoToolManager *toolManager;

@property (nonatomic, strong) UIImageView *img;

@property (nonatomic, strong) UIView *headerView;

//保存年月日
@property (nonatomic, strong) NSMutableArray *yearArr;

@property (nonatomic, strong) NSMutableArray *monthArr;

@property (nonatomic, strong) NSMutableArray *dayArr;

@property (nonatomic, strong) UIImage *userImage;

@end

@implementation ChangeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = NO;
    
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 44, 0));
    }];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundColor:SetColor(24, 147, 219, 1)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitPersonInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tableView.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    [self setUpNav];
    
    //整理年月日数据
    [self setDateArray];
}

setBack();
pop();

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textF.font = SetFont(14);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.leftString = @[@"姓名", @"性别", @"出生日期", @"收货地址"][indexPath.row];
    cell.textF.placeholder = @[@"未填写", @"未选择", @"未选择", @"未添加地址"][indexPath.row];
    if (self.dataDic) {
        NSString *address = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAddress"] == nil ? @"请选择地址" : [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAddress"];
        NSArray *dataArr = @[isNullClass(self.dataDic[@"member_name"]), isNullClass(self.dataDic[@"sex"]), isNullClass(self.dataDic[@"birthday"]), address];
        cell.textF.placeholder = dataArr[indexPath.row];
    }
    cell.textF.enabled = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return InfoCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80.0;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 80)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        _headerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage)];
        tap.numberOfTapsRequired = 1;
        [_headerView addGestureRecognizer:tap];
        
        UILabel *headerLabel = [[UILabel alloc] init];
        headerLabel.font = SetFont(14);
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.text = @"头像";
        
        self.img = [[UIImageView alloc] init];
        //    self.img.backgroundColor = RandomColor;
        [self.img sd_setImageWithURL:self.dataDic[@"head_photo"]];
        ViewRadius(self.img, 30);
        
        [_headerView addSubview:headerLabel];
        [_headerView addSubview:self.img];
        
        __weak typeof(self) weakSelf = self;
        [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.headerView.mas_centerY);
            make.left.equalTo(weakSelf.headerView.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake((SCREENBOUNDS.width - 30) / 2, 40));
        }];
        
        [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.headerView.mas_centerY);
            make.right.equalTo(weakSelf.headerView.mas_right).offset(-40);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    }
    return _headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 80)];
    [view addSubview:self.headerView];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0:                              //修改姓名
        {
            ChangeNameViewController *change = [[ChangeNameViewController alloc] init];
            change.returnNameString = ^(NSString *string) {
                [weakSelf getCellForIndexPath:indexPath].textF.text = string;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:change animated:YES];
        }
            break;
        case 1:                             //修改性别
        {
            CustomPickerView *pick = [[CustomPickerView alloc] initWithFrame:FRAME(0, SCREENBOUNDS.height - 200 - 64, SCREENBOUNDS.width, 200)];
            pick.dataArray = @[@[@"男", @"女"]];
            NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
            pick.returnSelectData = ^(NSArray *arr) {
                for (NSString *string in arr) {
                    NSInteger index = [string integerValue];
                    [result addObject:@[@"男", @"女"][index]];
                }
                [weakSelf getCellForIndexPath:indexPath].textF.text = result.firstObject;
                [weakSelf.tableView reloadData];
            };
            [self.view addSubview:pick];
            
        }
            break;
        case 2:                             //修改出生日期
        {
            CustomPickerView *pick = [[CustomPickerView alloc] initWithFrame:FRAME(0, SCREENBOUNDS.height - 200 - 64, SCREENBOUNDS.width, 200)];
            pick.dataArray = [self setDateArray];
            __block NSString *resultStr = @"";
            pick.returnSelectData = ^(NSArray *arr) {
                for (NSInteger index = 0; index < arr.count; index++) {
                    NSInteger i = [arr[index] integerValue];
                    resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"%@-", [self setDateArray][index][i]]];
                }
                [weakSelf getCellForIndexPath:indexPath].textF.text = [resultStr substringToIndex:resultStr.length - 1];
                [weakSelf.tableView reloadData];
            };
            [self.view addSubview:pick];
        }
            break;
        case 3:                             //修改收货地址
        {
            SelectAddressViewController *address = [[SelectAddressViewController alloc] init];
//            address.returnAddress = ^(NSString *string) {
//                [weakSelf getCellForIndexPath:indexPath].textF.text = string;
//                [weakSelf.tableView reloadData];
//            };
            address.returnAddress = ^(NSString *string, NSString *name, NSString *phone) {
                [weakSelf getCellForIndexPath:indexPath].textF.text = string;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:address animated:YES];
        }
            break;
            
        default:
            break;
    }
}

//选择image
- (void)chooseImage {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [weakSelf.view showImageHUDText:@"此设备不支持相机!"];
            return;
        }
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在设置-隐私-相机中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action1];
            [weakSelf presentViewController:alert animated:YES completion:nil];
            return;
        }
        [weakSelf hx_presentCustomCameraViewControllerWithManager:weakSelf.manager done:^(HXPhotoModel *model, HXCustomCameraViewController *viewController) {
            [weakSelf.manager afterListAddCameraTakePicturesModel:model];
        } cancel:^(HXCustomCameraViewController *viewController) {

        }];

    }];

    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf hx_presentAlbumListViewControllerWithManager:self.manager delegate:self];
    }];

    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
}


//懒加载相册管理类
- (HXPhotoManager *)manager {
    if (_manager == nil) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        _manager.configuration.maxNum = 1;
        _manager.configuration.photoMaxNum = 1;
        _manager.configuration.saveSystemAblum = YES;
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
//    NSLog(@"done-------------------------------");    
    NSData *data = UIImagePNGRepresentation(model.thumbPhoto);
    self.img.image = [UIImage imageWithData:data];
    [self.tableView reloadData];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userImage"];
}

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    __weak typeof(self) weakSelf = self;
    [self.toolManger getSelectedImageList:photoList success:^(NSArray<UIImage *> *imageList) {
        NSData *data = UIImagePNGRepresentation(imageList.firstObject);
        weakSelf.img.image = [UIImage imageWithData:data];
        [weakSelf.tableView reloadData];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userImage"];
        self.userImage = imageList.firstObject;
    } failed:^{

    }];
}

// 获取cell
- (CustomTableViewCell *)getCellForIndexPath:(NSIndexPath *)indexPath {
    return (CustomTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
}

//设置年月日
- (NSArray *)setDateArray {
    self.yearArr = [NSMutableArray arrayWithCapacity:1];
    self.monthArr = [NSMutableArray arrayWithCapacity:1];
    self.dayArr = [NSMutableArray arrayWithCapacity:1];
    
    NSDate *date = [NSDate date];
    NSString *stringF = @"YYYY";
    NSString *dateString = [date dateStringWithFormat:stringF];
    NSInteger dateInteger = [dateString integerValue];
    
    for (NSInteger index = dateInteger - 100 ; index < dateInteger + 10; ++index) {
        [self.yearArr addObject:[NSString stringWithFormat:@"%ld", index]];
    }
    
    
    for (NSInteger index = 1; index <= 12; index++) {
        [self.monthArr addObject:[NSString stringWithFormat:@"%ld", index]];
    }
    
    //获取每月天数
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    NSUInteger numberOfDaysInMonth = range.length;
    
    for (NSInteger index = 1; index <= numberOfDaysInMonth; index++) {
        [self.dayArr addObject:[NSString stringWithFormat:@"%ld", index]];
    }
    
    return @[[self.yearArr mutableCopy], [self.monthArr mutableCopy], [self.dayArr mutableCopy]];
}

//上传个人信息
- (void)submitPersonInfo {
    __weak typeof(self) weakSelf = self;
    //AFURLResponseSerialization
    //http://45.77.244.195/index.php/home/Member/changeMemberInfo
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary *parme = @{
                            @"phone" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account"],
                            @"member_name" : [self getCellForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].textF.text ?: @"",
                            @"sex" : [self getCellForIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].textF.text ?: @"",
                            @"birthday" : [self getCellForIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]].textF.text ?: @""
                            };
    
    NSData *imageData = UIImageJPEGRepresentation(self.userImage, 0.1);
    [manager POST:@"https://zbt.change-word.com/index.php/home/Member/changeMemberInfo" parameters:parme constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (self.userImage) {
            [formData appendPartWithFileData:imageData name:@"head_photo" fileName:@"header.png" mimeType:@"image/png"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *strData = responseObject;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", dic);
        if (dic[@"resultCode"]) {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
