//
//  SPTaskModel.m
//  shanpai
//
//  Created by liang chunyan on 14-11-27.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPTaskModel.h"

@interface SPTaskModel()
/*!
 *  从数组转换
 *
 *  @param array http请求的数组
 *
 *  @return array
 */
+ (NSArray *)sptConvertFromArray:(NSArray *)array;

@end

@implementation SPTaskModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.auto_id = SPFormatstring(dictionary[@"auto_id"]);
        self.city    = SPFormatstring(dictionary[@"city"]);
        self.cityid  = SPFormatstring(dictionary[@"cityid"]);
        self.created = dictionary[@"created"];
        self._description = dictionary[@"description"];
        self._id     = dictionary[@"id"];
        self.image   = dictionary[@"image"];
        self.intro   = dictionary[@"intro"];
        self.link    = dictionary[@"link"];
        self.listorder = dictionary[@"listorder"];
        self.module    = dictionary[@"module"];
        self.newtitle  = dictionary[@"newtitle"];
        self.number    = SPFormatstring(dictionary[@"number"]);
        self.opentype  = dictionary[@"opentype"];
        self.start_date = SPFormatstring(dictionary[@"start_date"]);
        self.status    = SPFormatstring(dictionary[@"status"]);
        self.top_time  = SPFormatstring(@"top_time");
        self.virtual_hits = SPFormatstring(dictionary[@"virtual_hits"]);
    }
    return self;
}

+ (NSArray *)sptConvertFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *info = (NSDictionary *)obj;
        SPTaskModel *model = [[SPTaskModel alloc] initWithDictionary:info];
        [result addObject:model];
    }];
    
    return result;
}

+ (void)sptGetTaskList:(NSInteger)pageNum
               listRow:(NSInteger)pagesize
                 block:(void (^)(NSArray *, NSError *))block
{
    //路径
    NSString *path = @"Ad/ls/";
    NSDictionary *params = @{
                             @"p"  :  [NSString stringWithFormat:@"%ld",(long)pageNum],
                             @"listRows" : [NSString stringWithFormat:@"%ld",(long)pagesize],
                             @"userid"  : [SPUserData userID],
                             };
    
    [SVProgressHUD show];
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSArray *resArray = [SPTaskModel sptConvertFromArray:responseObject[@"data"]];
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
