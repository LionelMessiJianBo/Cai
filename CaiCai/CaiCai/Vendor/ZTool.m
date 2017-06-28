//
//  ZTool.m
//  DingDing
//
//  Created by Anissa on 14-4-9.
//  Copyright (c) 2014年 Cstorm. All rights reserved.
//

#import "ZTool.h"
//#import "RSADataSigner.h"
//#import "RSAEncryptor.h"

#import <CommonCrypto/CommonDigest.h>

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"




@implementation ZTool
+(BOOL)isValidateFamilyName:(NSString *)familyName{
    NSString *nameRegex = @"[\u4e00-\u9fa5]{1,2}";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
    return [nameTest evaluateWithObject:familyName];
}
+(BOOL)isValidateChinese:(NSString *)chinese{
    NSString *nameRegex = @"[\u4e00-\u9fa5]+";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
    return [nameTest evaluateWithObject:chinese];
}
+(BOOL)isValidateName:(NSString *)name{
    NSString *nameRegex = @"[\u4e00-\u9fa5]{2,4}";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
    return [nameTest evaluateWithObject:name];
}

+(BOOL)isValidateNickname:(NSString *)nickname{
    NSString *nameRegex = @"^[\u4e00-\u9fa5a-zA-Z0-9]+$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
    return [nameTest evaluateWithObject:nickname];
}

+(BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL)isValidatePhone:(NSString *)phone{
    NSString *phoneRegex = @"(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(17[0-9]{1})|(14[0-9]{1}))+\\d{8})";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

+(BOOL)isValidateInteger:(NSString *)string{
    NSString *integerRegex = @"[1-9][0-9]{0,20}";
    NSPredicate *integerTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",integerRegex];
    return [integerTest evaluateWithObject:string];
}
+(BOOL)isValidateVehicleNumber:(NSString *)vehicleNumber{
    NSString *vehicleNumRegex = @"[\u4e00-\u9fa5]{1}[A-Z]{1}[A-Z_0-9]{5,6}";
    NSPredicate *vehicleNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",vehicleNumRegex];
    return [vehicleNumTest evaluateWithObject:vehicleNumber];
}

+(BOOL)checkNum:(NSString *)str
{
    NSString *regex = @"^[0-9]+(.[0-9]{1})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

+(BOOL)checkFloatNum:(NSString *)str
{
    float indexNum = [str doubleValue];
    if (indexNum <= 0.0) {
        return YES;
    }
    return NO;
}

+(BOOL)isIphone4s{
    return [UIScreen mainScreen].bounds.size.height==480;
}
+ (BOOL)isIphone5
{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [UIScreen mainScreen].currentMode.size) : NO);
}
+(BOOL)isIphone6{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(375*2, 667*2), [UIScreen mainScreen].currentMode.size) : NO);
}
+(BOOL)isIphone6p{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(414*3, 736*3), [UIScreen mainScreen].currentMode.size) : NO);
}
+(BOOL)isMoreThanIphone5s{
    return ![self isIphone4s] && ![self isIphone5];
}
+(NSString *)deleteBlank:(NSString *)string{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
+(NSString *)deleteAllBlank:(NSString *)string{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}
+ (NSString *)safeString:(NSString *)string
{
    if (!string || [string isKindOfClass:[NSNull class]] || ![string isKindOfClass:[NSString class]]){
        return @"";
    }
    return string;
}
+(NSString*)saveString:(id)string{
    if ([string isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",string];
    }
    if (!string || [string isKindOfClass:[NSNull class]] || ![string isKindOfClass:[NSString class]]){
        return @"";
    }
    return string;
}
+ (NSString *)safeString:(NSString *)string withString:(NSString *)defaultString {
    //没有网络时字符串有时为(null)
    if (!string || [string isKindOfClass:[NSNull class]] || ![string isKindOfClass:[NSString class]]){
        return defaultString;
    }
    return string;
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize textSize = CGSizeZero;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_7_0
    
    textSize = [text sizeWithFont:font constrainedToSize:size];
    
#else
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary * tdic = @{NSFontAttributeName: font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    textSize = [text boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:tdic
                                  context:nil].size;
#endif
    return textSize;
}

+ (void)showAlertWithMessage:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    UILabel *alertLabel = (UILabel *)[window viewWithTag:50000];
    CGFloat fontSize = 14.0f;
    if( alertLabel ){
        [alertLabel removeFromSuperview];
        alertLabel = nil;
    }
    
    alertLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    alertLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    alertLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    alertLabel.layer.cornerRadius = 3;
    alertLabel.layer.masksToBounds = YES;
    alertLabel.tag = 50000;
    alertLabel.numberOfLines = 0;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.font = [UIFont systemFontOfSize:14.0f];
    [window addSubview:alertLabel];
    alertLabel.text = message;
    [alertLabel sizeToFit];
    
    if( message && message.length ){
        CGRect frame = alertLabel.frame;
        if( frame.size.width >  window.bounds.size.width-50 ){
            frame.size.width = window.bounds.size.width-50;
        }else{
            frame.size.width += 10;
        }
        frame.size.height = [message boundingRectWithSize:CGSizeMake(frame.size.width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size.height+10;
        frame.origin.x = (window.bounds.size.width-frame.size.width)/2.0f;
        frame.origin.y = window.bounds.size.height-frame.size.height-80;
        alertLabel.frame = frame;
    }
    
    [alertLabel performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.5f];
}
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//+ (void)showHudWithMessage:(NSString *)message
//{
//    CGSize msgSize = [message boundingRectWithSize:CGSizeMake(kScreenWidth/2, MAXFLOAT)
//                                          options:\
//                      NSStringDrawingTruncatesLastVisibleLine |
//                      NSStringDrawingUsesLineFragmentOrigin |
//                      NSStringDrawingUsesFontLeading
//                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}
//                                          context:nil].size;
//
//    NSLog(@"%f====%f",msgSize.width,msgSize.height);
//    CGFloat height;
//    if (msgSize.height>kScreenWidth/4-30)
//    {
//        height =msgSize.height+30;
//    }
//    else
//    {
//        height =kScreenWidth/4;
//    }
//    
//    
//    
//    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
//    
//    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    coverView.backgroundColor = [UIColor clearColor];
//    [window addSubview:coverView];
//    
//    UIView *bgView = [[UIView alloc] init];
//    bgView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
//    bgView.bounds = CGRectMake(0, 0, kScreenWidth/2+30, height);
//    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
//    bgView.layer.cornerRadius = 4;
//    bgView.layer.masksToBounds = YES;
//    [coverView addSubview:bgView];
//    
//    UILabel *alertLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, bgView.width-30, bgView.height-30)];
//    alertLab.text = message;
//    alertLab.textAlignment = NSTextAlignmentCenter;
//    alertLab.textColor = [UIColor whiteColor];
//    alertLab.font = [UIFont systemFontOfSize:17];
//    alertLab.numberOfLines = 0;
//    [bgView addSubview:alertLab];
//    
//    [coverView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.5];
//
//    
//}

//+ (void)showAlertWithMessage:(NSString *)message andDelegate:(id)delegate andTag:(int)tag{
//    CustomAlertView *alertview = [[CustomAlertView alloc] initWithTitle:nil
//                                                        message:message
//                                                       delegate:delegate
//                                              cancelButtonTitle:@"取消"
//                                              otherButtonTitles:@"确认"];
//    alertview.tag = tag;
//    [alertview show];
//}
//
//+(void)showAlertWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle andDelegate:(id)delegate andTag:(int)tag{
//    CustomAlertView *alertview = [[CustomAlertView alloc] initWithTitle:nil
//                                                        message:message
//                                                       delegate:delegate
//                                              cancelButtonTitle:cancelTitle
//                                              otherButtonTitles:otherTitle];
//    alertview.tag = tag;
//    [alertview show];
//}

+(void)showFunctionInstruction{
    [self showAlertWithMessage:@"小伙伴儿正在加急开发中，敬请期待!"];
}

+(NSArray *)allCharacters{
    return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
}

+(NSString *)formatInterger:(NSInteger)number{
    if( number>=10 ){
        return [NSString stringWithFormat:@"%ld",(long)number];
    }else if(number>=0){
        return [NSString stringWithFormat:@"0%ld",(long)number];
    }
    return @"00";
}

+(NSString *)jsonStringFromDictionary:(NSDictionary *)dic{
    NSArray *keys = dic.allKeys;
    NSArray *values = dic.allValues;
    
    NSMutableString *result = [NSMutableString string];
    for (NSInteger i=0; i<keys.count; i++) {
        if( i==keys.count-1 ){
            if( [values[i] hasPrefix:@"{"] && [values[i] hasSuffix:@"}"] ){
                [result appendFormat:@"\"%@\":%@",keys[i],values[i]];
            }else{
                [result appendFormat:@"\"%@\":\"%@\"",keys[i],values[i]];
            }
        }else{
            if( [values[i] hasPrefix:@"{"] && [values[i] hasSuffix:@"}"] ){
                [result appendFormat:@"\"%@\":%@,",keys[i],values[i]];
            }else{
                [result appendFormat:@"\"%@\":\"%@\",",keys[i],values[i]];
            }
        }
    }
    result = [[[@"{" stringByAppendingString:result] stringByAppendingString:@"}"] copy];
    return result;
}

//+ (NSString *)doRsa:(NSString *)str withKey:(NSString *)key{
//    id<DataSigner> signer;
//    signer = CreateRSADataSigner(key);
//    NSString *signedString = [signer signString:str];
//    return signedString;
//}
+(NSString *) sha1:(NSString *)input
{
    //const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    //NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}
//获取手机设备的ip地址

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}
+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}
+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}
//获取当前系统版本号
+ (CGFloat)getIOSVersion{
    
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

//根据文字计算宽度的方法
+ (CGSize)getTextWidthMethod:(NSString *)textString andWordFontOfSize:(NSInteger)size
{
    CGSize textSize = [textString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
    return textSize;
}

//+ (void)requestCallPhone:(UIViewController *)viewController andAlertTag:(int)alertTag andOrderType:(NSInteger)orderType andOrderId:(NSString *)orderId
//{
//    //滞空缓存字段
//    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:RequestCallPhone];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    
//    Passenger *passenger = (Passenger *)[UserManager sharedInstace].usr;
//    [passenger getPhoneCallWithOrderId:orderId orderType:orderType userId:passenger.ID success:^(NSDictionary * _Nullable result) {
//        
//        NSDictionary *dict = result[@"responseBody"];
//        
//        //请求成功后缓存电话为其他界面拨打使用
//        [[NSUserDefaults standardUserDefaults]setObject:dict[@"telephone"] forKey:RequestCallPhone];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        
//        NSString *showString = @"";
//        showString = [NSString stringWithFormat:@"%@",dict[@"telephone"]];
//        //转接电话
//        if ([dict[@"teleType"]integerValue] == 2) {
//            //转接电话又弹出框提示
//            CustomAlertView *view = [[CustomAlertView alloc]initWithTitle:@"您将拨打专线号码" message:showString delegate:viewController cancelButtonTitle:@"取消" otherButtonTitles:@"确认"];
//            view.tag = [dict[@"telephone"] integerValue];
//            [view show];
//        }
//        //直接拨打
//        if ([dict[@"teleType"]integerValue] == 1) {
//            //转接电话又弹出框提示
//            CustomAlertView *view = [[CustomAlertView alloc]initWithTitle:@"您将拨打电话" message:showString delegate:viewController cancelButtonTitle:@"取消" otherButtonTitles:@"确认"];
//            view.tag = [dict[@"telephone"] integerValue];
//            [view show];
//        }
//        
//    } failure:^{
//        [self showAlertWithMessage:@"获取电话失败"];
//    }];
//}
//获取当前视图
+ (UIViewController *)presentingVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}
//获取字符串首字母
+ (NSString *)firstCharactorWithString:(NSString *)string
{
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    return [pinYin substringToIndex:1];
}

//设置指定部位的圆角
+ (UIView *)setLayerCornerRadius:(UIView *)view rescCorner:(UIRectCorner)rectCorner cornerRadii:(CGSize)size {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorner cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
    return view;
}

@end
