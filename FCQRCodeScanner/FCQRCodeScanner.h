//
//  FCQRCodeScanner.h
//
//
//  Created by Frank on 5/18/15.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FCMaskView.h"

@protocol FCQRCodeScannerDelegate <NSObject>
@optional
/**
 *  获取二维码扫描值的委托函数
 *  @param aString 二维码返回的字符串
 */
- (void)getQRCodeWithString:(NSString *)aString;

/**
 *  关闭二维码扫描界面的委托函数
 */
- (void)close;

/**
 *  获取二维码扫描值的委托函数
 *  @param aVMetadataMachineReadableCodeObj 二维码返回值的机器码对象, 一般使用stringValue解析有用字符
 */
- (void)getQRCodeWithAVMetadataMachineReadableCodeObject:(AVMetadataMachineReadableCodeObject *)aAVMetadataMachineReadableCodeObj;

@end

/**
 *  二维码扫描界面, 需要实现以下可选委托(如果要获取扫描值, 请至少实现getQRCodeWith其中之一)
 *
 *  关闭二维码扫描界面的委托函数
 *  - (void)close;
 *
 *  获取二维码扫描值的委托函数
 *  <1> - (void)getQRCodeWithString:(NSString *)aString;
 *  <2> - (void)getQRCodeWithAVMetadataMachineReadableCodeObject:(AVMetadataMachineReadableCodeObject *)aAVMetadataMachineReadableCodeObj;
 */
@interface FCQRCodeScanner : UIViewController<AVCaptureMetadataOutputObjectsDelegate>{
}

/**
 *  扫描委托
 *  delegate
 */
@property (nonatomic, assign) id <FCQRCodeScannerDelegate> delegate;

/**
 *  遮罩界面
 *  mask view
 */
@property (nonatomic, strong) FCMaskView *maskView;

/**
 *  LED灯的开关状态
 *  flashlight state
 */
@property (nonatomic, assign) BOOL torchOn;

/**
 *  关闭按钮
 *  cancel button
 */
@property (nonatomic, weak) IBOutlet UIButton *btnCancel;

/**
 *  LED灯按钮
 *  flashligh switch button
 */
@property (nonatomic, weak) IBOutlet UIButton *btnTorch;

/**
 *  传递委托并初始化
 *  initialize the class with delegate
 *
 *  @param aDelegate 委托
 *
 *  @return FCQRCodeScanner实例化对象(instance)
 */
+ (instancetype)scannerWithDelegate:(id <FCQRCodeScannerDelegate>)aDelegate;

/**
 *  开始二维码扫描读取
 *  begin to read
 */
- (BOOL)startReading;

@end
