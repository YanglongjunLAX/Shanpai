//
//  SPGuessFingerController.m
//  shanpai
//
//  Created by liang chunyan on 14-12-5.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPGuessFingerController.h"
#import "SPGuessFingerModel.h"
#import "UIButton+AFNetworking.h"

@interface SPGuessFingerController ()
//自己的头像
@property (weak, nonatomic) IBOutlet UIImageView *selfHeadImageView;
//邀请好友
@property (weak, nonatomic) IBOutlet UIButton *inviteFriendButton;
//对手的头像
@property (weak, nonatomic) IBOutlet UIButton *enemyButton;
//对手的名称
@property (weak, nonatomic) IBOutlet UILabel *enemyNameLabel;
//剪刀
@property (weak, nonatomic) IBOutlet UIImageView *jiandaoImageView;
//石头
@property (weak, nonatomic) IBOutlet UIImageView *shitouImageView;
//布
@property (weak, nonatomic) IBOutlet UIImageView *buImageView;
//放招出去
@property (weak, nonatomic) IBOutlet UIButton *pkButton;
//随机好友信息
@property (strong, nonatomic) NSDictionary *userInfo;
//选择标记
@property (nonatomic, assign) NSUInteger    sendTag;

- (void)loadSelfInfo;
//加载随机好友信息
- (void)loadRandomUserInfo;
- (void)spgSetActions;
- (void)imageViewTap:(UITapGestureRecognizer *)ges;
- (void)spgPKStart:(UIButton *)button;
@end

@implementation SPGuessFingerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"猜拳";
    [self setBackLeftItem];
    [self loadSelfInfo];
    [self loadRandomUserInfo];
    self.sendTag = 0;
    [self spgSetActions];
}

- (void)loadSelfInfo
{
    [self.selfHeadImageView setImageWithURL:[NSURL URLWithString:[SPUserData spUserInfo].loginInfo[@"avatar"]]];
}

- (void)loadRandomUserInfo
{
    __weak typeof(self) weakSelf = self;
    [SPGuessFingerModel spgRequestRandUserInfo:^(NSDictionary *dictionary, NSError *error) {
        weakSelf.userInfo = dictionary[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.userInfo[@"avatar"] != nil)
            {
                [weakSelf.enemyButton setBackgroundImageForState:UIControlStateNormal
                                                         withURL:[NSURL URLWithString:self.userInfo[@"avatar"]]];
            }
            weakSelf.enemyNameLabel.text = weakSelf.userInfo[@"nickname"];
        });
    }];
}

- (void)spgSetActions
{
    self.jiandaoImageView.userInteractionEnabled = YES;
    self.shitouImageView.userInteractionEnabled  = YES;
    self.buImageView.userInteractionEnabled      = YES;
    
    UITapGestureRecognizer *jiandaoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
    [self.jiandaoImageView addGestureRecognizer:jiandaoTap];
    
    UITapGestureRecognizer *shitouTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
    [self.shitouImageView addGestureRecognizer:shitouTap];
    
    UITapGestureRecognizer *buTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
    [self.buImageView addGestureRecognizer:buTap];
    
    [self.pkButton addTarget:self
                      action:@selector(spgPKStart:)
            forControlEvents:UIControlEventTouchUpInside];
}

- (void)imageViewTap:(UITapGestureRecognizer *)ges
{
    if (ges.view == self.jiandaoImageView)
    {
        self.sendTag = 1;
        [self.shitouImageView setImage:[UIImage imageNamed:@"pk_cq_shitou"]];
        [self.jiandaoImageView setImage:[UIImage imageNamed:@"pk_cq_jiandao_sel"]];
        [self.buImageView setImage:[UIImage imageNamed:@"pk_cq_bao"]];
    }
    else if (ges.view == self.shitouImageView)
    {
        self.sendTag = 2;
        [self.shitouImageView setImage:[UIImage imageNamed:@"pk_cq_shitou_sel"]];
        [self.jiandaoImageView setImage:[UIImage imageNamed:@"pk_cq_jiandao"]];
        [self.buImageView setImage:[UIImage imageNamed:@"pk_cq_bao"]];
    }
    else if (ges.view == self.buImageView)
    {
        self.sendTag = 3;
        
        [self.shitouImageView setImage:[UIImage imageNamed:@"pk_cq_shitou"]];
        [self.jiandaoImageView setImage:[UIImage imageNamed:@"pk_cq_jiandao"]];
        [self.buImageView setImage:[UIImage imageNamed:@"pk_cq_bao_sel"]];
    }
}

- (void)spgPKStart:(UIButton *)button
{
    [SPGuessFingerModel spgPKStartAction:[NSString stringWithFormat:@"%ld",(long)self.sendTag]
                                reuserId:self.userInfo[@"uid"] block:^(NSDictionary *info, NSError *error)
     {
         NSLog(@"%@",info);
                                }];
}

@end
