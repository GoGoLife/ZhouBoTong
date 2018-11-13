//
//  FeedbackViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/5/5.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "FeedbackViewController.h"
#import "Globefile.h"
#import "ShowHUDView.h"

@interface FeedbackViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textV;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    
    self.textV = [[UITextView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 200) textContainer:nil];
    self.textV.backgroundColor = [UIColor whiteColor];
    self.textV.text = @"输入反馈信息";
    self.textV.textColor = [UIColor grayColor];
    self.textV.delegate = self;
    
    [self.view addSubview:self.textV];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = FRAME(0, SCREENBOUNDS.height - 108, SCREENBOUNDS.width, 44);
    [button setBackgroundColor:SetColor(24, 147, 219, 1)];
    [button addTarget:self action:@selector(submitFeedBackInformation) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    
    [self.view addSubview:button];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1; //点击次数
    tapGesture.numberOfTouchesRequired = 1; //点击手指数
    [self.view addGestureRecognizer:tapGesture];
    
    [self setUpNav];
}

setBack();
pop();

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"输入反馈信息"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"输入反馈信息";
        textView.textColor = [UIColor grayColor];
    }
}

//轻击手势触发方法
-(void)tapGesture:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

- (void)submitFeedBackInformation {
    if ([self.textV.text isEqualToString:@"输入反馈信息"] || !self.textV.text) {
        [ShowHUDView showHUDWithView:self.view AndTitle:@"请输入反馈信息"];
        return;
    }
    NSString *url = @"https://zbt.change-word.com/index.php/home/member/addFeedback";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parme = @{
                            @"member_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"],
                            @"content" : self.textV.text
                            };
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:parme progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject === %@", responseObject);
        if ([responseObject[@"resultCode"] integerValue] == 1) {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"感谢您的反馈"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"提交反馈失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error === %@", error);
            [ShowHUDView showHUDWithView:weakSelf.view AndTitle:@"提交反馈失败"];
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
