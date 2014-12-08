//
//  SPModifyInfoController.m
//  shanpai
//
//  Created by liang chunyan on 14-12-4.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPModifyInfoController.h"

@interface SPModifyInfoController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tesxtField;
@property (nonatomic, strong) UILabel  *leftView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, copy) NSString  *httpKey;
@property (nonatomic, copy) NSString  *httpValue;

- (void)spmSetSubViews;
- (void)spmSetTextField;
- (void)spmSetPickerView;
- (void)confirmAction:(id)sender;
@end

@implementation SPModifyInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self spmSetSubViews];
    [self spmSetTextField];
    
    if (self.modifystyle != SPModifySex)
    {
        self.pickerView.hidden = YES;
    }
    else
    {
        [self spmSetPickerView];
        self.tesxtField.userInteractionEnabled = NO;
    }
    
    [self configRightItemWithImage:@"nav_bar_confirm_icon" action:@selector(confirmAction:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)spmSetSubViews
{
    switch (self.modifystyle)
    {
        case SPModifySex:
            self.title = @"更改性别";
            self.tesxtField.text = [SPUserData userSex];
            self.httpKey = @"gender";
            break;
        case SPModifyNickName:
            self.title = @"更改昵称";
            self.tesxtField.text = [SPUserData userNickName];
            self.httpKey = @"nickname";
            break;
        case SPModifyName:
            self.title = @"真实姓名";
            self.tesxtField.text = [SPUserData userName];
            self.httpKey = @"name";
            break;
        case SPModifyPostNumber:
            self.title = @"收获邮编";
            self.httpKey = @"receive_postcode";
            self.tesxtField.text = [SPUserData receive_postcode];
            break;
        case SPModifyPostAdder:
            self.title = @"收获地址";
            self.httpKey = @"receive_address";
            self.tesxtField.text = [SPUserData receive_address];
            break;
        default:
            break;
    }
}

- (void)spmSetTextField
{
    self.tesxtField.leftView = self.leftView;
    self.tesxtField.leftViewMode = UITextFieldViewModeAlways;
}

- (UILabel *)leftView
{
    if (!_leftView)
    {
        CGRect rect = CGRectMake( 0, 0, 100, 40);
        _leftView = [[UILabel alloc] initWithFrame:rect];
        _leftView.textAlignment = NSTextAlignmentCenter;
        _leftView.text = self.navigationItem.title;
        _leftView.textColor = [UIColor blackColor];
    }
    return _leftView;
}

- (void)spmSetPickerView
{
    self.pickerView.delegate   = self;
    self.pickerView.dataSource = self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *result = nil;
    
    if (row == 0)
    {
        result = @"男";
    }
    else if (row == 1)
    {
        result = @"女";
    }
    
    return result;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0)
    {
        self.tesxtField.text = @"男";
    }
    else
    {
        self.tesxtField.text = @"女";
    }
}

- (void)confirmAction:(id)sender
{
    if (self.modifystyle == SPModifySex)
    {
        if ([self.tesxtField.text isEqualToString:@"男"])
        {
            self.httpValue = @"1";
        }
        else if([self.tesxtField.text isEqualToString:@"女"])
        {
            self.httpValue = @"0";
        }
    }
    else
    {
        self.httpValue = self.tesxtField.text;
    }
    if(self.httpValue.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"修改内容不能为空"];
        return;
    }
    
    [SPUserData updateUserInfo:@{self.httpKey : self.httpValue} block:^(NSDictionary *info, NSError *error) {
        
        if ([info[@"status"] integerValue] == 1)//信息修改成功
        {
            NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithDictionary:[SPUserData spUserInfo].loginInfo];
            info[self.httpKey] = self.httpValue;
            [SPUserData spUserInfo].loginInfo = info;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

@end
