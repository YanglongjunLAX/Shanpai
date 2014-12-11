//
//  SPEditPhoneNumberController.m
//  shanpai
//
//  Created by liang chunyan on 14-12-8.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPEditPhoneNumberController.h"

@interface SPEditPhoneNumberController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *vCode;

- (void)speSetTextFields;
//发送验证码
- (void)sendVCode:(UIButton *)button;
//确定修改
- (void)send:(id)sender;
@end

@implementation SPEditPhoneNumberController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"编辑手机号";
    [self speSetTextFields];
    [self configRightItemWithTitle:@"确定" action:@selector(send:)];
}

- (void)speSetTextFields
{
    CGRect frame = CGRectMake( 0, 0, 60, 50);
    UILabel *pleftLabel = [[UILabel alloc] initWithFrame:frame];
    pleftLabel.text = @"手机号:";
    self.phoneNumber.leftView     = pleftLabel;
    self.phoneNumber.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumber.placeholder = @"请输入您的手机号码";
    self.phoneNumber.keyboardType = UIKeyboardTypePhonePad;
    
    UILabel *vLeftLabel = [[UILabel alloc] initWithFrame:frame];
    vLeftLabel.text = @"验证码:";
    self.vCode.leftViewMode = UITextFieldViewModeAlways;
    self.vCode.leftView = vLeftLabel;
    self.vCode.keyboardType = UIKeyboardTypePhonePad;
    self.vCode.placeholder  = @"请输入验证码";
    
    CGRect bFrame = CGRectMake( 0, 0, 130, 50);
    UIButton *sendVVodeBtn = [[UIButton alloc] initWithFrame:bFrame];
    [sendVVodeBtn setTitle:@"发送验证码>" forState:UIControlStateNormal];
    [sendVVodeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [sendVVodeBtn addTarget:self
                     action:@selector(sendVCode:)
           forControlEvents:UIControlEventTouchUpInside];
    
    self.phoneNumber.rightView = sendVVodeBtn;
    self.phoneNumber.rightViewMode = UITextFieldViewModeAlways;
}

- (void)sendVCode:(UIButton *)button
{
    if (self.phoneNumber.text.length < 1 || ![self.phoneNumber.text validateRegular:@"^1\\d{10}$"])
    {
        [self showTipMessage:@"请输入正确的手机号码"];
        [self.phoneNumber becomeFirstResponder];
        return;
    }
    //获取验证码
    NSDictionary *dic = @{
                          @"type"      : @2,
                          @"phonenum"  : self.phoneNumber.text
                          };
    
    [SVProgressHUD show];
    SPHttpClient *client = [SPHttpClient manager];
    [client GET:@"Public/getVerifyCode2/"
     parameters:dic
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showTipMessage:error.localizedFailureReason];
        }];
}

- (void)send:(id)sender
{
    NSString       * path = @"Member/checkPhone";
    NSDictionary   * params = @{
                                @"vercode"   :  self.vCode.text,
                                @"phonenum"  :  self.phoneNumber.text,
                                };
    
    [SVProgressHUD show];
    SPHttpClient *client = [SPHttpClient manager];
    [client GET:path
     parameters:params
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showTipMessage:error.localizedFailureReason];
        }];
}

@end
