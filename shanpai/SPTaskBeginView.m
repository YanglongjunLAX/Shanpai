//
//  SPTaskBeginView.m
//  shanpai
//
//  Created by liang chunyan on 14-12-11.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPTaskBeginView.h"

@interface SPTaskBeginView()<SwipeViewDataSource,SwipeViewDelegate>

@end

@implementation SPTaskBeginView

- (id)init
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SPTaskFirstView"
                                                   owner:nil
                                                 options:nil];
    self = array[0];
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.imageSwipeView.dataSource = self;
    self.imageSwipeView.delegate   = self;
}

- (void)loadUrl:(NSString *)url
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)setDataList:(NSArray *)dataList
{
    _dataList = dataList;
    if (self.dataList)
    {
        self.pageControl.numberOfPages = self.dataList.count;
        [self.imageSwipeView reloadData];
    }
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
        imageView = [[UIImageView alloc] initWithFrame:self.imageSwipeView.bounds];
    }
    
    NSDictionary *dic = self.dataList[index];
    [imageView setImageWithURL:[NSURL URLWithString:dic[@"image"]]];
    
    self.pageControl.currentPage = index;
    
    return imageView;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.imageSwipeView.bounds.size;
}

@end
