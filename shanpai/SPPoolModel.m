//
//  SPPoolModel.m
//  shanpai
//
//  Created by liang chunyan on 14-11-26.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  奖池排行

#import "SPPoolModel.h"

@interface SPPoolModel()

+ (NSArray *)sppConvertFromArray:(NSArray *)array;

@end

@implementation SPPoolModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.avatar = dictionary[@"avatar"];
        self.cityid = SPFormatstring(dictionary[@"cityid"]);
        self.credits = SPFormatstring(dictionary[@"credits"]);
        self.money = SPFormatstring(dictionary[@"money"]);
        self.nickname = dictionary[@"nickname"];
        self.uid = SPFormatstring(dictionary[@"uid"]);
    }
    return self;
}

+ (void)sppGetPoolList:(NSInteger)pageNum
                 block:(void (^)(NSArray *, NSError *))block
{
    NSString *path = @"Member/poolls";
    NSDictionary *params = @{
                         @"p"   : [NSString stringWithFormat:@"%ld",(long)pageNum],
                         @"userid" : [SPUserData userID],
                         };
    
    [SVProgressHUD show];
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSLog(@"%@",responseObject);
                            NSArray *resArray = [SPPoolModel sppConvertFromArray:responseObject[@"data"]];
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

+ (NSArray *)sppConvertFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        SPPoolModel *model = [[SPPoolModel alloc] initWithDictionary:dic];
        [result addObject:model];
    }];
    return result;
}

@end
