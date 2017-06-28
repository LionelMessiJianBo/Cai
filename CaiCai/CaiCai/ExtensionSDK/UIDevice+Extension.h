//
//  UIDevice+Extension.h
//  ExtensionSDK
//
//  Created by YDJ on 13-3-8.
//  Copyright (c) 2013年 jingyoutimes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Security/Security.h>

#define kDeviceSystemVersionFloatValue_Ext [[[UIDevice currentDevice] systemVersion] floatValue]


@interface UIDevice (Extension)

/**
 * @brief 判断是否是iPhone5的设备
 *
 * @return YES 是，NO 不是
 */
@property (NS_NONATOMIC_IOSONLY, getter=isPhone5_Ext, readonly) BOOL phone5_Ext;

/**
 * @brief 判断设备是否retain屏幕
 *
 * @return YES 是，NO 不是
 */
@property (NS_NONATOMIC_IOSONLY, getter=isRetain_Ext, readonly) BOOL retain_Ext;

/**
 * @brief 判断设备是否越狱
 *
 * @return YES 越狱，NO 未越狱
 */
@property (NS_NONATOMIC_IOSONLY, getter=isJailbroken_Ext, readonly) BOOL jailbroken_Ext;


/**
 * @brief 获得设备的唯一标示
 *
 * @return 返回设备的唯一标示
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *udidString_Ext;

/**
 * @brief 获得系统的进程
 *
 * @return 返回数组，数组中是字典，包括进程的id和名称
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *runningProcesses_Ext;

/**
 * @brief 获得系统的名称，ios
 *
 * @return 返回名称字符串
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *systemNameString_Ext;

/**
 * @brief 获得系统的版本号，6.1.3
 *
 * @return 版本号字符串
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *systemVersionString_Ext;

/**
 * @brief 获取设备的名字,xx的iPhone
 *
 * @return 设备名字
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *deviceNameString_Ext;

/**
 * @brief model的名字
 *
 * @return model字符串
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *localizedModelString_Ext;

/**
 * @brief 得到设备类型 ,IPHONE5
 *
 * @return 设备类型字符串
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *platformString_Ext;

/**
 * @brief 平台的信息
 *
 * @return 信息字符串
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *platform_Ext;

/**
 * @brief 平台枚举
 *
 * @return 枚举值
 */
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger platformType_Ext;


@end
