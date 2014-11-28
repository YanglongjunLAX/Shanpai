//
//  GetFriendModel.m
//  shanpai5.0
//
//  Created by liang chunyan on 14-4-15.
//  Copyright (c) 2014年 arrowspeed. All rights reserved.
//

#import "GetFriendModel.h"

@implementation GetFriendModel
@synthesize avatar;
@synthesize uid;
@synthesize nickname;

-(id)initJsonData:(NSMutableDictionary*)dict
{
    if (self = [super init])
    {
        self.avatar = [dict objectForKey:@"avatar"];
        self.nickname = [dict objectForKey:@"nickname"];
        self.uid = [dict objectForKey:@"uid"];
        
    }
    return self;
}


@end
