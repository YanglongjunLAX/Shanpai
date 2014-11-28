//
//  SPHttpClient.h
//  shanpai
//
//  Created by liang chunyan on 14-11-7.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"

@interface SPHttpClient : AFHTTPRequestOperationManager
/*!
 *  得到完整的url地址
 *
 *  @param string 扩展地址
 *
 *  @return url
 */
+(NSString *)getReallyUrlString:(NSString *)string;

@end
