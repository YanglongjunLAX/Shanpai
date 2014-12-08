//
//  SPGameDynamicCell.m
//  shanpai
//
//  Created by liang chunyan on 14-12-3.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPGameDynamicCell.h"

@interface SPGameDynamicCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameContent;

@end

@implementation SPGameDynamicCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(SPGameDynamicModel *)model
{
    _model = model;
    if (self.model)
    {
        self.gameContent.text = model.title;
        if ([model.module isEqualToString:@"Fist"])
        {
            self.tagLabel.text   = @"[猜拳]";
            self.iconImage.image = [UIImage imageNamed:@"pk_finger_guessing_icon"];
        }
        else if ([model.module isEqualToString:@"GuessPic"])
        {
            self.tagLabel.text   = @"[猜图]";
            self.iconImage.image = [UIImage imageNamed:@"pk_guess_figure_icon.png"];
        }
        else if ([model.module isEqualToString:@"Puzzle"])
        {
            self.tagLabel.text   = @"[猜迷]";
            self.iconImage.image = [UIImage imageNamed:@"pk_jigsaw_icon.png"];
        }
    }
}

@end
