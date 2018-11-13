//
//  BuySellViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "BuySellViewController.h"
#import "Globefile.h"
#import "Buy_FirstCollectionViewCell.h"
#import "HomeSecondCollectionViewCell.h"
#import "UITextField+LeftRightView.h"
#import "AppDelegate.h"
#import "BuyViewController.h"
#import "assessmentViewController.h"
#import "Publish_infoViewController.h"
#import "Buy_GroupListViewController.h"

@interface BuySellViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *backgroundView;//遮罩层

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation BuySellViewController

- (void)viewWillAppear:(BOOL)animated {
    [self getBuyYeachInfo];
    [self addmaskView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cencalButton];
}

- (void)addmaskView {
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegete.window addSubview:self.backgroundView];
    [self setPrepositionView:_backgroundView];
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, SCREENBOUNDS.height)];
        _backgroundView.backgroundColor = SetColor(204, 204, 204, 0.5);
        _backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cencalButton)];
        [_backgroundView addGestureRecognizer:tap];
        
    }
    return _backgroundView;
}

//设置前置view
- (void)setPrepositionView:(UIView *)backGroundView {
    NSArray *imageNamedArr = @[@"woyaomai", @"woyaomai2", @"pinggu"];
    NSArray *titleArr = @[@"我要买", @"我要卖", @"免费评估"];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    ViewRadius(view, 5.0);
    [backGroundView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backGroundView.mas_left);
        make.right.equalTo(backGroundView.mas_right);
        make.bottom.equalTo(backGroundView.mas_bottom);
        make.height.mas_equalTo(@(200));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = Color176;
    [view addSubview:line];
    
    UIButton *cencalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cencalBtn.backgroundColor = [UIColor whiteColor];
    cencalBtn.titleLabel.font = SetFont(15);
    [cencalBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cencalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cencalBtn addTarget:self action:@selector(cencalButton) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cencalBtn];
    
    [cencalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.bottom.equalTo(view.mas_bottom);
        make.height.mas_equalTo(@(38));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.bottom.equalTo(cencalBtn.mas_top);
        make.height.mas_equalTo(@(2));
    }];
    
    
    CGFloat width = (SCREENBOUNDS.width - 40) / 3;
    for (NSInteger index = 0; index < 3; ++index) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.backgroundColor = RandomColor;
        button.titleLabel.font = SetFont(15);
        [button setTitleColor:SetColor(58, 52, 52, 1) forState:UIControlStateNormal];
        button.tag = index + 500;
        [button setImage:[UIImage imageNamed:imageNamedArr[index]] forState:UIControlStateNormal];
        [button setTitle:titleArr[index] forState:UIControlStateNormal];
        [self initButton:button];
        [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).offset(10 + (width + 10) * index);
            make.top.equalTo(view.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(width, 140));
        }];
    }
}

//将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    float  spacing = 10;//图片和文字的上下间距
    CGSize imageSize = [UIImage imageNamed:@"woyaomai"].size;
    UILabel *label = [[UILabel alloc] init];
    label.text = btn.titleLabel.text;
    label.font = SetFont(15);
    label.numberOfLines = 0;
    [label sizeToFit];
    CGSize titleSize = label.bounds.size;
//    CGSize imageSize = btn.imageView.frame.size;
//    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布";
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, SCREENBOUNDS.height - 64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[Buy_FirstCollectionViewCell class] forCellWithReuseIdentifier:@"first"];
    [self.collectionView registerClass:[HomeSecondCollectionViewCell class] forCellWithReuseIdentifier:@"second"];
    
    [self.view addSubview:self.collectionView];
    
    static NSString *tabBarDidSelectedNotification = @"tabBarDidSelectedNotification";
    //注册接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarSeleted) name:tabBarDidSelectedNotification object:nil];
    
}

 //接收到通知实现方法
- (void)tabBarSeleted {
    // 如果是连续选中2次, 直接刷新
    if (self.tabBarController.selectedIndex == 2 && [self isShowingOnKeyWindow]) {

        //直接写刷新代码
        [self addmaskView];

    }
}

/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow
{
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.view.frame fromView:self.view.superview];
    CGRect winBounds = keyWindow.bounds;

    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);

    return !self.view.isHidden && self.view.alpha > 0.01 && self.view.window == keyWindow && intersects;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) {
        return self.dataArr.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSDictionary *dic = self.dataArr[indexPath.row];
        HomeSecondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
        [cell layoutIfNeeded];
        cell.isType = NO;
        [cell.leftImg sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"public"]];
        cell.textF.text = dic[@"title"];
        cell.price.text = dic[@"price"];
        cell.bottomTextF.text = [@"  " stringByAppendingString:dic[@"contacts"]?:@""];
//        [cell.bottomTextF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"已售：XXX" withFont:12], cell.bottomTextF.bounds.size.height) AndTitle:@"已售：2" TextAligment:NSTextAlignmentRight Font:SetFont(12) Color:Color176];
        return cell;
    }
    Buy_FirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
    cell.leftView.userInteractionEnabled = YES;
    cell.rightTopView.userInteractionEnabled = YES;
    cell.rightBottomView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchLeftView)];
    [cell.leftView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchRightTopView)];
    [cell.rightTopView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchRightBottomView)];
    [cell.rightBottomView addGestureRecognizer:tap3];
    return cell;
}

StringWidth();
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return CGSizeMake(SCREENBOUNDS.width - 20, 100);
    }
    return CGSizeMake(SCREENBOUNDS.width - 20, 200);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSDictionary *dic = self.dataArr[indexPath.row];
        Publish_infoViewController *info = [[Publish_infoViewController alloc] init];
        info.sell_id = dic[@"sell_id"];
        info.publish_type = 1;
        [self.navigationController pushViewController:info animated:YES];
    }
}

//买,卖,评估
- (void)selectButton:(UIButton *)button {
    NSString *isRZ = [[NSUserDefaults standardUserDefaults] objectForKey:@"isRZ"];
    //判断用户是否认证
    if (![isRZ integerValue]) {
        [self cencalButton];
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前用户未实名认证，请去(个人中心)完成认证" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.tabBarController.selectedIndex = 4;
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSInteger index = button.tag - 500;
    if (index == 0) {
        BuyViewController *buyVC = [[BuyViewController alloc] init];
        buyVC.titleString = @"我要买";
        [self.navigationController pushViewController:buyVC animated:YES];
    }else if (index == 1) {
        BuyViewController *buyVC = [[BuyViewController alloc] init];
        buyVC.titleString = @"我要卖";
        buyVC.isShowSecond = YES;
        [self.navigationController pushViewController:buyVC animated:YES];
    }else {
        assessmentViewController *assessment = [[assessmentViewController alloc] init];
        [self.navigationController pushViewController:assessment animated:YES];
    }
    
}

- (void)cencalButton {
    [_backgroundView removeFromSuperview];
}

//团购入口
- (void)touchLeftView {
    Buy_GroupListViewController *hot = [[Buy_GroupListViewController alloc] init];
    [self.navigationController pushViewController:hot animated:YES];
}

- (void)touchRightTopView {
    Buy_GroupListViewController *hot = [[Buy_GroupListViewController alloc] init];
    [self.navigationController pushViewController:hot animated:YES];
}

- (void)touchRightBottomView {
    Buy_GroupListViewController *hot = [[Buy_GroupListViewController alloc] init];
    [self.navigationController pushViewController:hot animated:YES];
}

//获取求购信息
- (void)getBuyYeachInfo {
    NSString *url = @"https://zbt.change-word.com/index.php/home/Goods/sellList";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"艇买列表 ==== %@", responseObject);
        weakSelf.dataArr = (NSArray *)responseObject[@"data"];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
