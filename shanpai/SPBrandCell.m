//
//  SPBrandCell.m
//  shanpai
//
//  Created by liang chunyan on 14-11-18.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPBrandCell.h"

@interface SPBrandCell()
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (weak, nonatomic) IBOutlet UILabel *adTitle;
@property (weak, nonatomic) IBOutlet UILabel *adPeople;
@property (weak, nonatomic) IBOutlet UILabel *adContent;
@end

@implementation SPBrandCell

- (void)awakeFromNib
{
    self.adImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setSpObj:(SPBrandData *)spObj
{
    _spObj = spObj;
    if (self.spObj)
    {
        [self.adImageView setImageWithURL:[NSURL URLWithString:spObj.photo]];
        self.adTitle.text   = spObj.title;
        NSString *content   = [NSString flattenHTML:spObj.content];
        self.adContent.text = content;
        self.adPeople.text  =  [NSString stringWithFormat:@"%@人参与",spObj.hits];
    }
}

@end
