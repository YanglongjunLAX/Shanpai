//
//  SPjindouCell.m
//  shanpai
//
//  Created by liang chunyan on 14-11-21.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPjindouCell.h"

@interface SPjindouCell()
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;

@end

@implementation SPjindouCell

- (void)awakeFromNib
{
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    self.leftView.backgroundColor = [UIColor whiteColor];
    self.rightView.backgroundColor = [UIColor whiteColor];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self updateLabelText];
}

- (void)updateLabelText
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *string = SPFormatstring([userDefault objectForKey:@"sendnumber"]);
    self.sendLabel.text = [NSString stringWithFormat:@"本周已送%@次>>",string];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.contentView];
    
    if (CGRectContainsPoint(self.leftView.bounds, point))
    {
        if (self.leftAction)
        {
            self.leftAction();
        }
    }
    else if(CGRectContainsPoint(self.rightView.frame, point))
    {
        if (self.rightAction)
        {
            self.rightAction();
        }
    }
}

@end
