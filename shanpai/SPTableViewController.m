//
//  SPTableViewController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-4.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPTableViewController.h"
#import "SPTabbarView.h"
#import "SPTaskViewController.h"//任务
#import "SPPKViewController.h"//pk台
#import "ShanpaiViewController.h"//拍照
#import "SPPinpaiViewController.h"//品牌
#import "SPStroeViewController.h"//商城

@interface SPTabbarController ()

@property (nonatomic, readonly) SPTabbarView *tabbarView;
//配置tabbarView
- (void)configTabbarView;
//添加viewControllers
- (void)addViewControllers;
//设置全局的nav
- (void)configNavbar;
//添加通知
- (void)addNotify;
//隐藏自定义的tabbar
- (void)hiddenTabbar:(id)sender;
//显示自定义的Tabbar
- (void)showTabbar:(id)sender;
@end

@implementation SPTabbarController
@synthesize tabbarView = _tabbarView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configNavbar];
    [self configTabbarView];
    [self addViewControllers];
    [self addNotify];
}

- (void)dealloc
{
    NSNotificationCenter *notifiCenter = [NSNotificationCenter defaultCenter];
    
    [notifiCenter removeObserver:self
                            name:kForHiddenTabbar
                          object:nil];
    
    [notifiCenter removeObserver:self
                            name:kForShowTabbar
                          object:nil];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
//    [self.view autoRemoveConstraintsAffectingViewAndSubviews];
    [self.tabbarView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    
    [self.tabbarView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    [self.tabbarView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.tabbarView autoSetDimension:ALDimensionHeight toSize:CGRectGetHeight(self.tabBar.frame)];
}

- (void)awakeFromNib
{
//    self.tabBar.alpha = 0.0;
    self.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - private method
- (void)addNotify
{
    NSNotificationCenter *notifiCenter = [NSNotificationCenter defaultCenter];
    [notifiCenter addObserver:self
                     selector:@selector(hiddenTabbar:)
                         name:kForHiddenTabbar
                       object:nil];
    
    [notifiCenter addObserver:self
                     selector:@selector(showTabbar:)
                         name:kForShowTabbar
                       object:nil];
}

- (void)hiddenTabbar:(id)sender
{
    self.tabbarView.hidden = YES;
}

- (void)showTabbar:(id)sender
{
    self.tabbarView.hidden = NO;
    [self.view bringSubviewToFront:self.tabbarView];
}

- (void)configTabbarView
{
    [self.view addSubview:self.tabbarView];
    [self.view bringSubviewToFront:self.tabbarView];
    [self.tabbarView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    
    [self.tabbarView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    [self.tabbarView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.tabbarView autoSetDimension:ALDimensionHeight toSize:CGRectGetHeight(self.tabBar.frame)];
}

- (void)configNavbar
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 2.设置导航栏的背景图片
    NSString *navBarBg = nil;
    navBarBg = @"nav_bar_bg_ios7";
    navBar.tintColor = [UIColor whiteColor];
    [navBar setBackgroundImage:[UIImage imageNamed:navBarBg] forBarMetrics:UIBarMetricsDefault];
    // 3.标题
    [navBar setTitleTextAttributes:@{
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     }];
}

- (void)addViewControllers
{
    //任务
    SPTaskViewController   *vc1  = [[SPTaskViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    //pk台
    SPPKViewController      *vc2  = [[SPPKViewController alloc] init];
    UINavigationController  *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    //闪拍
    ShanpaiViewController   *vc3  = [[ShanpaiViewController alloc] init];
    UINavigationController  *nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    //品牌
    SPPinpaiViewController  *vc4 = [[SPPinpaiViewController alloc] init];
    UINavigationController  *nav4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    //商城
    SPStroeViewController   *vc5 = [[SPStroeViewController alloc] init];
    UINavigationController  *nav5 = [[UINavigationController alloc] initWithRootViewController:vc5];
    
    NSArray *array = @[
                        nav1,
                        nav2,
                        nav3,
                        nav4,
                        nav5,
                       ];
    self.viewControllers = array;
}

#pragma mark - getters
- (SPTabbarView *)tabbarView
{
    if (!_tabbarView)
    {
        _tabbarView = [[SPTabbarView alloc] init];
        __weak __typeof(&*self)weakSelf = self;
        _tabbarView.action = ^(NSInteger index)
        {
            __strong __typeof(&*weakSelf)strongSelf = weakSelf;
            if (!strongSelf)
            {
                return;
            }
            strongSelf.selectedIndex = index;
        };
    }
    return _tabbarView;
}

@end
