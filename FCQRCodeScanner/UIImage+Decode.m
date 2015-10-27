//
//  UIImage+Decode.m
//  
//
//  Created by Frank on 10/27/15.
//  Copyright © 2015 Frank. All rights reserved.
//

#import "UIImage+Decode.h"

@implementation UIImage (Decode)

- (NSString *)decodeWithQRCodeType {
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:[CIContext contextWithOptions:nil] options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];// iOS 8 以上, iPhone 5S以上(包括)设备才能正常识别
    
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:self.CGImage]];
    
    CIQRCodeFeature *feature = [features firstObject];
    
    return feature.messageString;
}


@end
