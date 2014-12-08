//
//  SPOpinionBackController.m
//  shanpai
//
//  Created by liang chunyan on 14-12-5.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  意见反馈

#import "SPOpinionBackController.h"
#import "SSTextView.h"

@interface SPOpinionBackController ()<UITextViewDelegate>

@property (nonatomic, strong) SSTextView   *textView;
//意见反馈
- (void)sendOpinon;

@end

@implementation SPOpinionBackController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = [HXColor colorWithHexString:@"#F6F2ED"];
    [self.view addSubview:self.textView];
    [self.textView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [self.textView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [self.textView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [self.textView autoSetDimension:ALDimensionHeight toSize:150];
    
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.textView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [self.textView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [self.textView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [self.textView autoSetDimension:ALDimensionHeight toSize:150];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SSTextView *)textView
{
    if (!_textView)
    {
        _textView = [[SSTextView alloc] init];
        _textView.layer.borderWidth = 2.0;
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.layer.borderColor = [UIColor whiteColor].CGColor;
        _textView.layer.cornerRadius = 4;
        _textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 5);
        _textView.placeholder = @"如果您在使用过程有遇到疑问或是有好的建议，请反馈给我们，谢谢！";
        _textView.returnKeyType = UIReturnKeySend;
        self.textView.delegate = self;
    }
    return _textView;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        //发送
        [self sendOpinon];
        return NO;
    }
    return YES;
}

- (void)sendOpinon
{
    
    if (self.textView.text.length < 1)
    {
        return;
    }
    
    [self.textView resignFirstResponder];
    NSString      *path = @"Feedback/insert";
    NSDictionary  *params = @{
                              @"content"  : self.textView.text,
                              };
    
    [SVProgressHUD show];
    [[SPHttpClient manager] POST:path
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
                             if ([responseObject[@"status"] integerValue] == 1)
                             {
                                 [self.navigationController popViewControllerAnimated:YES];
                             }
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [SVProgressHUD showErrorWithStatus:@"发送失败"];
                         }];
}

@end
