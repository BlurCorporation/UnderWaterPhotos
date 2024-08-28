//
//  UIImage+OpenCV.mm
//  OpenCVClient
//
//  Created by Washe on 01/12/2012.
//  Copyright 2012 Washe / Foundry. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//
//  adapted from
//  http://docs.opencv.org/doc/tutorials/ios/image_manipulation/image_manipulation.html#opencviosimagemanipulation

#import "UIImage+OpenCV.h"


@implementation UIImage (OpenCV)

- (UIImage *)normalizedImage {
    if (self.imageOrientation == UIImageOrientationUp) return self;

    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

-(cv::Mat)CVMat
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(self.CGImage);
    CGFloat cols = self.size.width;
    CGFloat rows = self.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

- (cv::Mat)CVMat3
{
    cv::Mat result = [self CVMat];
    cv::cvtColor(result , result , cv::COLOR_RGBA2RGB);
    return result;

}

-(cv::Mat)CVGrayscaleMat
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGFloat cols = self.size.width;
    CGFloat rows = self.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat orientation:(UIImageOrientation)orientation
{
    return [[UIImage alloc] initWithCVMat:cvMat orientation:orientation];
}

//- (id)initWithCVMat:(const cv::Mat&)cvMat orientation:(UIImageOrientation)orientation
//{
//    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
//    CGColorSpaceRef colorSpace;
//    
//    if (cvMat.elemSize() == 1) {
//        colorSpace = CGColorSpaceCreateDeviceGray();
//    } else {
//        colorSpace = CGColorSpaceCreateDeviceRGB();
//    }
//    
//    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
//        // Creating CGImage from cv::Mat
//    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
//                                        cvMat.rows,                                 //height
//                                        8,                                          //bits per component
//                                        8 * cvMat.elemSize(),                       //bits per pixel
//                                        cvMat.step[0],                              //bytesPerRow
//                                        colorSpace,                                 //colorspace
//                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
//                                        provider,                                   //CGDataProviderRef
//                                        NULL,                                       //decode
//                                        false,                                      //should interpolate
//                                        kCGRenderingIntentDefault                   //intent
//                                        );                     
//    
//        // Getting UIImage from CGImage
//    self = [self initWithCGImage:imageRef scale: 1.0 orientation: orientation];
//    CGImageRelease(imageRef);
//    CGDataProviderRelease(provider);
//    CGColorSpaceRelease(colorSpace);
//    
//    return self;
//}

- (id)initWithCVMat:(const cv::Mat&)cvMat orientation:(UIImageOrientation)orientation
{
//	NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
	NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.step.p[0]*cvMat.rows];
	CGColorSpaceRef colorSpace;
	CGBitmapInfo bitmapInfo;

	if (cvMat.elemSize() == 1) {
		  colorSpace = CGColorSpaceCreateDeviceGray();
		  bitmapInfo = kCGImageAlphaNone | kCGBitmapByteOrderDefault;
	  } else {
		  colorSpace = CGColorSpaceCreateDeviceRGB();
		  bitmapInfo = kCGBitmapByteOrder32Little | (
			  cvMat.elemSize() == 3? kCGImageAlphaNone : kCGImageAlphaNoneSkipFirst
		  );
	  }
	
	CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
		// Creating CGImage from cv::Mat
	CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
										cvMat.rows,                                 //height
										8,                                          //bits per component
										8 * cvMat.elemSize(),                       //bits per pixel
										cvMat.step[0],                              //bytesPerRow
										colorSpace,                                 //colorspace
										kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
										provider,                                   //CGDataProviderRef
										NULL,                                       //decode
										false,                                      //should interpolate
										kCGRenderingIntentDefault                   //intent
										);
	
		// Getting UIImage from CGImage
	self = [self initWithCGImage:imageRef scale: 1.0 orientation: orientation];
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGColorSpaceRelease(colorSpace);
	
	return self;
}




@end
