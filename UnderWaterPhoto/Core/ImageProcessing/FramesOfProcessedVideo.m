//
//  FramesOfProcessedVideo.m
//  UnderWaterPhoto
//
//  Created by USER on 25.01.2024.
//

#import <Foundation/Foundation.h>
#import "FramesOfProcessedVideo.h"

@implementation FramesOfProcessedVideo : NSObject
- (instancetype)initWithImages:(NSMutableArray *)images frames:(NSInteger)frames {
    self = [super init];
    if (self) {
        _images = images;
        _frames = frames;
    }
    return self;
}
@end
