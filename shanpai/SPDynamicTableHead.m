//
//  SPDynamicTableHead.m
//  shanpai
//
//  Created by liang chunyan on 14-12-2.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPDynamicTableHead.h"
#import "SPDynamicModel.h"

@interface SPDynamicTableHead()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *releationButton;
@property (weak, nonatomic) IBOutlet UIButton *modifyNickName;

- (void)relationButtonClicked:(UIButton *)button;
- (void)modifyButtonClicked:(UIButton *)button;
//修改备注名字
- (void)modifyNickNameAction;
@end

@implementation SPDynamicTableHead

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.imageView.layer.cornerRadius = 4;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 1.5f;
    
    [self.releationButton addTarget:self
                             action:@selector(relationButtonClicked:)
                   forControlEvents:UIControlEventTouchUpInside];
    [self.modifyNickName addTarget:self
                            action:@selector(modifyButtonClicked:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [lineView autoSetDimension:ALDimensionHeight toSize:1];
}

- (void)setUserInfo:(SPFansModel *)userInfo
{
    _userInfo = userInfo;
    //更新界面数据
    if (self.userInfo)
    {
        if (self.userInfo.avatar == nil || self.userInfo.avatar.length < 1)
        {
            self.imageView.image = [UIImage imageNamed:@"user_header"];
        }
        else
        {
            [self.imageView setImageWithURL:[NSURL URLWithString:self.userInfo.avatar]];
        }
        self.nameLabel.text = self.userInfo.nickname;
        //取消关注
        if ([self.userInfo.relation integerValue] == 1 || [self.userInfo.relation integerValue] == 3)
        {
            [self.releationButton setTitle:@"取消关注" forState:UIControlStateNormal];
        }
        //添加关注
        else
        {
            [self.releationButton setTitle:@"添加关注" forState:UIControlStateNormal];
        }
    }
}

- (void)relationButtonClicked:(UIButton *)button
{
    if (self.relationAction)
    {
        self.relationAction();
    }
}

- (void)modifyButtonClicked:(UIButton *)button
{
    if (self.modifyAction)
    {
        self.modifyAction();
    }
    [self modifyNickNameAction];
}

- (void)setReleationTitle:(NSString *)releationTitle
{
    _releationTitle = releationTitle;
    if (self.releationTitle)
    {
        [self.releationButton setTitle:self.releationTitle forState:UIControlStateNormal];
    }
}

- (void)modifyNickNameAction
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改备注名"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UITextField *textfiled = [alertView textFieldAtIndex:0];
        __weak __typeof(self)weakSelf = self;
        [SPDynamicModel spdModifyNickName:textfiled.text
                                   userID:self.userInfo.uid
                                    block:^(NSDictionary *info, NSError *error) {
                                        //修改成功
                                        
                                        if ([info[@"status"] integerValue] == 1)
                                        {
                                            weakSelf.nameLabel.text = textfiled.text;
                                        }
                                    }];
    }
}

@end
