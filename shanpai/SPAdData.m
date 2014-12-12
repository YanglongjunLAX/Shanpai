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
        SPAdData *objData = [[SPAdData alloc] initWithDictionary:info];
        [resarray addObject:objData];
    }];
    
    return resarray;
}

@end
