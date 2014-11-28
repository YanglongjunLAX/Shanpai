//
//  SPBaseViewController.h
//  shanpai
//
//  Created by liang chunyan on 14-11-4.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPBaseViewController : UIViewController

//设置切换城市按钮
- (void)setCityButton;

//设置个人中心按钮
- (void)setUserCenterButton;

//push到另外一个页面
- (void)pushToViewController:(UIViewController *)viewController;

//pressent-
- (void)presentViewControllerWithNavc:(UIViewController *)viewcontroller;

//显示tabbar
- (void)showTabbar;

//隐藏tabbar
- (void)hiddenTabbar;

//返回按钮
- (void)setBackLeftItem;

//返回按钮 action
- (void)setBackLeftItemWithAction:(SEL)section;

//popView
- (void)popViewController;
/*!
 *  初始化导航栏右边按钮
 *
 *  @param title  标题
 *  @param action 调用函数
 */
- (void)configRightItemWithTitle:(NSString*)title action:(SEL)action;
/*!
 *  提示信息
 *
 *  @param message 信息
 */
- (void)showTipMessage:(NSString *)message;
/*!
 *  登录成功通知
 *
 *  @param sender
 */
- (void)loginSuccess:(id)sender;
/*!
 *  跳转到登录界面
 */
- (void)pressentToLoginViewController;
@end
