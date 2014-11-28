//
//  SPUserCenterHeadView.m
//  shanpai
//
//  Created by liang chunyan on 14-11-12.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPUserCenterHeadView.h"
#import "UIButton+AFNetworking.h"

@interface SPUserCenterHeadView()
@property (weak, nonatomic) IBOutlet UIButton *userHeadView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *seImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomView; //底部view
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;//关注
@property (weak, nonatomic) IBOutlet UILabel *attentionNumber;//关注数目
@property (weak, nonatomic) IBOutlet UIButton *funsBtn;
@property (weak, nonatomic) IBOutlet UILabel *funsNumber;

//点击关注按钮
- (void)attentCall:(UIButton *)button;
//点击粉丝
- (void)funcsCall:(UIButton *)button;
/*!
 *  更换头像
 */
- (void)changeHead:(UIButton *)button;
@end

@implementation SPUserCenterHeadView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.bottomView.backgroundColor = [UIColor blackColor];
    self.bottomView.layer.opacity  = .5f;
    self.attentionNumber.textColor = [UIColor whiteColor];
    self.funsNumber.textColor      = [UIColor whiteColor];
    self.userNameLabel.textColor   = [UIColor whiteColor];
    
    CGFloat corWith = 75.0*0.5;
    self.userHeadView.layer.cornerRadius = corWith;
    self.userHeadView.layer.borderWidth = 2.0;
    self.userHeadView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userHeadView.layer.masksToBounds = YES;
    
    [self.userHeadView addTarget:self
                          action:@selector(changeHead:)
                forControlEvents:UIControlEventTouchUpInside];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    //更新数据
    [self updateUserInfo];
}

- (void)updateUserInfo
{
    //根据是否登录显示状态
    if (ISLogined)
    {
        
        NSDictionary *userInfo = [SPUserData spUserInfo].loginInfo;
        //头像
        [self.userHeadView setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:userInfo[@"avatar"]]];
        self.userNameLabel.text = userInfo[@"nickname"];
        self.attentionNumber.text = userInfo[@"follow_count"];
        self.funsNumber.text = userInfo[@"fans_count"];
        
        NSInteger gender = [userInfo[@"gender"] integerValue];
        //女
        if (gender == 0)
        {
            self.seImageView.image = [UIImage imageNamed:@"user_sex_female_icon"];
        }
        else //男
        {
            self.seImageView.image = [UIImage imageNamed:@"user_sex_male_icon"];
        }
        
    }
    else
    {
        self.userNameLabel.text = nil;
        [self.userHeadView setBackgroundImage:[UIImage imageNamed:@"pk_default_avatar"] forState:UIControlStateNormal];
    }
}

- (void)attentCall:(UIButton *)button
{
    if (self.attenBlock)
    {
        self.attenBlock();
    }
}

- (void)funcsCall:(UIButton *)button
{
    if (self.funcsBlock)
    {
        self.funcsBlock();
    }
}

- (void)changeHead:(UIButton *)button
{
    if (self.changeHeadImage)
    {
        self.changeHeadImage();
    }
}

@end
