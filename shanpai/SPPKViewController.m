//
//  SPPKViewController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-6.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPPKViewController.h"
#import "HMSegmentedControl.h"
#import "SVModalWebViewController.h"
#import "SPPKView.h"
#import "SPGameDynamicView.h"

#import "SPGuessFingerController.h"//猜拳

#import "SPPKPoolController.h"//奖池排行


#define kForSegmentHight      35.0f

@interface SPPKViewController ()
@property (strong, nonatomic) HMSegmentedControl  *segmentedControl;
@property (strong, nonatomic) NSArray             *titles;

@property (nonatomic, strong) SPPKView            *pkView;//pk台
@property (nonatomic, strong) SPGameDynamicView   *gameDynamicView;//游戏动态
@property (nonatomic, strong) UIView              *pkPoolView;
@property (nonatomic, strong) SPPKPoolController  *pkpoolController;

//设置约束
- (void)configConstrain;
//顶部选择
- (void)selectIndex:(NSUInteger)index;
//点击广告打开网页
- (void)openWebSiteWithUrl:(NSNotification *)notify;
//点击pk台cell,打开对应的controller
- (void)pkTaiOpenViewController:(NSNotification *)notify;
//添加通知
- (void)addNotiftys;
@end

@implementation SPPKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"PK台";
    [self setCityButton];
    [self setUserCenterButton];
    [self addNotiftys];
    //
    
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.pkView];
    [self.view addSubview:self.gameDynamicView];
    self.pkPoolView = self.pkpoolController.view;
    [self.view addSubview:self.pkPoolView];
    //
    [self.view bringSubviewToFront:self.pkView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar];
    [self selectIndex:self.segmentedControl.selectedIndex];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self configConstrain];
    
    if (self.pkView && self.pkView.superview)
    {
        [self.pkView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        
        [self.pkView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.pkView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        [self.pkView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kForSegmentHight];
    }
    
    if (self.gameDynamicView && self.gameDynamicView.superview)
    {
        [self.gameDynamicView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        
        [self.gameDynamicView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.gameDynamicView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        [self.gameDynamicView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kForSegmentHight];
    }
    
    if (self.pkPoolView && self.pkPoolView.superview)
    {
        [self.pkPoolView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        
        [self.pkPoolView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.pkPoolView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        [self.pkPoolView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kForSegmentHight];
    }
}

- (void)addNotiftys
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openWebSiteWithUrl:)
                                                 name:@"pktaiOpenUrl"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pkTaiOpenViewController:)
                                                 name:@"pkTaiOpenViewController"
                                               object:nil];
}

#pragma mark - Getter
- (SPPKPoolController *)pkpoolController
{
    if (!_pkpoolController)
    {
        _pkpoolController = [[SPPKPoolController alloc ] initWithNibName:@"SPPKPoolController" bundle:[NSBundle mainBundle]];
    }
    return _pkpoolController;
}

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
        _segmentedControl.selectedIndex = 0;
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

- (SPPKView *)pkView
{
    if (!_pkView)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SPPKTaiView" owner:self options:nil];
        _pkView = nib[0];
        _pkView.backgroundColor = [UIColor whiteColor];
    }
    return _pkView;
}

- (SPGameDynamicView *)gameDynamicView
{
    if (!_gameDynamicView)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SPGameDynamic" owner:self options:nil];
        _gameDynamicView = nib[0];
        _gameDynamicView.backgroundColor = [UIColor whiteColor];
    }
    return _gameDynamicView;
}

#pragma mark - Private Methods
- (void)configConstrain
{
    //顶部
    [self.segmentedControl autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.segmentedControl autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.segmentedControl autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.segmentedControl autoSetDimension:ALDimensionHeight toSize:kForSegmentHight];
}

- (void)selectIndex:(NSUInteger)index
{
    if (index == 0)
    {
        [self.view bringSubviewToFront:self.pkView];
    }
    else if(index == 1)
    {
        if (!ISLogined)
        {
            self.segmentedControl.selectedIndex = 0;
            [self pressentToLoginViewController];
            return;
        }
        [self.view bringSubviewToFront:self.gameDynamicView];
    }
    else if (index == 2)
    {
        if (!ISLogined)
        {
            self.segmentedControl.selectedIndex = 0;
            [self pressentToLoginViewController];
            return;
        }
        [self.view bringSubviewToFront:self.pkPoolView];
    }
    self.title = self.titles[index];
}

- (void)openWebSiteWithUrl:(NSNotification *)notify;
{
    NSDictionary *info = notify.userInfo;
    NSString *url = info[@"url"];
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress:url];
    [self presentViewController:webViewController animated:YES completion:NULL];
}

- (void)pkTaiOpenViewController:(NSNotification *)notify
{
    NSDictionary *info = notify.userInfo;
    NSUInteger row = [info[@"row"] integerValue];
    UIViewController  *VC = nil;
    switch (row)
    {
        case 0:
        {
            SPGuessFingerController *gesVC = [[SPGuessFingerController alloc] init];
            VC = gesVC;
            break;
        }
        case 1:
        {
            break;
        }
        case 2:
            break;
        default:
            break;
    }
    if (VC)
    {
        [self presentViewControllerWithNavc:VC];
    }
}

@end
