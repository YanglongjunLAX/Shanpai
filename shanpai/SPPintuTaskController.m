//
//  SPPintuTaskController.m
//  shanpai
//
//  Created by liang chunyan on 14-12-11.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPPintuTaskController.h"
#import "SPTaskBeginView.h"
#import "SVModalWebViewController.h"

@interface SPPintuTaskController ()

@property (nonatomic, strong) SPTaskBeginView  *beginView;

//开始拼图
- (void)beginPintu:(UIButton *)button;
//请求图片信息
- (void)requestAdImageData;
@end

@implementation SPPintuTaskController

- (void)loadView
{
    [super loadView];
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SPTaskFirstView"
                                                   owner:self
                                                 options:nil];
    self.beginView = array[0];
    
    [self.beginView.beginButton addTarget:self
                                   action:@selector(beginPintu:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    self.view = self.beginView;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"拼图";
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/info/id/%@" , @"http://shanpai.iushare.com/Api/", self.model.module, self.model.auto_id];
    [self.beginView loadUrl:urlStr];
    [self requestAdImageData];
    [self setBackLeftItem];
}

//开始拼图
- (void)beginPintu:(UIButton *)button
{
    NSString *url = [NSString stringWithFormat:@"%@%@/play/mode/1/id/%@/userid/%@" ,  @"http://shanpai.iushare.com/Api/" , self.model.module , self.model.auto_id , [SPUserData userID]];
    
    SVModalWebViewController  *webVC = [[SVModalWebViewController alloc] initWithAddress:url];
    [self presentViewControllerWithNavc:webVC];
}

- (void)requestAdImageData
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

@end
