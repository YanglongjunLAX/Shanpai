//
//  TableViewCell.m
//  shanpai
//
//  Created by liang chunyan on 14-11-27.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *pimageView;
@property (weak, nonatomic) IBOutlet UILabel *pName;
@property (weak, nonatomic) IBOutlet UILabel *pContent;

@end

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    if (self.imageName)
    {
        [self.pimageView setImage:[UIImage imageNamed:self.imageName]];
    }
}

- (void)setName:(NSString *)name
{
    _name = name;
    if (self.name)
    {
        self.pName.text = self.name;
    }
}

- (void)setContent:(NSString *)content
{
    _content = content;
    if (self.content)
    {
        self.pContent.text = self.content;
    }
}

@end
