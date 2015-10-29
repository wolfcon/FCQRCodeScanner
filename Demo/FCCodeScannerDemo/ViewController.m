//
//  ViewController.m
//  FCCodeScannerDemo
//
//  Created by Frank on 10/13/15.
//  Copyright © 2015 Frank. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+FCDecode.h"
#import "NSString+FCQRCodeGenerator.h"


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

- (IBAction)btnGenerateTouchUpInside:(id)sender {
    imageViewQRCode.image = [@"dont see me!" qRImageWithSize:240 avatar:[UIImage imageNamed:@"11"]];
}

- (IBAction)btnDecodeTouchUpinside:(id)sender {
    NSString *message = [imageViewQRCode.image decodeWithQRCodeType];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"QRCode is: " message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btnScanTouchUpInside:(id)sender{
    __weak typeof(self) weakSelf = self;
    scanner = [FCQRCodeScanner scannerWithFrame:self.view.frame
                                     completion:^(NSString *codeString) {
                                         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"QRCode is: " message:codeString preferredStyle:UIAlertControllerStyleAlert];
                                         
                                         UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                                             [scanner startReading];
                                         }];
                                         
                                         [alert addAction:action];
                                         
                                         [weakSelf presentViewController:alert animated:YES completion:nil];
                                     }
                                dismissedAction:^{
                                    [scanner.view removeFromSuperview];
                                }];
    
    [self.view addSubview:scanner.view];
}

#pragma mark  <<< ||| UIImagePickerControllerDelegate ||| >>>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // decode it after selected.
    [self dismissViewControllerAnimated:YES completion:^{
        if (![image decodeWithQRCodeType]) {
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
