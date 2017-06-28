//
//  ZTool.h
//  DingDing
//
//  Created by Anissa on 14-4-9.
//  Copyright (c) 2014年 Cstorm. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  个人定制的工具类
 */

@interface ZTool : NSObject

//正则表达式
+(BOOL)isValidateChinese:(NSString *)chinese;
+(BOOL)isValidateFamilyName:(NSString *)familyName;
+(BOOL)isValidateName:(NSString *)name;
+(BOOL)isValidateNickname:(NSString *)nickname;
+(BOOL)isValidateEmail:(NSString *)email;
+(BOOL)isValidatePhone:(NSString *)phone;
+(BOOL)isValidateInteger:(NSString *)string;
+(BOOL)checkNum:(NSString *)str;
+(BOOL)checkFloatNum:(NSString *)str;
+(BOOL)isValidateVehicleNumber:(NSString *)vehicleNumber;  //验证车牌号是否合法
+(UIImage *)imageWithColor:(UIColor *)color;
//当字符串为NSNull或不是字符串时，返回“”，保证字符串操作安全
+ (NSString *)safeString:(NSString *)string;
//当字符串为NULL或其他的时候，用defaultString，代理string
+ (NSString *)safeString:(NSString *)string withString:(NSString *)defaultString;

//根据设置文本标签的文本属性，返回文本标签的大小，返回类型为CGSize
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)size;
//去除字符串首尾空格
+(NSString *)deleteBlank:(NSString *)string;
//去除字符串里面的全部空格
+(NSString *)deleteAllBlank:(NSString *)string;
//弹出警告框
+ (void)showAlertWithMessage:(NSString *)message;
//+ (void)showHudWithMessage:(NSString *)message;
//+ (void)showAlertWithMessage:(NSString *)message andDelegate:(id)delegate andTag:(int)tag;
//+ (void)showAlertWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle andDelegate:(id)delegate andTag:(int)tag;

+ (BOOL)isIphone4s;
+ (BOOL)isIphone5;
+ (BOOL)isIphone6;
+ (BOOL)isIphone6p;
+(BOOL)isMoreThanIphone5s;
//获取当前视图
+ (UIViewController *)presentingVC;
//预留功能说明
+(void)showFunctionInstruction;

//26个英文字母数组
+(NSArray *)allCharacters;

/**
 *  格式化数字，例如number=5,则返回“05”，number=37,则返回“37”
 *
 *  @param number 要格式化的数字
 *
 *  @return 格式化的结果
 */
+(NSString *)formatInterger:(NSInteger)number;
+(NSString *)jsonStringFromDictionary:(NSDictionary *)dic;
//+(NSString *)doRsa:(NSString *)str withKey:(NSString *)key;
+(NSString *) sha1:(NSString *)input;
+(NSString*)saveString:(id)string;
//获取手机设备的ip地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
//+ (NSString *)getDeviceIPAddress:(BOOL)preferIPV4;
//获取当前系统版本号
+ (CGFloat)getIOSVersion;
/**
 *  @brief 根据文字字体计算尺寸
 *
 *  @param textString 文字
 *  @param textString 文号
 *  @return 尺寸
 */
+ (CGSize)getTextWidthMethod:(NSString *)textString andWordFontOfSize:(NSInteger)size;

/**
 *  @brief 获取转接电话的方法
 *
 *  @param viewController 植入哪个界面
 *  @param alertTag       tag
 *  @param orderType      订单类型
 *  @param orderId        订单id
 */
//+ (void)requestCallPhone:(UIViewController *)viewController andAlertTag:(int)alertTag andOrderType:(NSInteger)orderType andOrderId:(NSString *)orderId;

/**
 *  @brief 获取字符串首字母
 *
 *  @param string 目标字符串
 *
 *  @return 首字符字符串
 */
+ (NSString *)firstCharactorWithString:(NSString *)string;


//设置指定部位的圆角
+ (UIView *)setLayerCornerRadius:(UIView *)view rescCorner:(UIRectCorner)rectCorner cornerRadii:(CGSize)size;

@end
