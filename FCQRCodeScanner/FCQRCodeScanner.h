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
 *  二维码扫描界面(可以自定义按钮(背灯, 关闭等)和其他的xib内容)
 *
 *  关闭二维码扫描界面调用
 *  - (void)close;
 *
 *  扫描完成后继续开始可以调用
 *  - (void)startReading;
 *  
 *  从实例化对象的completionBlock处可以获取到扫描的二维码值
 *
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
 *  Initialize the class with view frame, completion block and dismissedAction block.
 *
 *  @param frame           self.view.frame
 *  @param completion      扫描到二维码后执行的block, 扫描后得到的code将作为block参数, 如果不关闭则可以执行[instance startReading];再次读取, 如果想关闭界面则调用[instance close];
 *  @param dismissedAction (使用[instance close]方法后会执行该block)关闭扫描界面时执行的block, 一般随加载的方式而选用关闭的执行方法, 譬如, present对应dismiss, addSubview对应remove, 还可以使用transition
 *
 *  @return FCQRCodeScanner实例化对象(instance)
 */
+ (instancetype)scannerWithFrame:(CGRect)frame completion:(void (^)(NSString *codeString))completion dismissedAction:(void (^)(void))dismissedAction NS_AVAILABLE_IOS(7_0);

/** 开始二维码扫描读取 begin to read */
- (void)startReading;

/** 关闭页面调用的方法 */
- (void)close;

@end
