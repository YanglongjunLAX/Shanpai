//
//  SPImageRecordModel.m
//  shanpai
//
//  Created by liang chunyan on 14-12-4.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPImageRecordModel.h"

@interface SPImageRecordModel()

+ (NSArray *)spiConvertFromArray:(NSArray *)array;

@end

@implementation SPImageRecordModel


+ (void)spiRequestImageList:(NSUInteger)pageNumber
                      block:(void (^)(NSArray *, NSError *))block
{
    NSString       *path    = @"Advert/myls";
    NSDictionary   *params  = @{
                                @"p"     : [NSString stringWithFormat:@"%ld",(long)pageNumber],
                                @"listRows" : @20,
                                };
    
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSArray *resArray = [SPImageRecordModel spiConvertFromArray:responseObject[@"data"]];
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

+ (NSArray *)spiConvertFromArray:(NSArray *)array
{
    NSMutableArray  *result = [[NSMutableArray alloc] init];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *info = (NSDictionary *)obj;
        SPImageRecordModel *model = [[SPImageRecordModel alloc] initWithDictionary:info];
        [result addObject:model];
    }];
    
    return result;
}

@end
