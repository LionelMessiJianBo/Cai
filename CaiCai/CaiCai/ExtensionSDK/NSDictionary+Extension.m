//
//  NSDictionary+Extension.m
//  CheShifu
//
//  Created by YDJ on 13-7-12.
//  Copyright (c) 2013年 GuanQinglong. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)


- (NSData *)JSONData_Ext
{

//    if (![NSJSONSerialization isValidJSONObject:self]) {
//        return nil;
//    }
    NSError * error=nil;
    NSData * data=nil;
    NSException * exce=nil;
    @try {
        data= [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    }
    @catch (NSException *exception) {
        exce=exception;
    }
    @finally {
        
    }
    
    if (error || exce) {
        NSLog(@"%@",exce);
        return nil;
    }

    return data;
    
}

- (NSString *)JSONString_Ext
{

    NSData * data=[self JSONData_Ext];
    NSString * string=nil;
    if (data) {
       string=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }
    return string;    
}

@end
