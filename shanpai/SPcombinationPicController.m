//
//  SPcombinationPicController.m
//  shanpai
//
//  Created by liang chunyan on 14-12-9.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPcombinationPicController.h"
#import "SPGuessFingerModel.h"
#import "SVModalWebViewController.h"
#import "SPEnemyController.h"
#import <CoreText/CoreText.h>

@interface SPcombinationPicController ()
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIImageView *enemyHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *enemyNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *beginPkBtn;

/*!
 *  回复别人的pk邀请
 */
@property (weak, nonatomic) IBOutlet UIButton *reBeginButton; //开始
@property (weak, nonatomic) IBOutlet UIButton *reRejectButton;//拒绝

//对手信息
@property (nonatomic, strong) NSDictionary *userInfo;

//加载自己的信息
- (void)loadSelfInfo;
//随机请求好友信息
- (void)loadRandomUserInfo;
//开始拼图
- (void)beginPinTu:(id)sender;
//添加行为
- (void)addActions;
//邀请好友
- (void)inviteFriend:(id)sender;
//设置界面
- (void)configViewByType;
//加载邀请人信息
- (void)loadInviteFriendInfo;

//开始  ||  拒绝行为
- (void)reBeginAction:(UIButton *)button;
- (void)reRejectAction:(UIButton *)button;
@end

@implementation SPcombinationPicController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"限时拼图";
    [self setBackLeftItem];
    [self loadSelfInfo];
    [self loadRandomUserInfo];
    [self addActions];
    [self configViewByType];
}

- (void)loadSelfInfo
{
    if ([SPUserData spUserInfo].loginInfo[@"avatar"])
    {
        [self.userHeadImage setImageWithURL:[NSURL URLWithString:[SPUserData spUserInfo].loginInfo[@"avatar"]]];
    }
    self.userNameLabel.text = [SPUserData userNickName];
}

- (void)addActions
{
    [self.beginPkBtn addTarget:self
                        action:@selector(beginPinTu:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.inviteButton addTarget:self
                          action:@selector(inviteFriend:)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self.reBeginButton addTarget:self
                           action:@selector(reBeginAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [self.reRejectButton addTarget:self
                            action:@selector(reRejectAction:)
                  forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadRandomUserInfo
{
    if (self.controllerType != SPpkAttack)
    {
        return;
    }
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

//开始拼图
- (void)beginPinTu:(id)sender
{
    NSString *path = @"http://shanpai.iushare.com/Api/";
    NSString *fullPath = [NSString stringWithFormat:@"%@/Puzzle/insert/userid/%@/ruserid/%@",path,[SPUserData userID],self.userInfo[@"uid"]];
    
    SVModalWebViewController *modelVC = [[SVModalWebViewController alloc] initWithAddress:fullPath];
    [self presentViewController:modelVC animated:YES completion:^{
    }];
}

//邀请好友
- (void)inviteFriend:(id)sender
{
    if (self.controllerType != SPpkAttack)
    {
        return;
    }
    SPEnemyController *friendVC = [[SPEnemyController alloc] init];
    __weak typeof(self) weakSelf = self;
    friendVC.selectFansFuncCall = ^(SPFansModel *model){
        weakSelf.userInfo = [model toDictionary];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (weakSelf.userInfo[@"avatar"] != nil)
            {
                [weakSelf.enemyHeadImage setImageWithURL:[NSURL URLWithString:self.userInfo[@"avatar"]]];
            }
            
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:weakSelf.userInfo[@"nickname"]];
            [attrStr addAttribute:(id)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:NSMakeRange(0, [attrStr.string length])];
            
            weakSelf.enemyNameLabel.attributedText = attrStr;
        });
    };
    
    [self.navigationController pushViewController:friendVC animated:YES];
}

- (void)configViewByType
{
    if (self.controllerType == SPpkAttack)
    {
        self.reBeginButton.hidden    = YES;
        self.reRejectButton.hidden   = YES;
    }
    else if (self.controllerType == SPpkBeating)
    {
        self.inviteButton.hidden = YES;
        self.beginPkBtn.hidden   = YES;
        [self loadInviteFriendInfo];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"没有设置页面类型"];
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
    NSString *path = @"http://shanpai.iushare.com/Api/Puzzle/play/";
    NSString *fullPath = [NSString stringWithFormat:@"%@userid/%@/id/%@",path,[SPUserData userID],self.gameDynamicModel.pk_id];
    SVModalWebViewController *modelVC = [[SVModalWebViewController alloc] initWithAddress:fullPath];
    [self presentViewController:modelVC animated:YES completion:^{
    }];
}

- (void)reRejectAction:(UIButton *)button
{
    [SPPKresultModel replyGuessPicRejectPKId:self.gameDynamicModel.pk_id
                                       model:@"Puzzle"
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
