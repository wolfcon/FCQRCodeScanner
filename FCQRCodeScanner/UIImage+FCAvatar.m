//
//  UIImage+Avatar.m
//  
//
//  Created by Frank on 10/26/15.
//  Copyright © 2015 Frank. All rights reserved.
//

#import "UIImage+FCAvatar.h"

@implementation UIImage (FCAvatar)

- (UIImage *)imageWithAvatar:(UIImage *)avatar inCenterSize:(CGSize)size {
    UIGraphicsBeginImageContext(self.size);
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [avatar drawInRect:CGRectMake((self.size.width - size.width) / 2., (self.size.height - size.height) / 2., size.width, size.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
