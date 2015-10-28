//
//  NSString+FCQRCodeGenerator.m
//
//
//  Created by Frank on 10/27/15.
//  Copyright © 2015 Frank. All rights reserved.
//

#import "NSString+FCQRCodeGenerator.h"
#import "UIImage+FCAvatar.h"

@implementation NSString (FCQRCodeGenerator)

- (CIImage *)cIImageWithQRCodeType {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator" keysAndValues:@"inputMessage", data,
                        @"inputCorrectionLevel", @"H", nil];  //L: 7% M: 15% Q: 25% H: 30%,
    
    return filter.outputImage;
}


- (UIImage *)qRImageWithSize:(NSUInteger)size NS_AVAILABLE_IOS(7_0) {
	return [self qRImageWithSize:size avatar:nil];
}

- (UIImage *)qRImageWithSize:(NSUInteger)size avatar:(UIImage *)avatar NS_AVAILABLE_IOS(7_0) {
    CIImage *aCIImage = [self cIImageWithQRCodeType];
    
    CGRect extent = aCIImage.extent;
    CGFloat rate = size / extent.size.width; // 计算比率, 用于放大
    
    // 颜色空间创建 (记得release)
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    // 创建Bitmap (记得release)
    CGContextRef contextRef = CGBitmapContextCreate(nil, size, size, 8, 0, colorSpaceRef, kCGImageAlphaNone);
    
    // 生成原始的二维码图像CGImageRef (记得release), 原始小图形
    CGImageRef bitmapImage = [[CIContext contextWithOptions:nil] createCGImage:aCIImage fromRect:extent];
    
    // 放大图形, 画在画布上(按照比率)
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationNone);
    CGContextScaleCTM(contextRef, rate, rate);
    CGContextDrawImage(contextRef, aCIImage.extent, bitmapImage);
    
    // 根据画布生成放大后的二维码图像CGImageRef (记得release)
    CGImageRef scaledImage = CGBitmapContextCreateImage(contextRef);
    
    UIImage *image = [UIImage imageWithCGImage:scaledImage];
    
    // 如果小图标实例不为空, 则添加图形的1/6大小的小图标
    if (avatar != nil) {
        image = [image imageWithAvatar:avatar inCenterSize:CGSizeMake(image.size.width/6., image.size.height/6.)];
    }
    
    CGImageRelease(scaledImage);
    CGImageRelease(bitmapImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpaceRef);
    
    return image;
}
@end
