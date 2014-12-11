//
//  SPTaskBeginController.h
//  shanpai
//
//  Created by liang chunyan on 14-12-7.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPBaseViewController.h"
#import "SPTaskModel.h"
/*!
 *  任务类型
 */
typedef NS_ENUM(NSUInteger, SPTaskType){
    /*!
     *  答题
     */
    SPTaskTestPaper,
    /*!
     *  问卷
     */
    SPTaskQuestionnaire,
};

@interface SPTaskBeginController : SPBaseViewController
/*!
 *  任务数据
 */
@property (nonatomic, strong) SPTaskModel *model;
/*!
 *  类型
 */
@property (nonatomic, assign) SPTaskType   type;

@end
