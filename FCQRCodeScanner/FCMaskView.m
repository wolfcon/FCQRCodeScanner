//
//  FCMaskView.m
//  FCCodeScannerDemo
//
//  Created by Frank on 10/13/15.
//  Copyright © 2015 Frank. All rights reserved.
//

#import "FCMaskView.h"

@interface FCMaskView (){
    CGFloat scanRectWidth;
    
    CGFloat frameWidth;
    CGFloat frameHeight;
    CGFloat topOrBottom;
    CGFloat leftOrRight;
    
    UIImageView *scanLine;
}

@end

@implementation FCMaskView

+ (instancetype)maskViewWithFrame:(CGRect)aFrame{
    return [[FCMaskView alloc] initWithFrame:aFrame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        
        //初始化系列值
        self.isFullScreen = NO;
        self.scanRectBorderColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.9];
        self.scanLineColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.9];
        self.scanRectBorderLineWidth = 5;
        self.scanLineWidth = 3;
        self.scanRectRate = 0.6;//默认一个较适中的尺寸
        
        [self initMeasurementWithFrame:frame];
    }
    return self;
}

/**
 *  初始化尺寸
 */
- (void)initMeasurementWithFrame:(CGRect)frame{
    //初始化尺寸
    frameWidth = frame.size.width;
    frameHeight = frame.size.height;
    
    scanRectWidth = self.scanRectRate*MIN(frameWidth, frameHeight);
    
    topOrBottom = (frameHeight - scanRectWidth)/2;
    leftOrRight = (frameWidth - scanRectWidth)/2;
    
    self.scanLineLength = scanRectWidth;
}

// 重写frame的赋值方式, 初始化一些基础跟frame有关的线值
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    [self initMeasurementWithFrame:frame];
}

// 设置清除画板
- (BOOL)clearsContextBeforeDrawing{
    return YES;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    if (!self.isFullScreen) {
        //非全屏画遮罩
        [self drawAroundInRect:rect];
    } else {
        //全屏需要画全屏线
        self.scanLineLength = UIInterfaceOrientationIsLandscape(self.orientation) ? MAX(frameWidth, frameHeight) : MIN(frameWidth, frameHeight);
        topOrBottom = 0;
        leftOrRight = 0;
    }
    
    [self drawScanLineInRect:rect];
}

/**
 *  画除扫描线之外的边框, 及背景遮罩
 *
 *  @param rect 需要画的区域, 一般为自drawRect的参数rect
 */
- (void)drawAroundInRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置填充背景颜色
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:100/255. green:100/255. blue:100/255. alpha:0.7].CGColor);
    
    CGRect clips[] =
    {
        CGRectMake(0, 0, frameWidth, topOrBottom),
        CGRectMake(0, frameHeight - topOrBottom, frameWidth, topOrBottom),
        CGRectMake(0, topOrBottom, leftOrRight, frameHeight - 2*topOrBottom),
        CGRectMake(frameWidth - leftOrRight, topOrBottom, leftOrRight, frameHeight - 2*topOrBottom)
    };
    
    // 画绿色线框
    CGContextSetStrokeColorWithColor(context, self.scanRectBorderColor.CGColor);
    // 设置线宽
    CGContextSetLineWidth(context, self.scanRectBorderLineWidth);
    // 添加矩形路径, 然后勾画
    CGContextAddRect(context, CGRectMake(leftOrRight, topOrBottom, scanRectWidth, scanRectWidth));
    CGContextStrokePath(context);
    
    // 切割中心的透明区域
    CGContextClipToRects(context, clips, sizeof(clips) / sizeof(clips[0]));
    CGContextFillRect(context, rect);
}

/**
 *  添加扫描线
 *
 *  @param rect 需要画的区域, 一般继承自drawRect的参数rect
 */
- (void)drawScanLineInRect:(CGRect)rect{
    // 重画时先清除
    [scanLine removeFromSuperview];
    
    if (!scanLine) {
        scanLine = [[UIImageView alloc] init];
    }
    
    scanLine.frame = CGRectMake(leftOrRight, topOrBottom, self.scanLineLength, self.scanLineWidth);
    
    UIGraphicsBeginImageContext(scanLine.frame.size);
    [scanLine.image drawInRect:CGRectMake(0, 0, scanLine.frame.size.width, scanLine.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), scanLine.frame.size.height);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.scanLineColor.CGColor);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, 0);  //起点坐标
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), scanLine.frame.size.width, scanLine.frame.size.height);   //终点坐标
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    scanLine.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self addSubview:scanLine];
    
    [UIView animateWithDuration:1.5
                          delay:0
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         scanLine.frame = CGRectMake(leftOrRight, frameHeight - topOrBottom, self.scanLineLength, self.scanLineWidth);
                     }
                     completion:nil];
}

@end
