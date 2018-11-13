//
//  SettingViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/6.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "Globefile.h"
#import "ChangePasswordViewController.h"
#import "callAcitonView.h"
#import <Hyphenate/Hyphenate.h>
#import "AboutUSViewController.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tableView;
    NSString *cacheString;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"设置";
    
    tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:@"setting"];
    DropView(tableView);
    
    [self.view addSubview:tableView];
    
    __weak typeof(self) weakSelf = self;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //计算缓存
    CGFloat cache = [self folderSize];
    cacheString = [NSString stringWithFormat:@"%.2fM", cache];
    
    [self setUpNav];
    
    NSLog(@"bool === %d", [isNullClass([[NSUserDefaults standardUserDefaults] objectForKey:@"LoginWay"]) isEqualToString:@""]);
    NSLog(@"string === %@", isNullClass([[NSUserDefaults standardUserDefaults] objectForKey:@"LoginWay"]));
    NSLog(@"string111 === %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginWay"]);
    
}
setBack();
pop();

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LoginWay"] != nil) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LoginWay"] != nil) {
        return 3;
    }else {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 3;
                break;
            default:
                return 0;
                break;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LoginWay"] != nil) {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setting"];
        switch (indexPath.section) {
            case 0:
                cell.leftString = @[@"功能与介绍", @"清除缓存", @"当前版本"][indexPath.row];
                cell.textF.placeholder = @[@"", cacheString, @"1.0"][indexPath.row];
                break;
            default:
                break;
        }
        return cell;
    }else {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setting"];
        switch (indexPath.section) {
            case 0:
                cell.leftString = @"修改密码";
                break;
            case 1:
                cell.leftString = @[@"功能与介绍", @"清除缓存", @"当前版本"][indexPath.row];
                cell.textF.placeholder = @[@"", cacheString, @"1.0"][indexPath.row];
                break;
                
            default:
                break;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LoginWay"] != nil) {
        if (section == 0) {
            return 74.0;
        }
    }else {
        if (section == 1) {
            return 74.0;
        }
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LoginWay"] != nil) {
        if (section == 0) {
            UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 74)];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor redColor]];
            [button setTitle:@"退出登录" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
            ViewRadius(button, 5.0);
            
            [view addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view).insets(UIEdgeInsetsMake(30, 15, 0, 15));
            }];
            return view;
        }
    }else {
        if (section == 1) {
            UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 74)];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor redColor]];
            [button setTitle:@"退出登录" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
            ViewRadius(button, 5.0);
            
            [view addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view).insets(UIEdgeInsetsMake(30, 15, 0, 15));
            }];
            return view;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LoginWay"] != nil) {
        switch (indexPath.section) {
            case 0:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        AboutUSViewController *about = [[AboutUSViewController alloc] init];
                        [self.navigationController pushViewController:about animated:YES];
                    }
                        break;
                    case 1:
                    {
                        //清除缓存
                        [self removeCache];
                    }
                        
                        break;
                    case 2:
                        
                        break;
                        
                    default:
                        break;
                }
            }
                break;
                
            default:
                break;
        }
    }else {
        switch (indexPath.section) {
            case 0:
            {
                ChangePasswordViewController *change = [[ChangePasswordViewController alloc] init];
                [self.navigationController pushViewController:change animated:YES];
            }
                break;
            case 1:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        AboutUSViewController *about = [[AboutUSViewController alloc] init];
                        [self.navigationController pushViewController:about animated:YES];
                    }
                        break;
                    case 1:
                    {
                        //清除缓存
                        [self removeCache];
                    }
                        
                        break;
                    case 2:
                        
                        break;
                        
                    default:
                        break;
                }
            }
                break;
                
            default:
                break;
        }
    }
}

// 计算缓存大小
- (CGFloat)folderSize{
    CGFloat folderSize = 0.0;
    
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
    
    //获取所有文件的数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    NSLog(@"文件数：%ld",files.count);
    
    for(NSString *path in files) {
        
        NSString*filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        
        //累加
        folderSize += [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    //转换为M为单位
    CGFloat sizeM = folderSize /1024.0/1024.0;
    
    return sizeM;
}

- (void)removeCache{
    //===============清除缓存==============
    //获取路径
    NSString*cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    
    //返回路径中的文件数组
    NSArray*files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    NSLog(@"文件数：%ld",[files count]);
    for(NSString *p in files){
        NSError*error;
        
        NSString* path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",p]];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            BOOL isRemove = [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
            if(isRemove) {
                NSLog(@"清除成功");
                //这里发送一个通知给外界，外界接收通知，可以做一些操作（比如UIAlertViewController）
                cacheString = @"0.0M";
//                [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                [tableView reloadData];
                
            }else{
                NSLog(@"清除失败");
            }
        }
    }
}

// 退出登录
- (void)logOut {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate setLoginVC];
    [[EMClient sharedClient] logout:YES];
    [self removeCache];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"account_id"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"LoginWay"];
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
