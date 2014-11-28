//
//  GetFriendModel.h
//  shanpai5.0
//
//  Created by liang chunyan on 14-4-15.
//  Copyright (c) 2014年 arrowspeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetFriendModel : NSObject
@property (strong, nonatomic) NSString *  avatar;
@property (strong, nonatomic) NSString *  nickname;
@property (strong, nonatomic) NSString *  uid;

-(id)initJsonData:(NSMutableDictionary*)dict;
@end
