//
//  SPReSetViewController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-5.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  *

#import "SPReSetViewController.h"


@interface SPReSetViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextView;
@property (weak, nonatomic) IBOutlet UITextField *codeTestView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextView;
@property (weak, nonatomic) IBOutlet UIButton *submmitButton;

//标签label
@property (nonatomic, strong) UILabel    *phoneLabel;
@property (nonatomic, strong) UILabel    *codeLabel;
@property (nonatomic, strong) UILabel    *passwordLabel;
//获取验证码button
@property (nonatomic, strong) UIButton   *getCode;

//
@property (nonatomic, copy) NSString     *phoneNumber;
@property (nonatomic, copy) NSString     *code;
@property (nonatomic, copy) NSString     *password;

//左侧标签栏的Frame
- (CGRect)leftLabelFrame;
//设置leftview and 获取验证码按钮
- (void)configLeftAndRightView;
//获取验证码
- (void)getCodeAction:(UIButton *)button;
//提交
- (void)submmitAction:(UIButton *)button;
//刷新界面
- (void)updateView;
//注册
- (void)registerAction;
@end

@implementation SPReSetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configLeftAndRightView];
    [self setBackLeftItem];
    [self updateView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.phoneNumberTextView becomeFirstResponder];
}

#pragma mark - getters
- (void)setControllerType:(viewType)controllerType
{
    _controllerType = controllerType;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel)
    {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.text = @"  手机号:";
        _phoneLabel.frame = [self leftLabelFrame];
    }
    return _phoneLabel;
}

- (UILabel *)codeLabel
{
    if (!_codeLabel)
    {
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.text  = @"  验证码:";
        _codeLabel.frame = [self leftLabelFrame];
    }
    return _codeLabel;
}

- (UILabel *)passwordLabel
{
    if (!_passwordLabel)
    {
        _passwordLabel = [[UILabel alloc] init];
        _passwordLabel.text = @"  密  码:";
        _passwordLabel.frame = [self leftLabelFrame];
    }
    return _passwordLabel;
}

- (UIButton *)getCode
{
    if (!_getCode)
    {
        _getCode = [[UIButton alloc] init];
        _getCode.frame = CGRectMake( 0, 0, 100, 35);
        _getCode.layer.cornerRadius = 3;
        _getCode.layer.borderColor = [UIColor blackColor].CGColor;
        _getCode.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        [_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCode.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_getCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _getCode;
}

#pragma mark - private method

- (void)updateView
{
    //代理设置
    self.phoneNumberTextView.delegate = self;
    self.codeTestView.delegate        = self;
    self.passwordTextView.delegate    = self;
    //键盘返回类型
    self.phoneNumberTextView.returnKeyType = UIReturnKeyNext;
    self.codeTestView.returnKeyType        = UIReturnKeyNext;
    self.passwordTextView.returnKeyType    = UIReturnKeyDone;
    
    //重新设置密码
    if (self.controllerType == resetPassward)
    {
        self.title = @"重设密码";
        [self.submmitButton setTitle:@"提   交" forState:UIControlStateNormal];
    }
    //注册页面
    else if (self.controllerType == registerType)
    {
        self.title = @"注册";
        [self.submmitButton setTitle:@"完成注册" forState:UIControlStateNormal];
        self.passwordTextView.placeholder = @"请输入密码，最少六位";
    }
    //按钮添加行为
    [self.getCode addTarget:self
                     action:@selector(getCodeAction:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [self.submmitButton addTarget:self
                           action:@selector(submmitAction:)
                 forControlEvents:UIControlEventTouchUpInside];
}
//左侧标签栏的Frame
- (CGRect)leftLabelFrame
{
    return CGRectMake( 0, 0, 80.0f, 35.0f);
}

- (void)configLeftAndRightView
{
    self.phoneNumberTextView.leftView     = self.phoneLabel;
    self.phoneNumberTextView.leftViewMode = UITextFieldViewModeAlways;
    
    self.codeTestView.leftView     = self.codeLabel;
    self.codeTestView.leftViewMode = UITextFieldViewModeAlways;
    self.codeTestView.rightView = self.getCode;
    self.codeTestView.rightViewMode = UITextFieldViewModeAlways;

    self.passwordTextView.leftView     = self.passwordLabel;
    self.passwordTextView.leftViewMode = UITextFieldViewModeAlways;
}

//获取验证码
- (void)getCodeAction:(UIButton *)button
{
    //验证码
    self.phoneNumber = self.phoneNumberTextView.text;
    if (self.phoneNumber.length < 1 || ![self.phoneNumber validateRegular:@"^1\\d{10}$"])
    {
        [self showTipMessage:@"请输入正确的手机号码"];
        [self.phoneNumberTextView becomeFirstResponder];
        return;
    }
    NSString *type = @"1";
    if (self.controllerType == resetPassward)
    {
        type = @"3";
    }
    //获取验证码
    NSDictionary *dic = @{
                          @"ukey"      : kForHttpPassword,
                          @"type"      : type,
                          @"phonenum"  : self.phoneNumber
                          };
    
    SPHttpClient *client = [SPHttpClient manager];
    [client GET:@"Public/getVerifyCode2/"
     parameters:dic
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self showTipMessage:responseObject[@"info"]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showTipMessage:error.localizedFailureReason];
        }];
    
    self.getCode.userInteractionEnabled = NO;
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
//            dispatch_release(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.getCode.userInteractionEnabled = YES;
            });
        }else{
//            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新获取",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getCode setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

//提交
- (void)submmitAction:(UIButton *)button
{
    [self.view endEditing:NO];
    self.phoneNumber = self.phoneNumberTextView.text;
    self.code        = self.codeTestView.text;
    self.password    = self.passwordTextView.text;
    
    if (self.phoneNumber.length < 1 || ![self.phoneNumber validateRegular:@"^1\\d{10}$"])
    {
        [self showTipMessage:@"请输入正确的手机号码"];
        [self.phoneNumberTextView becomeFirstResponder];
        return;
    }
    if (self.code.length < 1)
    {
        [self showTipMessage:@"请输入验证码"];
        [self.codeTestView becomeFirstResponder];
        return;
    }
    if (self.password.length < 1)
    {
        [self showTipMessage:@"请输入密码"];
        [self.passwordTextView becomeFirstResponder];
        return;
    }
    
    //注册
    if (self.controllerType == registerType)
    {
        [self registerAction];
    }
}

- (void)registerAction
{
    [SVProgressHUD show];
    [SPUserData registerWithAccount:self.phoneNumber
                           password:self.password
                            verCode:self.code
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                //没有注册成功
                                if ([responseObject[@"status"] integerValue] != 1)
                                {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                                    });
                                }
                                //注册成功
                                else
                                {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self showTipMessage:@"注册成功"];
                                    });
                                    [SPUserData saveAccount:self.phoneNumber pasword:self.password];
                                    //保存用户信息
                                    [SPUserData spUserInfo].loginInfo = responseObject[@"data"][0];
                                    //发出登录成功通知
                                    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
                                    [notification postNotificationName:kForLoginSucces object:self userInfo:responseObject[@"data"][0]];
                                    
                                    //返回
//                                    [self.navigationController popViewControllerAnimated:YES];
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                }
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD dismiss];
                                    [self showTipMessage:@"注册失败"];
                                });
                            }];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneNumberTextView)
    {
        [self.codeTestView becomeFirstResponder];
    }
    else if (textField == self.codeTestView)
    {
        [self.passwordTextView becomeFirstResponder];
    }//提交
    else
    {
        
    }
    return YES;
}

@end
