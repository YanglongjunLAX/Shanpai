//
//  SPExangeModel.m
//  shanpai
//
//  Created by liang chunyan on 14-11-27.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  兑换记录model

#import "SPExangeModel.h"

@interface SPExangeModel()

+ (NSArray *)speConvertFromArray:(NSArray *)array;

@end

@implementation SPExangeModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.city      = SPFormatstring(dictionary[@"city"]);
        self.content   = SPFormatstring(dictionary[@"content"]);
        self.create_time = dictionary[@"create_time"];
        self.credits   = SPFormatstring(dictionary[@"credits"]);
        self.eid       = SPFormatstring(dictionary[@"eid"]);
        self.exchange_time = dictionary[@"exchange_time"];
        self.exchanged = SPFormatstring(dictionary[@"exchanged"]);
        self._id       = SPFormatstring(dictionary[@"id"]);
        self.image     = dictionary[@"image"];
        self.key       = dictionary[@"key"];
        self.num       = dictionary[@"num"];
        self.status    = SPFormatstring(dictionary[@"status"]);
        self.surplus   = SPFormatstring(dictionary[@"surplus"]);
        self.tag       = SPFormatstring(dictionary[@"tag"]);
        self.title     = dictionary[@"title"];
    }
    return self;
}

+ (NSArray *)speConvertFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        SPExangeModel *model = [[SPExangeModel alloc ] initWithDictionary:dic];
        [result addObject:model];
    }];
    return result;
}

/*!
 *  分页获取奖池的数据
 *
 *  @param pageNum 页数
 *  @param block   回调
 */
+ (void)spEGetExangeList:(NSInteger)pageNum
                   block:(void (^)(NSArray *, NSError *))block
{
    NSString *path = @"StoreExchange/myls";
    NSDictionary *params = @{
                             @"p"   : [NSString stringWithFormat:@"%ld",(long)pageNum],
                             @"userid" : [SPUserData userID],
                             @"listRows" : @20,
                             };
    
    [SVProgressHUD show];
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSLog(@"%@",responseObject);
                            NSArray *resArray = [SPExangeModel speConvertFromArray:responseObject[@"data"]];
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

@end
