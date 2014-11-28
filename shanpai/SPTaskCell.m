//
//  SPTaskCell.m
//  shanpai
//
//  Created by liang chunyan on 14-11-27.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPTaskCell.h"

@interface SPTaskCell()
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (weak, nonatomic) IBOutlet UILabel *adName;
@property (weak, nonatomic) IBOutlet UILabel *adContent;
@property (weak, nonatomic) IBOutlet UILabel *adHit;
@property (weak, nonatomic) IBOutlet UIImageView *adTag;
/*!
 *  设置类型图标
 */
- (void)sptSetTagImageView;
@end

@implementation SPTaskCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setModel:(SPTaskModel *)model
{
    _model = model;
    if (self.model)
    {
        self.adName.text    = self.model.newtitle;
        self.adContent.text = self.model.intro;
        [self.adImageView setImageWithURL:[NSURL URLWithString:self.model.image]];
        self.adHit.text     = [NSString stringWithFormat:@"%@人参与",self.model.number];
        [self sptSetTagImageView];
    }
}

- (void)sptSetTagImageView
{
    NSString *tag = self.model.module;
    if ([@"Questionnaire" isEqualToString:tag])
    {
        self.adTag.image = [UIImage imageNamed:@"wenjuan_tag"];
    }else if ([@"TestPaper" isEqualToString:tag]){
        self.adTag.image = [UIImage imageNamed:@"dati_tag"];
    }else if ([@"GuessPic" isEqualToString:tag]){
        self.adTag.image = [UIImage imageNamed:@"caitu_tag"];
    }else if ([@"Puzzle" isEqualToString:tag]){
        self.adTag.image = [UIImage imageNamed:@"pintu_tag"];
    }else if ([@"Vote" isEqualToString:tag]){
        self.adTag.image = [UIImage imageNamed:@"toupiao_tag"];
    }else if ([@"Topic" isEqualToString:tag]){
        self.adTag.image = [UIImage imageNamed:@"taolun_tag"];
    }else if ([@"ScratchCard" isEqualToString:tag]){
        self.adTag.image = [UIImage imageNamed:@"guaguale_tag"];
    }else if ([@"Signin" isEqualToString:tag]){
        self.adTag.image = [UIImage imageNamed:@"qiandao_tag"];
    }else if ([@"Activities" isEqualToString:tag]){
        self.adTag.image = [UIImage imageNamed:@"xunbao_tag"];
    }else if([@"LuckDraw" isEqualToString:tag]){
        self.adTag.image = [UIImage imageNamed:@"yaoyiyao_tag.png"];
    }else if ([@"Information" isEqualToString:tag]){
        self.adTag.image = [UIImage imageNamed:@"neirong_tag.png"];
    }
}

@end
