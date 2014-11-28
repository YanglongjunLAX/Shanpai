//
//  SPAdData.m
//  shanpai
//
//  Created by liang chunyan on 14-11-19.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
// 广告数据

#import "SPAdData.h"

@interface SPAdData()

+ (NSArray *)arrayFromInfoArray:(NSArray *)array;

@end

@implementation SPAdData

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self)
    {
        self.create_time = info[@"create_time"];
        self._id         = info[@"id"];
        self.image       = info[@"image"];
        self.list_brand  = SPFormatstring(info[@"list_brand"]);
        self.list_index  = SPFormatstring(info[@"list_index"]);
        self.list_pk     = SPFormatstring(info[@"list_pk"]);
        self.list_store  = SPFormatstring(info[@"list_store"]);
        self.status      = SPFormatstring(info[@"status"]);
        self.tag_brand   = SPFormatstring(info[@"tag_brand"]);
        self.tag_index   = SPFormatstring(info[@"tag_index"]);
        self.tag_pk      = SPFormatstring(info[@"tag_pk"]);
        self.tag_store   = SPFormatstring(info[@"tag_store"]);
        self.tags        = SPFormatstring(info[@"tags"]);
        self.title       = SPFormatstring(info[@"title"]);
        self.update_time = SPFormatstring(info[@"update_time"]);
        self.url         = SPFormatstring(info[@"url"]);
    }
    return self;
}

+ (void)getTaskAdWithPath:(NSString *)path params:(NSDictionary *)params block:(void (^)(NSArray *, NSError *))block
{
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if ([responseObject[@"status"] integerValue] == 1)
                            {
                                NSArray *array = [self arrayFromInfoArray:responseObject[@"data"]];
                                if (block)
                                {
                                    block(array,nil);
                                }
                            }
                            else
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                                });
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [SVProgressHUD showErrorWithStatus:@"获取广告数据错误"];
                        }];
}

+ (NSArray *)arrayFromInfoArray:(NSArray *)array
{
    NSMutableArray *resarray = [[NSMutableArray alloc] init];
    
    __block NSDictionary  *info;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        info = (NSDictionary *)obj;
        SPAdData *objData = [[SPAdData alloc] initWithInfo:info];
        [resarray addObject:objData];
    }];
    
    return resarray;
}

@end
