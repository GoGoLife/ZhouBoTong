//
//  PersonSecondYeach_InfoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/8/27.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "PersonSecondYeach_InfoViewController.h"
#import "callAcitonView.h"
#import "URLImageScroll.h"
#import "PlayVideo_TableViewCell.h"
#import <UShareUI/UShareUI.h>

@interface PersonSecondYeach_InfoViewController ()

@end

@implementation PersonSecondYeach_InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.addView.DPButton.hidden = YES;
    self.addView.AddCartsButton.hidden = YES;
    __weak typeof(self) weakSelf = self;
    CGFloat width = SCREENBOUNDS.width / 3;
    [self.addView.KFButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.addView.DPButton.mas_right).offset(- width / 2);
//        make.top.equalTo(weakSelf.addView.mas_top);
//        make.bottom.equalTo(weakSelf.addView.mas_bottom);
//        make.width.mas_equalTo(@(width / 2));
    }];
    
    [self.addView.PayButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.addView.AddCartsButton.mas_right).offset(- width + 60);
        make.right.equalTo(weakSelf.addView.mas_right);
    }];
    [self getInfo_Sell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        GroupBuyView *view = [[GroupBuyView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 100)];
//        if (1) {   //[self.dataDic[@"is_collection"] integerValue]
//            view.collectBtn.backgroundColor = BaseViewColor;
//            [view.collectBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//            [view.collectBtn setTitle:@"已收藏" forState:UIControlStateNormal];
//            view.collectBtn.enabled = NO;
//        }
//        //收藏
//        [view.collectBtn addTarget:self action:@selector(collectGoods) forControlEvents:UIControlEventTouchUpInside];
        //分享
        [view.shareBtn addTarget:self action:@selector(shareAction_Person) forControlEvents:UIControlEventTouchUpInside];
        view.collectBtn.hidden = YES;
        view.backgroundColor = [UIColor whiteColor];
        view.isNewLayout = YES;
        view.topTextF.text = self.dataDic[@"title"];
        view.priceLeftString = [NSString stringWithFormat:@"¥%@", self.dataDic[@"price"]];
        view.remarkLabel.font = SetFont(12);
        view.remarkLabel.text = [NSString stringWithFormat:@"发布时间:%@", self.dataDic[@"add_time"]];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)}];
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

StringWidth();
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
                    cell.textF.textAlignment = NSTextAlignmentLeft;
                    cell.textF.font = SetFont(14);
                    [cell.textF creatLeftView:FRAME(0, 0, [self calculateRowWidth:@"地址：" withFont:14], 60) AndTitle:@"地址：" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:[UIColor blackColor]];
                    cell.textF.text = self.dataDic[@"address"];
                }
                    break;
                case 1:
                {
                    cell.textF.textAlignment = NSTextAlignmentLeft;
                    cell.textF.font = SetFont(14);
                    NSString *fee = self.dataDic[@"contacts"];//[isNullClass(self.dataDic[@"merchant"]) isEqualToString:@""] ? @"" : self.dataDic[@"merchant"][@"distribution_fee"];
                    cell.textF.text = [NSString stringWithFormat:@"%@", fee];//@"¥2000";
                    [cell.textF creatLeftView:FRAME(0, 0, [self calculateRowWidth:@"联系人：" withFont:14], 60) AndTitle:@"联系人：" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:[UIColor blackColor]];
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
            NSString *name = self.dataDic[@"phone"];//[isNullClass(self.dataDic[@"merchant"]) isEqualToString:@""] ? @"" : self.dataDic[@"merchant"][@"merchant_name"];
            cell.textF.text = [NSString stringWithFormat:@"    %@", name];//@"    阿波罗11号店";
            [cell.textF creatLeftView:FRAME(0, 0, 20, 20) AndImage:[UIImage imageNamed:@"phone"]];
            [cell.textF creatRightView:FRAME(0, 0, [self calculateRowWidth:@"一键拨号" withFont:14], 60) AndTitle:@"一键拨号" TextAligment:NSTextAlignmentCenter Font:SetFont(14) Color:SetColor(147, 147, 147, 1)];
            return cell;
        }
            break;
        case 3:
        {
            PlayVideo_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.info_string = self.dataDic[@"info"];
            cell.info_label.text = self.dataDic[@"info"];
            cell.video_URLString = isNullClass(self.dataDic[@"video"]);
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
//        LoopView *loopV = [[LoopView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 200)];
//        loopV.imageArray = @[@"1", @"2", @"3", @"4"];
//        return loopV;
        URLImageScroll *scroll = [[URLImageScroll alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 200) withImageArray:self.dataDic[@"photo"]];
//        scroll.URLImageArr = self.dataDic[@"photo"];
//        NSLog(@"urlimagearr111  === %@", scroll.URLImageArr);
        return scroll;
    }
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 10)];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        [callAcitonView showCallActionWithTitle:self.dataDic[@"phone"] AndShowView:self];
    }
}

//获取我要卖的详情信息
- (void)getInfo_Sell {
    if (!self.buy_id) {
        return;
    }
    NSString *url = @"https://zbt.change-word.com/index.php/home/Goods/buyInfo";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *dic = @{@"buy_id" : self.buy_id};
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"sell Info ===== %@", responseObject);
        weakSelf.dataDic = (NSDictionary *)responseObject[@"data"];
        [weakSelf.tableView reloadData];
        [weakSelf isSecondYeachBuy:[weakSelf.dataDic[@"purchase"] integerValue]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//判断此二手艇是否被人购买
- (void)isSecondYeachBuy:(NSInteger)purchase {
    if (purchase) {
        self.addView.PayButton.enabled = NO;
        [self.addView.PayButton setTitle:@"交易中" forState:UIControlStateNormal];
    }
}

- (void)shareAction_Person {
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
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.dataDic[@"title"] descr:self.dataDic[@"info"] thumImage:thumbURL];
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
