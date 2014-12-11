//
//  SPGameDynamicModel.m
//  shanpai
//
//  Created by liang chunyan on 14-12-3.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPGameDynamicModel.h"
//胜利
static const NSString *winPath    = @"PkCount/getWinCount";
//输
static const NSString *losePath   = @"PkCount/getLoseCount";
//打平
static const NSString *levelPath  = @"PkCount/getEqualCount";

@interface SPGameDynamicModel()

+ (NSArray *)spgConvertFromArray:(NSArray *)array;

@end

@implementation SPGameDynamicModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.code    =  SPFormatstring(dictionary[@"code"]);
        self.content = dictionary[@"content"];
        self.create_time = dictionary[@"create_time"];
        self.created     = dictionary[@"created"];
        self._id         = dictionary[@"id"];
        self.module      = dictionary[@"module"];
        self.pk_id       = dictionary[@"pk_id"];
        self.state       = dictionary[@"state"];
        self.title       = dictionary[@"title"];
    }
    return self;
}

+ (NSArray *)spgConvertFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *info = (NSDictionary *)obj;
        SPGameDynamicModel *model = [[SPGameDynamicModel alloc] initWithDictionary:info];
        [result addObject:model];
        
    }];
    
    return result;
}

+ (void)spgRequestGameDynamicList:(NSUInteger)pageNumber
                            block:(void (^)(NSArray *, NSError *))block
{
    NSString      *path    = @"PKMessage/ls";
    NSDictionary  *params  = @{
                               @"p"   :  [NSString stringWithFormat:@"%ld",(long)pageNumber],
                               @"userid" : [SPUserData userID],
                               };
    
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSArray *resArray = [SPGameDynamicModel spgConvertFromArray:responseObject[@"data"]];
                            if (block)
                            {
                                block(resArray,nil);
                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
                            });
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD dismiss];
                            });
                        }];
}

+ (void)requestGameResultByType:(SPGameDynamicStyle)style
                          block:(void (^)(NSDictionary *, NSError *))block
{
    NSString *path = @"";
    switch (style)
    {
        case GameStyleWin:
            path = (NSString *)winPath;
            break;
        case GameStyleLose:
            path = (NSString *)losePath;
            break;
        case GameStylePing:
            path = (NSString *)levelPath;
            break;
        default:
            NSLog(@"类型错误！！！！！！！！");
            return;
    }
    
    NSDictionary *params = @{
                             @"userid" : [SPUserData userID],
                             };
    
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if (block)
                            {
                                block(responseObject,nil);
                            }
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD dismiss];
                            });
                        }];
}

+ (void)requestGameMessageByMessageID:(NSString *)messageID
                               module:(NSString *)module
                                block:(void (^)(NSDictionary *, NSError *))block
{
    NSString       *path     = @"PKMessage/router/";
    NSDictionary   *params   = @{
                                 @"id"       :  messageID,
                                 @"module"   :  module,
                                 };
    
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                            if (block)
                            {
                                block(responseObject, nil);
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
                            });
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD dismiss];
                            });
                        }];
}

@end
