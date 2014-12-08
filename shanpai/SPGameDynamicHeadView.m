//
//  SPGameDynamicHeadView.m
//  shanpai
//
//  Created by liang chunyan on 14-12-3.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPGameDynamicHeadView.h"
#import "SPGameDynamicModel.h"

@interface SPGameDynamicHeadView()
@property (weak, nonatomic) IBOutlet UILabel *winLabel;
@property (weak, nonatomic) IBOutlet UILabel *loseLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
//请求游戏结果
- (void)requestAllResuest;
@end

@implementation SPGameDynamicHeadView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self requestAllResuest];
}

- (void)requestAllResuest
{
    __weak __typeof(self)weakSelf = self;
    //赢
    [SPGameDynamicModel requestGameResultByType:GameStyleWin
                                          block:^(NSDictionary *info, NSError *error) {
                                              __strong __typeof(weakSelf)strongSelf = weakSelf;
                                              if (info[@"count"] != nil)
                                              {
                                                  strongSelf.winLabel.text = [NSString stringWithFormat:@"赢%@次",SPFormatstring(info[@"count"])];
                                              }
    }];
    //输
    [SPGameDynamicModel requestGameResultByType:GameStyleLose
                                          block:^(NSDictionary *info, NSError *error) {
                                              __strong __typeof(weakSelf)strongSelf = weakSelf;
                                              if (info[@"count"] != nil)
                                              {
                                                  strongSelf.loseLabel.text = [NSString stringWithFormat:@"输%@次",SPFormatstring(info[@"count"])];
                                              }
                                          }];
    //平
    [SPGameDynamicModel requestGameResultByType:GameStylePing
                                          block:^(NSDictionary *info, NSError *error) {
                                              __strong __typeof(weakSelf)strongSelf = weakSelf;
                                              if (info[@"count"] != nil)
                                              {
                                                  strongSelf.levelLabel.text = [NSString stringWithFormat:@"平%@次",SPFormatstring(info[@"count"])];;
                                              }
                                          }];
}

@end
