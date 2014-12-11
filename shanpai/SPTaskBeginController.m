//
//  SPTaskBeginController.m
//  shanpai
//
//  Created by liang chunyan on 14-12-7.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPTaskBeginController.h"
#import "SwipeView.h"
#import "SVModalWebViewController.h"

@interface SPTaskBeginController ()<SwipeViewDataSource,SwipeViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *beginButton;
@property (weak, nonatomic) IBOutlet SwipeView *imageSwipeView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSString  *pathValue;

@property (nonatomic, strong) NSMutableArray  *imageList;

- (void)sptSetActions;

- (void)sptBeginGame:(UIButton *)button;

- (void)sptLoadUrl:(NSString *)path;

- (void)loadImageInfo;

@end

@implementation SPTaskBeginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadImageInfo];
    
    [self sptSetActions];
    [self setBackLeftItem];
    
    NSString *fullPath = [NSString stringWithFormat:@"%@%@/show/id/%@",@"http://shanpai.iushare.com/Api/",self.pathValue,self.model.auto_id];
    [self sptLoadUrl:fullPath];
    
    self.imageSwipeView.dataSource = self;
    self.imageSwipeView.delegate   = self;
}

- (NSMutableArray *)imageList
{
    if (!_imageList)
    {
        _imageList = [[NSMutableArray alloc] init];
    }
    return _imageList;
}

- (void)sptSetActions
{
    [self.beginButton addTarget:self
                         action:@selector(sptBeginGame:)
               forControlEvents:UIControlEventTouchUpInside];
}

- (void)sptBeginGame:(UIButton *)button
{
    NSString *prePath = @"http://shanpai.iushare.com/Api/";
    NSString *path = nil;
    
    switch (self.type)
    {
        case SPTaskTestPaper:
        case SPTaskQuestionnaire:
           path = [NSString stringWithFormat:@"%@Questions/show/group_id/%@/userid/%@",prePath,self.model.auto_id,[SPUserData userID]];
            break;
        default:
            break;
    }
    SVModalWebViewController  *webVC = [[SVModalWebViewController alloc] initWithAddress:path];
    [self presentViewControllerWithNavc:webVC];
}

- (void)sptLoadUrl:(NSString *)path
{
    NSURL *url = [NSURL URLWithString:path];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.imageList.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *imageView = (UIImageView *)view;
    if (imageView == nil)
    {
        imageView = [[UIImageView alloc] initWithFrame:self.imageSwipeView.bounds];
    }
    
    NSDictionary *dic = self.imageList[index];
    [imageView setImageWithURL:[NSURL URLWithString:dic[@"image"]]];
    
    return imageView;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.imageSwipeView.bounds.size;
}

- (void)loadImageInfo
{
    NSString *path = [NSString stringWithFormat:@"%@/getSlides/",self.pathValue];
    NSDictionary *params = @{
                             @"auto_id"  :  self.model.auto_id,
                             };
    
    __weak typeof(self) weeakSelf = self;
    [SVProgressHUD show];
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                            [weeakSelf.imageList addObjectsFromArray:responseObject[@"data"]];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
                                [weeakSelf.imageSwipeView reloadData];
                                weeakSelf.pageControl.numberOfPages = weeakSelf.imageList.count;
                            });
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD dismiss];
                            });
                        }];
}

- (NSString *)pathValue
{
    if (!_pathValue)
    {
        switch (self.type)
        {
            case SPTaskTestPaper:
                self.title = @"答题";
                _pathValue = @"TestPaper";
                break;
            case SPTaskQuestionnaire:
                self.title = @"问卷";
                _pathValue = @"Questionnaire";
                break;
            default:
                break;
        }
    }
    return _pathValue;
}

@end
