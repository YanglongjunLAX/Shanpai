//
//  SPLoginViewController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-5.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPLoginViewController.h"
#import "SPReSetViewController.h"//忘记密码

@interface SPLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwd;
@property (weak, nonatomic) IBOutlet UIButton *loginByQQBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginByWeiboBtn;

//设置试图样式
- (void)configViewStyle;
//设置
- (void)setSelctors;
//登录
- (void)loginAction:(id)sender;
//忘记密码
- (void)forgetPwdAction:(id)sender;
//QQ登录
- (void)qqLoginAction:(id)sender;
//微博登录
- (void)weiboLoginAction:(id)sender;
//注册
- (void)gotoRegisterViewController:(id)sender;
@end

@implementation SPLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登录";
    [self configViewStyle];
    [self setSelctors];
    [self setBackLeftItem];
    [self configRightItemWithTitle:@"注册" action:@selector(gotoRegisterViewController:)];
    [self.accountTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - PrivateMethod
- (void)setSelctors
{
    [self.loginButton addTarget:self
                         action:@selector(loginAction:)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.forgetPwd addTarget:self
                       action:@selector(forgetPwdAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginByQQBtn addTarget:self
                          action:@selector(qqLoginAction:)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginByWeiboBtn addTarget:self
                             action:@selector(weiboLoginAction:)
                   forControlEvents:UIControlEventTouchUpInside];
}

//登录
- (void)loginAction:(id)sender
{
    [self.view endEditing:NO];
    
    NSString *_account  = self.accountTextField.text;
    NSString *_password = self.pwdTextField.text;
    
    if (_account.length < 1)
    {
        [self showTipMessage:@"账号不能为空"];
        [self.accountTextField becomeFirstResponder];
        return;
    }
    if (_password.length < 1)
    {
        [self showTipMessage:@"密码不能为空"];
        [self.pwdTextField becomeFirstResponder];
        return;
    }
    [SVProgressHUD show];
    [SPUserData loginWithAccount:_account
                        password:_password
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             //提示
//                             [self showTipMessage:responseObject[@"info"]];
                             
                             //登陆成功
                             if ([responseObject[@"status"] integerValue] == 1)
                             {
                                 //保存用户信息
                                 [SPUserData spUserInfo].loginInfo = responseObject[@"data"][0];
                                 //保存账号密码
                                 [SPUserData saveAccount:_account pasword:_password];
                                 //发出登录成功通知
                                 NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
                                 [notification postNotificationName:kForLoginSucces object:self userInfo:responseObject[@"data"][0]];
                                 //返回
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
                             [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                             [self showTipMessage:[error localizedFailureReason]];
                             [SVProgressHUD showErrorWithStatus:[error localizedFailureReason]];
                         }];
}

//忘记密码
- (void)forgetPwdAction:(id)sender
{
    SPReSetViewController *forgetpwVC = [[SPReSetViewController alloc] init];
    forgetpwVC.controllerType = resetPassward;
    [self pushToViewController:forgetpwVC];
}

//注册页面
- (void)gotoRegisterViewController:(id)sender
{
    SPReSetViewController *forgetpwVC = [[SPReSetViewController alloc] init];
    forgetpwVC.controllerType = registerType;
    [self pushToViewController:forgetpwVC];
}

//QQ登录
- (void)qqLoginAction:(id)sender
{
    
}

//微博登录
- (void)weiboLoginAction:(id)sender
{
}

- (void)configViewStyle
{
    CGRect rect = CGRectMake(0, 0, 40, 50);
    //账号框左侧视图
    UIImageView *accountImageView = [[UIImageView alloc] init];
    accountImageView.contentMode = UIViewContentModeScaleAspectFit;
    accountImageView.image = [UIImage imageNamed:@"login_inptu_user_icon"];
    accountImageView.frame = rect;
    self.accountTextField.leftView = accountImageView;
    self.accountTextField.leftViewMode = UITextFieldViewModeAlways;
    self.accountTextField.keyboardType = UIKeyboardTypePhonePad;
    self.accountTextField.delegate = self;
    self.accountTextField.returnKeyType = UIReturnKeyNext;
    
    //密码框左侧视图
    UIImageView *pwdImageView = [[UIImageView alloc] init];
    pwdImageView.contentMode = UIViewContentModeScaleAspectFit;
    pwdImageView.image = [UIImage imageNamed:@"login_inptu_password_icon"];
    pwdImageView.frame = rect;
    self.pwdTextField.leftView = pwdImageView;
    self.pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    self.pwdTextField.delegate = self;
    self.pwdTextField.returnKeyType = UIReturnKeyDone;
    
    //登录按钮
    UIImage *loginImage = [UIImage imageNamed:@"login_btn"];
    loginImage = [loginImage stretchableImageWithLeftCapWidth:loginImage.size.width*0.5 topCapHeight:loginImage.size.height*0.5];
    [self.loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.accountTextField)
    {
        [self.pwdTextField becomeFirstResponder];
    }
    else
    {
        [self loginAction:nil];
    }
    return YES;
}

@end
