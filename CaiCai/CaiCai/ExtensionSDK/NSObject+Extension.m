//
//  NSObject+Extension.m
//  CheShifu
//
//  Created by YDJ on 13-5-24.
//  Copyright (c) 2013年 GuanQinglong. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>

@implementation NSObject (Extension)


-(void)setUserInfo_Ext:(NSDictionary *)newUserInfo_Ext
{
    objc_setAssociatedObject(self, @"userInfo_Ext", newUserInfo_Ext, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)userInfo_Ext
{
    return objc_getAssociatedObject(self, @"userInfo_Ext");
}


- (BOOL)encoderObject_Ext:(id)obj withPath:(NSString *)path_
{
    
    if ( obj &&![obj conformsToProtocol:@protocol(NSCoding)]) {
        NSLog(@"没有实现NSCoding协议");
        return NO;
    }
    
    BOOL isResult=YES;
    
    NSFileManager * file=[NSFileManager defaultManager];
    
    NSArray * array=[path_ componentsSeparatedByString:@"/"];
    
    if (array.count==0) {
        isResult=NO;
        return isResult;
    }
    
    NSString * objPath=@"/";
    
    for (int i=0; i<array.count-1; i++) {
        NSString * name=array[i];
        NSString * temp=[objPath stringByAppendingPathComponent:name];
        objPath=[NSString stringWithFormat:@"%@",temp];
        if (![file fileExistsAtPath:temp]) {
           isResult=[file createDirectoryAtPath:temp withIntermediateDirectories:YES attributes:nil error:nil];
            if (isResult==NO) {
                return isResult;
            }
        }
    }
    NSString * docName=array.lastObject;
    NSString * lastpath=[objPath stringByAppendingPathComponent:docName];
    NSMutableData * data=[[NSMutableData alloc] init];
    NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:obj
                    forKey:[docName md5DHexDigestString_Ext]];
    [archiver finishEncoding];
    isResult=[data writeToFile:lastpath atomically:YES];
    
    [archiver release];
    [data release];
    
    return isResult;
    
}

- (id)decoderObjectPath_Ext:(NSString *)path_
{

    NSFileManager * file=[NSFileManager defaultManager];
    
    if ([file fileExistsAtPath:path_]==NO) {
        return nil;
    }
    NSArray * array=[path_ componentsSeparatedByString:@"/"];
    if (array.count==0) {
        return nil;
    }
    NSData * data=[[NSMutableData alloc] initWithContentsOfFile:path_];
    NSKeyedUnarchiver * unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id obj=[unarchiver decodeObjectForKey:[array.lastObject md5DHexDigestString_Ext]];
    [unarchiver finishDecoding];
    
    [unarchiver release];
    [data release];
    
    return obj;
}


-(void)writeToFile_Ext:(NSString *)path data:(NSData *)data
{//下载的数据写到本地
    if (path==nil||data==nil) {
        return ;
    }
    
    NSString * imagePath=@"/";
    NSFileManager * file=[NSFileManager defaultManager];
    
    NSArray * array=[path componentsSeparatedByString:@"/"];
    
    for (int i=0; i<array.count-1; i++) {
        NSString * name=array[i];
        NSString * temp=[imagePath stringByAppendingPathComponent:name];
        imagePath=[NSString stringWithFormat:@"%@",temp];
        if (![file fileExistsAtPath:temp]) {
            [file createDirectoryAtPath:temp withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString * lastPath=[imagePath stringByAppendingPathComponent:array.lastObject];
    [data writeToFile:lastPath atomically:YES];
}


- (BOOL)createDirectoryPath_Ext:(NSString *)path withAttribute:(NSDictionary *)att error:(NSError **)error
{
    if (path==nil || path.length==0) {
        return NO;
    }
    
    
    BOOL result=YES;
    
    NSString * imagePath=@"/";
    NSFileManager * file=[NSFileManager defaultManager];
    
    NSArray * array=[path componentsSeparatedByString:@"/"];
    
    for (int i=0; i<array.count; i++) {
        NSString * name=array[i];
        NSString * temp=[imagePath stringByAppendingPathComponent:name];
        imagePath=[NSString stringWithFormat:@"%@",temp];
        if (![file fileExistsAtPath:temp]) {
            NSDictionary * dic=nil;
            if (i==array.count-1) {
                dic=att;
            }
           result=[file createDirectoryAtPath:temp withIntermediateDirectories:YES attributes:dic error:error];
            if (result==NO) {
                return NO;
            }
        }
    }
    
    return result;
}



@end
