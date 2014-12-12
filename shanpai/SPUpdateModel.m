//
//  SPUpdateModel.m
//  shanpai
//
//  Created by liang chunyan on 14-12-12.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPUpdateModel.h"

#define APPLE_ID      @"672199494"

@interface SPUpdateModel()<UIAlertViewDelegate>

@end

@implementation SPUpdateModel

+ (void)spuGetversionBlock:(void (^)(NSDictionary *, NSError *))block
{
    NSString *path = @"http://itunes.apple.com/lookup";
    NSDictionary *dict = @{@"id":APPLE_ID};
    [[AFHTTPRequestOperationManager manager] GET:path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (block)
        {
            block(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        block(nil,error);
    }];
}

+ (NSString *)spuGetLocalVersion
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *localVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    return localVersion;
}

+ (void)openAppStoreUrl
{
    NSString *path = @"http://shanpai.iushare.com/Api/AppStore/download";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
}

@end
