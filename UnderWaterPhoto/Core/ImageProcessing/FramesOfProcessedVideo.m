//
//  FramesOfProcessedVideo.m
//  UnderWaterPhoto
//
//  Created by USER on 25.01.2024.
//

#import <Foundation/Foundation.h>
#import "FramesOfProcessedVideo.h"

@implementation FramesOfProcessedVideo : NSObject
//- (instancetype)initWithImages:(NSMutableArray *)images frames:(NSInteger)frames :(NSString*) videoUrl {
- (instancetype)initWithURLString:(NSString *)urlstring {
    self = [super init];
    if (self) {
//        _images = images;
//        _frames = frames;
		_urlstring = urlstring;
    }
    return self;
}
@end
