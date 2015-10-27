//
//  NSString+FCQRCodeGenerator.h
//  
//
//  Created by Frank on 10/27/15.
//  Copyright © 2015 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (FCQRCodeGenerator)

/**
 *  根据图片尺寸和字符返回一个二维码图片
 *
 *  @param size   图片尺寸
 *
 *  @return 二维码图片
 */

- (UIImage *)qRImageWithSize:(NSUInteger)size NS_AVAILABLE_IOS(7_0);


/**
 *  根据图片尺寸和徽标返回一个二维码图片
 *
 *  @param size   图片尺寸
 *  @param avatar 徽标图片
 *
 *  @return 二维码图片
 */
- (UIImage *)qRImageWithSize:(NSUInteger)size avatar:(UIImage *)avatar NS_AVAILABLE_IOS(7_0);

@end
