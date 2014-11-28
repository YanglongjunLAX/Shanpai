//
//  SPBrandData.m
//  shanpai
//
//  Created by liang chunyan on 14-11-18.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  品牌数据

#import "SPBrandData.h"

//分页页数
#define kForPageNumber     @"p"
//分页大小
#define kForPageSize       @"listRows"
//用户id
#define kForUserid         @"userid"

@interface SPBrandData()

+ (NSArray *)brandDatasFromArray:(NSArray *)array;

@end

@implementation SPBrandData

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self)
    {
        self.content     = info[@"content"];
        self.created     = info[@"created"];
        self.hits        = info[@"hits"];
        self._id         = info[@"id"];
        self.jump_url    = info[@"jump_url"];
        self.photo       = info[@"photo"];
        self.title       = info[@"title"];
        self.url         = info[@"url"];
        self.virtual_hits= info[@"virtual_hits"];
    }
    return self;
}

+ (void)requestBrandDatas:(NSInteger)pageNumber pageSize:(NSInteger)pageSize success:(void (^)(NSArray *))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{//Brand/ls/
    /*!
     *  请求参数
     */
    [SVProgressHUD show];
    NSDictionary *par = @{
                          kForPageNumber    :  [NSString stringWithFormat:@"%ld",(long)pageNumber],
                          kForPageSize :  [NSString stringWithFormat:@"%ld",(long)pageSize],
//                          kForUserid   :  [SPUserData spUserInfo].loginInfo[@"uid"],
                          };
    
    [[SPHttpClient manager] GET:@"Brand/ls/"
                     parameters:par
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if ([responseObject[@"status"] integerValue] == 1)
                            {//有数据
                                NSArray *array = [self brandDatasFromArray:responseObject[@"data"]];
                                if (success)
                                {
                                    success(array);
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
                            if (failure)
                            {
                                failure(operation,error);
                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD dismiss];
                            });
                        }];
}

+ (NSArray *)brandDatasFromArray:(NSArray *)array
{
    NSMutableArray  *result = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        SPBrandData *spObj = [[SPBrandData alloc] initWithInfo:dic];
        [result addObject:spObj];
    }];
    return result;
}

@end
