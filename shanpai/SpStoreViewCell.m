//
//  SpStoreViewCell.m
//  shanpai
//
//  Created by liang chunyan on 14-11-19.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SpStoreViewCell.h"

@interface SpStoreViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *jinDouLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;

@end

@implementation SpStoreViewCell

- (void)awakeFromNib
{
    self.jinDouLabel.textColor      = [UIColor colorWithHexString:@"#ff7e00"];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
}

- (void)setDataObj:(SPStroeSData *)dataObj
{
    _dataObj = dataObj;
    if (self.dataObj)
    {
        if ([self.dataObj.tag integerValue] == 1)
        {
            self.hotImageView.hidden = NO;
        }
        else
        {
            self.hotImageView.hidden = YES;
        }
        self.jinDouLabel.text = self.dataObj.credits;
        self.nameLabel.text   = self.dataObj.title;
        [self.iconImageView setImageWithURL:[NSURL URLWithString:self.dataObj.photo]];
    }
}

@end
