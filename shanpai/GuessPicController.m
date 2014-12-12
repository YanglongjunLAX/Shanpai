//
//  GuessPicController.m
//  shanpai
//
//  Created by liang chunyan on 14-12-9.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "GuessPicController.h"
#import "SPGuessFingerModel.h"
#import "SPEnemyController.h"
#import "SVModalWebViewController.h"

@interface GuessPicController ()
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *enemyHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *enemyNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIButton *beginButton;

@property (nonatomic, strong) NSDictionary  *userInfo;
@property (weak, nonatomic) IBOutlet UIButton *reBeginButton;
@property (weak, nonatomic) IBOutlet UIButton *rerejectButton;

- (void)loadSelfInfo;
- (void)loadRandomUserInfo;

//添加行为
- (void)addActions;
- (void)inviteFriend:(id)sender;
- (void)beginPintu:(id)sender;

//设置页面根据type
- (void)configViewBytype;
//加载邀请人信息
- (void)loadInviteFriendInfo;

//开始  ||  拒绝行为
- (void)reBeginAction:(UIButton *)button;
- (void)reRejectAction:(UIButton *)button;
@end

@implementation GuessPicController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"猜图";
    
    [self loadSelfInfo];
    [self loadRandomUserInfo];
    [self setBackLeftItem];
    [self addActions];
    
    [self configViewBytype];
    [self loadInviteFriendInfo];
}

- (void)loadSelfInfo
{
    if ([SPUserData spUserInfo].loginInfo[@"avatar"])
    {
        [self.userHeadImage setImageWithURL:[NSURL URLWithString:[SPUserData spUserInfo].loginInfo[@"avatar"]]];
    }
    self.userNameLabel.text = [SPUserData userNickName];
}

- (void)loadRandomUserInfo
{
    
    if (self.controllerType == SPpkAttack)
    {
        __weak typeof(self) weakSelf = self;
        [SPGuessFingerModel spgRequestRandUserInfo:^(NSDictionary *dictionary, NSError *error) {
            NSDictionary *otherInfo = dictionary[@"data"];
            if (![otherInfo[@"uid"] isEqualToString:[SPUserData userID]])
            {
                weakSelf.userInfo = dictionary[@"data"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.userInfo[@"avatar"] != nil)
                    {
                        [weakSelf.enemyHeadImage setImageWithURL:[NSURL URLWithString:self.userInfo[@"avatar"]]];
                    }
                    weakSelf.enemyNameLabel.text = weakSelf.userInfo[@"nickname"];
                });
            }
        }];
    }
}

- (void)addActions
{
    [self.inviteButton addTarget:self
                          action:@selector(inviteFriend:)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self.beginButton addTarget:self
                         action:@selector(beginPintu:)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.reBeginButton addTarget:self
                           action:@selector(reBeginAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [self.rerejectButton addTarget:self
                            action:@selector(reRejectAction:)
                  forControlEvents:UIControlEventTouchUpInside];
}

- (void)inviteFriend:(id)sender
{
    if (self.userInfo == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请邀请好友"];
    }
    else
    {
        SPEnemyController *friendVC = [[SPEnemyController alloc] init];
        __weak typeof(self) weakSelf = self;
        friendVC.selectFansFuncCall = ^(SPFansModel *model){
            weakSelf.userInfo = [model toDictionary];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.userInfo[@"avatar"] != nil)
                {
                    [weakSelf.enemyHeadImage setImageWithURL:[NSURL URLWithString:self.userInfo[@"avatar"]]];
                }
                weakSelf.enemyNameLabel.text = weakSelf.userInfo[@"nickname"];
            });
        };
        
        [self.navigationController pushViewController:friendVC animated:YES];
    }
}

- (void)beginPintu:(id)sender
{
    NSString *path = @"http://shanpai.iushare.com/Api/";
    NSString *fullPath = [NSString stringWithFormat:@"%@/GuessPic/insert/userid/%@/ruserid/%@",path,[SPUserData userID],self.userInfo[@"uid"]];
    
    SVModalWebViewController *modelVC = [[SVModalWebViewController alloc] initWithAddress:fullPath];
    [self presentViewController:modelVC animated:YES completion:^{
    }];
}

- (void)configViewBytype
{
    if (self.controllerType == SPpkAttack)
    {
        self.reBeginButton.hidden   = YES;
        self.rerejectButton.hidden  = YES;
    }
    else
    {
        self.inviteButton.hidden = YES;
        self.beginButton.hidden  = YES;
        [self loadInviteFriendInfo];
    }
}

- (void)loadInviteFriendInfo
{
    if (self.gameDynamicModel)
    {
        __weak typeof(self) weakSelf = self;
        self.enemyNameLabel.text = self.gameDynamicModel.nickname;
        if (self.gameDynamicModel.avatar)
        {
            [weakSelf.enemyHeadImage setImageWithURL:[NSURL URLWithString:self.gameDynamicModel.avatar]];
        }
    }
}

- (void)reBeginAction:(UIButton *)button
{
    NSString *path = @"http://shanpai.iushare.com/Api/GuessPic/play/";
    NSString *fullPath = [NSString stringWithFormat:@"%@userid/%@/id/%@",path,[SPUserData userID],self.gameDynamicModel.pk_id];
    SVModalWebViewController *modelVC = [[SVModalWebViewController alloc] initWithAddress:fullPath];
    [self presentViewController:modelVC animated:YES completion:^{
    }];
}

- (void)reRejectAction:(UIButton *)button
{
    [SPPKresultModel replyGuessPicRejectPKId:self.gameDynamicModel.pk_id
                                       model:@"GuessPic"
                                       block:^(NSDictionary *info, NSError *error) {
                                           if ([info[@"status"] integerValue] == 1)
                                           {
                                               //可以返回
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
                                       }];
}

@end
