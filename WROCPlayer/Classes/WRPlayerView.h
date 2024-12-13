//
//  WRPlayerView.h
//  WROCPlayer
//
//  Created by 项辉 on 2024/12/11.
//

#import <UIKit/UIKit.h>

@class AVPlayer;

NS_ASSUME_NONNULL_BEGIN

@interface WRPlayerView : UIView

@property (nonatomic, strong) UIView *containerView;

- (void)setupPlayer:(AVPlayer *)player;
- (void)destory;

@end

NS_ASSUME_NONNULL_END
