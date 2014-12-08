//
//  SPDynamicTableHead.h
//  shanpai
//
//  Created by liang chunyan on 14-12-2.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPFansModel.h"

typedef void (^dynamicAttention)();

@interface SPDynamicTableHead : UIView

@property (nonatomic, strong) SPFansModel  *userInfo;
/*!
 *  添加 、 取消关注
 */
@property (nonatomic, copy) dynamicAttention relationAction;
/*!
 *  修改备注名
 */
@property (nonatomic, copy) dynamicAttention modifyAction;
/*!
 *  取消 or 添加关注
 */
@property (nonatomic, copy) NSString    *releationTitle;

@end
