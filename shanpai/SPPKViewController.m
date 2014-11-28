//
//  SPPKViewController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-6.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPPKViewController.h"
#import "HMSegmentedControl.h"

#define kForSegmentHight      35.0f

@interface SPPKViewController ()
@property (strong, nonatomic) HMSegmentedControl  *segmentedControl;
@property (strong, nonatomic) NSArray             *titles;

//设置约束
- (void)configConstrain;
//顶部选择
- (void)selectIndex:(NSUInteger)index;
@end

@implementation SPPKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"PK台";
    [self setCityButton];
    [self setUserCenterButton];
    [self.view addSubview:self.segmentedControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self configConstrain];
}

#pragma mark - Getter
- (HMSegmentedControl *)segmentedControl
{
    if (!_segmentedControl)
    {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:self.titles];
        [_segmentedControl setSelectionIndicatorHeight:4.0f];
        [_segmentedControl setFont:[UIFont systemFontOfSize:15]];
        [_segmentedControl setBackgroundColor:[UIColor whiteColor]];
        [_segmentedControl setTextColor:[UIColor colorWithHexString:@"#444444"]];
        [_segmentedControl setSelectionIndicatorColor:[UIColor orangeColor]];
        [_segmentedControl setSelectionIndicatorMode:HMSelectionIndicatorFillsSegment];
        [_segmentedControl setSegmentEdgeInset:UIEdgeInsetsMake(0, 2, 0, 2)];
        [self.view addSubview:_segmentedControl];
        
        __weak __typeof(&*self)weakSelf = self;
        [_segmentedControl setIndexChangeBlock:^(NSUInteger index) {
            __strong __typeof(&*weakSelf)strongSelf = weakSelf;
            if (!strongSelf)
            {
                return;
            }
            [strongSelf selectIndex:index];
        }];
    }
    return _segmentedControl;
}

- (NSArray *)titles
{
    if (!_titles)
    {
        _titles = @[@"PK台", @"游戏动态", @"奖池排行"];
    }
    return _titles;
}

#pragma mark - Private Methods
- (void)configConstrain
{
    [self.segmentedControl autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.segmentedControl autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.segmentedControl autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.segmentedControl autoSetDimension:ALDimensionHeight toSize:kForSegmentHight];
}

- (void)selectIndex:(NSUInteger)index
{
    NSLog(@"%lu",index);
}

@end
