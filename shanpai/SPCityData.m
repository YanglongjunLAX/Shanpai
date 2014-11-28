//
//  SPCityData.m
//  shanpai
//
//  Created by liang chunyan on 14-11-10.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPCityData.h"

#define kForGetListP       @"p"
#define kForGetListRows    @"listRows"

@interface SPCityData()
/*!
 *  从服务端获取到得数据转为字典
 *
 *  @param array 数组
 *
 *  @return
 */
+ (NSDictionary *)cityInfoFromArray:(NSArray *)array;
@end

@implementation SPCityData

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self)
    {
        self.arrchild_id    = info[@"arrchild_id"];
        self.arrparent_id   = info[@"arrparent_id"];
        self.cat_id         = info[@"cat_id"];
        self.cat_name       = info[@"cat_name"];
        self.child          = info[@"child"];
        self.clat           = info[@"clat"];
        self.clng           = info[@"clng"];
        self.create_time    = info[@"create_time"];
        self.firstletter    = info[@"firstletter"];
        self.image          = info[@"image"];
        self.level          = info[@"level"];
        self.listorder      = info[@"listorder"];
        self.parent_id      = info[@"parent_id"];
        self.status         = info[@"status"];
    }
    return self;
}

+ (void)getCityList:(NSInteger)pageNumber
           pageSize:(NSInteger)pageSize
            success:(void (^)(NSInteger status, NSDictionary *info))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *par = @{
                          kForGetListP    :  [NSString stringWithFormat:@"%ld",(long)pageNumber],
                          kForGetListRows :  [NSString stringWithFormat:@"%ld",(long)pageSize],
                          };
    [[SPHttpClient manager] GET:@"City/ls/"
                     parameters:par
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if (success)
                            {
                                NSDictionary *info = [self cityInfoFromArray:responseObject[@"data"]];
//                                NSLog(@"%@",info);
                                NSInteger sta = [responseObject[@"status"] integerValue];
                                success(sta,info);
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            if (failure)
                            {
                                failure(operation,error);
                            }
                        }];
}

+ (NSDictionary *)cityInfoFromArray:(NSArray *)array
{
    NSMutableDictionary  *info = [[NSMutableDictionary alloc] init];
    __block NSArray *_keys;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        _keys = [info allKeys];
        NSString *k = dic[@"firstletter"];
        //包含key
        if ([_keys containsObject:k])
        {
            NSMutableArray  *narray = [info objectForKey:k];
            SPCityData  *city = [[SPCityData alloc] initWithInfo:dic];
            [narray addObject:city];
        }
        else
        {
            NSMutableArray  *kArray = [[NSMutableArray alloc] init];
            SPCityData  *city = [[SPCityData alloc] initWithInfo:dic];
            [kArray addObject:city];
            [info setObject:kArray forKey:k];
        }
    }];
    return info;
}

@end
