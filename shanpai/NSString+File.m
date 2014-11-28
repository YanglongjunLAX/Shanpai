//
//  NSString+File.m
//  SinaWeibo
//
//  Created by mj on 13-8-19.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "NSString+File.h"

@implementation NSString (SP)
// 在文件名后拼接一段字符串（扩展名不变）
- (NSString *)fileNameAppendString:(NSString *)str
{
    // 如果没有传入任何字符串
    if (str.length == 0) return self;
    
    // 1.文件拓展名
    NSString *extension = [self pathExtension];
    // 2.获得没有拓展名的文件名
    NSString *shortName = [self stringByDeletingPathExtension];
    // 3.拼接str
    NSString *dest = [shortName stringByAppendingString:str];
    // 4.拼接拓展名
    return [dest stringByAppendingPathExtension:extension];
}

+ (NSString *)withinWanStr:(int)count
{
    NSString *str = nil;
    if (count < 10000) {
        str = [NSString stringWithFormat:@"%d", count];
    } else {
        // 整万
        double result = count/10000.0;
        
        if ((int)(result * 10) % 10 == 0) {
            str = [NSString stringWithFormat:@"%.f万", result];
        } else {
            str = [NSString stringWithFormat:@"%.1f万", result];
        }
    }
    return str;
}

- (void)openWebsetBySelf
{
    NSURL *url = [NSURL URLWithString:self];
    [[UIApplication sharedApplication] openURL:url];
}

- (BOOL)validateRegular:(NSString *)regular
{
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    if (([regextestmobile evaluateWithObject:self] == YES))
    {
        return YES;
    }
    return NO;
}

+ (NSString *)flattenHTML:(NSString *)html
{
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO)
    {
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        [theScanner scanUpToString:@">" intoString:&text] ;
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    NSMutableString * resultStr = [html mutableCopy];
    [resultStr replaceOccurrencesOfString:@"/n" withString:@"" options:0 range:NSMakeRange(0, resultStr.length)];
    return resultStr;
}

+ (NSString *)earseSpace:(NSString *)string
{
    NSMutableString *cUrl = [string mutableCopy];
    [cUrl replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, cUrl.length)];
    return cUrl;
}

@end
