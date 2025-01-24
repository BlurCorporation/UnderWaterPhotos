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
#import "AVFoundation/AVFoundation.h"
#import <opencv2/imgcodecs/ios.h>

@implementation CVWrapper

+ (nullable UIImage*) processWithImages:(UIImage*)image error:(NSError**)error;
{
    UIImage* image1 = [image normalizedImage];
    cv::Mat matImage = [image1 CVMat3];
    matImage = GWA_RGB(matImage);
    matImage = ICM(matImage, 0.5);
    UIImage* result =  [UIImage imageWithCVMat: matImage orientation: UIImageOrientationUp];
    return result;
}

+ (nullable FramesOfProcessedVideo *)processWithVideos:(nonnull NSString *)video error:(NSError *__autoreleasing  _Nullable * _Nullable)error {
    NSURL *videoURL = [NSURL URLWithString: [NSString stringWithFormat:@"file://%@", video]];
    NSLog(@"%@", videoURL);
    AVAsset *videoAsset = [AVAsset assetWithURL:videoURL];
    
    AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize size = [videoTrack naturalSize];
    CGAffineTransform txf = [videoTrack preferredTransform];
    
//    BOOL shouldRotate = false;
    
    UIImageOrientation baseVideoOrientation = UIImageOrientationUp;
    
	if (txf.a == 0 && txf.b == 1 && txf.c == -1 && txf.d == 0) {
		baseVideoOrientation = UIImageOrientationRight;
	} else if (size.width == txf.tx && size.height == txf.ty) {
        // UIInterfaceOrientationLandscapeRight
        baseVideoOrientation = UIImageOrientationDown;
    } else if (txf.tx == 0 && txf.ty == 0) {
        // UIInterfaceOrientationLandscapeLeft
        baseVideoOrientation = UIImageOrientationUp;
    } else if (txf.tx == 0 && txf.ty == size.width) {
        // UIInterfaceOrientationPortraitUpsideDown
        baseVideoOrientation = UIImageOrientationLeft;
    } else {
        // UIInterfaceOrientationPortrait
        baseVideoOrientation = UIImageOrientationRight;
    }
    
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSURL *tempurl = [[fileManager URLsForDirectory: NSCachesDirectory inDomains: NSUserDomainMask] objectAtIndex: 0];
	NSString *filenamemp4 = [NSString stringWithFormat:@"%@.mp4", [[NSUUID UUID] UUIDString]];
	NSURL *outputurl = [NSURL URLWithString:[[tempurl URLByAppendingPathComponent: filenamemp4] absoluteString]];
	NSString *outputurlString = [[outputurl absoluteString] substringFromIndex:7];
	std::string urlStringCPP = [outputurlString UTF8String];
	std::cout << urlStringCPP << std::endl;
	
    std::cout << cv::getBuildInformation() << std::endl;
    NSString *filePath = video; //[[NSBundle mainBundle] pathForResource:@"testVideo3" ofType:@"mov"];
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
    
	int oldWidth = static_cast<int>(cap.get(CAP_PROP_FRAME_WIDTH));
    int width = static_cast<int>(cap.get(CAP_PROP_FRAME_WIDTH));
    int height = static_cast<int>(cap.get(CAP_PROP_FRAME_HEIGHT));
    int n_frames = int(cap.get(CAP_PROP_FRAME_COUNT));
    double FPS = cap.get(CAP_PROP_FPS);
    std::cout << "Width: " << width << " Height: " << height << " n_frames: " << n_frames << " FPS: " << FPS << std::endl;
	NSLog(@"1");
	
	switch (baseVideoOrientation) {
		case UIImageOrientationUp:
			break;
		case UIImageOrientationDown:
			break;
		case UIImageOrientationLeft:
//			int oldWidth = width;
			width = height;
			height = oldWidth;
			break;
		case UIImageOrientationRight:
//			int oldWidth = width;
			width = height;
			height = oldWidth;
			break;
		default:
			break;
	}
	
    cv::VideoWriter outt(urlStringCPP,cv::VideoWriter::fourcc('D', 'I', 'V', 'X'), FPS, cv::Size(width, height));
	
	
	
	NSLog(@"2");
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
//    NSMutableArray *images1 = [[NSMutableArray alloc] init];
    
	NSLog(@"------ ORIENTATION ------");
//	NSLog(baseVideoOrientation);
	
    for (i = 0; i < n_frames - 1; i++) {
		@autoreleasepool {
			cap >> image;
			switch (baseVideoOrientation) {
				case UIImageOrientationUp:
					NSLog(@"UIImageOrientationUp");
					break;
				case UIImageOrientationDown:
					NSLog(@"UIImageOrientationDown");
					cv::rotate(image, image, cv::ROTATE_180);
					break;
				case  UIImageOrientationLeft:
					NSLog(@"UIImageOrientationLeft");
					cv::rotate(image, image, cv::ROTATE_90_COUNTERCLOCKWISE);
					break;
				case UIImageOrientationRight:
					NSLog(@"UIImageOrientationRight");
//					cv::flip(image, image, -1);
					cv::rotate(image, image, cv::ROTATE_90_CLOCKWISE);
					break;
				default:
					break;
			}
			
//			cv::flip(image, image, 0);
//			cv::rotate(image, image, cv::ROTATE_90_COUNTERCLOCKWISE);
			image_out = colorcorrection(image);
			outt << image_out;
//			UIImage *correctedImage = [UIImage imageWithCVMat:image_out orientation: baseVideoOrientation];
//			UIImage *lowResImage = [UIImage imageWithData:UIImageJPEGRepresentation(correctedImage, 0.8)];
//			NSData * imageData = UIImageJPEGRepresentation(lowResImage,1);
//			NSLog(@"%u", [imageData length]/1000);
//			NSLog(@"%u", length);
			
//			[images addObject: [[UIImage alloc] normalizedImage]];
		}
		NSLog(@"%u", i);
    }
    
    NSLog(@"%d", [images count]);
//	UIImage *img = [UIImage imageNamed: @"image.png"];
//	FramesOfProcessedVideo *result = [[FramesOfProcessedVideo alloc] initWithImages:  frames:FPS]
//    FramesOfProcessedVideo *result = [[FramesOfProcessedVideo alloc] initWithImages:images frames:FPS urlstring:outputurlString];
	FramesOfProcessedVideo *result = [[FramesOfProcessedVideo alloc] initWithURLString:[outputurl absoluteString]];
    return result;
}



@end
