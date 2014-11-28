//
//  spBeanModel.m
//  shanpai
//
//  Created by liang chunyan on 14-11-24.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "spBeanModel.h"

@implementation spBeanModel

+ (void)spkGetBeanPhone:(NSString *)phone
                  money:(NSString *)money
                content:(NSString *)content
                success:(void (^)(id))success
{
    //获取金豆
    NSString * path = @"Beans/askMoney";
    if (content == nil)
    {
        content = @"送我100金豆吧土豪";
    }
    NSDictionary *params = @{
                             @"phone"   :   phone,
                             @"userid"  :   [SPUserData userID],
                             @"money"   :   money,
                             @"content" :   content,
                             };
    
    [SVProgressHUD show];
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if ([responseObject[@"status"] integerValue] == 1)
                            {
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
                            if (success)
                            {
                                success(responseObject);
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                            success(nil);
                        }];
}

+ (void)spkSendBeanPhone:(NSString *)phone
                   money:(NSString *)money
                 content:(NSString *)content
                 success:(void (^)(id))success
{
    //送金豆
    NSString *path = @"Beans/sendMoney";
    if (content == nil)
    {
        content = @"我是土豪，送你100金豆";
    }
    NSDictionary *params = @{
                             @"phone"   :   phone,
                             @"userid"  :   [SPUserData userID],
                             @"money"   :   money,
                             @"content" :   content,
                             };
    
    [SVProgressHUD show];
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                            if ([responseObject[@"status"] integerValue] == 1)
//                            {
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    [SVProgressHUD dismiss];
//                                });
//                            }
//                            else
//                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                                });
//                            }
                            if (success)
                            {
                                success(responseObject);
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                            success(nil);
                        }];
}

@end
