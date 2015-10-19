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

/** 遮罩界面 mask view */
@property (nonatomic, strong) FCMaskView *maskView;

/** LED灯的开关状态 flashlight state */
@property (nonatomic, assign) BOOL torchOn;

/** 关闭按钮 cancel button */
@property (nonatomic, weak) IBOutlet UIButton *btnCancel;

/** LED灯按钮 flashligh switch button */
@property (nonatomic, weak) IBOutlet UIButton *btnTorch;

/**
 *  传递委托和遮罩界面尺寸并初始化
 *  initialize the class with delegate
 *
 *  @param aDelegate   委托
 *  @param aFrame       初始化遮罩界面用
 *
 *  @return FCQRCodeSca∫nner实例化对象(instance)
 */
+ (instancetype)scannerWithFrame:(CGRect)frame completion:(void (^)(NSString *codeString))completion dismissedAction:(void (^)(void))dismissedAction;

/** 开始二维码扫描读取 begin to read */
- (void)startReading;

/** 关闭页面调用的方法 */
- (void)close;

@end
