//
//  LTParallaxScrollView.m
//  LTParallaxScrollView
//
//  Created by Yu Cong on 14-9-7.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "LTParallaxScrollView.h"

#define defaultAcceleration CGPointMake(1.0, 1.0)
#define defaultZooming CGPointMake(1.0, 1.0)

@interface LTParallaxScrollView()
@property (nonatomic, strong) NSMutableDictionary *accelerationsOfSubViews;
@property (nonatomic, strong) NSMutableDictionary *zoomSpeedOfSubViews;
@end

@implementation LTParallaxScrollView

- (NSMutableDictionary *)accelerationsOfSubViews{
    if (!_accelerationsOfSubViews) {
        _accelerationsOfSubViews = [NSMutableDictionary dictionary];
    }
    return _accelerationsOfSubViews;
}

- (NSMutableDictionary *)zoomSpeedOfSubViews{
    if (!_zoomSpeedOfSubViews) {
        _zoomSpeedOfSubViews = [NSMutableDictionary dictionary];
    }
    return _zoomSpeedOfSubViews;
}

-(NSValue*) keyOfView:(UIView*) view
{
    return @((int)view);
}

- (void)addSubview:(UIView *)view
{
    [self addSubview:view withAcceleration:defaultAcceleration];
}

- (void)addSubview:(UIView *)view withAcceleration:(CGPoint) acceleration
{
    [super addSubview:view];
    [self setAcceleration:acceleration forView:view];
}

- (void)setAcceleration:(CGPoint) acceleration forView:(UIView *)view
{
    self.accelerationsOfSubViews[[self keyOfView:view]] = NSStringFromCGPoint(acceleration);
}

- (void)setZoomSpeed:(CGPoint) zoomSpeed forView:(UIView *)view;
{
    self.zoomSpeedOfSubViews[[self keyOfView:view]] = NSStringFromCGPoint(zoomSpeed);
}

- (CGPoint)accelerationForView:(UIView *)view
{
    NSString *pointValue = self.accelerationsOfSubViews[[self keyOfView:view]];
    if(!pointValue){
        return CGPointZero;
    }
    else{
        return CGPointFromString(pointValue);
    }
}

- (CGPoint)zoomSpeedForView:(UIView *)view
{
    NSString *pointValue = self.zoomSpeedOfSubViews[[self keyOfView:view]];
    if(!pointValue){
        return CGPointZero;
    }
    else{
        return CGPointFromString(pointValue);
    }
}

- (void)willRemoveSubview:(UIView *)subview
{
    [self.accelerationsOfSubViews removeObjectForKey:[self keyOfView:subview]];
}

- (void)layoutSubviews
{
    for (UIView *subview in self.subviews) {

        CGPoint accelecration = [self accelerationForView:subview];
        CGPoint zoomSpeed = [self zoomSpeedForView:subview];

        if(CGPointEqualToPoint(accelecration,defaultAcceleration) && CGPointEqualToPoint(zoomSpeed,CGPointZero)){
            return;
        }
        CGAffineTransform translation = CGAffineTransformMakeTranslation(self.contentOffset.x*(1.0-accelecration.x), self.contentOffset.y*(1.0-accelecration.y));
        
        
        CGAffineTransform scale=CGAffineTransformMakeScale(1-self.contentOffset.y/300*zoomSpeed.x, 1-self.contentOffset.y/300*zoomSpeed.y);
        
        subview.transform = CGAffineTransformConcat(scale, translation);
        
    }
    [super layoutSubviews];
}

@end