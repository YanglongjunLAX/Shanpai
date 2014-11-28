//
//  SPStroeSData.m
//  shanpai
//
//  Created by liang chunyan on 14-11-19.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  商城model

#import "SPStroeSData.h"

@interface SPStroeSData()
/*!
 *  从字典数组中转换到SPStroeSData数组
 *
 *  @param array 字典数组
 *
 *  @return SPStroeSData数组
 */
+ (NSArray *)getObjectsFromArray:(NSArray *)array;

@end

@implementation SPStroeSData

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.content = SPFormatstring(dictionary[@"content"]);
        self.credits = SPFormatstring(dictionary[@"credits"]);
        self.created = SPFormatstring(dictionary[@"created"]);
        self._id     = SPFormatstring(dictionary[@"id"]);
        self.photo   = SPFormatstring(dictionary[@"photo"]);
        self.surplus = SPFormatstring(dictionary[@"surplus"]);
        self.tag     = SPFormatstring(dictionary[@"tag"]);
        self.title   = SPFormatstring(dictionary[@"title"]);
    }
    return self;
}

+ (void)getStoreDatasWithPath:(NSString *)path
                       params:(NSDictionary *)params
                        block:(void (^)(NSArray *, NSError *))block
{
    [SVProgressHUD show];
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if ([responseObject[@"status"] integerValue] == 1)
                            {
                                NSArray *array = [self getObjectsFromArray:responseObject[@"data"]];
                                if (block)
                                {
                                    block(array,nil);
                                }
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD dismiss];
                                });
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

+ (NSArray *)getObjectsFromArray:(NSArray *)array
{
    NSMutableArray *objectArray = [[NSMutableArray alloc] init];
    
    __block NSDictionary *info;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        info = (NSDictionary *)obj;
        SPStroeSData *dataObj = [[SPStroeSData alloc] initWithDictionary:info];
        [objectArray addObject:dataObj];
    }];
    
    return objectArray;
}

@end
