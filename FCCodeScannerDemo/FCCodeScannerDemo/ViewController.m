//
//  ViewController.m
//  FCCodeScannerDemo
//
//  Created by Frank on 10/13/15.
//  Copyright © 2015 Frank. All rights reserved.
//

#import "ViewController.h"
#import "FCMaskView.h"


@interface ViewController (){
    FCQRCodeScanner *scanner;
    
    IBOutlet UIImageView *imageViewQRCode;
}

@end

@implementation ViewController

- (IBAction)btnDecodeFromLibraryTouchUpinside:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    imagePickerController.delegate = self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (NSString *)decodeImage:(UIImage *)image{
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];

    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    
    CIQRCodeFeature *f = [features firstObject];
    
    return f.messageString;
}

- (IBAction)btnDecodeTouchUpinside:(id)sender {
    NSString *message = [self decodeImage:imageViewQRCode.image];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"QRCode is: " message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btnScanTouchUpInside:(id)sender{
    scanner = [FCQRCodeScanner scannerWithDelegate:self frame:self.view.frame];

    [self presentViewController:scanner animated:YES completion:nil];
}

#pragma mark  <<< ||| FCQRCodeDelegate ||| >>>

- (void)close{
//    [scanner.view removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getQRCodeWithString:(NSString *)aString{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"QRCode is: " message:aString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [scanner startReading];
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark  <<< ||| UIImagePickerControllerDelegate ||| >>>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (![self decodeImage:image]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"sorry, can't decode this image!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
