//
//  AVAudioPlayer+FCPlayFile.h
//  
//
//  Created by Frank on 10/21/15.
//  Copyright © 2015 Frank. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAudioPlayer (FCPlayFile)

/**
 *  播放MainBundle中的声音 play a beep sound.
 *
 *  @param name 文件名
 *  @param type 文件类型
 */
+ (void)playSoundFromMainBundleWithName:(NSString *)name type:(NSString *)type;

/** 播放滴的声音 play a beep sound. */
+ (void)playBeepSound;

@end
