//
//  WRPlayerView.h
//  WROCPlayer
//
//  Created by 项辉 on 2024/12/11.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "WRPlayerDefine.h"

@class AVPlayer;

NS_ASSUME_NONNULL_BEGIN

@interface WRPlayerView : UIView

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, copy) void (^operationBlock)(WRPlayerOperation operation, __nullable id var_value);

- (void)setupPlayer:(AVPlayer *)player;
- (void)destory;

- (void)setStatus:(WRPlayerStatus)status;
- (void)setPlaybackStatus:(WRPlaybackStatus)status;
- (void)setAsset:(AVAsset *)asset;

@end

NS_ASSUME_NONNULL_END
