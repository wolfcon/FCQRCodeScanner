//
//  AVAudioPlayer+FCPlayFile.m
//  
//
//  Created by Frank on 10/21/15.
//  Copyright © 2015 Frank. All rights reserved.
//

#import "AVAudioPlayer+FCPlayFile.h"

@implementation AVAudioPlayer (FCPlayFile)


+ (void)playSoundFromMainBundleWithName:(NSString *)name type:(NSString *)type {
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        [audioPlayer play];
    }
}

+ (void)playBeepSound {
    [AVAudioPlayer playSoundFromMainBundleWithName:@"beep" type:@"mp3"];
}

@end
