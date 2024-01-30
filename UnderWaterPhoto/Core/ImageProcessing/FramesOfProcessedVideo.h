//
//  FramesOfProcessedVideo.h
//  UnderWaterPhoto
//
//  Created by USER on 25.01.2024.
//

@interface FramesOfProcessedVideo : NSObject

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) NSInteger frames;

- (instancetype)initWithImages:(NSMutableArray *)images frames:(NSInteger)frames;

@end

