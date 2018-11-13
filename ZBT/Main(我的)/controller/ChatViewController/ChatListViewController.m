//
//  ChatListViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/8/13.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ChatListViewController.h"
#import "EaseConvertToCommonEmoticonsHelper.h"

@interface ChatListViewController ()

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会话列表";
    
    [self tableViewDidTriggerHeaderRefresh];
    self.showRefreshHeader = YES;
    
    [self setUpNav];
}

- (void)setUpNav {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem = backItem;
}

//返回方法
- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSAttributedString*)conversationListViewController:(EaseConversationListViewController*)conversationListViewController latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel {
    NSString *latestMessageTitle =@"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if(lastMessage) {
        EMMessageBody*messageBody = lastMessage.body;
        switch(messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = @"[图片]";
            }break;
            case EMMessageBodyTypeText:{
                //表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:((EMTextMessageBody*)messageBody).text];
                latestMessageTitle = didReceiveText;
                if([lastMessage.ext objectForKey:@"em_is_big_expression"]) {
                    latestMessageTitle =@"[动画表情]";
                }
            }
                break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle =@"[音频]";
            }
                break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = @"[位置]";
            }
                break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = @"[视频]";
            }
                break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = @"[文件]";
            }
                break;
            default: {
            }break;
        }
    }
    NSMutableAttributedString*attStr = [[NSMutableAttributedString alloc]initWithString:latestMessageTitle];
    return attStr;
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
