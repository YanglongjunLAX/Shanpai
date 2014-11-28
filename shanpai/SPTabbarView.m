//
//  SPTabbarView.m
//  shanpai
//
//  Created by liang chunyan on 14-11-4.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
// 自定义的tabber

#import "SPTabbarView.h"
#import "BLTabbarItem.h"

@interface SPTabbarView()
//按钮
@property(nonatomic, strong) BLTabbarItem   *item1;
@property(nonatomic, strong) BLTabbarItem   *item2;
@property(nonatomic, strong) UIImageView    *item3;
@property(nonatomic, strong) BLTabbarItem   *item4;
@property(nonatomic, strong) BLTabbarItem   *item5;
@property(nonatomic, strong) UIImageView    *imageView;

//当前选中的下表
@property(nonatomic, assign) NSInteger      curIndex;
//设置当前的约束
- (void)setupCurrentConstraints;
//点击函数
- (void)clickAction:(id)sender;
//设置点击行为
- (void)setActions;
@end

@implementation SPTabbarView

- (id)init
{
    self = [super init];
    if (self)
    {
        [self addSubview:self.imageView];
        
        //添加views
        [self addSubview:self.item1];
        [self addSubview:self.item2];
        [self addSubview:self.item3];
        [self addSubview:self.item4];
        [self addSubview:self.item5];
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.curIndex = 10001;
    [self setActions];
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self setupCurrentConstraints];
}

- (void)setupCurrentConstraints
{
    
    [_imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [_imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [_imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [_imageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    
    NSArray *subviews = @[self.item1, self.item2, self.item3, self.item4, self.item5];

    [self.item1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = (UIView *)obj;
        [view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    }];
    [self.item5 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    
    [self.item1 autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [subviews autoDistributeViewsAlongAxis:ALAxisHorizontal withFixedSpacing:0.0f insetSpacing:YES alignment:NSLayoutFormatAlignAllBaseline];
}

#pragma getters
- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"tools_bar_bg"];
    }
    return _imageView;
}

- (BLTabbarItem *)item1
{
    if (!_item1)
    {
        _item1 = [[BLTabbarItem alloc] init];
        _item1.tag = 10001;
        [_item1 setTitle:@"任务" icon:@"tools_bar_mission_icon.png"];
    }
    return _item1;
}

- (BLTabbarItem *)item2
{
    if (!_item2)
    {
        _item2 = [[BLTabbarItem alloc] init];
        [_item2 setTitle:@"PK台" icon:@"tools_bar_pk_icon.png"];
        _item2.tag = 10002;
    }
    return _item2;
}

- (BLTabbarItem *)item4
{
    if (!_item4)
    {
        _item4 = [[BLTabbarItem alloc] init];
        [_item4 setTitle:@"品牌" icon:@"tools_bar_brand_icon.png"];
        _item4.tag = 10004;
    }
    return _item4;
}

- (BLTabbarItem *)item5
{
    if (!_item5)
    {
        _item5 = [[BLTabbarItem alloc] init];
        [_item5 setTitle:@"商城" icon:@"tools_bar_mall_icon.png"];
        _item5.tag = 10005;
    }
    return _item5;
}

- (UIImageView *)item3
{
    if (!_item3)
    {
        _item3 = [[UIImageView alloc] init];
        _item3.contentMode = UIViewContentModeScaleAspectFit;
        _item3.image = [UIImage imageNamed:@"tools_bar_camera_icon.png"];
        _item3.tag = 10003;
    }
    return _item3;
}

- (void)setCurIndex:(NSInteger)curIndex
{
    if (_curIndex != curIndex)
    {
        _curIndex = curIndex;
        [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *view = (UIView *)obj;
            if (view.tag != curIndex)
            {
                if ([view isKindOfClass:[UIButton class]])
                {
                    UIButton *button = (UIButton *)view;
                    button.selected = NO;
                }
            }
            else
            {
                if ([view isKindOfClass:[UIButton class]])
                {
                    UIButton *button = (UIButton *)view;
                    button.selected = YES;
                }
            }
        }];
    }
}

#pragma mark - clickaction
- (void)clickAction:(id)sender
{
    NSInteger index = 0;
    if ([sender isKindOfClass:[UIView class]])
    {
        index = ((UIView *)sender).tag;
    }
    else if ([sender isKindOfClass:[UIGestureRecognizer class]])
    {
        index = 10003;
    }
    self.curIndex = index;
    if (self.action)
    {
        self.action(index - 10001);
    }
}

- (void)setActions
{
    //图片可以点击
    self.item3.userInteractionEnabled = YES;
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = (UIView *)obj;
        if ([view isKindOfClass:[UIButton class]])
        {
                UIButton *button = (UIButton *)view;
                [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(view == self.item3)
        {
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
            [self.item3 addGestureRecognizer:tapGes];
        }
    }];

}
@end
