//
//  AddAddressViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/8.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "AddAddressViewController.h"
#import "Globefile.h"
#import "selectAddressPicker.h"
#import <BMKLocationKit/BMKLocationComponent.h>
#import "ShowHUDView.h"

#import "CustomTableViewCell.h"

@interface AddAddressViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, BMKLocationManagerDelegate, UITextFieldDelegate>
{
    NSInteger isDefault;   //是否是默认地址
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) selectAddressPicker *pickerView;

//记录收货地址
@property (nonatomic, strong) NSString *addressString;

@property (nonatomic, strong) NSString *infoAddress;

@property (nonatomic, strong) BMKLocationManager *manager;

//整理过后的地址信息数据   方便显示
@property (nonatomic, strong) NSMutableArray *changeData;

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加收货地址";
    self.changeData = [@[@"", @"", @"", @""] mutableCopy];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    DropView(self.tableView);
    self.tableView.scrollEnabled = NO;
    
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"address"];
    
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setBackgroundColor:SetColor(251, 70, 74, 1)];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(addShoppingAdress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:saveButton];
    
    __weak typeof(self) weakSelf = self;
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(@(44));
    }];
    
    [self setUpNav];
    
    if (self.dataDic) {
        NSArray *addressArray = [self.dataDic[@"address"] componentsSeparatedByString:@"-"];
        self.changeData = [@[self.dataDic[@"name"], self.dataDic[@"addressee_phone"], addressArray.firstObject, @""] mutableCopy];
        self.addressString = addressArray.firstObject;
    }
}

setBack();
pop();

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"address"];
            cell.textF.delegate = self;
            cell.leftString = @[@"姓名", @"手机", @"收货地址", @"地区"][indexPath.row];
            cell.textF.placeholder = @[@"请填写", @"请填写", @"请选择", @"定位选择"][indexPath.row];
            cell.textF.text = self.changeData[indexPath.row];
            if (indexPath.row == 2 || indexPath.row == 3) {
                cell.textF.enabled = NO;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            return cell;
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            UILabel *label = [[UILabel alloc] init];
            label.font = SetFont(14);
            label.textAlignment = NSTextAlignmentLeft;
            label.text = @"设为默认地址";
            [label sizeToFit];
            
            
            UISwitch *switchView = [[UISwitch alloc] init];
            if ([self.dataDic[@"default_address"] integerValue]) {
                switchView.on = YES;
            }else {
                switchView.on = NO;
            }
            [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:switchView];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).offset(15);
                make.centerY.equalTo(cell.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(100, 40));
            }];
            
            [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-15);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(60, 28));
            }];
            
            return cell;
            
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return InfoCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 100.0;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSArray *addressArray = [self.dataDic[@"address"] componentsSeparatedByString:@"-"];
    
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 100)];
    UITextView *textV = [[UITextView alloc] initWithFrame:view.bounds];
    textV.backgroundColor = [UIColor whiteColor];
    textV.text = addressArray.lastObject ? addressArray.lastObject :@"请填写详细地址";
    self.infoAddress = addressArray.lastObject ?: @"";
    textV.textColor = [UIColor grayColor];
    textV.delegate = self;
    
    [view addSubview:textV];
    return view;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"请填写详细地址"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"请填写详细地址";
        textView.textColor = [UIColor grayColor];
    }else {
        self.infoAddress = textView.text;
    }
}

-(void)switchAction:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"开");
        isDefault = 1;
    }else {
        NSLog(@"关");
        isDefault = 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0 && indexPath.row == 2) {
        [self.view addSubview:self.pickerView];
        _pickerView.stringblockr = ^(NSString *address) {
            weakSelf.addressString = address;
            NSLog(@"address == %@", address);
            [weakSelf.changeData replaceObjectAtIndex:2 withObject:address];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
    }
    
    /*
     ///省份名字属性
     @property(nonatomic, copy, readonly) NSString *province;
     
     ///城市名字属性
     @property(nonatomic, copy, readonly) NSString *city;
     
     ///区名字属性
     @property(nonatomic, copy, readonly) NSString *district;
     */
    if (indexPath.section == 0 && indexPath.row == 3) {
        [self.manager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
            NSLog(@"location === %@", location);
            NSLog(@"state === %d", state);
            NSLog(@"error === %@", error);
            NSLog(@"地址数据 === %@", location.rgcData);
            NSString *string = [NSString stringWithFormat:@"%@/%@/%@", location.rgcData.province,location.rgcData.city,location.rgcData.district];
            weakSelf.addressString = string;
//            [self getTabelViewCell:[NSIndexPath indexPathForRow:3 inSection:0]].textF.text = string;
            [weakSelf.changeData replaceObjectAtIndex:3 withObject:string];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
}

- (CustomTableViewCell *)getTabelViewCell:(NSIndexPath *)indexPath {
    return (CustomTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
}

//添加收货地址
- (void)addShoppingAdress {
    [self.view endEditing:YES];
    NSLog(@"info ==== %@", self.infoAddress);
    __weak typeof(self) weakSelf = self;
    if (self.isChange) {
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        NSDictionary *parame = @{
                                 @"id" : self.Address_id,
                                 @"address" : [NSString stringWithFormat:@"%@-%@", self.addressString, self.infoAddress],
                                 @"name" : [self getTabelViewCell:[NSIndexPath indexPathForRow:0 inSection:0]].textF.text,
                                 @"addressee_phone" : [self getTabelViewCell:[NSIndexPath indexPathForRow:1 inSection:0]].textF.text,
                                 @"default_address" : [NSString stringWithFormat:@"%ld", isDefault]
                                 };
        NSLog(@"parame == %@", parame);
        [manager POST:@"https://zbt.change-word.com/index.php/home/Member/changeAddress" parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"changeAddress ==== %@", responseObject);
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"保存成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"保存失败"];
        }];
        
    }else {
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        NSDictionary *parame = @{
                                 @"phone" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account"],
                                 @"address" : [NSString stringWithFormat:@"%@-%@", self.addressString, self.infoAddress],
                                 @"name" : [self getTabelViewCell:[NSIndexPath indexPathForRow:0 inSection:0]].textF.text,
                                 @"addressee_phone" : [self getTabelViewCell:[NSIndexPath indexPathForRow:1 inSection:0]].textF.text,
                                 @"default_address" : [NSString stringWithFormat:@"%ld", isDefault]
                                 };
        NSLog(@"parame == %@", parame);
        [manager POST:@"https://zbt.change-word.com/index.php/home/Member/addAddress" parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"保存成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"保存失败"];
        }];
    }
}

- (selectAddressPicker *)pickerView {
    if (!_pickerView) {
        _pickerView = [[selectAddressPicker alloc] initWithFrame:FRAME(0, SCREENBOUNDS.height - 264, SCREENBOUNDS.width, 200)];
    }
    return _pickerView;
}

// 懒加载
- (BMKLocationManager *)manager {
    if (!_manager) {
        _manager = [[BMKLocationManager alloc] init];
        //设置delegate
        _manager.delegate = self;
        //设置返回位置的坐标系类型
        _manager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _manager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _manager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        //        _manager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
        //        _manager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        _manager.locationTimeout = 10;
        //设置获取地址信息超时时间
        _manager.reGeocodeTimeout = 10;
    }
    return _manager;
}

// 隐藏键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
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
