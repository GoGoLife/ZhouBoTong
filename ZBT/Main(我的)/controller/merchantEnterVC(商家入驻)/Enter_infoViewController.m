//
//  Enter_infoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/19.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Enter_infoViewController.h"
#import "Globefile.h"
#import "HXPhotoPicker.h"

@interface Enter_infoViewController ()<HXAlbumListViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HXPhotoManager *manager;

//图片获取
@property (nonatomic, strong) HXDatePhotoToolManager *toolManager;

//营业执照
@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UITextView *textV;

@property (nonatomic, strong) UIImage *selectImage;

@end

@implementation Enter_infoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 44, 0));
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitToService) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.leftTitleArray.count;
    }
    return 1;
}

StringWidth();
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [self calculateRowWidth:@"电子邮件" withFont:14];
    if (indexPath.section == 0) {
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textF.textAlignment = NSTextAlignmentRight;
        cell.textF.font = SetFont(14);
        [cell layoutIfNeeded];
        cell.textF.placeholder = self.placeholderArray[indexPath.row];
        CGFloat height = cell.textF.bounds.size.height;
        [cell.textF creatLeftView:FRAME(0, 0, width, height) AndTitle:self.leftTitleArray[indexPath.row] TextAligment:NSTextAlignmentLeft Font:SetFont(14) Color:[UIColor blackColor]];
        return cell;
    }else if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"first"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] init];
        label.font = SetFont(14);
        label.text = @"营业执照";
        
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:self.imageV];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).offset(5);
            make.left.equalTo(cell.contentView.mas_left).offset(5);
        }];
        
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_top);
            make.left.equalTo(cell.contentView.mas_left).offset(80);
            make.right.equalTo(cell.contentView.mas_right).offset(-5);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-5);
        }];
        return cell;
    }else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"second"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] init];
        label.font = SetFont(14);
        label.text = @"描述信息";
        
        self.textV = [[UITextView alloc] init];
        self.textV.text = @"请输入描述信息";
        ViewBorderRadius(self.textV, 0.0, 0.5, [UIColor grayColor]);
        
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:self.textV];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).offset(5);
            make.left.equalTo(cell.contentView.mas_left).offset(5);
        }];
        
        [self.textV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_top);
            make.left.equalTo(label.mas_right).offset(10);
            make.right.equalTo(cell.contentView.mas_right).offset(-5);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-5);
        }];
        return cell;
    }
}

- (UIImageView *)imageV {
    if (_imageV == nil) {
        _imageV = [[UIImageView alloc] init];
        _imageV.image = [UIImage imageNamed:@"RZAdd"];
    }
    return _imageV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50.0;
    }
    return 120.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [self hx_presentAlbumListViewControllerWithManager:self.manager delegate:self];
    }
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

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    self.toolManager = [[HXDatePhotoToolManager alloc] init];
    __weak typeof(self) weakSelf = self;
    NSLog(@"manager == %@", self.toolManager);
    [self.toolManager getSelectedImageList:photoList success:^(NSArray<UIImage *> *imageList) {
        weakSelf.selectImage = imageList.firstObject;
        weakSelf.imageV.image = weakSelf.selectImage;
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    } failed:^{
        
    }];
}

- (void)submitToService {
    if (!self.type) {
        return;
    }
    NSString *username = [self getCellForTabelview:[NSIndexPath indexPathForRow:0 inSection:0]].textF.text;
    NSString *phone = [self getCellForTabelview:[NSIndexPath indexPathForRow:1 inSection:0]].textF.text;
    NSString *mailbox = [self getCellForTabelview:[NSIndexPath indexPathForRow:2 inSection:0]].textF.text;
    NSString *address = [self getCellForTabelview:[NSIndexPath indexPathForRow:3 inSection:0]].textF.text;
    
    if ([username isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入姓名"];
        return;
    }else if ([phone isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入电话"];
        return;
    }else if ([mailbox isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入邮箱"];
        return;
    }else if ([address isEqualToString:@""]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入地址"];
        return;
    }
    NSString *url = @"https://zbt.change-word.com/index.php/home/join/addJoin";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary *parme = @{
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"username" : username,
                            @"phone" : phone,
                            @"address" : address,
                            @"mailbox" : mailbox,
                            @"type" : @(self.type),
                            @"info" : self.textV.text
                            };
    
    __weak typeof(self) weakSelf = self;
    NSData *imageData = UIImageJPEGRepresentation(self.selectImage, 0.1);
    [manager POST:url parameters:parme constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"photo" fileName:@"zhizhao.png" mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *strData = responseObject;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"parme === %@", parme);
        NSLog(@"%@", dic);
        if (dic[@"resultMsg"]) {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"申请成功"];
//            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"申请失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"申请失败"];
        NSLog(@"error === %@", error);
    }];
}

- (CustomTableViewCell *)getCellForTabelview:(NSIndexPath *)indexPath {
    return (CustomTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
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
