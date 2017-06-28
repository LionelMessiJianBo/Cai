//
//  TaxiButton.m
//  DingDing
//
//  Created by gaojun on 16/7/8.
//  Copyright © 2016年 Cstorm. All rights reserved.
//

#import "TaxiButton.h"

@implementation TaxiButton

@synthesize buttonFeature;
//放大点击区域 最多为44 * 44
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect bounds = self.bounds;
    
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

- (void)setTaxiEnabled:(BOOL)taxiEnabled
{
    //可以点击
    if (taxiEnabled)
    {
        //电话按钮
        if (buttonFeature == ButtonFeaturePhone) {
            self.enabled = YES;
            [self setImage:[UIImage imageNamed:@"phone_red"] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:@"phone_gray"] forState:UIControlStateHighlighted];
        }
        //消息按钮
        if (buttonFeature == ButtonFeatureMessage) {
            self.enabled = YES;
            [self setImage:[UIImage imageNamed:@"message_red"] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:@"message_gray"] forState:UIControlStateHighlighted];
        }
    }
    else
    {
        //电话按钮
        if (buttonFeature == ButtonFeaturePhone) {
            self.enabled = NO;
            [self setImage:[UIImage imageNamed:@"phone_red"] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:@"phone_gray"] forState:UIControlStateHighlighted];
        }
        //消息按钮
        if (buttonFeature == ButtonFeatureMessage) {
            self.enabled = NO;
            [self setImage:[UIImage imageNamed:@"message_red"] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:@"message_gray"] forState:UIControlStateHighlighted];
        }
    }
    _taxiEnabled = taxiEnabled;
}

@end
