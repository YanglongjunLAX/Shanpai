//
//  SPMessageModel.m
//  shanpai
//
//  Created by liang chunyan on 14-11-25.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  消息

#import "SPMessageModel.h"

@interface SPMessageModel()

+ (NSArray *)spmConvertFromInfo:(NSArray *)array;

@end

@implementation SPMessageModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.content = dictionary[@"content"];
        self.created = dictionary[@"created"];
        self.data    = dictionary[@"data"];
        self.failures = SPFormatstring(dictionary[@"failures"]);
        self.isread   = SPFormatstring(dictionary[@"isread"]);
        self.nickname = SPFormatstring(dictionary[@"nickname"]);
        self.pmid     = SPFormatstring(dictionary[@"pmid"]);
        self.recvuid  = SPFormatstring(dictionary[@"recvuid"]);
        self.remark   = SPFormatstring(dictionary[@"remark"]);
        self.sended   = SPFormatstring(dictionary[@"sended"]);
        self.senduid  = SPFormatstring(dictionary[@"senduid"]);
        self.status   = SPFormatstring(dictionary[@"status"]);
        self.taskType = SPFormatstring(dictionary[@"taskType"]);
        self.title    = SPFormatstring(dictionary[@"title"]);
        self.type     = SPFormatstring(dictionary[@"type"]);
    }
    return self;
}

+ (void)spmGetChatList:(NSInteger)pageNum
               listRow:(NSInteger)pagesize
                  type:(NSString *)type
                 block:(void (^)( NSArray*, NSError *))block
{
    //路径
    NSString *path = @"Pmsgs/ls";
    NSDictionary *params = @{
                             @"p"  :  [NSString stringWithFormat:@"%ld",(long)pageNum],
                             @"listRows" : [NSString stringWithFormat:@"%ld",(long)pagesize],
                             @"recvuid"  : [SPUserData userID],
                             @"type"     : type,
                             };
    
    [SVProgressHUD show];
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSLog(@"%@",responseObject);
                            NSArray *resArray = [SPMessageModel spmConvertFromInfo:responseObject[@"data"]];
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

+ (NSArray *)spmConvertFromInfo:(NSArray *)array
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *info = (NSDictionary *)obj;
        SPMessageModel *model = [[SPMessageModel alloc] initWithDictionary:info];
        [resultArray addObject:model];
    }];
    
    return resultArray;
}



@end
