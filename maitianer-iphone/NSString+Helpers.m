//
//  NSString+Helpers.m
//  maitianer-iphone
//
//  Created by 张 朝 on 12-2-8.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import "NSString+Helpers.h"

@implementation NSString (Helpers)

- (NSString *) stringByUrlEncoding
{
	return (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)self,  NULL,  (CFStringRef)@"!*'();:@&amp;=+$,/?%#[]",  kCFStringEncodingUTF8);
}

@end
