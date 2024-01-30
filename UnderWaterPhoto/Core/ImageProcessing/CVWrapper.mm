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
#import "include/videoenhancement.h"
#import <Foundation/Foundation.h>
#import "FramesOfProcessedVideo.h"

@implementation CVWrapper


+ (nullable UIImage*) processWithImages:(UIImage*)image error:(NSError**)error;
{
    cv::Mat matImage = [image CVMat3];
    matImage = GWA_RGB(matImage);
    matImage = ICM(matImage, 0.5);
    UIImage* result =  [UIImage imageWithCVMat: matImage];
    return result;
}

//+ (nullable NSMutableArray *)processWithVideos:(nonnull NSString *)video error:(NSError *__autoreleasing  _Nullable * _Nullable)error {
//    std::cout << cv::getBuildInformation() << std::endl;
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"testVideo" ofType:@"MP4"];
//    std::string InputFile = [filePath UTF8String];
//    std::cout << InputFile << std::endl;
//    std::size_t filename;
//    if (InputFile.find('.') != std::string::npos) filename = InputFile.find_last_of('.');
//    std::string ext_out = ".avi";
//    std::string OutputFile = InputFile.substr(0, filename);
//    OutputFile.insert(filename, ext_out);
//
//    cv::VideoCapture cap(InputFile);
//    if (!cap.isOpened()) {
//        std::cerr << "Error opening video file." << std::endl;
//    }
//    
//    int width = static_cast<int>(cap.get(CAP_PROP_FRAME_WIDTH));
//    int height = static_cast<int>(cap.get(CAP_PROP_FRAME_HEIGHT));
//    int n_frames = int(cap.get(CAP_PROP_FRAME_COUNT));
//    double FPS = cap.get(CAP_PROP_FPS);
//    std::cout << "Width: " << width << " Height: " << height << " n_frames: " << n_frames << " FPS: " << FPS << std::endl;
//    
//    cv::VideoWriter outt(OutputFile,cv::VideoWriter::fourcc('D', 'I', 'V', 'X'), FPS, cv::Size(width, height));
//    
//    std::string ext_comp = "_comp.avi";
//    std::string Comparison = InputFile.substr(0, filename);
//    Comparison.insert(filename, ext_comp);
//    std::cout << Comparison << std::endl;
//    cv::VideoWriter comp(Comparison, cv::VideoWriter::fourcc('D', 'I', 'V', 'X'), FPS, cv::Size(2 * width, height));
//    std::cout << comp.isOpened() << std::endl;
//    cv::Mat image, image_out, comparison, top;
//    vector<cv::Mat> frames;
//    cv::Mat sum(cv::Size(width, height), CV_32FC3, Scalar());
//    cv::Mat avgImg(cv::Size(width, height), CV_32FC3, Scalar());
//    vector<Mat_<uchar>> channels;
//
//    int i = 0, j = 0;
//    float n;
//    if (n_frames / FPS < 7) n = n_frames / FPS * 0.5;
//    else n = FPS * 7;
//    
//    NSMutableArray *images = [[NSMutableArray alloc] init];
//    NSMutableArray *images1 = [[NSMutableArray alloc] init];
//    
//    for (i = 0; i < n_frames - 1; i++) {
//        cap >> image;
//        image_out = colorcorrection(image);
//        outt << image_out;
//        [images addObject:[UIImage imageWithCVMat:image_out]];
//    }
//    
//    NSLog(@"%d", [images count]);
//    return images;
//}

+ (nullable FramesOfProcessedVideo *)processWithVideos:(nonnull NSString *)video error:(NSError *__autoreleasing  _Nullable * _Nullable)error {
    std::cout << cv::getBuildInformation() << std::endl;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"testVideo" ofType:@"MP4"];
    std::string InputFile = [filePath UTF8String];
    std::cout << InputFile << std::endl;
    std::size_t filename;
    if (InputFile.find('.') != std::string::npos) filename = InputFile.find_last_of('.');
    std::string ext_out = ".avi";
    std::string OutputFile = InputFile.substr(0, filename);
    OutputFile.insert(filename, ext_out);

    cv::VideoCapture cap(InputFile);
    if (!cap.isOpened()) {
        std::cerr << "Error opening video file." << std::endl;
    }
    
    int width = static_cast<int>(cap.get(CAP_PROP_FRAME_WIDTH));
    int height = static_cast<int>(cap.get(CAP_PROP_FRAME_HEIGHT));
    int n_frames = int(cap.get(CAP_PROP_FRAME_COUNT));
    double FPS = cap.get(CAP_PROP_FPS);
    std::cout << "Width: " << width << " Height: " << height << " n_frames: " << n_frames << " FPS: " << FPS << std::endl;
    
    cv::VideoWriter outt(OutputFile,cv::VideoWriter::fourcc('D', 'I', 'V', 'X'), FPS, cv::Size(width, height));
    
    std::string ext_comp = "_comp.avi";
    std::string Comparison = InputFile.substr(0, filename);
    Comparison.insert(filename, ext_comp);
    std::cout << Comparison << std::endl;
    cv::VideoWriter comp(Comparison, cv::VideoWriter::fourcc('D', 'I', 'V', 'X'), FPS, cv::Size(2 * width, height));
    std::cout << comp.isOpened() << std::endl;
    cv::Mat image, image_out, comparison, top;
    vector<cv::Mat> frames;
    cv::Mat sum(cv::Size(width, height), CV_32FC3, Scalar());
    cv::Mat avgImg(cv::Size(width, height), CV_32FC3, Scalar());
    vector<Mat_<uchar>> channels;

    int i = 0, j = 0;
    float n;
    if (n_frames / FPS < 7) n = n_frames / FPS * 0.5;
    else n = FPS * 7;
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSMutableArray *images1 = [[NSMutableArray alloc] init];
    
    for (i = 0; i < n_frames - 1; i++) {
        cap >> image;
        image_out = colorcorrection(image);
        outt << image_out;
        [images addObject:[UIImage imageWithCVMat:image_out]];
    }
    
    NSLog(@"%d", [images count]);
    
    FramesOfProcessedVideo *result = [[FramesOfProcessedVideo alloc] initWithImages:images frames:FPS];
    return result;
}

@end
