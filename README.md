# FCQRCodeScanner

[![Build Status](https://travis-ci.org/wolfcon/FCQRCodeScanner.svg)](https://travis-ci.org/wolfcon/FCQRCodeScanner)

Simple QRcode Scanner & Generator(Apple API) 

## Support platform

iOS 7.0 for common function.

iOS 8.0 for local picture decode.<font color=#990000>*[And device limitation: iPhone 5S above device support this function(include 5S)]*</font>

## Installation

- Drag FCQRCodeScanner folder to your project.
  
- <font color=#FF0000>(not available now)</font>*~~CocoaPod:~~* 
  
  *~~add `pod 'FCQRCodeScanner', '~>0.1.0'`~~*

## Usage

#### Scan



- ``` objective-c
  #import "FCQRCodeScanner.h"
  ```
  
- ``` objective-c
  FCQRCodeScanner *scanner = [FCQRCodeScanner scannerWithFrame:self.view.frame
                                  completion:^(NSString *codeString) {
  									// Do something when get a code
                                    	// you can do continue scan by [scanner startReading];
                                    	// or you can use code and close scan view by [scanner close];
                                  }
                                  dismissedAction:^{
                                  	// Do something after scan view exit
                                    	// Close button clicked event will trigger this block
                                    	// For example [scanner.view removeFromSuperview];
                                  }];
  ```
  
- Add the scan view
  
  ``` objective-c
  [self.view addSubview:scanner.view];
  // or you can use any other way
  // present or transition
  ```
  
- Close the scan view
  
  ``` objective-c
  [scanner close]; // this function will trigger dismissedAction block.
  ```



#### Generate



- ``` objective-c
  #import "NSString+FCQRCodeGenerator.h"
  ```
  
- ``` objective-c
  // string is what you wanna generate from
  // image is QRCode Avatar that you wanna add
  UIImage *myQRCodeImage = [string qRImageWithSize:200]; 
  // or
  UIImage *myQRCodeImageWithAvatar = [string qRImageWithSize:200 avatar:image];
  ```



#### Decode a QRImage from local storage.



- ``` objective-c
  #import "UIImage+Decode.h"
  ```
  
- ``` objective-c
  // image is what you wanna decode from local storage.
  NSString *codeString = [image decodeWithQRCodeType];
  // iPhone 5S above device support this function(include 5S)
  ```



## License

Under the MIT License.