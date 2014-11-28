//
//  spStoreHeadView.m
//  shanpai
//
//  Created by liang chunyan on 14-11-20.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "spStoreHeadView.h"
#import "SwipeView.h"
#import "SPAdData.h"

@interface spStoreHeadView()<SwipeViewDataSource,SwipeViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;

@property (strong, nonatomic) SwipeView  *swipeView;//展示广告图片

@end

@implementation spStoreHeadView

- (void)updateConstraints
{
    [super updateConstraints];
    if (self.swipeView && self.swipeView.superview)
    {
        [self.swipeView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.swipeView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.swipeView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.swipeView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.bottomView.backgroundColor = [UIColor colorWithWhite:.8 alpha:.7];
    [self addSubview:self.swipeView];
    [self sendSubviewToBack:self.swipeView];
    self.titleLabel.text = nil;
}

- (SwipeView *)swipeView
{
    if (!_swipeView)
    {
        _swipeView = [[SwipeView alloc] init];
        _swipeView.delegate    = self;
        _swipeView.dataSource  = self;
        _swipeView.wrapEnabled = YES;
        _swipeView.backgroundColor = [UIColor darkGrayColor];
    }
    return _swipeView;
}

#pragma mark - delegate
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.dataArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *imageView = (UIImageView *)view;
    if (imageView == nil)
    {
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    
    SPAdData *data = self.dataArray[index];
    [imageView setImageWithURL:[NSURL URLWithString:data.image]];
    self.titleLabel.text = data.title;
    self.pageController.currentPage = index;
    return imageView;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.bounds.size;
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    if (self.action)
    {
        //广告弹出内置网页
        SPAdData *data = self.dataArray[index];
        self.action(index,data.url);
    }
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    self.pageController.numberOfPages = dataArray.count;
    if (self.dataArray)
    {
        [self.swipeView reloadData];
    }
}

@end
