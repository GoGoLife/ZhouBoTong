//
//  EquipmentInfoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/15.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "EquipmentInfoViewController.h"
#import "MarchantInfoViewController.h"
#import "Boat_OrderInfoViewController.h"
#import "AllArticleViewController.h"
#import "ShowHUDView.h"
#import "StandardsView.h"
#import "callAcitonView.h"
#import "EaseUI.h"
#import <Hyphenate/Hyphenate.h>
#import "ChatViewController.h"
#import "URLImageScroll.h"
#import <UShareUI/UShareUI.h>


@interface EquipmentInfoViewController ()
{
    UIView *backgroundView;
}

@end

@implementation EquipmentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    // Do any additional setup after loading the view.
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gouwuzhou1"] style:UIBarButtonItemStylePlain target:self action:@selector(pushShoppingCar)];
    self.navigationItem.rightBarButtonItem = right;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[EquipmentTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerClass:[PlayVideo_TableViewCell class] forCellReuseIdentifier:@"playCell"];
    
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-44);
    }];
    
    self.addView = [[AddCartsView alloc] init];
    [self.addView.DPButton addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
    [self.addView.PayButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.addView.AddCartsButton addTarget:self action:@selector(addCarsTOService) forControlEvents:UIControlEventTouchUpInside];
    [self.addView.KFButton addTarget:self action:@selector(pushChatView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addView];
    
    [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(@(44));
    }];
    
    [self setUpNav];
    
    [self getDetailsInfo_goods];
    
}

//右上角跳转购物车
- (void)pushShoppingCar {
    self.tabBarController.selectedIndex = 3;
}

//跳转店铺详情
- (void)pushVC {
    AllArticleViewController *article = [[AllArticleViewController alloc] init];
    article.merchant_id = self.dataDic[@"merchant_id"];
    [self.navigationController pushViewController:article animated:YES];
}

//跳转购买订单详情
- (void)payAction:(UIButton *)button {
    NSString *isRZ = [[NSUserDefaults standardUserDefaults] objectForKey:@"isRZ"];
    //判断用户是否认证
    if (![isRZ integerValue]) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前用户未实名认证，请去(个人中心)完成认证"  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.tabBarController.selectedIndex = 4;
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    Boat_OrderInfoViewController *order = [[Boat_OrderInfoViewController alloc] init];
    order.dataDic = self.dataDic;
    order.isShowAway = YES;
    order.number = @"1";
    order.order_type = self.type == 1 ? @"1" : (self.type == 2 ? @"2" : @"3");
    order.after_type = self.type == 2 ? 4 : 0;
    [self.navigationController pushViewController:order animated:YES];
}

//跳转单聊界面
- (void)pushChatView {
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:@"15864853159" conversationType:EMConversationTypeChat];
    chatController.title = @"聊天";
    [self.navigationController pushViewController:chatController animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            
            break;
        case 1:
        {
            EquipmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            switch (indexPath.row) {
                case 0:
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [cell.textF creatLeftView:FRAME(0, 0, [self calculateRowWidth:@"规格/数量" withFont:14], 60) AndTitle:@"规格/数量" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:[UIColor blackColor]];
                    [cell.textF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"选择规格" withFont:14], 60) AndTitle:@"查看规格" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:SetColor(147, 147, 147, 1)];
                }
                    break;
                case 1:
                {
                    cell.textF.font = SetFont(14);
                    NSString *fee = [isNullClass(self.dataDic[@"merchant"]) isEqualToString:@""] ? @"" : self.dataDic[@"merchant"][@"distribution_fee"];
                    cell.textF.text = [NSString stringWithFormat:@"￥%@", fee];//@"¥2000";
                    [cell.textF creatLeftView:FRAME(0, 0, [self calculateRowWidth:@"配送费：" withFont:14], 60) AndTitle:@"配送费：" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:[UIColor blackColor]];
                }
                    break;
                default:
                    break;
            }
            return cell;
            
        }
            break;
        case 2:
        {
            EquipmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSString *name = [isNullClass(self.dataDic[@"merchant"]) isEqualToString:@""] ? @"" : self.dataDic[@"merchant"][@"merchant_name"];
            cell.textF.text = [NSString stringWithFormat:@"    %@", name];//@"    阿波罗11号店";
            [cell.textF creatLeftView:FRAME(0, 0, 20, 20) AndImage:[UIImage imageNamed:@"dianpu"]];
            [cell.textF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"一键拨号" withFont:14], 60) AndTitle:@"一键拨号" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:SetColor(147, 147, 147, 1)];
            return cell;
        }
            break;
        case 3:
        {
            PlayVideo_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.info_string = self.dataDic[@"describe"];
            cell.info_label.text = self.dataDic[@"describe"];
            cell.video_URLString = isNullClass(self.dataDic[@"video"]);
            return cell;
        }
            break;
            
        default:
            
            break;
    }
    return nil;
}

StringHeight();
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        NSString *string = self.dataDic[@"describe"] ?: self.dataDic[@"info"];
        CGFloat info_height = [self calculateRowHeight:string fontSize:14 withWidth:SCREENBOUNDS.width - 10];
        return 200 + 20 + info_height;
    }
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 100.0;
    }else if (section == 0 || section == 2) {
        return 0.0;
    }
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 200;
    }
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        GroupBuyView *view = [[GroupBuyView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 100)];
        if ([self.dataDic[@"is_collection"] integerValue]) {
            view.collectBtn.backgroundColor = BaseViewColor;
            [view.collectBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [view.collectBtn setTitle:@"已收藏" forState:UIControlStateNormal];
        }
        //收藏
        [view.collectBtn addTarget:self action:@selector(collectGoods) forControlEvents:UIControlEventTouchUpInside];
        //分享
        [view.shareBtn addTarget:self action:@selector(shareAction_Equipment) forControlEvents:UIControlEventTouchUpInside];
        view.backgroundColor = [UIColor whiteColor];
        view.isNewLayout = YES;
        view.topTextF.text = self.dataDic[@"goods_name"];
        view.priceLeftString = [NSString stringWithFormat:@"¥%@", self.dataDic[@"goods_price"]];
        view.remarkLabel.font = SetFont(12);
        view.remarkLabel.text = @"已售0件";
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@", self.dataDic[@"original_price"]] attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)}];
        view.priceTextF.attributedText = attrStr;
        return view;
    }else if(section == 3) {
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(15, 0, SCREENBOUNDS.width - 15, 40)];
        label.font = SetFont(12);
        label.textColor = SetColor(165, 165, 165, 1);
        label.text = @"详细信息";
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
//        LoopView *loopV = [[LoopView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 200)];
//        loopV.imageArray = @[@"1", @"2", @"3", @"4"];
//        return loopV;
        URLImageScroll *scrollV = [[URLImageScroll alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 200) withImageArray:self.dataDic[@"photo"]];
        return scrollV;
    }
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 10)];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 0) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        backgroundView = [[UIView alloc] initWithFrame:delegate.window.bounds];
        backgroundView.backgroundColor = SetColor(189, 189, 189, 0.5);
        backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
        [backgroundView addGestureRecognizer:tap];
        [delegate.window addSubview:backgroundView];
        [self showView:backgroundView];
    }
    
    if (indexPath.section == 2) {
        [callAcitonView showCallActionWithTitle:self.dataDic[@"merchant"][@"shop_phone"] AndShowView:self];
    }
}

- (void)showView:(UIView *)view {
    StandardsView *bottomV = [[StandardsView alloc] init];
    bottomV.addButton.hidden = YES;
    bottomV.subtractButton.hidden = YES;
    bottomV.backgroundColor = [UIColor whiteColor];
    [bottomV.leftImageV sd_setImageWithURL:[NSURL URLWithString:[self.dataDic[@"photo"] firstObject]] placeholderImage:[UIImage imageNamed:@"public"]];
    bottomV.topLabel.text = [NSString stringWithFormat:@"¥%@", self.dataDic[@"goods_price"]];
    bottomV.bottomTextF.text = [NSString stringWithFormat:@"¥%@", self.dataDic[@"original_price"]];
    [bottomV.payButton addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bottomV];
    __weak typeof(self) weakSelf = self;
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(@(280));
    }];
}

- (void)hiddenView {
    [backgroundView removeFromSuperview];
}

- (void)removeView:(UITapGestureRecognizer *)tap {
    [backgroundView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

StringWidth();

- (void)removeButtonTarget {
    [self.addView.DPButton removeTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
}

//收藏商品
- (void)collectGoods {
    NSString *url = @"https://zbt.change-word.com/index.php/home/Collection/addGoodsCollection";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"phone" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account"],
                            @"goods_id" : self.goods_id
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"收藏成功"];
        [weakSelf getDetailsInfo_goods];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)getDetailsInfo_goods {
    NSLog(@"goods_id ==== %@", self.goods_id);
    if (!self.goods_id) {
        NSLog(@"fasfasdfasfasfad");
        return;
    }
    NSLog(@"12321414443reytrrt");
    NSString *url = @"https://zbt.change-word.com/index.php/home/goods/goodsDetail";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"phone" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account"],
                            @"goods_id" : self.goods_id};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"GoodsDetails === %@", responseObject);
        weakSelf.dataDic = (NSDictionary *)responseObject[@"data"];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error == %@", error);
    }];
}

//添加商品到购物车
- (void)addCarsTOService {
    NSLog(@"dataDic === %@", self.dataDic);
    NSString *url = @"https://zbt.change-word.com/index.php/home/Shopping/addShoppingCart";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"merchant_id" : self.dataDic[@"merchant"][@"merchant_id"],
                            @"goods_id" : self.dataDic[@"goods_id"],
                            @"goods_number" : @"1"
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"添加商品到购物车 === %@", responseObject);
        if ([responseObject[@"resultCode"] integerValue] == 1) {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"添加购物车成功"];
        }else {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:responseObject[@"resultMsg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"添加购物车失败"];
    }];
}

- (void)shareAction_Equipment {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        switch (platformType) {
            case UMSocialPlatformType_QQ:
            {
                NSLog(@"分享到QQ!!");
                [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
                //                                [self shareTextToPlatformType:UMSocialPlatformType_QQ];
            }
                break;
            case UMSocialPlatformType_Qzone:
            {
                NSLog(@"分享到QQ空间!!");
                //                                [self shareTextToPlatformType:UMSocialPlatformType_Qzone];
                [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
            }
                break;
            case UMSocialPlatformType_WechatSession:
            {
                NSLog(@"分享到微信!!");
                //                                [self shareTextToPlatformType:UMSocialPlatformType_WechatSession];
                [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
            }
                break;
            case UMSocialPlatformType_WechatTimeLine:
            {
                NSLog(@"分享到朋友圈!!");
                //                                [self shareTextToPlatformType:UMSocialPlatformType_WechatTimeLine];
                [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
            }
                break;
                
                
            default:
                break;
        }
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
//    NSString* thumbURL =  @"https://zbt.change-word.com/Public/20180830101912.png";
    NSString *thumbURL = [self.dataDic[@"photo"] firstObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.dataDic[@"goods_name"] descr:self.dataDic[@"describe"] thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = [@"https://itunes.apple.com/us/app/舟博通/id1237486832?l=zh&ls=1&mt=8" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
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
