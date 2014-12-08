//
//  SPGoldenRecordModel.m
//  shanpai
//
//  Created by liang chunyan on 14-12-4.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  金豆记录

#import "SPGoldenRecordModel.h"

@interface SPGoldenRecordModel()

+ (NSArray *)convertFromArray:(NSArray *)array;

@end

@implementation SPGoldenRecordModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.created = dictionary[@"created"];
        self.credits = dictionary[@"credits"];
        self.title   = dictionary[@"title"];
    }
    return self;
}

+ (void)spgRequestGoldenList:(NSUInteger)pageNumber block:(void (^)(NSArray *, NSError *))block
{
    NSString       *path = @"CreditsLog/ls";
    NSDictionary   *params = @{
                               @"p"  : [NSString stringWithFormat:@"%ld",(long)pageNumber],
                               @"listRows"  :  @20,
                               @"userid"    :  [SPUserData userID],
                               };
    
    [SVProgressHUD show];
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
                            NSArray *resArray = [SPGoldenRecordModel convertFromArray:responseObject[@"data"]];
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

+ (NSArray *)convertFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *info = (NSDictionary *)obj;
        SPGoldenRecordModel *model = [[SPGoldenRecordModel alloc] initWithDictionary:info];
        [result addObject:model];
    }];
    
    return result;
}

@end
