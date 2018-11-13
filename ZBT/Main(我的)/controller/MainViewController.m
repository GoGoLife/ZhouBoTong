//
//  MainViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "MainViewController.h"
#import "Globefile.h"
#import "FirstCollectionViewCell.h"
#import "SecondCollectionViewCell.h"
#import "ThreeCollectionViewCell.h"

#import "HeaderCollectionReusableView.h"

#import "ChangeInfoViewController.h"
#import "FeedbackViewController.h"
#import "SettingViewController.h"

#import "LYSSlideMenuController.h"
#import "AllOrderViewController.h"
#import "WaitPayViewController.h"
#import "WaitSendViewController.h"
#import "WaitGetViewController.h"
#import "WaitEvaluateViewController.h"
#import "DrawbackViewController.h"
#import "Person_OrderViewController.h"
#import "Person_SellOrderViewController.h"

#import "ProductViewController.h"
#import "StoreViewController.h"
#import "HomeCollectionViewCell.h"
#import "EnterViewController.h"

#import "Customzation_OneViewController.h"
#import "Customzation_TwoViewController.h"
#import "AddCustomzationViewController.h"

#import "After_AllOrderViewController.h"
#import "After_WaitFinishViewController.h"
#import "After_FinishViewController.h"
#import "After_WaitEvaluateViewController.h"

#import "Appointment_AllViewController.h"
#import "Appointment_WaitFinishViewController.h"
#import "Appointment_FinishViewController.h"
#import "Appointment_EvaluateViewController.h"

#import "Publish_NeedViewController.h"
#import "Publish_SellViewController.h"

#import "Group_ListViewController.h"
#import "MyWalletViewController.h"

#import "SureRealNameViewController.h"

#import <UShareUI/UShareUI.h>
#import <Hyphenate/Hyphenate.h>
#import "EaseUI.h"
#import "ChatListViewController.h"
#import "callAcitonView.h"

@interface MainViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

//我的订单
@property (nonatomic, strong) LYSSlideMenuController *slideMenu;

//我的收藏
@property (nonatomic, strong) LYSSlideMenuController *CollectMenu;

//我的定制
@property (nonatomic, strong) LYSSlideMenuController *customzationMenu;

//我的售后
@property (nonatomic, strong) LYSSlideMenuController *afterMenu;

//我的预约
@property (nonatomic, strong) LYSSlideMenuController *appointmentMenu;

//我的发布
@property (nonatomic, strong) LYSSlideMenuController *publishMenu;

//个人信息数据
@property (nonatomic, strong) NSDictionary *personData;

@end

@implementation MainViewController

//创建我的订单的全部VC
- (LYSSlideMenuController *)slideMenu {
    //    if (_slideMenu == nil) {
    _slideMenu = [[LYSSlideMenuController alloc] init];
    _slideMenu.title = @"我的订单";
    
    //全部
    //    AllOrderViewController *all = [[AllOrderViewController alloc] init];
    //待付款
    WaitPayViewController *all1 = [[WaitPayViewController alloc] init];
    //待发货
    WaitSendViewController *all2 = [[WaitSendViewController alloc] init];
    //待收货
    WaitGetViewController *all3 = [[WaitGetViewController alloc] init];
    //待评价
    WaitEvaluateViewController *all4 = [[WaitEvaluateViewController alloc] init];
    //退款
    DrawbackViewController *all5 = [[DrawbackViewController alloc] init];
    //个人订单
    Person_OrderViewController *person = [[Person_OrderViewController alloc] init];
    //个人卖出订单
    Person_SellOrderViewController *sell = [[Person_SellOrderViewController alloc] init];
    
    //    _slideMenu.controllers = @[all, all1, all2, all3, all4, all5];
    //    _slideMenu.titles = @[@"全部", @"待付款", @"待发货", @"待收货", @"待评价", @"退款"];
    _slideMenu.controllers = @[person, sell, all1, all2, all3, all4, all5];
    _slideMenu.titles = @[@"已买到", @"已卖出", @"待付款", @"待发货", @"待收货", @"待评价", @"退款"];
    _slideMenu.titleColor = [UIColor blackColor];
    _slideMenu.titleSelectColor = [UIColor blueColor];
    _slideMenu.bottomLineColor = [UIColor blueColor];
    _slideMenu.pageNumberOfItem = 5;
    _slideMenu.bottomLineWidth = (SCREENBOUNDS.width - 20) / 5;
    //    }
    return _slideMenu;
}

//我的收藏
- (LYSSlideMenuController *)CollectMenu {
    _CollectMenu = [[LYSSlideMenuController alloc] init];
    _CollectMenu.title = @"我的收藏";
    //商品收藏
    ProductViewController *product = [[ProductViewController alloc] init];
    //店铺收藏
    StoreViewController *store = [[StoreViewController alloc] init];
    _CollectMenu.controllers = @[product, store];
    _CollectMenu.bottomLineWidth = SCREENBOUNDS.width / 4;
    _CollectMenu.titles = @[@"商品", @"门店"];
    _CollectMenu.titleColor = [UIColor blackColor];
    _CollectMenu.titleSelectColor = [UIColor blueColor];
    _CollectMenu.bottomLineColor = [UIColor blueColor];
    _CollectMenu.pageNumberOfItem = 2;
    return _CollectMenu;
}

//我的定制
- (LYSSlideMenuController *)customzationMenu {
    _customzationMenu = [[LYSSlideMenuController alloc] init];
    _customzationMenu.title = @"我的定制";
    //已发布定制
    Customzation_OneViewController *one = [[Customzation_OneViewController alloc] init];
    //已完成定制
    Customzation_TwoViewController *two = [[Customzation_TwoViewController alloc] init];
    _customzationMenu.controllers = @[one, two];
    _customzationMenu.bottomLineWidth = SCREENBOUNDS.width / 4;
    _customzationMenu.titles = @[@"已购买定制", @"已发布定制"];
    _customzationMenu.titleColor = [UIColor blackColor];
    _customzationMenu.titleSelectColor = [UIColor blueColor];
    _customzationMenu.bottomLineColor = [UIColor blueColor];
    _customzationMenu.pageNumberOfItem = 2;
    return _customzationMenu;
}

//我的售后
- (LYSSlideMenuController *)afterMenu {
    _afterMenu = [[LYSSlideMenuController alloc] init];
    _afterMenu.title = @"我的售后";
    
    After_AllOrderViewController *one = [[After_AllOrderViewController alloc] init];
    After_WaitFinishViewController *two = [[After_WaitFinishViewController alloc] init];
    After_FinishViewController *three = [[After_FinishViewController alloc] init];
    After_WaitEvaluateViewController *four = [[After_WaitEvaluateViewController alloc] init];
    
    _afterMenu.controllers = @[one, two, three, four];
    _afterMenu.bottomLineWidth = (SCREENBOUNDS.width - 40) / 4;
    _afterMenu.titles = @[@"全部", @"未完成", @"已完成", @"待评价"];
    _afterMenu.titleColor = [UIColor blackColor];
    _afterMenu.titleSelectColor = [UIColor blueColor];
    _afterMenu.bottomLineColor = [UIColor blueColor];
    _afterMenu.pageNumberOfItem = 4;
    return _afterMenu;
}

//我的预约
- (LYSSlideMenuController *)appointmentMenu {
    _appointmentMenu = [[LYSSlideMenuController alloc] init];
    _appointmentMenu.title = @"我的预约";
    Appointment_AllViewController *one = [[Appointment_AllViewController alloc] init];
    Appointment_WaitFinishViewController *two = [[Appointment_WaitFinishViewController alloc] init];
    Appointment_FinishViewController *three = [[Appointment_FinishViewController alloc] init];
    Appointment_EvaluateViewController *four = [[Appointment_EvaluateViewController alloc] init];
    
    _appointmentMenu.controllers = @[one, two, three, four];
    _appointmentMenu.bottomLineWidth = (SCREENBOUNDS.width - 40) / 4;
    _appointmentMenu.titles = @[@"全部", @"未完成", @"已完成", @"待评价"];
    _appointmentMenu.titleColor = [UIColor blackColor];
    _appointmentMenu.titleSelectColor = [UIColor blueColor];
    _appointmentMenu.bottomLineColor = [UIColor blueColor];
    _appointmentMenu.pageNumberOfItem = 4;
    
    return _appointmentMenu;
}

//我的发布
- (LYSSlideMenuController *)publishMenu {
    _publishMenu = [[LYSSlideMenuController alloc] init];
    _publishMenu.title = @"我的发布";
    //已发布定制
    Publish_NeedViewController *one = [[Publish_NeedViewController alloc] init];
    //已完成定制
    Publish_SellViewController *two = [[Publish_SellViewController alloc] init];
    _publishMenu.controllers = @[one, two];
    _publishMenu.bottomLineWidth = SCREENBOUNDS.width / 4;
    _publishMenu.titles = @[@"求购发布", @"出售发布"];
    _publishMenu.titleColor = [UIColor blackColor];
    _publishMenu.titleSelectColor = [UIColor blueColor];
    _publishMenu.bottomLineColor = [UIColor blueColor];
    _publishMenu.pageNumberOfItem = 2;
    return _publishMenu;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //获取个人信息
    [self getPersonInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    //    [collectionView registerClass:[FirstCollectionViewCell class] forCellWithReuseIdentifier:@"first"];
    [self.collectionView registerClass:[SecondCollectionViewCell class] forCellWithReuseIdentifier:@"first"];
    [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"second"];
    [self.collectionView registerClass:[ThreeCollectionViewCell class] forCellWithReuseIdentifier:@"three"];
    
    [self.collectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"newHeader"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    [self.view addSubview:self.collectionView];
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 5;
            break;
        case 2:
            return 8;
            break;
        case 3:
            return 5;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return nil;
            break;
        case 1:
        {
            SecondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
            cell.imageV.image = [UIImage imageNamed:@[@"daifukuan", @"daifahuo", @"daishouhuo", @"daipingjia", @"tuikuan"][indexPath.row]];
            cell.nameLabel.text = @[@"待付款", @"待发货", @"待收货", @"待评价", @"退款"][indexPath.row];
            return cell;
        }
            break;
        case 2:
        {
            HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
            cell.bottomLabel.font = SetFont(13);
            cell.topImageV.image = [UIImage imageNamed:@[@"qianbao", @"shoucang", @"jiameng", @"yuyue", @"pintuan", @"minefabu", @"dingzhi", @"shouhou"][indexPath.row]];
            cell.bottomLabel.text = @[@"我的钱包", @"我的收藏", @"加盟入住", @"我的预约", @"我的拼团", @"我的发布", @"我的定制", @"我的售后"][indexPath.row];
            return cell;
        }
            break;
        case 3:
        {
            ThreeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"three" forIndexPath:indexPath];
            cell.nameLabel.text = @[@"消息", @"意见反馈", @"分享好友", @"设置", @"联系我们"][indexPath.row];
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

//- collectionviewsectio


#pragma mark ------ UICollectionViewLayout   delegate
//设置指定indexPath的单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1:
            return CGSizeMake((SCREENBOUNDS.width - 70) / 5, (SCREENBOUNDS.width - 70) / 5 + 10);
            break;
        case 2:
            return CGSizeMake((SCREENBOUNDS.width - 160) / 4, (SCREENBOUNDS.width - 160) / 4 + 40);
            break;
        case 3:
            return CGSizeMake(SCREENBOUNDS.width - 30, ThreeCellHeight);
            break;
        default:
            return CGSizeZero;
            break;
    }
}

//设置分组中的每一个section的上下左右的空白距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if (section == 1) {
        return UIEdgeInsetsMake(20, 15, 20, 15);
    }
    return UIEdgeInsetsMake(10, 15, 10, 15);
}

//设置行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

//设置cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 2) {
        return 30.0;
    }
    return 10.0;
}

//Header
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return CGSizeMake(SCREENBOUNDS.width, 100);
            break;
        case 1:
            return CGSizeMake(SCREENBOUNDS.width, 40);
            break;
            
        default:
            return CGSizeZero;
            break;
    }
}

//Footer
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return CGSizeMake(SCREENBOUNDS.width, 10.0);
    }
    return CGSizeMake(SCREENBOUNDS.width, 0.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        view.backgroundColor = BaseViewColor;
        return view;
        
    }else {
        switch (indexPath.section) {
            case 0:
            {
                HeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
                [view.headerImg sd_setImageWithURL:[NSURL URLWithString:self.personData[@"head_photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
                view.nameLabel.text = [self.personData[@"member_name"] isKindOfClass:[NSNull class]] ? @"" : self.personData[@"member_name"];
                UITapGestureRecognizer *RZClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(RZUserInfomation)];
                RZClick.numberOfTapsRequired = 1;
                view.RZImg.userInteractionEnabled = YES;
                [view.RZImg addGestureRecognizer:RZClick];
                if ([self.personData[@"rz"] integerValue]) {
                    view.RZImg.image = [UIImage imageNamed:@"renzheng"];
                }else {
                    view.RZImg.image = [UIImage imageNamed:@"weirenzheng"];
                }
                
                view.userInteractionEnabled = YES;
                UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushChangeInfo)];
                click.numberOfTapsRequired = 1;
                [view addGestureRecognizer:click];
                
                return view;
            }
                break;
            case 1:
            {
                UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"newHeader" forIndexPath:indexPath];
                for (UIView *vv in view.subviews) {
                    [vv removeFromSuperview];
                }
                
                UILabel *label = [[UILabel alloc] init];
                label.text = @"我的订单";
                label.textAlignment = NSTextAlignmentLeft;
                label.font = SetFont(15);
                
                UILabel *rightLabel = [[UILabel alloc] init];
                rightLabel.textAlignment = NSTextAlignmentRight;
                rightLabel.font = SetFont(15);
                rightLabel.textColor = SetColor(135, 135, 135, 1);
                rightLabel.text = @"全部";
                
                UIImageView *rightImg = [[UIImageView alloc] init];
                //                rightImg.backgroundColor = RandomColor;
                rightImg.image = [UIImage imageNamed:@"right"];
                
                //分割线
                UIView *line = [[UIView alloc] init];
                line.backgroundColor = LineColor;
                
                [view addSubview:label];
                [view addSubview:rightLabel];
                [view addSubview:rightImg];
                [view addSubview:line];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, -100));
                }];
                
                
                [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(view.mas_centerY);
                    make.top.equalTo(view.mas_top).offset(13);
                    make.bottom.equalTo(view.mas_bottom).offset(-13);
                    make.right.equalTo(view.mas_right).offset(-10);
                    make.width.mas_equalTo(@(10));
                }];
                
                [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(rightImg.mas_left).offset(-10);
                    make.height.equalTo(label.mas_height);
                    make.width.mas_equalTo(@(50));
                }];
                
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.mas_left);
                    make.right.equalTo(view.mas_right);
                    make.bottom.equalTo(view.mas_bottom);
                    make.height.mas_equalTo(@(1));
                }];
                
                view.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushMyOrder)];
                [view addGestureRecognizer:tap];
                
                return view;
            }
                break;
                
            default:
                return nil;
                break;
        }
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:break;
        case 1: // 我的订单
        {
            self.slideMenu.currentItem = indexPath.row;
            [self.navigationController pushViewController:_slideMenu animated:YES];
        }
            
            break;
        case 2:
        {
            [self selectItem:indexPath.row];
        }
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //                    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
                    ////                    EMConversation
                    //                    NSLog(@"conversations == %@", conversations);
                    ChatListViewController *list = [[ChatListViewController alloc] init];
                    [self.navigationController pushViewController:list animated:YES];
                    
                }
                    break;
                case 1:  //用户反馈
                {
                    FeedbackViewController *feed = [[FeedbackViewController alloc] init];
                    [self.navigationController pushViewController:feed animated:YES];
                }
                    
                    break;
                case 2:  //分享好友
                {
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
                    break;
                case 3:   //设置
                {
                    SettingViewController *setting = [[SettingViewController alloc] init];
                    [self.navigationController pushViewController:setting animated:YES];
                }
                    break;
                case 4:
                {
                    [callAcitonView showCallActionWithTitle:@"057756578869" AndShowView:self];
                }
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


//自定义方法   修改个人信息
- (void)pushChangeInfo {
    ChangeInfoViewController *change = [[ChangeInfoViewController alloc] init];
    change.dataDic = self.personData;
    [self.navigationController pushViewController:change animated:YES];
}

//跳转到我的订单页面
- (void)pushMyOrder {
    [self.navigationController pushViewController:self.slideMenu animated:YES];
}

//跳转认证界面
- (void)RZUserInfomation {
    if ([self.personData[@"rz"] integerValue]) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"已认证"];
    }else {
        SureRealNameViewController *sure = [[SureRealNameViewController alloc] init];
        [self.navigationController pushViewController:sure animated:YES];
    }
}


- (void)selectItem:(NSInteger)index {
    switch (index) {
        case 0:                                                 //我的钱包
        {
            MyWalletViewController *wallet = [[MyWalletViewController alloc] init];
            [self.navigationController pushViewController:wallet animated:YES];
        }
            break;
        case 1:                                                 //我的收藏
        {
            self.CollectMenu.title = @"我的收藏";
            [self.navigationController pushViewController:_CollectMenu animated:YES];
        }
            break;
        case 2:                                                 //加盟入住
        {
            EnterViewController *enter = [[EnterViewController alloc] init];
            [self.navigationController pushViewController:enter animated:YES];
        }
            break;
        case 3:                                                 //我的预约
        {
            self.appointmentMenu.title = @"我的预约";
            [self.navigationController pushViewController:_appointmentMenu animated:YES];
        }
            break;
        case 4:                                                 //我的拼团
        {
            Group_ListViewController *list = [[Group_ListViewController alloc] init];
            [self.navigationController pushViewController:list animated:YES];
        }
            break;
        case 5:                                                 //我的发布
        {
            self.publishMenu.title = @"我的发布";
            [self.navigationController pushViewController:_publishMenu animated:YES];
        }
            break;
        case 6:                                                 //我的定制
        {
            self.customzationMenu.title = @"我的定制";
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCustomzationVC)];
            _customzationMenu.navigationItem.rightBarButtonItem = item;
            [self.navigationController pushViewController:_customzationMenu animated:YES];
        }
            break;
        case 7:                                                 //我的售后
        {
            self.afterMenu.title = @"我的售后";
            [self.navigationController pushViewController:_afterMenu animated:YES];
        }
            break;
            
            
        default:
            break;
    }
}

//添加我的定制
- (void)addCustomzationVC {
    AddCustomzationViewController *add = [[AddCustomzationViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
}

//获取个人信息
- (void)getPersonInfo {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"https://zbt.change-word.com/index.php/home/Member/showInfo";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{@"phone" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account"]};
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject === %@", responseObject);
        weakSelf.personData = (NSDictionary *)responseObject[@"data"];
        [weakSelf.collectionView reloadData];
        [[NSUserDefaults standardUserDefaults] setObject:isNullClass(weakSelf.personData[@"member_name"]) forKey:@"sell_name"];
        [[NSUserDefaults standardUserDefaults] setObject:isNullClass(weakSelf.personData[@"phone"]) forKey:@"sell_phone"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
//    if (platformType == UMSocialPlatformType_WechatSession) {
//        WXMiniProgramObject *miniObject = [WXMiniProgramObject object];
//        miniObject.webpageUrl = @"https://zbt.change-word.com/home/index/login";
//        miniObject.userName = @"wx8fa1d3305bb95168";
//        miniObject.path = @"pages/index/index";
//        miniObject.hdImageData = UIImagePNGRepresentation([UIImage imageNamed:@"wx.png"]);
//
//        WXMediaMessage *message = [WXMediaMessage message];
//        message.title = @"舟博通";
//        message.description = @"跳转舟博通小程序";
//        message.mediaObject = miniObject;
//        message.thumbData = nil;
//
//        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
//        req.message = message;
//        req.scene = WXSceneSession;
//        [WXApi sendReq:req];
//    }else {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建网页内容对象
        NSString* thumbURL =  @"https://zbt.change-word.com/Public/20180830101912.png";
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用舟博通发布二手艇以及买卖二手艇" descr:@"欢迎使用舟博通发布二手艇以及买卖二手艇，请前往下载。" thumImage:thumbURL];
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
//    }
}

- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = @"社会化组件UShare将各大社交平台接入您的应用，快速武装App。";
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

@end
