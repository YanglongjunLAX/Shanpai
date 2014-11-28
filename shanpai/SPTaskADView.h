//
//  SPTaskADView.h
//  shanpai
//
//  Created by liang chunyan on 14-11-7.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPTaskADView : UIView

//总页数
@property (nonatomic, assign)NSUInteger numberOfPage;
//类型
@property (nonatomic, copy) NSString *type;
//
@property (nonatomic, copy) NSString *desStr;

@end

//colecctionView
@interface ADCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *imageURL;

@end