//
//  UIFont+Extension.m
//  CheShifu
//
//  Created by YDJ on 13-7-10.
//  Copyright (c) 2013年 GuanQinglong. All rights reserved.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)

+ (UIFont *)systemAvenirHeavySize_Ext:(CGFloat)fontSize
{
    return [[self class] fontWithName:@"Avenir-Heavy" size:fontSize];
}

+ (UIFont *)systemAvenirBlackSize_Ext:(CGFloat )fontSize
{
    return [[self class] fontWithName:@"Avenir-Black" size:fontSize];
}

@end
