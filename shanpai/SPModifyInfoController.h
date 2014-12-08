//
//  SPModifyInfoController.h
//  shanpai
//
//  Created by liang chunyan on 14-12-4.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPBaseViewController.h"
/*!
 *  修改资料的类型
 */
typedef NS_ENUM(NSUInteger, SPModifyStyle){
    /*!
     *  修改性别
     */
    SPModifySex         = 0,
    /*!
     *  修改昵称
     */
    SPModifyNickName    = 1,
    /*!
     *  修改姓名
     */
    SPModifyName,
    /*!
     *  修改邮政编码
     */
    SPModifyPostNumber,
    /*!
     *  修改该收获地址
     */
    SPModifyPostAdder,
};

@interface SPModifyInfoController : SPBaseViewController

@property (nonatomic, assign) SPModifyStyle  modifystyle;

@end
