//
//  FCMaskView.h
//  FCCodeScannerDemo
//
//  Created by Frank on 10/13/15.
//  Copyright © 2015 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  遮罩界面(扫描窗+扫描线, 半透明背景)
 *  Mask View with a scanning window and line on a tranparent background
 */
@interface FCMaskView : UIView
/**
 *  扫描框边框线颜色
 */
@property (nonatomic, strong) UIColor *scanRectBorderColor;

/**
 *  扫描线颜色
 */
@property (nonatomic, strong) UIColor *scanLineColor;

/**
 *  扫描框宽度比例, 已较小的屏幕分辨率为基准, 取值范围(0~1)
 */
@property (nonatomic, assign) CGFloat scanRectRate;

/**
 *  扫描线的长度, 默认与扫描框的宽度相同
 */
@property (nonatomic, assign) CGFloat scanLineLength;

/**
 *  是否全屏无遮罩, 默认为非全屏, 值为NO
 */
@property (nonatomic, assign) BOOL isFullScreen;

/**
 *  扫描线宽度
 */
@property (nonatomic, assign) CGFloat scanLineWidth;

/**
 *  扫描框边框线宽
 */
@property (nonatomic, assign) CGFloat scanRectBorderLineWidth;

/**
 *  当前界面的朝向
 */
@property (nonatomic, assign) UIInterfaceOrientation orientation;

/**
 *  传递尺寸实例化对象
 *  initialize class with frame
 *
 *  @param aFrame 尺寸(frame)
 *
 *  @return FCMaskView实例化对象(instance)
 */
+ (instancetype)maskViewWithFrame:(CGRect)aFrame;

@end
