//
//  CVWrapper.m
//  CVOpenTemplate
//
//  Created by Washe on 02/01/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import "CVWrapper.h"
#import "UIImage+OpenCV.h"
#import "include/colorcorrection.h"
#import "include/contrastenhancement.h"

@implementation CVWrapper


+ (nullable UIImage*) processWithImages:(UIImage*)image error:(NSError**)error;
{
    cv::Mat matImage = [image CVMat3];
    matImage = GWA_RGB(matImage);
    matImage = ICM(matImage, 0.5);
    UIImage* result =  [UIImage imageWithCVMat: matImage];
    return result;
}


@end
