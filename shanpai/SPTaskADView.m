//
//  SPTaskADView.m
//  shanpai
//
//  Created by liang chunyan on 14-11-7.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPTaskADView.h"
#import "SwipeView.h"

#import "SPAdData.h"


@interface SPTaskADView() <SwipeViewDataSource, SwipeViewDelegate>
@property (weak, nonatomic) IBOutlet SwipeView *imageswipe;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

//广告数据
@property (nonatomic, strong) NSArray  *dataList;

- (void)getAdData;
- (void)sptSetSwipeView;
@end

@implementation SPTaskADView
- (id)init
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SPTaskAdView"
                                                   owner:self
                                                 options:nil];
    self = array[0];
    [self sptSetSwipeView];
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self getAdData];
}

- (void)awakeFromNib
{
    [self getAdData];
}

- (void)getAdData
{
    //请求的路径
    NSString *path = @"AdvertBanners/ls";
    //参数
    NSDictionary *params = @{@"advType":@"index",@"listRows":@"5"};
    
    __weak typeof(self) weakSelf = self;
    [SPAdData getTaskAdWithPath:path params:params block:^(NSArray *array, NSError *error) {
        weakSelf.dataList = array;
        [weakSelf.imageswipe reloadData];
        weakSelf.pageControl.numberOfPages = array.count;
    }];
    
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.dataList.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *imageView = (UIImageView *)view;
    if (imageView == nil)
    {
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    
    SPAdData *data = self.dataList[index];
    [imageView setImageWithURL:[NSURL URLWithString:data.image]];
    self.contentLabel.text = data.title;
    self.pageControl.currentPage = index;
    self.tagLabel.text = data.tags;
    return imageView;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return swipeView.bounds.size;
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    //taskOpenWebView
    SPAdData *data = self.dataList[index];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"taskOpenWebView"
                                                        object:nil
                                                      userInfo:@{@"url"   :  data.url}];
}

- (void)swipeViewDidEndDragging:(SwipeView *)swipeView willDecelerate:(BOOL)decelerate
{
    SPAdData *data = self.dataList[swipeView.currentItemIndex];
    self.contentLabel.text = data.title;
    self.pageControl.currentPage = swipeView.currentItemIndex;
    self.tagLabel.text = data.tags;
}

- (void)sptSetSwipeView
{
    self.imageswipe.dataSource = self;
    self.imageswipe.delegate   = self;
}

@end

