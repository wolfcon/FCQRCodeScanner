//
//  FCQRCodeScanner.m
// 
//
//  Created by Frank on 5/18/15.
//
//


#import "FCQRCodeScanner.h"
#import "AVAudioPlayer+FCPlayFile.h"

@interface FCQRCodeScanner (){
    /** 是否正在读取 */
    BOOL isReading;
    AVCaptureSession *captureSession;
    AVCaptureMetadataOutput *captureMetadataOutput;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    
    IBOutlet UIView *subView;
    
    /** 初始化遮罩界面以及扫描界面时用到 used for mask view and scan layer */
    CGRect superFrame;
    
    /** 无权访问相机的警告信息 warning Label for no access to camara*/
    IBOutlet UILabel *lblWarning;
}

@property (copy) void (^completion)(NSString *codeString, FCQRCodeScanner *instance);

@property (copy) void (^dismissedAction)(FCQRCodeScanner *instance);

@end

#pragma mark -

@implementation FCQRCodeScanner


+ (instancetype)scannerWithFrame:(CGRect)frame completion:(void (^)(NSString *, FCQRCodeScanner *))completion dismissedAction:(void (^)(FCQRCodeScanner *))dismissedAction {
    return [[FCQRCodeScanner alloc] initWithFrame:frame completion:completion dismissedAction:dismissedAction];
}

- (instancetype)initWithFrame:(CGRect)frame completion:(void (^)(NSString *, FCQRCodeScanner *))completion dismissedAction:(void (^)(FCQRCodeScanner *))dismissedAction {
    self = [super init];
    if (self) {
        // 闪光灯默认不打开
        // Flashlight is off by default.
        _torchOn = NO;
        
        superFrame = frame;
        
        _completion = completion;
        _dismissedAction = dismissedAction;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    isReading = NO;
    
    [self loadCaptureSession];
    self.view.frame = superFrame;
}

/**
 *  检查摄像头的授权信息
 *
 *  @return 是否拥有授权
 */
- (BOOL)camaraAllowed{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return (AVAuthorizationStatusAuthorized == status);
}

- (BOOL)loadCaptureSession{
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //根据拥有授权动态隐藏信息
    lblWarning.hidden = [self camaraAllowed] ? YES : NO;
    
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
    
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 这里可以添加其他的类型
    // may add other types if you need.
    [captureMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    // 初始化遮罩
    // initialize mask
    _maskView = [FCMaskView maskViewWithFrame:superFrame];
    [captureVideoPreviewLayer setFrame:superFrame];
    
    [subView.layer addSublayer:captureVideoPreviewLayer];
    [subView addSubview:_maskView];
    
    [self startReading];
    [captureSession startRunning];
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_maskView letScanLineMove];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillEnterForeground{
    [_maskView letScanLineMove];
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

/** 读取数据 read data */
- (void)startReading{
    isReading = YES;
}


/**停止读取数据 stop reading data */
- (void)stopReading{
    isReading = NO;
}

/** 关闭扫描界面(包括停止读取数据, 调用委托) stop reading data and call the delegation to close this view */
- (void)close {
    [self stopReading];
    [captureSession stopRunning];
    
    _dismissedAction(self);
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
/** 取消捕捉的按钮按下的方法 Button event for X button */
- (IBAction)btnCancelTouchUpInside:(id)sender{
    [self close];
}

/** 闪光灯按钮按下的方法 Flashlight event for on/off */
- (IBAction)btnTorchSwitchTouchUpInside:(id)sender{
    // 如果开关关闭, 则打开, 打开, 则关闭
    // If the switch on, turn off. Otherwise, turn on.
    _torchOn = _torchOn ? NO : YES;
    
    [self torchSwitch:self.torchOn];
}

- (IBAction)btnChooseImageFromLibraryTouchUpInside:(id)sender{
    
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
            [self stopReading];
            [AVAudioPlayer playBeepSound];
            
            _completion(metadataObj.stringValue, self);
        }
    }
}


@end
