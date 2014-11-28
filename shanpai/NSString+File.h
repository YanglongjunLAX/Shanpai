//
//  NSString+File.h
//  SinaWeibo
//
//  Created by mj on 13-8-19.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (SP)
// 在文件名后拼接一段字符串（扩展名不变）
- (NSString *)fileNameAppendString:(NSString *)str;

// 根据count是否超过1万来返回字符串
+ (NSString *)withinWanStr:(int)count;

//打开网站
- (void)openWebsetBySelf;
/*!
 *  验证正则表达式
 *
 *  @param regular 正则表达式
 *
 *  @return 返回正确或者不正确
 */
- (BOOL)validateRegular:(NSString *)regular;
/*!
 *  过滤掉html标签
 *
 *  @param html 要过滤的字符串
 *
 *  @return 过滤后的字符串
 */
+ (NSString *)flattenHTML:(NSString *)html;
/*!
 *  去掉url的空格
 *
 *  @param string 要去掉的字符串
 *
 *  @return 去掉之后的字符串
 */
+ (NSString *)earseSpace:(NSString *)string;
@end
