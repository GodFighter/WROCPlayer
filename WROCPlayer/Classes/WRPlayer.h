//
//  WRPlayer.h
//  Pods
//
//  Created by 项辉 on 2024/12/6.
//

#import <Foundation/Foundation.h>

#import "WRPlayerDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface WRPlayer : NSObject

@property (nonatomic, assign, readonly) WRPlayerStatus status;
@property (nonatomic, assign, readonly) WRPlaybackStatus playbackStatus;

@property (nonatomic, weak) id <WRPlayerDelegate> _Nullable delegate;

@property (nonatomic, assign, readonly) NSTimeInterval duration;
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
@property (nonatomic, assign, readonly) CGSize naturalSize;

+ (instancetype)Shared;

- (void)destory;
- (void)playURL:(NSURL *)url seekToTime:(NSTimeInterval)time;

- (void)play;
- (void)pause;
- (void)stop;

- (void)setSuperView:(UIView *)superView;
- (void)setContainerColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
