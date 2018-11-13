//
//  ShowHtmlTextViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/10/18.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "ShowHtmlTextViewController.h"
#import "Globefile.h"

@interface ShowHtmlTextViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ShowHtmlTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", self.textString);
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENBOUNDS.width, SCREENBOUNDS.height - 64)];
    [self.webView loadHTMLString:[self htmlText:self.textString] baseURL:[NSURL URLWithString:@"https://zbt.change-word.com"]];
    [self.view addSubview:self.webView];
    
    [self setUpNav];
}

/**
 * 返回H5标签转义属性
 */
- (NSString*)htmlText:(NSString *)string {
    
    NSDictionary* options = @{
                              NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType
                              };
    
    NSMutableAttributedString* attrs = [[NSMutableAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil error:nil];
    
    return attrs.string;
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
