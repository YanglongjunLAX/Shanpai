//
//  SPBeanHeadView.m
//  shanpai
//
//  Created by liang chunyan on 14-11-24.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPBeanHeadView.h"

@interface SPBeanHeadView()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *beanNumber;
@property (weak, nonatomic) IBOutlet UITextField *message;

- (void)spcsetFieldLeftAndRightView;

- (void)linkManAction:(UIButton *)button;

@end

@implementation SPBeanHeadView
@synthesize phone  = _phone;
@synthesize money  = _money;
@synthesize content = _content;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.beanNumber.keyboardType  = UIKeyboardTypeNumberPad;
    self.message.returnKeyType = UIReturnKeySend;
    
    [self spcsetFieldLeftAndRightView];
}

- (void)spcsetFieldLeftAndRightView
{
    //手机号码
    CGRect frame = CGRectMake( 0, 0, 60, 50);
    UILabel *label1 = [[UILabel alloc] initWithFrame:frame];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text     = @"手机号:";
    label1.textColor = [UIColor blackColor];
    self.phoneNumber.leftView = label1;
    self.phoneNumber.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"user_add_contacts_icon.png"]  forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 30, 50)];
    
    [button addTarget:self
               action:@selector(linkManAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    self.phoneNumber.rightView = button;
    self.phoneNumber.rightViewMode = UITextFieldViewModeAlways;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:frame];
    label2.text = @"数   量:";
    label2.textColor = [UIColor blackColor];
    label2.textAlignment = NSTextAlignmentCenter;
    self.beanNumber.leftView = label2;
    self.beanNumber.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:frame];
    label3.text = @"留个言:";
    label3.textColor = [UIColor blackColor];
    label3.textAlignment = NSTextAlignmentCenter;
    self.message.leftViewMode = UITextFieldViewModeAlways;
    self.message.leftView = label3;
}

- (void)setViewType:(beanType)viewType
{
    _viewType = viewType;
    //求金豆
    self.phoneNumber.placeholder = @"请输入土豪的手机号码";
    self.message.placeholder     = @"留言";
    if (self.viewType == spBeanTypeGet)
    {
        self.beanNumber.placeholder  = @"请输入想要的金豆数量";
    }
    else
    {
        self.beanNumber.placeholder  = @"请输入赠送的金豆数量";
    }
}

- (void)linkManAction:(UIButton *)button
{
    if (self.splinkman)
    {
        self.splinkman();
    }
}

- (NSString *)phone
{
    if (!_phone)
    {
        _phone = self.phoneNumber.text;
        if (_phone == nil)
        {
            _phone = @"";
        }
    }
    return _phone;
}

- (NSString *)content
{
    if (!_content)
    {
        _content = self.message.text;
        if (_content == nil)
        {
            _content = @"";
        }
    }
    return _content;
}

- (NSString *)money
{
    if (!_money)
    {
        _money = self.beanNumber.text;
        if (_money == nil)
        {
            _money = @"";
        }
    }
    return _money;
}

- (void)setPhone:(NSString *)phone
{
    _phone = phone;
    self.phoneNumber.text = phone;
}

@end
