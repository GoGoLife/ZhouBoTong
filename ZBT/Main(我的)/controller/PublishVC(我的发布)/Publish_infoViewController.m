//
//  Publish_infoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/6/12.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "Publish_infoViewController.h"
#import "Globefile.h"
#import "AddCartsView.h"
#import "Boat_OrderInfoViewController.h"
#import "ShowHUDView.h"
#import "Edit_InfoViewController.h"

@interface Publish_infoViewController ()

@property (nonatomic, strong) AddCartsView *addView;

@end

@implementation Publish_infoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布详情";
    
    if (self.isEdit) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editContent)];
        self.navigationItem.rightBarButtonItem = right;
    }
    
    // Do any additional setup after loading the view.
    __weak typeof(self) weakSelf = self;
    
    [self.button removeFromSuperview];
    if (self.isShowBottomView) {
        self.addView = [[AddCartsView alloc] init];
        [self.addView.DPButton setHidden:YES];
        [self.addView.KFButton setHidden:YES];
        self.addView.AddCartsButton.hidden = YES;
        [self.addView.PayButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.addView];
        
        [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view.mas_bottom);
            make.left.equalTo(weakSelf.view.mas_left);
            make.right.equalTo(weakSelf.view.mas_right);
            make.height.mas_equalTo(@(44));
        }];
    }else {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
}

- (void)editContent {
    Edit_InfoViewController *edit = [[Edit_InfoViewController alloc] init];
    edit.dataDic = self.dataDic;
    edit.publish_type = self.publish_type;
    [self.navigationController pushViewController:edit animated:YES];
}

//跳转购买订单详情
- (void)payAction:(UIButton *)button {
    Boat_OrderInfoViewController *order = [[Boat_OrderInfoViewController alloc] init];
    order.dataDic = self.dataDic;
    order.isShowAway = YES;
    order.order_type = @"3";
    order.number = @"1";
    [self.navigationController pushViewController:order animated:YES];
}

//添加商品到购物车
- (void)addCarsTOService {
    NSLog(@"dataDic === %@", self.dataDic);
    NSString *url = @"https://zbt.change-word.com/index.php/home/Shopping/addShoppingCart";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"merchant_id" : self.dataDic[@"member_id"],
                            @"goods_id" : self.dataDic[@"buy_id"],
                            @"goods_number" : @"1"
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"添加商品到购物车 === %@", responseObject);
        if ([responseObject[@"resultCode"] integerValue] == 1) {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"添加成功"];
        }else {
            NSString *string = responseObject[@"resultMsg"];
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:string];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"添加失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
