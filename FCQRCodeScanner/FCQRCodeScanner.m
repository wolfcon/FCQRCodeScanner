//
//  FCQRCodeScanner.m
// 
//
//  Created by Frank on 5/18/15.
//
//


#import "FCQRCodeScanner.h"

@interface FCQRCodeScanner (){
    /**
     *  是否正在读取
     */
    BOOL isReading;
    AVCaptureSession *captureSession;
    AVCaptureMetadataOutput *captureMetadataOutput;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    
    AVAudioPlayer *audioPlayer;
}

@end

#pragma mark -

@implementation FCQRCodeScanner

+ (instancetype)scannerWithDelegate:(id<FCQRCodeScannerDelegate>)aDelegate{
    return [[FCQRCodeScanner alloc] initWithDelegate:aDelegate];
}

- (instancetype)initWithDelegate:(id<FCQRCodeScannerDelegate>)aDelegate{
    self = [super init];
    if (self) {
        // 闪光灯默认不打开
        // Flashlight is off by default.
        self.torchOn = NO;
        
        _delegate = aDelegate;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    isReading = NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//    
//    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
//    
//    // 计算旋转度数
//    // Calculate the angle
//    CGFloat angle;
//    switch (deviceOrientation) {
//        case UIDeviceOrientationPortraitUpsideDown:
//            angle = M_PI;
//            break;
//        case UIDeviceOrientationLandscapeLeft:
//            angle = M_PI_2;
//            break;
//        case UIDeviceOrientationLandscapeRight:
//            angle = - M_PI_2;
//            break;
//        default:
//            angle = 0;
//            break;
//    }
//    
//    
//    
//    // 重画遮罩界面(Redraw the mask view)(View的ContentMode设为redraw)
//    CGRect frame = self.view.frame;
//    frame.size = size;
//    _maskView.frame = frame;
//}

/**
 *  读取数据
 *  read data
 *
 *  @return 是否成功启动读取设备(start succeed or not.)
 */
- (BOOL)startReading{
    isReading = YES;
    
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        
        return NO;
    }
    
    captureSession = [[AVCaptureSession alloc] init];
    [captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    if ([captureSession canAddInput:captureDeviceInput]) {
        [captureSession addInput:captureDeviceInput];
    }
    
    if ([captureSession canAddOutput:captureMetadataOutput]) {
        [captureSession addOutput:captureMetadataOutput];
    }
    
    dispatch_queue_t dispatchQueue = dispatch_queue_create("outputQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    // 这里可以添加其他的类型
    // may add other types if you need.
    [captureMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    [captureVideoPreviewLayer setFrame:self.view.frame];
    
    // 初始化遮罩
    // initialize mask
    _maskView = [FCMaskView maskViewWithFrame:self.view.frame];
    
    [self.view.layer addSublayer:captureVideoPreviewLayer];
    [self.view addSubview:_maskView];
    
    [self.view bringSubviewToFront:_btnCancel];
    [self.view bringSubviewToFront:_btnTorch];
    
    [captureSession startRunning];
    
    return YES;
}


/**
 *  停止读取数据
 *  stop reading data
 */
- (void)stopReading{
    [captureSession stopRunning];
    captureSession = nil;
}

/**
 *  关闭扫描界面(包括停止读取数据, 调用委托)
 *  stop reading data and call the delegation to close this view
 */
- (void)close {
    [self stopReading];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(close)]) {
        [self.delegate performSelector:@selector(close)];
    }
}

/**
 *  二维码扫描结束后播放声音
 *  If scan is over, play a beep sound.
 */
-(void)loadBeepSound{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        [audioPlayer play];
    }
}

/**
 *  闪光灯开关, 打开还是关闭
 *  Flashlight switch, on/off
 *
 *  @param on 打开状态(turn on/ off)
 */
- (void)torchSwitch:(BOOL)on{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        
        [device setTorchMode:(on ? AVCaptureTorchModeOn : AVCaptureTorchModeOff)];
        
        [device unlockForConfiguration];
    }
}
#pragma mark <<< Button Event >>>
/**
 *  取消捕捉的按钮按下的方法
 *  Button event for X button
 *
 *  @param sender 按钮(X button)
 */
- (IBAction)btnCancelTouchUpInside:(id)sender{
    [self close];
}

/**
 *  闪光灯按钮按下的方法
 *  Flashlight event for on/off
 *
 *  @param sender 闪光灯按钮(flashlight button)
 */
- (IBAction)btnTorchSwitchTouchUpInside:(id)sender{
    // 如果开关关闭, 则打开, 打开, 则关闭
    // If the switch on, turn off. Otherwise, turn on.
    self.torchOn = self.torchOn ? NO : YES;
    
    [self torchSwitch:self.torchOn];
}

#pragma mark - <<< AVCaptureMetadataOutputObjectsDelegate >>>
/**
 *  AVCaptureMetadataOutputObjectsDelegate委托函数, 用于获取到捕捉的数据
 *
 *  @param captureOutput   捕捉的输出
 *  @param metadataObjects 扫描到的数据
 *  @param connection      捕捉的连接
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //判断是否正在读取
    if (!isReading) {
        return;
    }
    
    //判断metadata不为空
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断读取到的对象类型是QR码
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSLog(@"-------扫描结果为:%@", metadataObj);
            
            //获取二维码的委托方法
            if (_delegate && [_delegate respondsToSelector:@selector(getQRCodeWithString:)]) {
                [_delegate performSelector:@selector(getQRCodeWithString:) withObject:metadataObj.stringValue];
            }
            
            if (_delegate && [_delegate respondsToSelector:@selector(getQRCodeWithAVMetadataMachineReadableCodeObject:)]) {
                [_delegate performSelector:@selector(getQRCodeWithAVMetadataMachineReadableCodeObject:) withObject:metadataObj];
            }
            
            [self loadBeepSound];
            isReading = NO;
            
            [self stopReading];
        }
    }
}


@end
