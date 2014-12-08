//
//  SPTaskBeginController.m
//  shanpai
//
//  Created by liang chunyan on 14-12-7.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPTaskBeginController.h"

@interface SPTaskBeginController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *beginButton;

- (void)sptSetActions;

- (void)sptBeginGame:(UIButton *)button;

- (void)sptLoadUrl:(NSString *)path;
@end

@implementation SPTaskBeginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sptSetActions];
    [self setBackLeftItem];
    
    NSString *fullPath = [NSString stringWithFormat:@"%@TestPaper/show/id/%@",@"http://shanpai.iushare.com/Api/",self.model._id];
    [self sptLoadUrl:fullPath];
}

- (void)sptSetActions
{
    [self.beginButton addTarget:self
                         action:@selector(sptBeginGame:)
               forControlEvents:UIControlEventTouchUpInside];
}

- (void)sptBeginGame:(UIButton *)button
{
    
}

- (void)sptLoadUrl:(NSString *)path
{
    NSURL *url = [NSURL URLWithString:path];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
