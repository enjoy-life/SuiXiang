//
//  LTParallaxScrollView.h
//  LTParallaxScrollView
//
//  Created by Yu Cong on 14-9-7.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTParallaxScrollView : UIScrollView

- (void)setAcceleration:(CGPoint) acceleration forView:(UIView *)view;

- (void)setZoomSpeed:(CGPoint) zoomSpeed forView:(UIView *)view;

@end
