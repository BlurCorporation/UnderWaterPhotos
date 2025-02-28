//
//  CVWrapper.h
//  CVOpenTemplate
//
//  Created by Washe on 02/01/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FramesOfProcessedVideo.h"

NS_ASSUME_NONNULL_BEGIN
@interface CVWrapper : NSObject

+ (nullable UIImage*) processWithImages:(UIImage*)image error:(NSError**)error;
+ (nullable FramesOfProcessedVideo*) processWithVideos:(NSString*)video error:(NSError**)error;

@end
NS_ASSUME_NONNULL_END
