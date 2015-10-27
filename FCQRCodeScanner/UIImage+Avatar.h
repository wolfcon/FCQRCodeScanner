//
//  UIImage+Avatar.h
//  
//
//  Created by Frank on 10/26/15.
//  Copyright © 2015 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Avatar)

/**
 *  将小图标添加到目标图片中间
 *
 *  @param avatar 小图标UIImage实例
 *  @param size   小图标放置后的尺寸
 *
 *  @return 添加了小图标的目标图片
 */
- (UIImage *)imageWithAvatar:(UIImage *)avatar inCenterSize:(CGSize)size;

@end
