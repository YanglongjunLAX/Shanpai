//
//  SPGuessPicController.m
//  shanpai
//
//  Created by liang chunyan on 14-12-11.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPGuessPicController.h"
#import "SPTaskBeginView.h"
#import "SVModalWebViewController.h"

@interface SPGuessPicController ()

@property (nonatomic, strong) SPTaskBeginView   *beginView;
//加载图片信息
- (void)loadAdInfo;
//开始任务
- (void)beginGameAction:(UIButton *)button;
@end

@implementation SPGuessPicController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"猜图";
    [self loadAdInfo];
    
    NSString * newId = self.model.auto_id;
    NSURLRequest * newsContentRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GuessPic/info/id/%@",@"http://shanpai.iushare.com/Api/",newId]]];
    [self.beginView.webView loadRequest:newsContentRequest];
    
    [self.beginView.beginButton addTarget:self
                                   action:@selector(beginGameAction:)
                         forControlEvents:UIControlEventTouchUpInside];
    [self setBackLeftItem];
}

- (void)loadView
{
    [super loadView];
    self.beginView = [[SPTaskBeginView alloc] init];
    self.view = self.beginView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadAdInfo
{
    NSString *path = [NSString stringWithFormat:@"%@/getSlides/",@"Game"];
    NSDictionary *params = @{
                             @"auto_id"  :  self.model.auto_id,
                             };
    
    __weak typeof(self) weeakSelf = self;
    [SVProgressHUD show];
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            weeakSelf.beginView.dataList = responseObject[@"data"];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
                            });
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD dismiss];
                            });
                        }];
}

- (void)beginGameAction:(UIButton *)button
{
    NSString *path = [NSString stringWithFormat:@"%@/GuessPic/play/id/%@/userid/%@/mode/%@",@"http://shanpai.iushare.com/Api/",self.model.auto_id,[SPUserData userID],self.model._id];
    
    SVModalWebViewController  *webVC = [[SVModalWebViewController alloc] initWithAddress:path];
    [self presentViewControllerWithNavc:webVC];
}

@end
