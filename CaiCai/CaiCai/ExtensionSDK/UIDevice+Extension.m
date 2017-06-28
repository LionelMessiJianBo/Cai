//
//  UIDevice+Extension.m
//  ExtensionSDK
//
//  Created by YDJ on 13-3-8.
//  Copyright (c) 2013年 jingyoutimes. All rights reserved.
//

#import "UIDevice+Extension.h"
#import "NSString+Extension.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>


#include <sys/types.h>
#import "UIDevice+Extension.h"
#import "NSString+Extension.h"

static NSString * const kaccount_UIDevice_Extension=@"comm.deviceid.account.keychainOrPasteboard";
static NSString * const kservise_UIDevice_Extension=@"comm.deviceid.service.keychainOrPasteboard";


#define IFPGA_NAMESTRING                       @"iFPGA"

#define IPHONE_1G_NAMESTRING                   @"iPhone 1G"
#define IPHONE_3G_NAMESTRING                   @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING                  @"iPhone 3GS"
#define IPHONE_4_NAMESTRING                    @"iPhone 4"
#define IPHONE_4S_NAMESTRING                   @"iPhone 4S"
#define IPHONE_5_NAMESTRING                    @"iPhone 5"
#define IPHONE_UNKNOWN_NAMESTRING              @"Unknown iPhone"

#define IPOD_1G_NAMESTRING                     @"iPod touch 1G"
#define IPOD_2G_NAMESTRING                     @"iPod touch 2G"
#define IPOD_3G_NAMESTRING                     @"iPod touch 3G"
#define IPOD_4G_NAMESTRING                     @"iPod touch 4G"
#define IPOD_UNKNOWN_NAMESTRING                @"Unknown iPod"

#define IPAD_1G_NAMESTRING                     @"iPad 1G"
#define IPAD_2G_NAMESTRING                     @"iPad 2G"
#define IPAD_3G_NAMESTRING                     @"iPad 3G"
#define IPAD_UNKNOWN_NAMESTRING                @"Unknown iPad"

// Nano? Apple TV?
#define APPLETV_2G_NAMESTRING                  @"Apple TV 2G"

#define IPOD_FAMILY_UNKNOWN_DEVICE             @"Unknown iOS device"

#define IPHONE_SIMULATOR_NAMESTRING            @"iPhone Simulator"
#define IPHONE_SIMULATOR_IPHONE_NAMESTRING     @"iPhone Simulator"
#define IPHONE_SIMULATOR_IPAD_NAMESTRING       @"iPad Simulator"

typedef NS_ENUM(unsigned int, UIDevicePlatform) {
    UIDeviceUnknown,
    
    UIDeviceiPhoneSimulator,
    UIDeviceiPhoneSimulatoriPhone, // both regular and iPhone 4 devices
    UIDeviceiPhoneSimulatoriPad,
    
    UIDevice1GiPhone,
    UIDevice3GiPhone,
    UIDevice3GSiPhone,
    UIDevice4iPhone,
    UIDevice4SiPhone,
    UIDevice5iPhone,
    
    UIDevice1GiPod,
    UIDevice2GiPod,
    UIDevice3GiPod,
    UIDevice4GiPod,
    
    UIDevice1GiPad, // both regular and 3G
    UIDevice2GiPad,
    UIDevice3GiPad,
    
    
    UIDeviceAppleTV2,
    
    UIDeviceUnknowniPhone,
    UIDeviceUnknowniPod,
    UIDeviceUnknowniPad,
    UIDeviceIFPGA,
    
};




@implementation UIDevice (Extension)

/**
 * @brief 判断设备是否是IPHONE5
 *
 * @return YES 是，NO 不是
 */
- (BOOL)isPhone5_Ext
{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [UIScreen mainScreen].currentMode.size) : NO);
}


- (BOOL)isRetain_Ext
{
    
    if (self.userInterfaceIdiom==UIUserInterfaceIdiomPhone) {//iphone/ipod
        if ([self isPhone5_Ext]) {
            return YES;
        }
        else{
            return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [UIScreen mainScreen].currentMode.size) : NO);
        }
    }
    else{//ipad
        
        return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1536, 2048), [UIScreen mainScreen].currentMode.size) : NO);
    }
    
    
}

/**
 * @brief 设备是否越狱
 *
 * @return YES 越狱, NO 未越狱
 */
- (BOOL)isJailbroken_Ext
{
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }    
    return jailbroken;    
}



-(NSString*)getUUID_Ext
{
    CFUUIDRef puuid = CFUUIDCreate( kCFAllocatorDefault );
    CFStringRef uuidString = CFUUIDCreateString( kCFAllocatorDefault, puuid );
    NSString * result = (NSString *)CFStringCreateCopy( kCFAllocatorDefault, uuidString);
    CFRelease(puuid);
    CFRelease(uuidString);
    return [result autorelease];
}

-(NSString *)createUdidString_Ext
{//uuid+随机字符或数字 经过md5处理
    
    NSString * service=kservise_UIDevice_Extension;
    NSString * account=kaccount_UIDevice_Extension;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:3];
    dictionary[( id)kSecClass] = ( id)kSecClassGenericPassword;
    if (service) {
        dictionary[( id)kSecAttrService] = service;
    }
    
    if (account) {
        dictionary[( id)kSecAttrAccount] = account;
    }
    dictionary[( id)kSecAttrAccessible] = ( id)kSecAttrAccessibleAlwaysThisDeviceOnly;
   
    ////获取
    NSMutableDictionary * tempDictionary=[NSMutableDictionary dictionaryWithDictionary:dictionary];
    CFTypeRef resultData = NULL;
    tempDictionary[( id)kSecReturnData] = @YES;
    tempDictionary[( id)kSecMatchLimit] = ( id)kSecMatchLimitOne;
    SecItemCopyMatching(( CFDictionaryRef)tempDictionary, &resultData);
    NSData * data=(NSData *)resultData;
    NSString * endid=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if (resultData) {
        CFRelease(resultData);
    }
    
    if (endid.length==0) {
        NSMutableString * string=[[NSMutableString alloc] init];
        NSString * uuString=[self getUUID_Ext];
        [string appendFormat:@"%@-",uuString];//uuid
        
        for (int i=0; i<16; i++) {//随机数
            int num=arc4random()%10;
            if (num%2==0) {
                [string appendFormat:@"%d",arc4random()%10];
            }
            else{
                [string appendFormat:@"%c",65+arc4random()%26];
            }
          }
        
        endid=[[NSString stringWithFormat:@"%@",string] md5DHexDigestString_Ext];
        dictionary[( id)kSecValueData] = [endid dataUsingEncoding:NSUTF8StringEncoding];
        dictionary[( id)kSecAttrLabel] = @"label for device id";
        SecItemAdd(( CFDictionaryRef)dictionary, NULL);
        
        [string release];
        
      }
    
    return endid;
}
/**
 * @brief 获得设备的唯一标示
 *
 * @return 返回设备的唯一标示
 */
- (NSString *)udidString_Ext
{
   return  [self createUdidString_Ext];
}
/**
 * @brief 系统的进程
 *
 * @return 数组中有字典，返回进程的id和名称
 */
- (NSArray *)runningProcesses_Ext
{

        int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
        size_t miblen = 4;
        
        size_t size;
        int st = 0;
        sysctl(mib, (u_int)miblen, NULL, &size, NULL, 0);
        
        struct kinfo_proc * process = NULL;
        struct kinfo_proc * newprocess = NULL;
        
        do {
            
            size += size / 10;
            newprocess = realloc(process, size);
            
            if (!newprocess){
                
                if (process){
                    free(process);
                }
                
                return nil;
            }
            
            process = newprocess;
            st = sysctl(mib, (u_int)miblen, process, &size, NULL, 0);
            
        } while (st == -1 && errno == ENOMEM);
        
        if (st == 0){
            
            if (size % sizeof(struct kinfo_proc) == 0){
                int nprocess = (int)(size / sizeof(struct kinfo_proc));
                
                if (nprocess){
                    
                    NSMutableArray * array = [[NSMutableArray alloc] init];
                    
                    for (int i = nprocess - 1; i >= 0; i--){
                        
                        NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
                        NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                        
                        NSDictionary * dict = [[NSDictionary alloc] initWithObjects:@[processID, processName]
                                                                            forKeys:@[@"ProcessID", @"ProcessName"]];
                        [processID release];
                        [processName release];
                        [array addObject:dict];
                        [dict release];  
                    }  
                    
                    free(process);  
                    return [array autorelease];  
                }  
            }  
        }  
    
        free(process);
        return nil;
}




- (NSString *)systemNameString_Ext
{
    NSString *infoString = self.systemName;//系统名称，如iPhone OS
    return infoString;
}

- (NSString *)systemVersionString_Ext
{
    NSString *infoString = self.systemVersion;//系统版本，如4.2.1
    return infoString;
}


- (NSString *)deviceNameString_Ext
{
    NSString *infoString = self.name;//设备的名称，如 张三的iPhone
    return infoString;
}

- (NSString *)localizedModelString_Ext
{
    NSString *infoString = self.localizedModel;//localized version of model
    return infoString;
}



#pragma mark -
#pragma mark Public Methods



#pragma mark sysctlbyname utils
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    NSLog(@"%s",answer);
    NSString *results = @(answer);
    free(answer);
    return results;
}

- (NSString *) platform_Ext
{
    return [self getSysInfoByName:"hw.machine"];
}

#pragma mark platform type and name utils
- (NSUInteger) platformType_Ext
{
    //    DDLog(@"Battery level: %0.2f", [[UIDevice currentDevice] batteryLevel] * 100);
    //    NSArray *stateArray = [NSArray arrayWithObjects: @"Unknown", @"not plugged into a charging source", @"charging", @"full", nil];
    //    DDLog(@"Battery state: %@", [stateArray objectAtIndex:[[UIDevice currentDevice] batteryState]]);
    
    NSString *platform = [self platform_Ext];
    // if ([platform isEqualToString:@"XX"])   return UIDeviceUnknown;
    if ([platform isEqualToString:@"iFPGA"])  return UIDeviceIFPGA;
    
    if ([platform isEqualToString:@"iPhone1,1"]) return UIDevice1GiPhone;
    if ([platform isEqualToString:@"iPhone1,2"]) return UIDevice3GiPhone;
    if ([platform hasPrefix:@"iPhone2"])         return UIDevice3GSiPhone;
    if ([platform isEqualToString:@"iPhone3,1"])   return UIDevice4iPhone;
    if ([platform isEqualToString:@"iPhone4,1"])   return UIDevice4SiPhone;
    
    if ([platform hasPrefix:@"iPhone5"])   return UIDevice5iPhone;
    
    
    if ([platform isEqualToString:@"iPod1,1"])   return UIDevice1GiPod;
    if ([platform isEqualToString:@"iPod2,1"])   return UIDevice2GiPod;
    if ([platform isEqualToString:@"iPod3,1"])   return UIDevice3GiPod;
    if ([platform isEqualToString:@"iPod4,1"])   return UIDevice4GiPod;
    
    if ([platform isEqualToString:@"iPad1,1"])   return UIDevice1GiPad;
    
    if ([platform isEqualToString:@"iPad2,1"] || [platform isEqualToString:@"iPad2,2"] || [platform isEqualToString:@"iPad2,3"])
    {
        return UIDevice2GiPad;
    }
    
    if ([platform isEqualToString:@"iPad3,1"] || [platform isEqualToString:@"iPad3,2"] || [platform isEqualToString:@"iPad3,3"])
    {   //ipad 3,1 is wifi
        //ipad 3,2 is gsm
        //ipad 3,3 is iPad Wi-Fi + Cellular GSM CDMA
        return UIDevice3GiPad;
    }
    
    if ([platform isEqualToString:@"iPad2,4"])   return UIDevice2GiPad;
    
    if ([platform isEqualToString:@"AppleTV2,1"]) return UIDeviceAppleTV2;
    
    /*
     MISSING A SOLUTION HERE TO DATE TO DIFFERENTIATE iPAD and iPAD 3G.... SORRY!
     */
    
    if ([platform hasPrefix:@"iPhone"]) return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"]) return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"]) return UIDeviceUnknowniPad;
    
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        if ([UIScreen mainScreen].bounds.size.width < 768)
            return UIDeviceiPhoneSimulatoriPhone;
        else
            return UIDeviceiPhoneSimulatoriPad;
        
        return UIDeviceiPhoneSimulator;
    }
    return UIDeviceUnknown;
}

- (NSString *) platformString_Ext
{
    switch ([self platformType_Ext])
    {
        case UIDevice1GiPhone: return IPHONE_1G_NAMESTRING;
        case UIDevice3GiPhone: return IPHONE_3G_NAMESTRING;
        case UIDevice3GSiPhone: return IPHONE_3GS_NAMESTRING;
        case UIDevice4iPhone: return IPHONE_4_NAMESTRING;
        case UIDevice4SiPhone: return IPHONE_4S_NAMESTRING;
        case UIDevice5iPhone: return IPHONE_5_NAMESTRING;
        case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPod: return IPOD_1G_NAMESTRING;
        case UIDevice2GiPod: return IPOD_2G_NAMESTRING;
        case UIDevice3GiPod: return IPOD_3G_NAMESTRING;
        case UIDevice4GiPod: return IPOD_4G_NAMESTRING;
        case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPad : return IPAD_1G_NAMESTRING;
        case UIDevice2GiPad : return IPAD_2G_NAMESTRING;
        case UIDevice3GiPad : return IPAD_3G_NAMESTRING;
            
            
        case UIDeviceAppleTV2 : return APPLETV_2G_NAMESTRING;
            
        case UIDeviceiPhoneSimulator: return IPHONE_SIMULATOR_NAMESTRING;
        case UIDeviceiPhoneSimulatoriPhone: return IPHONE_SIMULATOR_IPHONE_NAMESTRING;
        case UIDeviceiPhoneSimulatoriPad: return IPHONE_SIMULATOR_IPAD_NAMESTRING;
            
        case UIDeviceIFPGA: return IFPGA_NAMESTRING;
            
        default: return IPOD_FAMILY_UNKNOWN_DEVICE;
    }
}







@end
