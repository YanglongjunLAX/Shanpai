//
//  SPPKMesageModel.m
//  shanpai
//
//  Created by liang chunyan on 14-11-25.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPPKMesageModel.h"

@implementation SPPKMesageModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.code        = SPFormatstring(dictionary[@"code"]);
        self.content     = SPFormatstring(dictionary[@"content"]);
        self.create_time = SPFormatstring(dictionary[@"create_time"]);
        self.created     = SPFormatstring(dictionary[@"created"]);
        self._id         = SPFormatstring(dictionary[@"id"]);
        self.module      = SPFormatstring(dictionary[@"module"]);
        self.pk_id       = SPFormatstring(dictionary[@"pk_id"]);
        self.state       = SPFormatstring(dictionary[@"state"]);
        self.title       = SPFormatstring(dictionary[@"title"]);
    }
    return self;
}

+ (void)spmGetPKMessage:(NSInteger)pageNumber
                listRow:(NSInteger)listRow
                  block:(void (^)(NSArray *, NSError *))block
{
    NSString     * path = @"PKMessage/ls/";
    NSDictionary * params = @{
                              @"p"  : [NSString stringWithFormat:@"%ld",(long)pageNumber],
                              @"listRows" : [NSString stringWithFormat:@"%ld",(long)listRow],
                              @"userid"   : [SPUserData userID],
                              };
    
    [SVProgressHUD show];
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSLog(@"%@",responseObject);
                            if (block && responseObject[@"data"] != nil)
                            {
                                block(responseObject[@"data"],nil);
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
