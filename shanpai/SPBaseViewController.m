//
//  SPBaseViewController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-4.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPBaseViewController.h"
#import "BLChangeToUserView.h"//
#import "SPLoginViewController.h"//登录
#import "SPCityViewController.h"//切换城市
#import "TKAlertCenter.h"
#import "SPUserData.h"//用户
#import "SPUserViewController.h"

#define kForNavItemWidth        44.0f
#define kForNavItemHight        44.0f

static NSString *ncityName = @"广州";

@interface SPBaseViewController ()
//切换到用户中心
@property (nonatomic, strong) BLChangeToUserView *userView;
//切换到选择城市
@property (nonatomic, strong) UIButton *cityButton;
//切换城市
- (void)changeCity:(id)sender;
//切换到用户中心
- (void)changeToUserCenter:(id)sender;
//添加通知
- (void)addNotifications;
//登录成功
- (void)loginSuccess:(id)sender;
//退出登录
- (void)loginOut:(UIButton *)button;
@end

@implementation SPBaseViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        [self addNotifications];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.cityButton)
    {
        [self.cityButton setTitle:ncityName forState:UIControlStateNormal];
    }
    
    if (self.userView)
    {
        [self.userView updateImage];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//布局设置
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom;
}

//设置标题
- (void)setTitle:(NSString *)title
{
    self.navigationItem.title = title;
}


//添加通知
- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess:)
                                                 name:kForLoginSucces
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginOut:)
                                                 name:kForLoginOut
                                               object:nil];
}

- (void)loginSuccess:(id)sender
{
    if ([SPUserData spUserInfo].loginInfo)
    {
        //已经登录
        self.userView.state = 1;
    }
}

- (void)loginOut:(UIButton *)button
{
    self.userView.state = 0;
}

//设置切换城市按钮
- (void)setCityButton
{
    if (!self.cityButton)
    {
        self.cityButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, kForNavItemWidth, kForNavItemHight)];
        self.cityButton.showsTouchWhenHighlighted = YES;
    }
    
    [self.cityButton setTitle:ncityName forState:UIControlStateNormal];
    [self.cityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cityButton addTarget:self action:@selector(changeCity:) forControlEvents:UIControlEventTouchUpInside];
    if (self.navigationItem)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cityButton];
    }
}

//切换城市
- (void)changeCity:(id)sender
{
    SPCityViewController *cityVC = [[SPCityViewController alloc] init];
    cityVC.cityChanged = ^(NSString *cityName)
    {
        ncityName = cityName;
    };
    [self presentViewControllerWithNavc:cityVC];
}

//设置个人中心按钮
- (void)setUserCenterButton
{
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SPChangeToUser"owner:self options:nil];
    self.userView = nib[0];
    self.userView.frame = CGRectMake(0, 0, kForNavItemWidth, kForNavItemHight);
    self.userView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeToUserCenter:)];
    [self.userView addGestureRecognizer:tapGes];
    
    if ([SPUserData spUserInfo].loginInfo)
    {
        //已经登录
        self.userView.state = 1;
    }
    
    if (self.navigationItem)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.userView];
    }
}
//切换到用户中心
- (void)changeToUserCenter:(id)sender
{
    //没有登录
    if (!ISLogined)
    {
        SPLoginViewController *loginViewController = [[SPLoginViewController alloc] init];
        [self presentViewControllerWithNavc:loginViewController];
    }
    else
    {
        SPUserViewController *userVC = [[SPUserViewController alloc] init];
        [self presentViewControllerWithNavc:userVC];
    }
}

//跳转
- (void)pushToViewController:(UIViewController *)viewController
{
    if (self.navigationController)
    {
        self.hidesBottomBarWhenPushed = YES;
        [self hiddenTabbar];
        //隐藏掉自定义的tabbar
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)showTabbar
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kForShowTabbar
                                                        object:nil
                                                      userInfo:nil];
}

- (void)hiddenTabbar
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kForHiddenTabbar
                                                        object:nil
                                                      userInfo:nil];
}

- (void)setBackLeftItem
{
    [self setBackLeftItemWithAction:@selector(popViewController)];
}

- (void)setBackLeftItemWithAction:(SEL)section
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kForNavItemWidth, kForNavItemHight)];
    [button addTarget:self
               action:section
     forControlEvents:UIControlEventTouchUpInside];
    //设置 图片
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    if (self.navigationItem)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)popViewController
{
    //可以返回
    if (self.navigationController.viewControllers.count > 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (void)configRightItemWithTitle:(NSString *)title action:(SEL)action
{
    if (self.navigationItem)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kForNavItemWidth, kForNavItemHight)];
        [button setTitle:title forState:UIControlStateNormal];
        if (action)
        {
            [button addTarget:self
                       action:action
             forControlEvents:UIControlEventTouchUpInside];
        }
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)showTipMessage:(NSString *)message
{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
}

- (void)setHidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed
{
    [super setHidesBottomBarWhenPushed:hidesBottomBarWhenPushed];
    
}

- (void)presentViewControllerWithNavc:(UIViewController *)viewcontroller
{
    if ([viewcontroller isKindOfClass:[UINavigationController class]])
    {
        [self presentViewController:viewcontroller animated:YES completion:^{
            
        }];
    }
    else
    {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }
}

- (void)pressentToLoginViewController
{
    SPLoginViewController *loginViewController = [[SPLoginViewController alloc] init];
    [self presentViewControllerWithNavc:loginViewController];
}

@end
