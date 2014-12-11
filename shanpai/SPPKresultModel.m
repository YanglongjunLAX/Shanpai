//
//  SPPKresultModel.m
//  shanpai
//
//  Created by liang chunyan on 14-12-10.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPPKresultModel.h"

@implementation SPPKresultModel

+ (void)replyFingerRejectPKId:(NSString *)pkid
                   situaction:(NSString *)situaction
                         type:(NSString *)type
                        block:(void (^)(NSDictionary *, NSError *))block
{
    NSString     *path = @"Fist/reply/";
    NSDictionary *params = @{
                             @"id"    :   pkid,
                             @"situation" : situaction,
                             @"type"  :   type,
                             };
    
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if (block)
                            {
                                block(responseObject,nil);
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

+ (void)replyGuessPicRejectPKId:(NSString *)pKid
                          model:(NSString *)model
                          block:(void (^)(NSDictionary *, NSError *))block
{
    NSString *path = [NSString stringWithFormat:@"%@/reply",model];
    NSDictionary *params = @{
                             @"id" : pKid,
                             };
    
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if (block)
                            {
                                block(responseObject,nil);
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
