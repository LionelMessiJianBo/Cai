//
//  TaxiButton.h
//  DingDing
//
//  Created by gaojun on 16/7/8.
//  Copyright © 2016年 Cstorm. All rights reserved.
//
typedef NS_ENUM(NSUInteger,ButtonFeature) {
    ButtonFeaturePhone,   //电话
    ButtonFeatureMessage  //消息
};

typedef NS_ENUM(NSUInteger,MenuButtonFeature) {
    MenuButtonFeaturePhone,   //电话
    MenuButtonFeatureMessage, //消息
    MenuButtonFeatureReward   //有奖推荐
};
#import <UIKit/UIKit.h>

@interface TaxiButton : UIButton

@property (nonatomic, assign)BOOL taxiEnabled;
@property (nonatomic, assign)ButtonFeature buttonFeature;
@property (nonatomic, assign)MenuButtonFeature menuButtonFeature;

@end
