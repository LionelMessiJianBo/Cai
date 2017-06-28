//
//  NSObject+Extension.h
//  CheShifu
//
//  Created by YDJ on 13-5-24.
//  Copyright (c) 2013年 GuanQinglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)

@property (nonatomic,retain)NSDictionary * userInfo_Ext;

/**
 * @brief 进行encoder操作的方法
 *
 * @param obj 要进行coder的对象，该对象应接受NSCoding协议，实现协议的方法
 *
 * @param path_ 存放的路径名称，e.g:/users/test/data
 *
 * @return 操作是否成功,YES 成功，NO 失败
 */
- (BOOL)encoderObject_Ext:(id)obj withPath:(NSString *)path_;

/**
 * @brief 解析解码Decoder操作
 *
 * @param path_ 文件的路径，e.g:/users/test/data
 *
 * @return 返回解码后的对象
 */
- (id)decoderObjectPath_Ext:(NSString *)path_;

/**
 * @brief data写入本地
 *
 * @param path 存放的路径名称，e.g:/users/test/data
 * @param data 要存放的数据
 *
 */
-(void)writeToFile_Ext:(NSString *)path data:(NSData *)data;


/**
 *
 * @brief 创建文件夹
 * 
 * @param path 文件夹的路径,e.g：/users文件夹/doc文件夹
 * @param att 最后文件夹的属性
 * @param error 失败的指针地址
 *
 * @return 创建的成功还是失败
 *
 */
- (BOOL)createDirectoryPath_Ext:(NSString *)path withAttribute:(NSDictionary *)att error:(NSError **)error;

@end
