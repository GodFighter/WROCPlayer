//
//  AVAsset+WRPlayer.h
//  WROCPlayer
//
//  Created by 项辉 on 2024/12/13.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVAsset (WRPlayer)

- (NSString * _Nullable)wr_title;
- (void)wr_imageWithTime:(NSTimeInterval)time completion:(void (^)(UIImage * _Nullable image))completionBlock;

@end

NS_ASSUME_NONNULL_END
