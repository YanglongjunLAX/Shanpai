//
//  SPGuessFingerModel.m
//  shanpai
//
//  Created by liang chunyan on 14-12-5.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPGuessFingerModel.h"

@implementation SPGuessFingerModel

+ (void)spgRequestRandUserInfo:(void (^)(NSDictionary *, NSError *))block
{
    NSString *path = @"InviteRand/getRandMember";
    [[SPHttpClient manager] GET:path
                     parameters:nil
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if ([responseObject[@"status"] integerValue] == 1)
                            {
                                if (block)
                                {
                                    block(responseObject,nil);
                                }
                            }
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                        }];
}

+ (void)spgPKStartAction:(NSString *)type
                reuserId:(NSString *)ruserid
                   block:(void (^)(NSDictionary *, NSError *))block
{
    NSString *path = @"Fist/insert";
    NSDictionary *params = @{
                             @"type"   : type,
                             @"ruserid": ruserid,
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
