//
//  SPHttpClient.m
//  shanpai
//
//  Created by liang chunyan on 14-11-7.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPHttpClient.h"

@implementation SPHttpClient

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableString *string = [NSMutableString stringWithString:kForShanPaiBaseURL];
    if (URLString.length > 0)
    {
        [string appendString:URLString];
    }
    
    NSMutableDictionary *mp = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    mp[@"ukey"] = kForHttpPassword;//http请求api秘钥
    if (ISLogined)
    {
        mp[@"userid"] = [SPUserData userID];
    }
    
    return [super GET:string
           parameters:mp
              success:success
              failure:failure];
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableString *string = [NSMutableString stringWithString:kForShanPaiBaseURL];
    if (URLString.length > 0)
    {
        [string appendString:URLString];
    }
    
    NSMutableDictionary *mp = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    mp[@"ukey"] = kForHttpPassword;//http请求api秘钥
    if (ISLogined)
    {
        mp[@"userid"] = [SPUserData userID];
    }
    
    return [super POST:string parameters:mp success:success failure:failure];
}

+(NSString *)getReallyUrlString:(NSString *)string
{
    NSMutableString *mstring = [NSMutableString stringWithString:kForShanPaiBaseURL];
    if (string.length > 0)
    {
        [mstring appendString:string];
    }
    return mstring;
}

@end
