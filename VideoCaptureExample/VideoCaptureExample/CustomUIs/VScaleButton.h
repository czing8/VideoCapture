//
//  VScaleButton.h
//  VideoCaptureExample
//
//  Created by Vols on 2017/2/6.
//  Copyright © 2017年 vols. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScaleButtonState) {
    ScaleButtonStateBegin,
    ScaleButtonStateIn,
    ScaleButtonStateOut,
    ScaleButtonStateCancle,
    ScaleButtonStateFinish
};

typedef void (^ScaleButtonStateChange)(ScaleButtonState state);

@interface VScaleButton : UIView

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, readonly) CGFloat radius;
@property (nonatomic, copy) ScaleButtonStateChange stateChange;

- (void)disappearAnimation;
- (void)appearAnimation;

- (BOOL)circleContainsPoint:(CGPoint)point;
- (void)setTitle:(NSString *)title;

@end
