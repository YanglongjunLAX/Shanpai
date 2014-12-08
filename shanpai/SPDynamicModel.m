//
//  SPDynamicModel.m
//  shanpai
//
//  Created by liang chunyan on 14-12-2.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPDynamicModel.h"

@interface SPDynamicModel()

+ (NSArray *)spdConvertFromArray:(NSArray *)array;

@end

@implementation SPDynamicModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.avatar        = dictionary[@"avatar"];
        self.content       = dictionary[@"content"];
        self.created       = dictionary[@"created"];
        self.idescription  = dictionary[@"description"];
        self.fans_count    = SPFormatstring(dictionary[@"fans_count"]);
        self.follow_count  = SPFormatstring(dictionary[@"follow_count"]);
        self._id           = SPFormatstring(dictionary[@"id"]);
        self.item_id       = SPFormatstring(dictionary[@"item_id"]);
        self.module        = SPFormatstring(dictionary[@"module"]);
        self.nickname      = SPFormatstring(dictionary[@"nickname"]);
        self.picture       = dictionary[@"picture"];
        self.status        = SPFormatstring(dictionary[@"status"]);
        self.title         = dictionary[@"title"];
        self.uid           = SPFormatstring(dictionary[@"uid"]);
    }
    return self;
}

+ (void)spdGetDynamicList:(NSInteger)pageNumber
                      uid:(NSString *)uid
                    block:(void (^)(NSArray *, NSError *))block
{
    NSString *path = @"MemberDynamic/ls/";
    NSDictionary *params   = @{
                               @"p"    :  [NSString stringWithFormat:@"%ld",(long)pageNumber],
                               @"listRows" : @20,
                               @"userid"   : uid,
                               };
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
                            NSArray *resArray = [self spdConvertFromArray:responseObject[@"data"]];
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

+ (NSArray *)spdConvertFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *info = (NSDictionary *)obj;
        SPDynamicModel *model = [[SPDynamicModel alloc] initWithDictionary:info];
        [result addObject:model];
    }];
    
    return result;
}

+ (void)spdSetRelation:(NSString *)userID
                 block:(void (^)(NSDictionary *, NSError *))block
{
    NSString     * path = @"Buddys/insert/";
    NSDictionary * params = @{
                              @"userid"  : [SPUserData userID],
                              @"buddyid"        : userID,
                              };
    
    [SVProgressHUD show];
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if (block)
         {
             block(responseObject,nil);
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

+ (void)spdModifyNickName:(NSString *)newName
                   userID:(NSString *)userID
                    block:(void (^)(NSDictionary *, NSError *))block
{
    NSString     *path    = @"Buddys/update";
    NSDictionary *params  = @{
                          @"userid"   :  [SPUserData userID],
                          @"remark"   :  newName,
                          @"buddyid"  :  userID,
                          };
    
    [SVProgressHUD show];
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        if (block)
         {
             block(responseObject,nil);
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
