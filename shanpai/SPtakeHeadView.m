//
//  SPtakeHeadView.m
//  shanpai
//
//  Created by liang chunyan on 14-11-28.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPtakeHeadView.h"
#import "SSTextView.h"

@interface SPtakeHeadView ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet SSTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *noSendButton;

//上传 不上传回调函数
- (void)sendAction:(UIButton *)button;
- (void)noSendAction:(UIButton *)button;
@end

@implementation SPtakeHeadView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.delegate = self;
    //占位符
    self.textView.placeholder = @"亲，请输入图片名称并对您上传的图片添加几句描述吧，字数必须10字以上";
    
    [self.sendButton addTarget:self
                        action:@selector(sendAction:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.noSendButton addTarget:self
                          action:@selector(noSendAction:)
                forControlEvents:UIControlEventTouchUpInside];
    
    self.textView.returnKeyType = UIReturnKeyDone;
}

- (void)sendAction:(UIButton *)button
{
    if (self.sendAction)
    {
        if (self.textView.text.length < 10)
        {
            [SVProgressHUD showErrorWithStatus:@"描述内容必须是10个字以上"];
        }
        else
        {
            self.sendAction(self.textView.text);
        }
    }
}

- (void)noSendAction:(UIButton *)button
{
    if (self.noSendAction)
    {
        self.noSendAction(@"");
    }
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

- (void)reSetPlaceholder
{
    //文本框没有文字
    if (self.textView.text.length < 1)
    {
        self.textView.placeholder = self.textView.placeholder;
    }
}

- (NSString *)content
{
    return self.textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
