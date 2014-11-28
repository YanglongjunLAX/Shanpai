//
//  getFriendList.h
//  shanpai5.0
//
//  Created by liang chunyan on 14-4-14.
//  Copyright (c) 2014年 arrowspeed. All rights reserved.
//

#import <UIKit/UIKit.h>
@class getFriendListVC;
@protocol getFriendPhoneNumDelegate <NSObject>
@optional
-(void)getPhoneNum:(NSString*)phoneNum;

@end

@interface getFriendListVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) id<getFriendPhoneNumDelegate>Delegate;
@property (strong, nonatomic) NSMutableArray * friendArray;
@property (strong, nonatomic) UITableView    * friendTableView;
@property (strong, nonatomic) NSMutableArray * phoneNumArray;
@property (strong, nonatomic) NSMutableArray * AD_UserName;   //地址簿的用户名
@property (strong, nonatomic) NSMutableArray * selectStatus;  //好友选中状态
@end
