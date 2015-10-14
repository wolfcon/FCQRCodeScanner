//
//  ViewController.m
//  FCCodeScannerDemo
//
//  Created by Frank on 10/13/15.
//  Copyright © 2015 Frank. All rights reserved.
//

#import "ViewController.h"
#import "FCMaskView.h"


@interface ViewController ()

@end

@implementation ViewController



- (IBAction)btnScanTouchUpInside:(id)sender{
    FCQRCodeScanner *scanner = [FCQRCodeScanner scannerWithDelegate:self];
    
    [self presentViewController:scanner animated:YES completion:^{
        [scanner startReading];
    }];
}

#pragma  <<< ||| FCQRCodeDelegate ||| >>>

- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getQRCodeWithString:(NSString *)aString{
    [self close];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"QRCode is: " message:aString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
