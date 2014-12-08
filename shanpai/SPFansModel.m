//
//  SPFansModel.m
//  shanpai
//
//  Created by liang chunyan on 14-12-2.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  粉丝模型

#import "SPFansModel.h"

@interface SPFansModel()

+ (NSArray *)spfConvertFromArray:(NSArray *)array;

@end

@implementation SPFansModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.avatar               = dictionary[@"avatar"];
        self.buddy_lastuptime     = SPFormatstring(dictionary[@"buddy_lastuptime"]);
        self.buddyid              = SPFormatstring(dictionary[@"buddyid"]);
        self.dateline             = SPFormatstring(dictionary[@"dateline"]);
        
        self.idescription          = SPFormatstring(dictionary[@"description"]);
        
        self.fans_count           = SPFormatstring(dictionary[@"fans_count"]);
        self.follow_count         = SPFormatstring(dictionary[@"follow_count"]);
        self.grade                = SPFormatstring(dictionary[@"grade"]);
        self.group_id             = SPFormatstring(dictionary[@"group_id"]);
        self._id                  = SPFormatstring(dictionary[@"id"]);
        self.newdynamic           = SPFormatstring(dictionary[@"newdynamic"]);
        self.nickname             = SPFormatstring(dictionary[@"nickname"]);
        self.relation             = SPFormatstring(dictionary[@"relation"]);
        self.remark               = SPFormatstring(dictionary[@"remark"]);
        self.uid                  = SPFormatstring(dictionary[@"uid"]);
    }
    return self;
}

+ (void)spfGetFansList:(NSInteger)pageNum
                 block:(void (^)(NSArray *, NSError *))block
{
    NSString     *path     = @"Buddys/getMyFans/";
    NSDictionary *params   = @{
                               @"p"    :  [NSString stringWithFormat:@"%ld",(long)pageNum],
                               @"listRows" : @20,
                               @"userid"   : [SPUserData userID],
                               };
    
    [SVProgressHUD show];
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSLog(@"%@",responseObject);
                            NSArray *resArray = [self spfConvertFromArray:responseObject[@"data"]];
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

+ (void)spfGetFollowList:(NSInteger)pageNumber
                   block:(void (^)(NSArray *, NSError *))block
{
    NSString *path = @"Buddys/getMyFollow";
    NSDictionary *params   = @{
                               @"p"    :  [NSString stringWithFormat:@"%ld",(long)pageNumber],
                               @"listRows" : @20,
                               @"userid"   : [SPUserData userID],
                               };
    
    [SVProgressHUD show];
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSLog(@"%@",responseObject);
                            NSArray *resArray = [self spfConvertFromArray:responseObject[@"data"]];
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

+ (NSArray *)spfConvertFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *info = (NSDictionary *)obj;
        SPFansModel *model = [[SPFansModel alloc] initWithDictionary:info];
        [result addObject:model];
    }];
    
    return result;
}

@end
