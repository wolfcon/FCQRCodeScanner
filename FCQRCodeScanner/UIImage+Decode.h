//
//  UIImage+Decode.h
//  
//
//  Created by Frank on 10/27/15.
//  Copyright © 2015 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Decode)

/**
 *  使用CIDetector进行二维码的解码
 *
 *  @return 已破解的编码
 */
- (NSString *)decodeWithQRCodeType NS_AVAILABLE_IOS(8_0);

@end
