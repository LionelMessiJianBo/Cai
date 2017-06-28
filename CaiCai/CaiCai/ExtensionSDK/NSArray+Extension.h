//
//  NSArray+Extension.h
//  CheShifu
//
//  Created by YDJ on 13-7-12.
//  Copyright (c) 2013年 GuanQinglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extension)

/**
 * @brief 字典转换成json的Data类型
 *
 * @return 返回数据对象，失败时返回nil
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSData *JSONData_Ext NS_AVAILABLE(10_7, 5_0);

/**
 * @brief 字典对象转换成json字符串
 *
 * @return 返回字符串，失败时返回nil
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *JSONString_Ext NS_AVAILABLE(10_7, 5_0);

@end
